%% Preparation code from repo 'rwave'
% data_mosaic = load("init_model/stat_M623_scaled.mat");
% data_OFF = data_mosaic.mosaicOFF{1};
% data_ON = data_mosaic.mosaicON{1};
% 
% data_OFF = [real(data_OFF) imag(data_OFF)];
% data_ON = [real(data_ON) imag(data_ON)];
% 
% % Zero-center
% data_center = (min([data_OFF;data_ON])+max([data_OFF;data_ON]))/2;
% data_OFF = data_OFF-data_center;
% data_ON = data_ON-data_center;

%% Set up parameters
crop_x = 1600;
crop_y = 1600;
% crop_ON = data_ON; crop_OFF = data_OFF;
crop_ON = zeros(150,2); crop_OFF = zeros(160,2); %% toy data

crop_ON(abs(crop_ON(:,1))>crop_x|abs(crop_ON(:,2))>crop_y,:) = [];
crop_OFF(abs(crop_OFF(:,1))>crop_x|abs(crop_OFF(:,2))>crop_y,:) = [];


pad_r = 1900;


%% RGC mosaics
Result = rgcv1.RGC_mosaic(crop_ON,crop_OFF,pad_r,crop_x,crop_y);

pos_ON = cell2mat(Result(1));
pos_OFF = cell2mat(Result(2));
d_ON = cell2mat(Result(3));
d_OFF = cell2mat(Result(4));

figure(1);
plot(pos_ON(:, 1), pos_ON(:,2), '.r');
axis([-2000 2000 -2000 2000]);
hold on;
plot(pos_OFF(:, 1), pos_OFF(:,2), '.b');
title('ON and OFF-center RGC mosaics');

%% init_V1_mosaic
d_V1 = [];
[pos_V1, pos_OFF] = rgcv1.init_V1_mosaic_nearest_dipole(d_V1,d_OFF,crop_x,crop_y,pos_ON,pos_OFF,2);
figure(2);
plot(pos_V1(:,1),pos_V1(:,2), '.r');
axis([-2000 2000 -2000 2000]);hold on;
[pos_V1, pos_OFF] = rgcv1.init_V1_mosaic_nearest_dipole(d_V1,d_OFF,crop_x,crop_y,pos_ON,pos_OFF,3);
plot(pos_V1(:,1),pos_V1(:,2), '.b');
title('dipole sampling (red) and nearest dipole (blue)');

%% construct orientation map
imgsize_x = 200; % Filtered map width
img_sig = 7; % Gaussian image filtering width (unit: pixels)
ff_w0_sig = 18; % 24 for monkey/mouse, 18 for cat % Initial Exponential wiring range
ff_w0_str = 0.05; % Initial wiring strength
ff_w0_thr = 0; % V1 selection threshold

% Initial feedforward wiring
Result = rgcv1.init_feedforward(ff_w0_sig,pos_OFF,pos_ON,pos_V1,ff_w0_str,ff_w0_thr);
w0_V1_ON = cell2mat(Result(1));
w0_V1_OFF = cell2mat(Result(2));
w_V1_ON = w0_V1_ON;
w_V1_OFF = w0_V1_OFF;
pos_V1 = cell2mat(Result(3));

Result = rgcv1.compute_OP(pos_ON,pos_OFF,w0_V1_ON,w0_V1_OFF,w_V1_ON,w_V1_OFF);
op0 = Result(:,1);
op = Result(:,2);

imgsize_y = imgsize_x*crop_y/crop_x;
opmap0 = rgcv1.V1_filt_Gaussian(crop_x,crop_y,imgsize_x,img_sig,pos_V1,op0,true);
opmap = rgcv1.V1_filt_Gaussian(crop_x,crop_y,imgsize_x,img_sig,pos_V1,op,true);

figure(3);
subplot(121); imagesc(opmap0); axis xy image; title('Initial'); colormap(hsv);
caxis([-pi/2 pi/2]); colorbar;
subplot(122); imagesc(opmap); axis xy image; title('Final'); colormap(hsv);
caxis([-pi/2 pi/2]); colorbar; drawnow;
