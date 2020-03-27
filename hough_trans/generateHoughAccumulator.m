function hough_img = generateHoughAccumulator(img, theta_num_bins, rho_num_bins)
    % Be careful while choosing the range of possible \theta and p
    % and the number of bins for the accumulator array
   
    [row,col] = size(img);
    
    const_rho = sqrt(row.^2 + col.^2);
    
    result_img = zeros(rho_num_bins, theta_num_bins);
    
    for i = 1 : row
        for j = 1 : col
            if (img(i,j) > 40)
                 tmp_const = sqrt(i.^2+j.^2);
                 p = asin(i./tmp_const);
                 if (j>0)
                     p = pi - p;
                 end 
                 for t = 1 : theta_num_bins
                     tmp_theta = pi ./ theta_num_bins .* (t - 0.5);
                     tmp_rho = tmp_const .* sin(p + tmp_theta);
                     tmp_rho_index = round((tmp_rho + const_rho) ./ (const_rho .* 2 ./ rho_num_bins));
                     result_img(tmp_rho_index, t) = result_img(tmp_rho_index, t) + 1;
                 end
            end
        end
    end
    
    norm_img = result_img./max(result_img(:)).*255;
    
    hough_img = norm_img;
end