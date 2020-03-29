function stitched_img = stitchImg(varargin)

    result_img = varargin{ceil(nargin / 2)};
    index_bound = ceil(nargin / 2);
    for i = 1 : nargin
        if i ~= ceil(nargin / 2)
            img = varargin{i};
                    
            flag = 0;
            if i < index_bound
                flag = 1;
            end
            
            result_img = calculate_stitch(img, result_img, flag);
            result_img(isnan(result_img)) = 0;  

        end
    end
    stitched_img = result_img;
end


 function result = calculate_stitch(img, result_img, flag)
    [xs, xd] = genSIFTMatches(img, result_img);
    [~, H] = runRANSAC(xs, xd, 100, 5);

    [img_ht, img_wid, ~] = size(img);
    dest_corners = applyHomography(H, [1, 1; img_wid, 1; img_wid, img_ht; 1, img_ht]);

    tx = 0; 
    ty = 0;
    if flag == 1
        if round(min(dest_corners(:, 1))) < 0
            tx = -round(min(dest_corners(:, 1)));
            result_img = [zeros(size(result_img, 1),tx, 3), result_img];
        end
    else
        tmp_x = round(max(dest_corners(:, 1))) - size(result_img, 2);
        if tmp_x > 0
            result_img = [result_img, zeros(size(result_img, 1), tmp_x, 3)];
        end
    end

    [res_ht, ~] =  size(result_img);
    tmp_y = round(max(dest_corners(:, 2))) - res_ht;
    
    if round(min(dest_corners(:, 2))) < 0
        ty = -round(min(dest_corners(:, 2)));
        result_img = [zeros(ty, size(result_img, 2), 3); result_img];
    end
    if tmp_y > 0
        result_img = [result_img; zeros(tmp_y, size(result_img, 2), 3)];
    end
    cur_H = inv([1, 0, tx; 0, 1, ty; 0, 0, 1] * H);


    dest_canvas_wid_ht = [size(result_img, 2), size(result_img, 1)];
    [mask, res_img] = backwardWarpImg(img, cur_H, dest_canvas_wid_ht);

%     disp(size(mask))
%     disp(size(mask_ref))

    maskd = result_img(:, :, 1);
    maskd(result_img(:, :, 1) > 0) = 1;

    result = blendImagePair(res_img, mask, result_img, maskd, 'blend');
 end