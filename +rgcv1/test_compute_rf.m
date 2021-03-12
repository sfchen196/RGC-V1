%% Set up
crop_x = 1600;
crop_y = 1600;
crop_ON = zeros(160,2); crop_OFF = zeros(160,2); %% toy data
crop_ON(abs(crop_ON(:,1))>crop_x|abs(crop_ON(:,2))>crop_y,:) = [];
crop_OFF(abs(crop_OFF(:,1))>crop_x|abs(crop_OFF(:,2))>crop_y,:) = [];
pad_r = 1900;

alpha = 0.;
theta = 0.15*pi;

%% Retinal Ganglion Cell mosaics
Result = rgcv1.RGC_mosaic(crop_ON,crop_OFF,pad_r,crop_x,crop_y,alpha,theta);
pos_ON = cell2mat(Result(1));
pos_OFF = cell2mat(Result(2));

%% V1 Cortical Cell grids
pos_xy = combvec(-1600:100:1600,-1600:100:1600)';

%% Stimulus Gratings
[RF_xx, RF_yy] = meshgrid(linspace(0,pi,201));

ctx_retina_sigma = 56
retina_RF_sigma = 7
%% Calculate weights between stimulus/RF and cortical cells
[RF_ctx_ON,RF_ctx_OFF, CTX_RF] = rgcv1.compute_RF(pos_ON,pos_OFF,pos_xy, ctx_retina_sigma, retina_RF_sigma, RF_xx, RF_yy);
% [RF_ctx_ON,RF_ctx_OFF, CTX_RF] = rgcv1.compute_RF_copy(pos_ON,pos_OFF,pos_xy, ctx_retina_sigma, retina_RF_sigma, RF_xx, RF_yy);
rgcv1.plot_retina_cortex(workspace2struct, 141);
% size(RF_ctx_ON1)  
% size(RF_ctx_ON)
% RF_ctx_ON1 = reshape(RF_ctx_ON1, size(RF_ctx_ON1,1)^2, size(RF_ctx_ON1,3))
% RF_ctx_ON == RF_ctx_ON1'