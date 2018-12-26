% Reference http://www.leet.it/home/giusti/teaching/matlab_sessions/stitching/stitch.html

function result = stitch(I1, H, I2)
    [~, xdata, ydata] =imtransform(I1,maketform('projective',H'));

    x_o=[min(1,xdata(1)) max(size(I2,2), xdata(2))];
    y_o=[min(1,ydata(1)) max(size(I2,1), ydata(2))];

    result1 = imtransform(I1, maketform('projective',H'),'XData',x_o,'YData',y_o);
    result2 = imtransform(I2, maketform('affine',eye(3)),'XData',x_o,'YData',y_o);
    result = result1 + result2;
    overlap = (result1 > 0.0) & (result2 > 0.0);
    result_avg = (result1/2 + result2/2);
    
    result(overlap) = result_avg(overlap);
end