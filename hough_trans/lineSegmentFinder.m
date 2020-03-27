function cropped_line_img = lineSegmentFinder(orig_img, hough_img, hough_threshold)
    fh1 = figure();
    imshow(orig_img);
    hold on;
    
    [row, col] = size(orig_img);
    [rho_num_bins,theta_num_bins] = size(hough_img);
    
    
    const_rho =  sqrt(row.^2 + col.^2);
    
    for i = 1 : rho_num_bins
         for j = 1 : theta_num_bins
             if (hough_img(i,j) >= hough_threshold)
                 tmp_rho = 2 * const_rho .* i ./ rho_num_bins - const_rho;
                 tmp_theta = pi .* j ./ theta_num_bins;
                 
                 [y, x, ~] = find(orig_img);
                 tmp_index = find(abs(y .* cos(tmp_theta) - x .* sin(tmp_theta) - tmp_rho) <= 1);
                 y = y(tmp_index); 
                 x = x(tmp_index);
                 tmp_m = zeros(size(y));
      
                 for tmp_i = 1 : size(y)
                     if ((y(tmp_i) < row) && (y(tmp_i) > 1) && (x(tmp_i) < col) && (x(tmp_i) > 2))
                         cur = [orig_img(y(tmp_i)-1,x(tmp_i)-1), orig_img(y(tmp_i)+1,x(tmp_i)+1),...
                             orig_img(y(tmp_i)-1,x(tmp_i)+1), orig_img(y(tmp_i)+1,x(tmp_i)-1)];
                         if max(cur) - min(cur) > 6
                             tmp_m(tmp_i)=1;
                         end
                     end
                 end    
                 
                 tmp_index2 = find(tmp_m > 0);
                 y = y(tmp_index2); 
                 x = x(tmp_index2);
                 
                 if (size(y,1)==0)
                     continue
                 end
                 
                 coordinates = [x + (tmp_rho ./ sin(tmp_theta)), y] * [cos(-tmp_theta) sin(-tmp_theta); -sin(-tmp_theta) cos(-tmp_theta)];
                 x_cor = sort(coordinates(:,1));
                 x_index = [0; find([diff(x_cor); Inf] > 2)];
                 
                 for t = 1 : length(x_index) - 1
                     t_idx_1 = x_index(t) + 1;
                     t_idx_2 = x_index(t + 1);
                     x_1 = x_cor(t_idx_1); 
                     x_2 = x_cor(t_idx_2);
                     if (x_2 - x_1) > 20
                         angle = [tmp_rho ./ sin(tmp_theta), 0];
                         p1 = [x_1 0] / ([cos(-tmp_theta) sin(-tmp_theta); -sin(-tmp_theta) cos(-tmp_theta)]) - angle;
                         p2 = [x_2 0] / ([cos(-tmp_theta) sin(-tmp_theta); -sin(-tmp_theta) cos(-tmp_theta)]) - angle;
                         line = [p1; p2];
                         plot(line(:, 1), line(:, 2),'LineWidth',1, 'Color', [0, 1, 0]);
                     end
                 end
             end
         end
     end
                
                
    cropped_line_img = saveAnnotatedImg(fh1); 
    delete(fh1);
    
    

end

function annotated_img = saveAnnotatedImg(fh)
figure(fh); % Shift the focus back to the figure fh

% The figure needs to be undocked
set(fh, 'WindowStyle', 'normal');

% The following two lines just to make the figure true size to the
% displayed image. The reason will become clear later.
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);

% getframe does a screen capture of the figure window, as a result, the
% displayed figure has to be in true size. 
frame = getframe(fh);
frame = getframe(fh);
pause(0.5); 
% Because getframe tries to perform a screen capture. it somehow 
% has some platform depend issues. we should calling
% getframe twice in a row and adding a pause afterwards make getframe work
% as expected. This is just a walkaround. 
annotated_img = frame.cdata;
end
