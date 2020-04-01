clear cam
% set webcam
cam = webcam;
% standard eye value (for when the eye is looking precisely straight)
% in actual practice, these values would have to be measured precisely
standard_left = 136;
standard_right = 303;
%standard eye height on the picture, to eliminate false circles, that may
%be close to the eye in x-direction
standard_y = 165;
% set resolution
cam.Resolution = '800x600';
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
    % End of copied part.
    [centers,radii] = imfindcircles(edgeimg,[10 20],'Sensitivity',0.93);
    % calculate the relative position of the eye in comparison to its
    % normal position
    if size(centers,1) == 2
        % the matrix "centers" has 2 rows, which ideally means, that both eyes have been
        % tracked.
        % for each matrix value, the distance to the normal right and left
        % eye position are checked and the lowest value is taken as the
        % offset
        if abs(centers(1,2)-standard_y) <= 30
            % this checks, if centers(1,2) is near the expected height of the eyes
            offset_vector = [ centers(1,1)-standard_left ; centers(1,1)-standard_right ];
            [value,idx] = min(abs(offset_vector));
            offset = offset_vector(idx);
        elseif abs(centers(3,2)-standard_y) <= 30
            % this checks, if centers(2,2) is near the expected height of the eyes
            offset_vector = [ centers(2,1)-standard_left ; centers(2,1)-standard_right ];
            [value,idx] = min(abs(offset_vector));
            offset = offset_vector(idx);
        else
            offset = 0;
        end
    elseif size(centers,1) == 1
        % the matrix "centers" has 1 row, which ideally means, that either the left or
        % the right eye have been tracked .
        if abs(centers(1,2)-standard_y) <= 30
            % assumption, that the eye has been tracked
            offset_vector = [ centers(1,1)-standard_left ; centers(1,1)-standard_right ];
            [value,idx] = min(abs(offset_vector));
            offset = offset_vector(idx);
        else
            % assumption, that something, that's not the eye has been
            % tracked
            offset = 0;
        end
    elseif size(centers,1) == 0
        % the matrix "centers" has 0 rows
        offset = 0;
    else
        % the matrix "centers" has more than 2 rows. the algorithm now
        % searches for the x-coordinate of a circle, that is closest to
        % standard_left.
        % approach based on the post by user Birdman
        % link: https://de.mathworks.com/matlabcentral/answers/375710-find-nearest-value-to-specific-number
        for j = size(centers,1)
            [value,idx] = min(abs(centers(j,1) - standard_left));
            offset = centers(idx) - standard_left;
        end
    end
    % calculate
    imagesc(edgeimg);
    % display image
    imshow(faceimg);
    % display circles within the image
    h = viscircles(centers,radii);
end
% disconnect the webcam from MATLAB
clear cam