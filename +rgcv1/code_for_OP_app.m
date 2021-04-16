
theta = 0.15*pi;
alpha = 0;
ctx_retina_sigma = 100;
retina_RF_sigma = 14;
threshold = 0.75


 %% Set up
crop_x = 1600;
crop_y = 1600;
crop_ON = zeros(160,2); crop_OFF = zeros(160,2); %% toy data
crop_ON(abs(crop_ON(:,1))>crop_x|abs(crop_ON(:,2))>crop_y,:) = [];
crop_OFF(abs(crop_OFF(:,1))>crop_x|abs(crop_OFF(:,2))>crop_y,:) = [];
pad_r = 1900;


%% Retinal Ganglion Cell mosaics
Result = rgcv1.RGC_mosaic(crop_ON,crop_OFF,pad_r,crop_x,crop_y,alpha, theta);
pos_ON = cell2mat(Result(1));
pos_OFF = cell2mat(Result(2));

%% V1 Cortical Cell grids
pos_xy = combvec(-1600:100:1600,-1600:100:1600)';

%% Stimulus Gratings
% [RF_xx, RF_yy] = meshgrid(linspace(0,pi,201));
visual_space_to_simulate = 30;
[RF_xx, RF_yy] = meshgrid(linspace(-visual_space_to_simulate,visual_space_to_simulate,201));

retina_microns_per_degree = 1500 / 30;

%% Calculate weights between stimulus/RF and cortical cells

[RF_ctx_ON,RF_ctx_OFF, CTX_RF] = rgcv1.compute_RF(pos_ON,pos_OFF,pos_xy, ctx_retina_sigma, retina_RF_sigma, RF_xx, RF_yy, retina_microns_per_degree );

%% Calculate orientation tuning of each cortical cell
frequencies = 0.1:0.01:0.5;
best_r = -inf;
best_f = 0;
for f=frequencies
[best_response, best_response_location, selectivity, angles] = rgcv1.compute_OT(CTX_RF, RF_xx, RF_yy, f);
if best_r < sum(rectify(best_response))
    best_r = sum(rectify(best_response));
    best_f = f;
end
end

best_r
best_f
[best_response, best_response_location, selectivity, angles] = rgcv1.compute_OT(CTX_RF, RF_xx, RF_yy, best_f);
a = reshape(angles, sqrt(numel(best_response_location)), sqrt(numel(best_response_location)));

figure();
ax1=gca;
imagesc(a); 
caxis([0 pi]); 
colorbar; colormap(hsv); axis xy image
title(['c<-r: ' num2str(ctx_retina_sigma) '; r<-s: ' num2str(retina_RF_sigma)]);

 %% Plot selectivity of each cortical cell
s = reshape(selectivity, sqrt(numel(angles)), sqrt(numel(angles)));
figure();
ax2=gca;
imagesc(s); caxis([0 1]); colorbar; colormap('default'); axis xy image
title('Selectivity of each cortical cell');
%% Plot orientation tuning of cortical cells whose selectivity >= threshold


a=255*angles/(pi);
U8 = uint8(a);
%U8 = uint8(round(a - 1));
a = ind2rgb(U8,colormap(hsv));
a(selectivity < threshold,:,1) = 0;
a(selectivity < threshold,:,2) = 0;
a(selectivity < threshold,:,3) = 0;
a = reshape(a, sqrt(numel(angles)), sqrt(numel(angles)), 3);
figure();
ax3=gca;
image(1:33,1:33,a); 
caxis([0 255]); 
colorbar; colormap(hsv);
axis xy image
title(['Angle of each cortical cell whose selectivity >= ' num2str(threshold)]);
linkaxes([ax1 ax2 ax3])