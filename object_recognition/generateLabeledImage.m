function labeled_img = generateLabeledImage(gray_img, threshold)
    %     converts a gray-level image to a binary image using a threshold value 
    %     and segments the binary image into several connected regions
    bw_img = im2bw(gray_img, threshold);
    labeled_img = bwlabel(bw_img);
end

    
