clear cam
close all
% set new cam
cam = webcam;
% the resolution options are multiples of 4x3
cam.Resolution = '800x600';
% acquire images during recording
I = snapshot(cam);
image(I);
% set variables
rmin = 10;
rmax = 40;
sigma=0.5; %(standard deviation of Gaussian)
% function
s = size(I);
out.si=s;
[ci,cp,o]=thresh(I,s(1) * 0.1,s(1)*0.3);
ci=round(ci);
out.o = o;
out.pic=(I(ci(1)-ci(3):ci(1)+ci(3),ci(2)-ci(3):ci(2)+ci(3),:));
a = b;
clear cam