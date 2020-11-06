function [Result] = RGC_AC_mosaic(crop_ON,crop_OFF,pad_r,crop_x,crop_y)
disp("Generate RGC padding and AC mosaics");

%% Lattice spacing
density_ON = size(crop_ON,1)/4/crop_x/crop_y; %%csf number of cells/vertices in unit surface
density_OFF = size(crop_OFF,1)/4/crop_x/crop_y;
d_ON = sqrt(2/sqrt(3)/density_ON); %%csf distance/spacing between 2 cells (b.c. most adjacent 3 cells form an equilateral triangle)
d_OFF = sqrt(2/sqrt(3)/density_OFF);

theta = 0.15*pi; rot_OFF = [cos(theta) sin(theta); -sin(theta) cos(theta)]; %%csf clockwise rotation of theta


%% RGC mosaic 
hex = 1/2*[1 1;sqrt(3) -sqrt(3)];
ij = combvec(-100:100,-100:100)';
Lij = ij*hex';
pos_OFF = d_OFF*Lij;
pos_ON = d_ON*Lij*rot_OFF';


noise = randn(size(pos_OFF))*d_OFF*0.1; % std = 10% d_OFF
% pos_ON = pos_ON + noise;
% pos_OFF = pos_OFF + noise;
%% Give displacement ????
% pos_OFF = pos_OFF+[500 1250];


%% Restrict
pos_ON(pos_ON(:,1).^2+pos_ON(:,2).^2>pad_r^2,:) = [];
pos_OFF(pos_OFF(:,1).^2+pos_OFF(:,2).^2>pad_r^2,:) = [];

pos_ON(abs(pos_ON(:,1))>crop_x|abs(pos_ON(:,2))>crop_y,:) = [];
pos_OFF(abs(pos_OFF(:,1))>crop_x|abs(pos_OFF(:,2))>crop_y,:) = [];

Result = {pos_ON, pos_OFF, d_ON, d_OFF};
end