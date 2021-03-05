%% Set up
crop_x = 1600;
crop_y = 1600;
crop_ON = zeros(160,2); crop_OFF = zeros(160,2); %% toy data
crop_ON(abs(crop_ON(:,1))>crop_x|abs(crop_ON(:,2))>crop_y,:) = [];
crop_OFF(abs(crop_OFF(:,1))>crop_x|abs(crop_OFF(:,2))>crop_y,:) = [];
pad_r = 1900;

%% Retinal Ganglion Cell mosaics
Result = rgcv1.RGC_mosaic(crop_ON,crop_OFF,pad_r,crop_x,crop_y);
pos_ON = cell2mat(Result(1));
pos_OFF = cell2mat(Result(2));

%% V1 Cortical Cell grids
pos_xy = combvec(-1600:100:1600,-1600:100:1600)';

%% Stimulus Gratings
[RF_xx, RF_yy] = meshgrid(linspace(0,pi,201));

index = 0;
for i=1:3
    for j=1:3
        index = index + 1;
        ctx_retina_sigma = i*56
        retina_RF_sigma = j*7
        %% Calculate weights between stimulus/RF and cortical cells
        [RF_ctx_ON,RF_ctx_OFF, CTX_RF] = rgcv1.compute_RF(pos_ON,pos_OFF,pos_xy, ctx_retina_sigma, retina_RF_sigma, RF_xx, RF_yy);

        %% Calculate orientation tuning of each cortical cell
        [best_response, best_response_location, selectivity, angles] = rgcv1.compute_OT(CTX_RF, RF_xx, RF_yy);
        angles = reshape(angles, sqrt(numel(best_response_location)), sqrt(numel(best_response_location)));
        figure(1); subplot(3,3,index); 

        imagesc(angles); caxis([0 2*pi]); colorbar; colormap(hsv); axis xy image
        title(['c<-r: ' num2str(ctx_retina_sigma) '; r<-s: ' num2str(retina_RF_sigma)]);
    end
end


%% when c<-r weight is smaller than r<-s weight
ctx_retina_sigma = 7
retina_RF_sigma = 112
%% Calculate weights between stimulus/RF and cortical cells
[RF_ctx_ON,RF_ctx_OFF, CTX_RF] = rgcv1.compute_RF(pos_ON,pos_OFF,pos_xy, ctx_retina_sigma, retina_RF_sigma, RF_xx, RF_yy);

%% Calculate orientation tuning of each cortical cell
[best_response, best_response_location, selectivity, angles] = rgcv1.compute_OT(CTX_RF, RF_xx, RF_yy);
angles = reshape(angles, sqrt(numel(best_response_location)), sqrt(numel(best_response_location)));
figure(2); 

imagesc(angles); caxis([0 2*pi]); colorbar; colormap(hsv); axis xy image
title(['c<-r: ' num2str(ctx_retina_sigma) '; r<-s: ' num2str(retina_RF_sigma)]);
