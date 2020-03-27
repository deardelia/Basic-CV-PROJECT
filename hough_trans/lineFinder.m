function line_detected_img = lineFinder(orig_img, hough_img, hough_threshold)
    
     fh1 = figure();
     imshow(orig_img);
     hold on;

     [row, col] = size(orig_img);
     [rho_num_bins,theta_num_bins] = size(hough_img);
     const_rho =  sqrt(row.^2 + col.^2);
     result = [];
     for i = 1 : rho_num_bins
         for j = 1 : theta_num_bins
             if (hough_img(i,j) > hough_threshold)
                 tmp = [i, j];
                 result = [result;tmp];
             end
         end
     end
     
     tmp_col = size(result,1);
     
     tmp_array = ones(tmp_col,1);
     for i = 1 : tmp_col - 1
         if (tmp_array(i) ~= 0)
             for j = i + 1 : tmp_col
                 if (abs(result(i,1) - result(j,1)) < 15 && abs(result(i,2) - result(j,2)) < 15)
                    if hough_img(result(i,1),result(i,2)) >= hough_img(result(j,1),result(j,2))
                        tmp_array(j) = 0;
                    else 
                        tmp_array(i) = 0;
                        break;
                    end
                 end
             end
         end
     end
     
     tmp_rho = result(tmp_array>0,1);
     tmp_theta = result(tmp_array>0,2);
     
     rho = 2 * const_rho .* (tmp_rho - 0.5) ./ rho_num_bins - const_rho;
     theta = pi .* (tmp_theta - 0.5) ./ theta_num_bins; 
     
      for i = 1 : size(rho,1)
          x = 0;
          y = rho(i) ./ cos(theta(i));
          line_array = [[x, y];[col, (rho(i)  +  col .* sin(theta(i))) ./ cos(theta(i))]];
          plot(line_array(:, 1), line_array(:, 2),'LineWidth',2, 'Color', [0, 1, 0]);
      end

    line_detected_img = saveAnnotatedImg(fh1);    
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

