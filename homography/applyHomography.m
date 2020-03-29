function dest_pts_nx2 = applyHomography(H_3x3, src_pts_nx2)
    [src_row, ~] = size(src_pts_nx2);
    
    transformed_pts = H_3x3 * [src_pts_nx2, ones(src_row, 1)]';
    transformed_pts = transformed_pts';
    dest_pts_nx2 = transformed_pts(:, 1:2) ./ transformed_pts(:, 3);
end
