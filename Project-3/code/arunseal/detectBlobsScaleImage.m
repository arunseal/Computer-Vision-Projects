function blobs = detectBlobsScaleImage(im)
% DETECTBLOBS detects blobs in an image
%   BLOBS = DETECTBLOBSCALEIMAGE(IM, PARAM) detects multi-scale blobs in IM.
%   The method uses the Laplacian of Gaussian filter to find blobs across
%   scale space. This version of the code scales the image and keeps the
%   filter same for speed. 
% 
% Input:
%   IM - input image
%
% Ouput:
%   BLOBS - n x 4 array with blob in each row in (x, y, radius, score)
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2014
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 3: Blob detector


%Convert to grayscale and double
im=rgb2gray(im);
im=im2double(im);


%Specify sigma, n, k and initialize scalespace
sigma=2.5;
k=sqrt(2);
sigma_final = k.^12;
n = ceil((log(sigma_final) - log(sigma))/log(k)); 
[h,w]=size(im);
scalespace=zeros(h,w,n);

%Create LoG filter of fixed size
filt_size=2*ceil(3*sigma)+1;
LoG = sigma^2 * fspecial('log', filt_size, sigma);%Normalized LoG filter

%Rescale the image and filter it
im_res = im;
for i = 1:n
    im_filt = imfilter(im_res, LoG, 'same', 'replicate'); 
    im_filt = im_filt .^ 2; 
    scalespace(:,:,i) = imresize(im_filt, size(im), 'bicubic'); %performs bicubic interpolation
    if i < n        
        im_res = imresize(im, 1/(k^i), 'bicubic');%Downsampling
    end
end

%Non-maximum suppression for each space-scale slice
supp_size=3;
supp_space=zeros(h,w,n);
for i =1:n
    supp_space(:,:,i)=ordfilt2(scalespace(:,:,i),9,ones(supp_size));
end
%Non-maximum supression between scales and threshold
for i=1:n
    supp_space(:,:,i) = max(supp_space(:,:,max(i-1,1):min(i+1,n)),[],3);
end
supp_space = supp_space .* (supp_space == scalespace);


%Create blobs
r = [];   
c = [];   
rad = [];
val = [];
for i=1:n
    %Set threshold
    [rows, cols,value] = find(supp_space(:,:,i).*(supp_space(:,:,i)>= 0.005));
    numblobs = length(rows);
    if(numblobs >0)
        %Get values
        radii =  sigma * k^(i-1) * sqrt(2); 
        radii = repmat(radii, numblobs, 1);
        r = [r; rows];
        c = [c; cols];
        val = [val;value];
        rad = [rad; radii];
    end
end


blobs = [c,r,rad,val];