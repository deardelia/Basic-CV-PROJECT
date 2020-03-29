function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
    dest_canvas_width_height)


    [row, col, ~] = size(src_img);

    [x, y] = meshgrid(1:dest_canvas_width_height(1), 1:dest_canvas_width_height(2));
    src_pts = applyHomography(resultToSrc_H, [x(:), y(:)]);

    result_img(:, :, 1) = getChannelValue(row, col, src_img, src_pts, dest_canvas_width_height, 1);
    result_img(:, :, 2) = getChannelValue(row, col, src_img, src_pts, dest_canvas_width_height, 2);
    result_img(:, :, 3) = getChannelValue(row, col, src_img, src_pts, dest_canvas_width_height, 3);
    
    result_img(isnan(result_img)) = 0;
    
    src_points = [1,1; 1,row; col,row; col,1; 1,1];
    H_3x3 = inv(resultToSrc_H);
    dest_pts = applyHomography(H_3x3,src_points);
    
    x_i = round(dest_pts(:, 1));
    y_i = round(dest_pts(:, 2));
    mask = convert(poly2mask(x_i, y_i,  dest_canvas_width_height(2), dest_canvas_width_height(1)));

    result_img = result_img .* cat(3, mask, mask, mask);
    

end

function channelValue = getChannelValue(row, col, img, cur_pts, dest_canvas_width_height, tag)
    channelValue = interp2(1 : col, 1 : row, img(:, :, tag), cur_pts(:, 1), cur_pts(:, 2));
    channelValue = reshape(channelValue, [dest_canvas_width_height(2), dest_canvas_width_height(1)]);
end

function out_img = convert(img)
    if isa(img, 'logical') || isa(img, 'single')
        out_img = double(img);
    elseif isa(img, 'double')
        out_img = img; 
    elseif isa(img, 'uint8')
        if nargin==1
            out_img = double(img) / 255;
        else
            out_img = double(img)+1;
        end
    end
end
