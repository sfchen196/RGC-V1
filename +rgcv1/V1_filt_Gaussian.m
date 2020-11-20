function [map] = V1_filt_Gaussian(crop_x,crop_y,imgsize_x,img_sig,pos_V1,vals,circ)
imgsize_y = round(imgsize_x*crop_y/crop_x);

pos_V1(:,1) = pos_V1(:,1)*imgsize_x/2/crop_x+imgsize_x/2; %% adapt locs to img_size
pos_V1(:,2) = pos_V1(:,2)*imgsize_y/2/crop_y+imgsize_y/2;
n_V1 = size(pos_V1,1);
[xx,yy] = meshgrid(1:imgsize_x,1:imgsize_y);

distx = xx-reshape(pos_V1(:,1),[1 1 n_V1]); %% generates 3-D matrix: img_size * img_size * number_of_V1
disty = yy-reshape(pos_V1(:,2),[1 1 n_V1]);
gauss = exp(-(distx.^2+disty.^2)/img_sig^2/2);

if circ
    %% multiplies each orientation vector (ON_loc - OFF_loc) with 2i --> rotates the vec by 90 degree and then scales length by 2
    %% exp of complex number, exp(a+bi) --> exp(a)*[cos(b) + i*sin(b)]
    map = gauss.*exp(2i*reshape(vals,[1 1 n_V1])); 
    map = nansum(map,3); 
    map = angle(map)/2; %% 3-D complex matrix changes to 2-D double matrix of radians here 
    map(map<-pi/2) = map(map<-pi/2)+pi;
    map(map>pi/2) = map(map>pi/2)-pi;
else
    minv = min(vals); maxv = max(vals);
    norm_vals = (vals-minv)/(maxv-minv);
    map = gauss.*exp(1i*reshape(norm_vals,[1 1 n_V1]));
    map = nansum(map,3);
    map = angle(map);
    map = map*(maxv-minv)+minv;
end
end