%NOTE: This is run using the Viola-Jones cascade detector - this detector does not
%      work with greyscale images.
% link: https://de.mathworks.com/matlabcentral/answers/322849-eye-tracking-algorithm-help
clear cam
cam = webcam;
detector = vision.CascadeObjectDetector(); %Create a detector for face using Viola-Jones
detector1 = vision.CascadeObjectDetector('LeftEye'); % Create detector for a single eye
detector1.MergeThreshold = 200;
exposure = 1;
for j = 1:1:exposure %Infinite loop to continuously detect the face
    vid = snapshot(cam);  %Get a snapshot of webcam
    img = flip(vid, 2); %Flips the image horizontally
     %imgOrig = img;
     G = fspecial('gaussian', [5 5],2); %We can change the size of G by changing [5 5] (maybe smaller = [3 3]?)
     img = imfilter(img,G,'same');
     %greyScaleImg = rgb2gray(img); %%Image was greyscaled later on so that
     %                                  viola-jones can detect the rgb image.
     %[gx,gy] = gradient(double(greyScaleImg));
     %greyScaleImg = 255-greyScaleImg;
     %greyScaleImg = im2double(greyScaleImg);
     bboxFace = step(detector, img); % !img has been changed from grey! %Creating bounding box around face on grey scaled face image using detector 
       if ~ isempty(bboxFace)  %If face exists (~ means opposite OR "is not")
           biggest_box=1;     
           for i=1:rank(bboxFace) %Find the biggest face
               if bboxFace(i,3)>bboxFace(biggest_box,3)
                   biggest_box=i;
               end
           end
           faceImage = imcrop(img,bboxFace(biggest_box,:)); %!CHANGED! % extract the face from the image
           bboxeye = step(detector1, faceImage); % Locations of the left eye using detector
           %eyeInFace = insertObjectAnnotation(faceImage,'rectangle',bboxeye,'Eye'); %Not needed? %Produces image of face with bbox around eye
           %imresize(eyeInFace,0.3);
           %imshow(eyeInFace)  % Only need final image to be outputted
       else
           %imshow(faceImage)  % Only need final image to be outputted
       end
     % eyeImage = imcrop(faceImage, bboxeye(1,:));  
     % greyScaleImg = rgb2gray(eyeImage); %I put greyscaling onto the eye image so that Timm-Barth can compute better
     greyScaleImg = rgb2gray(faceImage);
     [gx,gy] = gradient(double(greyScaleImg));
     greyScaleImg = 255-greyScaleImg;
     greyScaleImg = im2double(greyScaleImg); 
     [rmax, cmax] = size(greyScaleImg);
     gMag = zeros(rmax,cmax);
     imshow(greyScaleImg) %Just a test to see if eye image is cropped and grey - can output image later.
     % This is the Timm-Barth section:
     for y = 150:(rmax-50)
         for x = 20:(cmax-170)
             gMag(y,x) = sqrt((gx(y,x) * gx(y,x)) + (gy(y,x) * gy(y,x)));
         end
     end
     %Compute the threshold
     stdMagGrad = std2(gMag);
     meanGMagrad = mean2(gMag);
     gradThreshold = 0.3 * stdMagGrad + meanGMagrad;
     %Normalise gradients above threshold to unit length, zero everything else
     for y = 150:(rmax-50) %It detects the edge and computes 
         for x = 20:(cmax-170)
             if gMag(y,x) > gradThreshold
                 gx(y,x) = gx(y,x) / gMag(y,x);
                 gy(y,x) = gy(y,x) / gMag(y,x);
             else
                 gx(y,x) = 0.00;
                 gy(y,x) = 0.00;
             end
         end
     end
     sqrdDp = zeros(rmax,cmax);
     sqrdDp = zeros(rmax,cmax);
     for y = 50:(rmax-100)
         for x = 20:(cmax-170)
             if gMag(y,x) > gradThreshold
                 for cy = 1:rmax % Detects the centre
                     for cx = 1:cmax
                         dx = x-cx; %Calculates distance between the edge and the centre.
                         dy = y-cy;
                         magnitude = sqrt((dx * dx) + (dy * dy));
                         dx = dx / magnitude;
                         dy = dy / magnitude;
                         dotProduct = dx * gx(y,x) + dy * gy(y,x);
                         dotProduct = max(0.0,dotProduct);
                         sqrdDp(cy,cx) = sqrdDp(cy,cx) + dotProduct * dotProduct;
                     end
                 end
             else
                 continue
             end
         end
         x;
     end
     y;
     % for y1 = 1:rmax
     %     for x1 = 1:cmax
     %         wSqrdDp(y1,x1) = sqrdDp(y1,x1) * I2(y1,x1);
     %     end
     % end
     [maximum, I] = max(sqrdDp(:));    % prev wSqrdDp
     threshold = 0.9 * maximum;
     for y1 = 150:(rmax-50)
         for x1 = 20:(cmax-20)
             if sqrdDp(y1,x1) < threshold  % prev wSqrdDp
                sqrdDp(y1,x1) = 0.00;      % prev wSqrdDp
             end
         end
     end
     [col, row] = ind2sub(size(sqrdDp),I); % prev wSqrdDp
     BullsEye = insertMarker(img, [row, col]); %Puts a plus sign on the specified location ([row, col] - is this centre??)
     imshow(BullsEye)
end
clear cam
