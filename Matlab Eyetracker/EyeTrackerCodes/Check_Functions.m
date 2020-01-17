close all
clear cam
cam = webcam;
I = snapshot(cam);
x = 6;
y = 6;
n = 8;
rmin = 10;
rmax = 40;
sigma=0.5; %(standard deviation of Gaussian)
part = 'pupil';
rows=size(I,1);
cols=size(I,2);
R=rmin:rmax;
maxrad=zeros(rows,cols);
maxb=zeros(rows,cols);
for i=(x-3):(x+3) % here lies the error
    for j=(y-3):(y+3)
        [b,r,blur]=partiald(I,[i,j],rmin,rmax,0.5,600,part);
        maxrad(i,j)=r;
        maxb(i,j)=b;
    end
end
B=max(max(maxb));
[x,y]=find(maxb==B);
radius=maxrad(x,y);
cp=[x,y,radius];
clear cam