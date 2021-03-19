function [RF_ctx_ON,RF_ctx_OFF, RF_ctx] = compute_RF(pos_ON,pos_OFF,pos_xy, ctx_retina_sigma, retina_RF_sigma, RF_xx, RF_yy, retina_microns_per_degree)
  %% inputs
      % pos_ON : N*2 matrix, positions of ON-retinal cells
      % pos_OFF: N*2 matrix, positions of OFF-retinal cells
      % pos_xy : K*2 matrix, positions of cortical celss
      % V1_retina_sigma : feedforward sigma between V1 and retina
      % retina_RF_sigma: feedforward sigma between retina and receptive field
      % [RF_xx, RF_yy] = meshgrid(1:M, 1:M) 
      
  %% outputs
      % RF_ctx_ON: Receptive Field for Cortical cells thru ON-RGCs
      % RF_ctx_OFF: Receptive Field for Cortical cells thru OFF-RGCs
      % RF_ctx: overall RF?
      
   
  % V1<-ON
  distx = pos_xy(:,1) - pos_ON(:,1)'; % number of V1 cells x number of ON retinal cells
  disty = pos_xy(:,2) - pos_ON(:,2)'; % number of V1 cells x number of ON retinal cells
  dist = sqrt(distx.^2+disty.^2);   % number of V1 cells x number of ON retinal cells
  ctx_ON = exp(-dist/ctx_retina_sigma);    % number of V1 cells x number of ON retinal cells
  assignin('base','ctx_ON',ctx_ON) 
  
  % V1<-OFF
  distx = pos_xy(:,1) - pos_OFF(:,1)';
  disty = pos_xy(:,2) - pos_OFF(:,2)';
  dist = sqrt(distx.^2+disty.^2);
  ctx_OFF = exp(-dist/ctx_retina_sigma);
  assignin('base','ctx_OFF',ctx_OFF)
 
  % RF of each ON retinal cell   
  dist_xr = RF_xx(:) - pos_ON(:,1)'/retina_microns_per_degree; % number of pixels in RF x number of ON retinal cells
  dist_yr = RF_yy(:) - pos_ON(:,2)'/retina_microns_per_degree; % number of pixels in RF x number of ON retinal cells
  dist = sqrt(dist_xr.^2+dist_yr.^2); % number of pixels in RF x number of ON retinal cells
  RFs_ON = exp(-dist/retina_RF_sigma); % number of pixels in RF x number of ON retinal cells
  assignin('base','RFs_ON', RFs_ON)
  
  % RF of each OFF retinal cell   
  dist_xr = RF_xx(:) - pos_OFF(:,1)'/retina_microns_per_degree;
  dist_yr = RF_yy(:) - pos_OFF(:,2)'/retina_microns_per_degree;
  dist = sqrt(dist_xr.^2+dist_yr.^2);
  RFs_OFF = exp(-dist/retina_RF_sigma);
  assignin('base','RFs_OFF', RFs_OFF) 
  %% compute RF for cortical cell i thru ON cell:
   RF_ctx_ON = ctx_ON * RFs_ON'; 
  % cortical RF will be of size: number of V1 cells * number of pixels (RF)
  
%   
%   RF_ctx_ON = zeros(size(RF_xx,1),size(RF_xx,2),size(pos_xy,1));
%   for i=1:size(pos_xy,1),
%         % what is the contribution of retinal ON cells to this cortical RF?
%         for j=1:size(pos_ON,1),
%           % example: RF_50 = reshape(RFs_ON(:,50),size(RF_xx)); 
%           % RFs_ON(:,50): the feedforward weights from all the pixels to the 50th ON_cell
%           RF_here = reshape(RFs_ON(:,j),size(RF_xx)); % number of ROWS in RF * number of COLUMNS in RF
%           RF_ctx_ON(:,:,i) = RF_ctx_ON(:,:,i) + ctx_ON(i,j) * RF_here;
%         end;                                                                    
%   end;
   
  
  
  %% compute RF for cortical cell i thru OFF cell:
  RF_ctx_OFF = ctx_OFF * RFs_OFF';
%   cortical RF will be of size: number of V1 cells * number of pixels (RF)
  
  
%   RF_ctx_OFF = zeros(size(RF_xx,1),size(RF_xx,2),size(pos_xy,1));
%   for i=1:size(pos_xy,1),
%         % what is the contribution of retinal OFF cells to this cortical RF?
%         for j=1:size(pos_OFF,1),
%           % example: RF_50 = reshape(RFs_ON(:,50),size(RF_xx)); 
%           % RFs_ON(:,50): the feedforward weights from all the pixels to the 50th ON_cell
%           RF_here = reshape(RFs_OFF(:,j),size(RF_xx)); % number of ROWS in RF * number of COLUMNS in RF
%           RF_ctx_OFF(:,:,i) = RF_ctx_OFF(:,:,i) + ctx_OFF(i,j) * RF_here;
%         end;
%   end;


   %% compute overall RF by subtracting RF_ctx_OFF from RF_ctx_ON
   RF_ctx = RF_ctx_ON - RF_ctx_OFF;
   
   
end










