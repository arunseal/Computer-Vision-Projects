% Entry code for evaluating demosaicing algorithms
% The code loops over all images and methods, computes the error and
% displays them in a table.
% 
% This code has been taken from:
%
%   CMPSCI 670: Computer Vision, Fall 2014
%   University of Massachusetts, Amherst
%   Author: Subhransu Maji

% Path to your data directory
dataDir = fullfile('..','data','demosaic');

% Path to your output directory
outDir = fullfile('..','output','demosaic');

% List of images
imageNames = {'balloon.jpeg',	'cat.jpg',	'ip.jpg','puppy.jpg','squirrel.jpg', ...
              'candy.jpeg',	'house.png', 'light.png', 'sails.png', 'tree.jpeg'};
numImages = length(imageNames);

% List of methods you have to implement          
methods = {'baseline', 'nn', 'linear', 'adagrad'};
numMethods = length(methods);

% Global variables
display = true;
error = zeros(numImages, numMethods);

% Loop over methods and print results
fprintf([repmat('-',[1 100]),'\n']); 
fprintf('# \t image \t\t baseline \t nn \t\t linear \t adagrad\n'); 
fprintf([repmat('-',[1 100]),'\n']); 
for i = 1:numImages,
    fprintf('%i \t %s ', i, imageNames{i});
    for j = 1:numMethods, 
        thisImage = fullfile(dataDir, imageNames{i});
        thisMethod = methods{j};
        [error(i,j), colorIm] = runDemosaicing(thisImage, thisMethod, display);
        fprintf('\t %f ', error(i,j)); 
        
        % Write the output
        outfileName = fullfile(outDir, [imageNames{i}(1:end-5) '-' thisMethod '-dmsc.jpg']);
        imwrite(colorIm, outfileName);
        
    end
    fprintf('\n');
end

% Compute average errors
fprintf([repmat('-',[1 100]),'\n']); 
fprintf(' \t %s ', 'average');
for j = 1:numMethods, 
        fprintf('\t %f ', mean(error(:,j)));     
end
fprintf('\n');
fprintf([repmat('-',[1 100]),'\n']); 
