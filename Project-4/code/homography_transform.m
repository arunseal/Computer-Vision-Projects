function [im2] = homography_transform(im1, H)
    Xi = cat(1, im1', ones(1, size(im1, 1)));
    lambdaX = H*Xi;
    lambdaX = lambdaX';
    im2 = lambdaX(:,1:2);
    im2(:,1)=im2(:,1)./lambdaX(:,3);
    im2(:,2)=im2(:,2)./lambdaX(:,3);
end