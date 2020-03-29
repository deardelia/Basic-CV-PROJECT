function H_3x3 = computeHomography(src_pts_nx2, dest_pts_nx2)
    %calculates the homography between two sets of corresponding points in two images
    [src_row, ~] = size(src_pts_nx2);
    
    xs = src_pts_nx2(:, 1);
    ys = src_pts_nx2(:, 2);
    xd = dest_pts_nx2(:, 1);
    yd = dest_pts_nx2(:, 2);
    
    result = [];
    
    for i = 1 : src_row
        row_1 = [xs(i), ys(i), 1, 0, 0, 0, -1.*xd(i).*xs(i),-1.*xd(i).*ys(i), -1.*xd(i)];
        row_2 = [0, 0, 0, xs(i), ys(i), 1,-1.*yd(i).*xs(i), -1.*yd(i).*ys(i), -1.*yd(i)];
        result = [result;row_1;row_2];
    end
    [h,~] = eig(result'*result);
    H_3x3 = reshape(h(:,1),[3,3])';
end

