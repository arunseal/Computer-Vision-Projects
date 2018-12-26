function [result_img, H, num_inliers, residual] = stitch_pair (im1, im2, sift_r, harris_r, harris_thresh, harris_sigma, num_putative_matches, ransac_n)

im1_bw = im2single(rgb2gray(im1));
im2_bw = im2single(rgb2gray(im2));

[~, left_Y, left_X] = harris(im1_bw, harris_sigma, harris_thresh, harris_r, 0);
[~, right_Y, right_X] = harris(im2_bw, harris_sigma, harris_thresh, harris_r, 0);

im1_kp = cat(2, left_X, left_Y,repmat(sift_r, length(left_X), 1));
im2_kp = cat(2, right_X, right_Y,repmat(sift_r, length(right_X), 1));

[im1_descriptor_loc, left_descriptors] = vl_sift_wrapper(im1_bw, im1_kp);
[im2_descriptor_loc, right_descriptors] = vl_sift_wrapper(im2_bw, im2_kp);


[left_matches, right_matches] = select_putative_matches(left_descriptors, right_descriptors, num_putative_matches);

I1 = im1_descriptor_loc(left_matches,:);
I2 = im2_descriptor_loc(right_matches,:);
% figure
% showMatchedFeatures(im1,im2,I1,I2,'montage');

[H, num_inliers, residual] = ransac(im1, im2, I1, I2, ransac_n, @fit_homography, @homography_transform);

result_img = stitch(im1, H, im2);

end