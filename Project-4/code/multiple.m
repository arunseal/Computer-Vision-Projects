images = cell(1, 3);
image1 = '1.jpg';
image2 = '2.jpg';
image3 = '3.jpg';
dataDir = fullfile('..','data','ledge');
im1 = imread(fullfile(dataDir, image1));
im2 = imread(fullfile(dataDir, image2));
images{1} = imread(fullfile(dataDir, image1));
images{2} = imread(fullfile(dataDir, image2));
images{3} = imread(fullfile(dataDir, image3));

[result, H, num_inliers, residual] = stitch_images(images, 5, 5, 0.03, 1, 200, 4000);

figure
imshow(result);