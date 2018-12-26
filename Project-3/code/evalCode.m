% Evaluation code for blob detector
%
% Your goal is to implement the laplacian of the gaussian blob detector 
%
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2014
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 3: Blob detector

imageName = 'sunflowers.jpg'; %butterfly.jpg, einstein.jpg, fishes.jpg, sunflowers.jpg


dataDir = fullfile('..','data');
im = imread(fullfile(dataDir, imageName));

imName = imageName(1:end-4);
outDir = fullfile('..', 'outputblobs');
if ~exist(outDir, 'file')
    mkdir(outDir);
end

%% Implement the code to detect blobs here
% First implement a version that scales the filter and applies on the
% image
tic;
blobs1 = detectBlobsScaleFilter(im);
toc;

% Now implement a version that scales the image
tic;
blobs2 = detectBlobsScaleImage(im);
toc;

%% Draw blobs on the image
numBlobsToDraw = 1000;
[H1]=drawBlobs(im, blobs1, numBlobsToDraw);
% title('Blob detection: Scale Filter');
title(strcat('Blob detection ->>',imageName));
saveas(H1,fullfile(outDir, strcat('slow',imageName)));

[H2]=drawBlobs(im, blobs2, numBlobsToDraw);
title(strcat('Blob detection ->>',imageName));
saveas(H2,fullfile(outDir, strcat('fast',imageName)));

