function [db, out_img] = compute2DProperties(orig_img, labeled_img)
    % takes a labeled image from the previous step and computes properties 
    % for each labeled object in the image.
    fh1 = figure();
    imshow(orig_img);
    
    [height,width] = size(orig_img);
    count = max(labeled_img(:)); %get the maximum value of the image
    
    db = zeros(7, count);%initialize the db
    
    for label = 1 : count
        % Row, column position of the center
        x = 0; y = 0; 
        for row = 1 : height
            for col = 1 : width
                if labeled_img(row,col) == label
                    x = x + row;
                    y = y + col;
                end
            end
        end
        
        % area
        region = (labeled_img==label);
        area = sum(region(:));
        
        x = floor(x/area);
        y = floor(y/area);
        db(1, label) = label;
        db(2, label) = x;
        db(3, label) = y;
        
        % Orientation
        a = 0; b = 0; c = 0;
        for row = 1 : height
            for col = 1 : width
                if labeled_img(row,col) == label
                    a = a + ((row-x ) * (row-x));
                    b = b + ((row-x ) * (col-y) * 2);
                    c = c + ((col-y ) * (col-y));
                end
            end
        end
        orientation = 0.5 * atand(b / (a-c));
        
        % The minimum moment of inertia
        min_value = a * sind(orientation) * sind(orientation) - b * sind(orientation) * cosd(orientation) + c * cosd(orientation) * cosd(orientation);
        max_value = a * sind(orientation+90) * sind(orientation+90) - b * sind(orientation+90) * cosd(orientation+90) + c * cosd(orientation+90) * cosd(orientation+90);
        if min_value >= max_value
            tmp = max_value;
            max_value = min_value;
            min_value = tmp;
            orientation = orientation + 90;
        end
        db(4, label) = min_value;
        db(5, label) = orientation;

        
        % roundness
        roundness = min_value / max_value;
        db(6, label) = roundness;
     

        db(7, label) = area;
        
        % plot the point and line
        hold on; 
        plot(y, x, 'ws', 'MarkerFaceColor', [1 1 1]);
        line([y y + 30 * sind(orientation)], [x x + 30 * cosd(orientation)],'LineWidth', 4, 'Color', [0, 1, 0]);
        
    end
    
    annotated_img = saveAnnotatedImg(fh1); 
    fh2 = figure; imshow(annotated_img);
    delete(fh1); delete(fh2);
    
    out_img = annotated_img;
    
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
