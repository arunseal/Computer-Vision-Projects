% Given a set of images with overlapping regions,
% automatically compute a panorama image.

function [result_img, H, num_inliers, residual] = stitch_images(im, sift_r, harris_r, harris_thresh, harris_sigma, num_putative_matches, ransac_n)

    image_order =  find_ordered_homography(im, sift_r, harris_r, harris_thresh,harris_sigma, num_putative_matches, ransac_n);
    disp(image_order);
    n_im = length(im);
    num_inliers = zeros(n_im, n_im);
    H = cell(n_im, n_im);
    residual = zeros(n_im, n_im);

    result_img = im{image_order(1)};
    for image_ind = 2:length(image_order)
        prev_ind = image_order(image_ind-1);
        ind = image_order(image_ind);

        [result_img, H{prev_ind, ind}, num_inliers(prev_ind, ind), residual(prev_ind, ind)] ...
            = stitch_pair(im{ind}, result_img, sift_r, harris_r, harris_thresh, ...
                          harris_sigma, num_putative_matches, ransac_n);
        figure
        imshow(result_img);

        H{ind, prev_ind} = H{prev_ind, ind};
        num_inliers(ind, prev_ind) = num_inliers(prev_ind, ind);
        residual(ind, prev_ind) = residual(prev_ind, ind);
    end
end