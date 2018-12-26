% RANSAC - A simple RANSAC implementation.
% Author: Daeyun Shin
% March 2014

function [result, best_num_inliers, residual] = ransac(im1, im2, I1, I2, N, est_func, transform_func)
    best_H = [];
    best_num_inliers = 0;

    for i = 1:N
        ind = randperm(size(I1,1));
        ind_s = ind(1:4);
        ind_r = ind(5:end);

        I1s = I1(ind_s,:);
        I2s = I2(ind_s,:);

        I1r = I1(ind_r,:);
        I2r = I2(ind_r,:);

        H = est_func(I1s, I2s);
        [tf] = transform_func(I1r, H);

        dists = sum((I2r - tf).^2,2);

        ind_b = find(dists<0.3);
        num_inliers = length(ind_b); 

        if best_num_inliers < num_inliers
            best_H = H;
            best_num_inliers = num_inliers;
            residual = mean(dists(ind_b));
            best_matches=ind_b;
            
        end
    end
    
%     disp(best_matches);
%     disp(length(best_matches));
    
    M1=I1(best_matches,:);
    M2=I2(best_matches,:);
    
%     figure
%     showMatchedFeatures(im1,im2,M1,M2,'montage');
    result = best_H;
end