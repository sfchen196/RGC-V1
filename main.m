data_mosaic = load("init_model/stat_M623_scaled.mat");
data_OFF = data_mosaic.mosaicOFF{1};
data_ON = data_mosaic.mosaicON{1};

data_OFF = [real(data_OFF) imag(data_OFF)];
data_ON = [real(data_ON) imag(data_ON)];

% Zero-center
data_center = (min([data_OFF;data_ON])+max([data_OFF;data_ON]))/2;
data_OFF = data_OFF-data_center;
data_ON = data_ON-data_center;

% Crop
crop_x = 1600;
crop_y = 1600;
crop_ON = data_ON; crop_OFF = data_OFF;
crop_ON(abs(crop_ON(:,1))>crop_x|abs(crop_ON(:,2))>crop_y,:) = [];
crop_OFF(abs(crop_OFF(:,1))>crop_x|abs(crop_OFF(:,2))>crop_y,:) = [];


pad_r = 1900;


%% RGC mosaics
Result = RGC_AC_mosaic(crop_ON,crop_OFF,pad_r,crop_x,crop_y);

pos_ON = cell2mat(Result(1));
pos_OFF = cell2mat(Result(2));
d_ON = cell2mat(Result(3));
d_OFF = cell2mat(Result(4));

figure(1);
plot(pos_ON(:, 1), pos_ON(:,2), '.r');
axis([-2000 2000 -2000 2000]);
hold on;
plot(pos_OFF(:, 1), pos_OFF(:,2), '.b');

%% init_V1_mosaic
d_V1 = [];
[pos_V1, pos_OFF] = init_V1_mosaic(d_V1,d_OFF,crop_x,crop_y,pos_ON,pos_OFF,2);
figure(2);
plot(pos_V1(:,1),pos_V1(:,2), '.r');
axis([-2000 2000 -2000 2000]);hold on;
[pos_V1, pos_OFF] = init_V1_mosaic(d_V1,d_OFF,crop_x,crop_y,pos_ON,pos_OFF,3);
plot(pos_V1(:,1),pos_V1(:,2), '.b');

%% construct orientation map


