clear cam
% set webcam
cam = webcam;
% standard eye value (for when the eye is looking precisely straight)
% in actual practice, these values would have to be measured precisely
standard_left = 98.5;
standard_right = 240.5;
% set amount of taken frames
exposure_time = 5;
% link: https://de.mathworks.com/matlabcentral/answers/322849-eye-tracking-algorithm-help
% The following part to detect the face has been copied from the link
% above.
% The search for the face serves to eliminate possible sources for circles
% in the background.
% detect the largest surface (aiming to detect the face)
kern = [1 2 1; 0 0 0; -1 -2 -1];
detector = vision.CascadeObjectDetector(); %Create a detector for face using Viola-Jones
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
    % run edge detection
    k = conv2(faceimg(:,:,2),kern,'same');
    v = conv2(faceimg(:,:,2),kern','same');
    e = sqrt(k.*k + v.*v);
    edgeimg = uint8((e > 100) * 240);
    % detect circles within the "edgeimg"
    % 'Sensitivity' may need to be adjusted based on ambient light
    [centers,radii] = imfindcircles(edgeimg,[10 18],'Sensitivity',0.93);
    % calculate the relative position of the eye in comparison to its
    % normal position
    if size(centers,1) == 2
        % the matrix "centers" has 2 rows, which ideally means, that both eyes have been
        % tracked.
        value = centers(1,1);
        if value <= 150
            offset = value - standard_left;
        else
            offset = value - standard_right;
        end
    elseif size(centers,1) == 1
        % the matrix "centers" has 1 row, which ideally means, that either the left or
        % the right eye have been tracked .
        if centers(1,1) <= 150
            % left eye has been tracked
            value = centers(1,1);
            offset = value - standard_left;
        else
            % right eye has been tracked
            value = centers(1,1);
            offset = value - standard_right;
        end
    elseif size(centers,1) == 0;
        % the matrix "centers" has 0 rows
        offset = 0;
    else
        % the matrix "centers" has more than 2 rows. the algorithm now
        % searches for the x-coordinate of a circle, that is closest to
        % standard_left.
        for j = size(centers,1)
            [~,~,idx] = unique(round(abs(centers(j,1) - standard_left)),'stable');
            value = centers(idx==1);
        end
    end
    % calculate
    imagesc(edgeimg);
    % End of copied part.
    % display image
    imshow(faceimg);
    % display circles within the image
    h = viscircles(centers,radii);
end
% disconnect the webcam from MATLAB
clear cam