%% Set up
crop_x = 1600;
crop_y = 1600;
crop_ON = zeros(160,2); crop_OFF = zeros(160,2); %% toy data
crop_ON(abs(crop_ON(:,1))>crop_x|abs(crop_ON(:,2))>crop_y,:) = [];
crop_OFF(abs(crop_OFF(:,1))>crop_x|abs(crop_OFF(:,2))>crop_y,:) = [];
pad_r = 1900;

%% Retinal Ganglion Cell mosaics
i = 1;
for i = 1:3
    for j = 1:3
alpha = 0.2
theta = pi/6
Result = rgcv1.RGC_mosaic(crop_ON,crop_OFF,pad_r,crop_x,crop_y, alpha, theta);
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

%% Calculate orientation tuning of each cortical cell
[best_response, best_response_location, selectivity, angles] = rgcv1.compute_OT(CTX_RF, RF_xx, RF_yy);
a = reshape(angles, sqrt(numel(angles)), sqrt(numel(angles)));
% figure(1); 
% imagesc(a); caxis([0 2*pi]); colorbar; map=colormap(hsv); axis xy image
% title(['Angle of each cortical cell : c<-r: ' num2str(ctx_retina_sigma) '; r<-s: ' num2str(retina_RF_sigma)]);
% 

%% Plot selectivity of each cortical cell
% s = reshape(selectivity, sqrt(numel(angles)), sqrt(numel(angles)));
% figure(2);
% imagesc(s); caxis([0 1]); colorbar; colormap('default'); axis xy image
% title('Selectivity of each cortical cell');
%% Plot orientation tuning of cortical cells whose selectivity >= threshold
threshold = 0.8

figure(3);
a=255*angles/(2*pi);
U8 = uint8(round(a - 1));
a = ind2rgb(U8,colormap(hsv));
a(selectivity < threshold,:,1) = 0;
a(selectivity < threshold,:,2) = 0;
a(selectivity < threshold,:,3) = 0;

a = reshape(a, sqrt(numel(angles)), sqrt(numel(angles)), 3);
subplot(3,3,i)
image(a); caxis([0 255]); colorbar; colormap(hsv);
axis xy image
title(['Angle of each cortical cell whose selectivity >= ' num2str(threshold)]);
i = i+1;
    end
end