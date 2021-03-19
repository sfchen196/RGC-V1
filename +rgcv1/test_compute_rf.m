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
pos_ON = cell2mat(Result(1));  % units of microns on retinal surface
pos_OFF = cell2mat(Result(2)); % units of microns on retinal surface

%% V1 Cortical Cell grids
pos_xy = combvec(-1600:100:1600,-1600:100:1600)';  % microns on cortical surface

% Stimulus space: units are degrees of visual angle, and we will represent
%   visual space from -30 to 30 degrees of visual angle

visual_space_to_simulate = 30;

%% Stimulus Gratings
[RF_xx, RF_yy] = meshgrid(linspace(-visual_space_to_simulate,visual_space_to_simulate,201));

ctx_retina_sigma = 56   % units of microns in retinal space
retina_RF_sigma = 7   % units of degrees of visual angle
retina_microns_per_degree = 1500 / 30;


%% Calculate weights between stimulus/RF and cortical cells
[RF_ctx_ON,RF_ctx_OFF, CTX_RF] = rgcv1.compute_RF(pos_ON,pos_OFF,pos_xy, ctx_retina_sigma, retina_RF_sigma, RF_xx, RF_yy,retina_microns_per_degree);
% [RF_ctx_ON,RF_ctx_OFF, CTX_RF] = rgcv1.compute_RF_copy(pos_ON,pos_OFF,pos_xy, ctx_retina_sigma, retina_RF_sigma, RF_xx, RF_yy);
rgcv1.plot_retina_cortex(workspace2struct, 80);
% size(RF_ctx_ON1)  
% size(RF_ctx_ON)
% RF_ctx_ON1 = reshape(RF_ctx_ON1, size(RF_ctx_ON1,1)^2, size(RF_ctx_ON1,3))
% RF_ctx_ON == RF_ctx_ON1'