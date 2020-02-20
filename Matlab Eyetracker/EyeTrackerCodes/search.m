%function to detect the pupil  boundary
%it searches a certain subset of the image
%with a given radius range(rmin,rmax)
%around a 10*10 neighbourhood of the point x,y given as input
%INPUTS:
%im:image to be processed
%rmin:minimum radius
%rmax:maximum radius
%x:x-coordinate of centre point
%y:y-coordinate of centre point
%OUTPUT:
%cp:centre coordinates of pupil(x,y) followed by radius
%Author:Anirudh S.K.
%Department of Computer Science and Engineering
%Indian Institute of Techology,Madras
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
function [cp]=search(I,rmin,rmax,x,y,part)
rows=size(I,1);
cols=size(I,2);
R=rmin:rmax;
maxrad=zeros(rows,cols);
maxb=zeros(rows,cols);
for i=x
    for j=y
        [b,r,blur]=partiald(I,[i,j],rmin,rmax,0.5,6,part);
        maxrad(i,j)=r;
        maxb(i,j)=b;
    end
end
B=max(max(maxb));
[x,y]=find(maxb==B);
radius=maxrad(x,y);
cp=[x,y,radius];
