function [weights_ON,weights_OFF] = compute_RF(pos_ON,pos_OFF,pos_xy,sigma,cortex_xx,cortex_yy)
    %% if pos_xy is a V1 cell
    
    % V1<-ON
    distx = pos_xy(1) - pos_ON(:,1);
    disty = pos_xy(2) - pos_ON(:,2);
    dist = sqrt(distx.^2+disty.^2);
    weights_ON = exp(-dist/sigma);
    
    % V1<-OFF
    distx = pos_xy(1) - pos_OFF(:,1);
    disty = pos_xy(2) - pos_OFF(:,2);
    dist = sqrt(distx.^2+disty.^2);
    weights_OFF = exp(-dist/sigma);
    
    
    %% if pos_xy is a pt in the filtered map
%     distx = cortex_xx - pos_xy(1); 
%     disty = cortex_yy - pos_xy(2);
%     gauss = exp(-(distx.^2+disty.^2)/img_sig^2/2);
 
    
    
end












