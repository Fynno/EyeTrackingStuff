% same code as "Eye_Tracker" but without the edge detection
% the resulting snapshot is too blurry in order for the program to detect
% circles.
clear cam
% set webcam
cam = webcam;
% set amount of taken frames
exposure_time = 5;
% link: https://de.mathworks.com/matlabcentral/answers/322849-eye-tracking-algorithm-help
% The following part to detect the face has been copied from the link
% above.
% The search for the face serves to eliminate possible sources for circles
% in the background.
kern = [1 2 1; 0 0 0; -1 -2 -1];
detector = vision.CascadeObjectDetector(); %Create a detector for face using Viola-Jones
detector1 = vision.CascadeObjectDetector('LeftEye'); % Create detector for a single eye
detector1.MergeThreshold = 200;
for j = 1:1:exposure_time
    mirroredimg = snapshot(cam);  %Get a snapshot of webcam
    img = flip(mirroredimg, 2); %Flips the image horizontally
    imagesc(img);
    G = fspecial('gaussian', [5 5],2); %We can change the size of G by changing [5 5] (maybe smaller = [3 3]?)
    img = imfilter(img,G,'same');
    boxface = step(detector, img); % !img has been changed from grey! %Creating bounding box around face on grey scaled face image using detector 
    if ~ isempty(boxface)  %If face exists (~ means opposite OR "is not")
        biggest_box=1;     
        for i=1:rank(boxface) %Find the biggest face
            if boxface(i,3)>boxface(biggest_box,3)
                biggest_box=i;
            end
        end
        faceimg = imcrop(img,boxface(biggest_box,:)); %!CHANGED! % extract the face from the image
        % boxeye = step(detector1, faceimg); % Locations of the left eye using detector
    end
    [centers,radii] = imfindcircles(faceimg,[8 18],'Sensitivity',0.89);
    imagesc(faceimg);
    % End of copied part.
    imshow(faceimg);
    h = viscircles(centers,radii);
end
clear cam