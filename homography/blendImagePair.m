function out_img = blendImagePair(wrapped_imgs, masks, wrapped_imgd, maskd, mode)
    masks = convert(masks);
    maskd = convert(maskd);
    
    masks(masks > 0) = 1;
    maskd(maskd > 0) = 1;
    
    [m_h_d,m_w_d] = size(maskd);
    [m_h_s,m_w_s] = size(masks);
    
    wrapped_imgd = convert(wrapped_imgd);
    wrapped_imgs = convert(wrapped_imgs);
    if strcmp(mode, 'overlay')        
        tmp_img = zeros([m_h_d,m_w_d,3]);
        for i = 1 : 3
            tmp_img(:,:,i) = ~maskd;
        end
        out_img = wrapped_imgs .* tmp_img + wrapped_imgd;
    elseif strcmp(mode, 'blend')
        mask_s = bwdist(~masks);
        mask_s = mask_s / max(mask_s(:));
        tmp_m_s = zeros([m_h_s,m_w_s,3]);
        for i = 1 : 3
            tmp_m_s(:,:,i) = mask_s / max(mask_s(:));
        end
        wt_imgs = wrapped_imgs .* tmp_m_s;
        
        mask_d = bwdist(~maskd);
        mask_d = mask_d / max(mask_d(:));
        tmp_m_d = zeros([m_h_d,m_w_d,3]);
        for i = 1 : 3
            tmp_m_d(:,:,i) = mask_d / max(mask_d(:));
        end
        wt_imgd = wrapped_imgd .* tmp_m_d;
        
        out_img = (wt_imgs + wt_imgd) ./ (tmp_m_s + tmp_m_d);
    end
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