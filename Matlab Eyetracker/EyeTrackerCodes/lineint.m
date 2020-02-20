%function to calculate the normalised line integral around a circular contour
%A polygon of large number of sides approximates a circle and hence is used
%here to calculate the line integral by summation
%INPUTS:
%1.I:Image to be processed
%2.C(x,y):Centre coordinates of the circumcircle
%Coordinate system :
%origin of coordinates is at the top left corner
%positive x axis points vertically down
%and positive y axis horizontally and to the right
%3.n:number of sides
%4.r:radius of circumcircle
%5.part:To indicate wheter search is for iris or pupil
%if the search is for the pupil,the function uses the entire circle(polygon) for computing L
%for the iris only the lateral portions are used to mitigate the effect of occlusions 
%that might occur at the top and/or at the bottom
%OUTPUT:
%L:the line integral divided by circumference
% 
% -------------------------------------------------------------------------
% Copyright (c) 2007, Anirudh Sivaraman
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.
% -------------------------------------------------------------------------
function [L]=lineint(I,C,r,n,part)
theta=(2*pi)/(100*n);% angle subtended at the centre by the sides
%orient one of the radii to lie along the y axis
%positive angle is ccw
%Author:Anirudh S.K.
%Department of Computer Science and Engineering
%Indian Institute of Techology,Madras
rows=size(I,1);
cols=size(I,2);
angle=theta:theta:2*pi;
x=C(1)-r*sin(angle);
y=C(2)+r*cos(angle);
if (any(x>=rows)||any(y>=cols)||any(x<=1)||any(y<=1))
    L=0;
    return
    %This process returns L=0 for any circle that does not fit inside the image
end
%lines 34 to 42 compute the whole line integral
if (strcmp(part,'pupil')==1)
    s=0;
    for i=1:n
        val=I(round(x(i)),round(y(i)));
        s=s+val;
    end
    L=s/n;
end
% lines 44 onwards compute the lateral line integral(to prevent occlusion affecting the results,the pixel average is taken only along the lateral portions)
if(strcmp(part,'iris')==1)
          s=0;
          for i=1:round((n/8))
          val=I(round(x(i)),round(y(i)));
          s=s+val;
          end
          
          for i=(round(3*n/8))+1:round((5*n/8))
          val=I(round(x(i)),round(y(i)));
          s=s+val;
          end
          
          for i=round((7*n/8))+1:(n)
          val=I(round(x(i)),round(y(i)));
          s=s+val;
          end
          
          L=(2*s)/n;
end
%works fine with the code