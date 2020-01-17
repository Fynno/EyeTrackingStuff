% Eye Tracking Simulation
% disconnect the previously used camera and close figures
clear cam
close all
% set new cam
cam = webcam;
% the resolution options are multiples of 4x3
cam.Resolution = '600x800';
% set length of exposure
exposure_time = 2;
% acquire images during recording
for i = 1:1:exposure_time
    img = snapshot(cam);
    image(img);
% Purpose : Detect Pupil from given image
%
% Uses (syntax) :
%   [out]=getEigenEye(img)
%
% Input Parameters :
%   img := RGB-Image (m-by-n-by-3 matrix); bounding box of Eye
%
% Return Parameters :
%   out := structure
%         out.si := size of img
%         out.o := img with marked pupils (m-by-n-by-3 matrix)
%         out.pic := EigenPupil (m-by-n-by-3 matrix)
% 
% Description and algorithms:
%   Using algorithm of Anirudh S.K. (thresh.m) to detect Pupil (which takes
%   rather long). 
%
% Author : Peter Aldrian, Uwe Meier, Andre Pura
% Date : August 12, 2009
% Version : 1.0
% -------------------------------------------------------------------------
% (c) 2009, Meier, University of Leoben, Leoben, Austria
% email: aldrian.peter@gmail.com uwemei@gmail.com andre.pura@gmail.com
% -------------------------------------------------------------------------

    s = size(img);
    out.si = s;

    [ci,cp,o] = thresh(img,s(1) * 0.1,s(1)*0.3);

    ci = round(ci);
    out.o = o;
    out.pic = (img(ci(1)-ci(3):ci(1)+ci(3),ci(2)-ci(3):ci(2)+ci(3),:));
    % Purpose : find position of Pupil within an Image
%
% Uses (syntax) :
%   [x y] = getEye(img,out)
%
% Input Parameters :
%   img := RGB-Image (m-by-n-by-3 matrix); bounding box of Eye
%   out := structure
%         out.si := size of img
%         out.o := img with marked pupils (m-by-n-by-3 matrix)
%         out.pic := EigenPupil (m-by-n-by-3 matrix)
% 
% Return Parameters :
%   x := x-value of Eye's center
%   y := y-value of Eye's center
% 
% Description and algorithms:
%   
%
% Author : Peter Aldrian, Uwe Meier, Andre Pura
% Date : August 12, 2009
% Version : 1.0
% -------------------------------------------------------------------------
% (c) 2009, Meier, University of Leoben, Leoben, Austria
% email: aldrian.peter@gmail.com uwemei@gmail.com andre.pura@gmail.com
% -------------------------------------------------------------------------
% inizialize values
% Size of the Image the EigenEye was calculated from
sizeOrig=out.si;
% RGB-image if EigenEye
Pupil=out.pic ;
% Size of EigenEye
[xP, yP, zP]=size(Pupil);
% Size of the current Image
[xImg,yImg,zImg] = size(img);
img = double(img);
% set minimal absolute difference to -1 (for first cycle)
minAbs = -1;
% -------------------------------------------------------------------------
% apply gaussian filter to the Image
h = fspecial('gaussian',4,5);
img =  imfilter(img,h,'replicate');
% Calculate Size of Pupil in Image. Since the relation between the size of
% the Pupil and the Image size is fixed, wen can easily calculate the size
% of the Pupil within the new Image
xImgP = int16( xP*xImg / sizeOrig(1) );
yImgP = int16( yP*yImg / sizeOrig(2) );
% Resize the Pupil to before calculated size
imPupil = imresize(Pupil,[xImgP, yImgP]);
imPupil = double(imPupil);
% Search the whole Image for the place with the least absolute mean pixel
% value difference between Pupil and Image
for jj = int16(1):int16((yImg-yImgP))
    for ii =int16(1):int16((xImg-xImgP))
        
%         absolute difference between EigenPupil and corresponding parts of
%         the Image
        absImg = abs(img(ii:(ii-1+xImgP),jj:(jj-1+yImgP),:) - ...
            imPupil(1:xImgP,1:yImgP,:));
        
%         Calculate mean
        sumAbsImg = sum(sum(sum(absImg)))/(xImgP*yImgP);
        
%         Save value and position of the Pupil only if calculated value is
%         smaller than the previous best or of first cycle
        if (sumAbsImg < minAbs || minAbs == -1 )
            posY = ii;
            posX = jj;
            minAbs = sumAbsImg;
            
        end
        
    end
    
end
% since posX, posY describe the top left corner of the found Pupil, half
% the sizes of the Pupils have to be added, to return the center
x = posX+xImgP/2;
y = posY+yImgP/2;
% Purpose : Detection of both Pupils from two detail images
%
% Uses (syntax) :
%   [x y xx yy] = getEyes(left,right)
%
% Input Parameters :
%   left := RGB-Image (m-by-n-by-3 matrix); bounding box of left Eye
%   right := RGB-Image (m-by-n-by-3 matrix); bounding box of right Eye
% 
% Return Parameters :
%   x := x-value of right Eye's center
%   y := y-value of right Eye's center
%   xx := x-value of left Eye's center
%   yy := y-value of left Eye's center
% 
% Description and algorithms:
%   Detect Pupils using EigenPupils of the user.
%   If no EigenPupils available perform search for Pupils and ask user to
%   check if algorithm detected the correct ones.
%   Having EigenPupils perform search for Pupils.
%   (To detect the EigenPupils either the user has to detect them on his
%   own or a detection-algorithm can be used. Even though these algorithms
%   require too much time for a real-time-application, they can be used to
%   detect the EigenPupil once in the beginning.
%
% Author : Peter Aldrian, Uwe Meier, Andre Pura
% Date : August 12, 2009
% Version : 1.0
% -------------------------------------------------------------------------
% (c) 2009, Meier, University of Leoben, Leoben, Austria
% email: aldrian.peter@gmail.com uwemei@gmail.com andre.pura@gmail.com
% -------------------------------------------------------------------------
% global variables needed to save right (outRa) and left (outLa) EigenPupil
% from first snapshot to find pupil-position in the following frames
global outRa;
global outLa;
% initialize outputs
x=0;
y=0;
xx=0;
yy=0;
% -------------------------------------------------------------------------
% if no EigenEyes found
if isempty(outRa) || isempty(outLa)
    
%     get EigenEyes
    outRa=getEigenEye(right);
    outLa=getEigenEye(left);
    
    fig_EigenAugen = figure;
    
%     plot results and ask for correctness of results; If not correct,
%     reset EigenPupils to null.
    subplot(1,2,1)
    imshow(outLa.o)
    subplot(1,2,2)
    imshow(outRa.o)
    pause(1);
    selection = questdlg('Are these your Eyes?','Question','Yes','No','Yes');
    switch selection
        case 'Yes'  
        case 'No'
            outRa=[];
            outLa=[];
    end
    close(fig_EigenAugen);  
end
% Search for Pupils only if EigenPupils found
if not( isempty(outRa) && isempty(outLa))
    
    [xx, yy]=getEye(left,outLa);
    [x, y]=getEye(right,outRa);
    
end

end
% disconnect camera from MATLAB
clear cam