function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)

    inliers_id = 0;
    for i = 1 : ransac_n
        tmp_index = randperm(size(Xs, 1), 4);
        x_src = Xs(tmp_index, :);
        x_dst = Xd(tmp_index, :);
        H_3x3 = computeHomography(x_src, x_dst);
        dest_pts = applyHomography(H_3x3, Xs);
        
        tmp = (dest_pts - Xd) .* ((dest_pts - Xd));
        tmp(:, 1) = tmp(:,1) + tmp(:,2);
        result_idx = find(sqrt(tmp(:, 1)) < eps)';
        
        if size(result_idx, 2) > size(inliers_id, 2)
            H = H_3x3;
            inliers_id = result_idx;
        end
    end

end