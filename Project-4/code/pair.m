image1 = 'uttower_left.jpg'; %butterfly.jpg, einstein.jpg, fishes.jpg, sunflowers.jpg
image2 = 'uttower_right.jpg';
dataDir = fullfile('..','data');
im1 = imread(fullfile(dataDir, image1));
im2 = imread(fullfile(dataDir, image2));

imbw1=im2double(rgb2gray(im1));
imbw2=im2double(rgb2gray(im2));

% function [result_img, H, num_inliers, residual] = stitch_pair (im1, im2, sift_r, harris_r, harris_thresh, harris_sigma, num_putative_matches, ransac_n)
[result_img, H, num_inliers, residual] = stitch_pair(im1, im2, 5, 5, 0.03, 1, 200, 4000);

figure
imshow(result_img);