function output_img = recognizeObjects(orig_img, labeled_img, obj_db)
    % Your program should compare (using your own comparison criteria) the 
    % properties of each object in a labeled image file with those from the object 
    % model database. 
    % It should produce an output image, which would display the 
    % positions, and orientations of only the recognized objects on the original 
    % image (using dots and line segments, as before)
    [orig_obj_db, out_img] = compute2DProperties(orig_img, labeled_img);
    
    fh1 = figure();
    imshow(orig_img);
    hold on;
    
    size_orig_obj = size(orig_obj_db);
    size_obj = size(obj_db);
    count_orig = size_orig_obj(2);
    count_db = size_obj(2);
        
%     fprintf("min_obj: %d, min_obj: %d\n", size_obj(1), size_obj(2));
%     fprintf("min_obj: %d, min_obj: %d\n", size_orig_obj(1), size_orig_obj(2));
    
    for i = 1 : count_orig
        orig_obj_prop = orig_obj_db(:, i);
        for j = 1 : count_db
            obj_prop = obj_db(:, j);
            % Check roundness and min_value
            round_orig = orig_obj_prop(6);
            round_obj = obj_prop(6);
            min_orig = orig_obj_prop(4);
            min_obj = obj_prop(4);
            
            roundness_diff = abs(round_orig - round_obj);
            min_diff = abs(min_orig - min_obj) / min_obj ;
%             fprintf("round_obj: %f\t round_orig: %f\n", round_obj, round_orig);
%             fprintf("min_obj: %f\t min_orig: %f\n", min_obj, min_orig);
            
            if (roundness_diff <0.05 && min_diff < 0.2)
                hold on;
                plot(orig_obj_prop(3), orig_obj_prop(2), 'ws', 'MarkerFaceColor', [1 1 1]);
                line([orig_obj_prop(3) orig_obj_prop(3) + 30 * sind(orig_obj_prop(5))],...
                     [orig_obj_prop(2) orig_obj_prop(2) + 30 * cosd(orig_obj_prop(5))],...
                    'LineWidth', 1.5, 'Color', [0,1,0]);
            end
        end
    end
    
    output_img = saveAnnotatedImg(fh1);
    fh2 = figure; imshow(output_img);
    delete(fh1);delete(fh2);

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
