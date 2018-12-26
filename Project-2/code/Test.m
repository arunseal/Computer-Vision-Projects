clc
clear all
close all

imArray=rand(3,3,3);




imAmbient=[0 0 0; 4 5 6; 0 0 1];
[h,w,n]=size(imArray);

output=zeros(h,w,n);
output=bsxfun(@minus, imArray(:,:,1:n), imAmbient);
output(output<0)=0;
output=bsxfun(@rdivide, output, 255)

surfaceNormals=imArray;
G1=surfaceNormals(:,:,1);
G2=surfaceNormals(:,:,2);
G3=surfaceNormals(:,:,3);
fx=-G1/G3;
fy=-G2/G3;

[h,w,n]=size(imArray);
xy = cumsum(round(rand(h,w)+1),1);

x = round(h.*rand(h,1));

imAmbient(1)


