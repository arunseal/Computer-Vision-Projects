function H = fit_homography(I1, I2)
    [h1, w1] = size(I1);
    [h2, w2] = size(I2);
    assert(h1 == h2);
    assert(w1 == 2);
    assert(w2 == 2);

    A = [];
    for i = 1:h1
        Xi = [I1(i,:)'; 1];
        xi_ = I2(i, 1);
        yi_ = I2(i, 2);
        zs = zeros(3, 1);
        A = cat(1, A, cat(2, zs', Xi', -yi_*Xi'));
        A = cat(1, A, cat(2, Xi', zs', -xi_*Xi'));
    end

    [U, S, V] = svd(A);
    H = V(:,end);

    H = reshape(H, [3 3])';    
end