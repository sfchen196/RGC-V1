function grating = make_grating(RF_xx, RF_yy, orientation, spatial_phase, spatial_frequency, amplitude)
% MAKE_GRATINGS - make a sinusoidal grating for a visual stimulus
%  
%  GRATING = MAKE_GRATINGS(RF_XX, RF_YY, ORIENTATION, SPATIAL_PHASE, ...
%      SPATIAL_FREQUENCY, AMPLITUDE)
%  Format of RF_xx and RF_yy: [RF_xx, RF_yy] = meshgrid(linspace(-pi,pi,n));
%   (should have units of degrees of visual angle; n is resolution)
%  RF_xx are the X positions of each stimulus point in units of degrees of
%    visual angle
%  RF_yy are the Y positions of each stimulus point in units of degrees of
%    visual angle
%  ORIENTATION is the orientation of the grating in radians
%  SPATIAL_FREQUENCY is the spatial frequency of the grating in
%    cycles/degree of visual angle
%  AMPLITUDE is the amplitude of the grating
%

    % references code from http://courses.washington.edu/matlab1/Matlab4BS_c5.htm
    ramp = cos(orientation).* RF_xx + sin(orientation).* RF_yy;
%     rot = [cos(orientation) sin(orientation); -sin(orientation) cos(orientation)];
%     ramp = rot * [RF_xx(:)'; RF_yy(:)'];
%     RF_xx = 
    grating = amplitude * (sin(2 * pi * spatial_frequency * ramp + spatial_phase));
    
    %% to make 3-D square wave W/O ORIENTATION, use signum() and replace ramp with RF_xx
%     grating = amplitude * sign(sin(2 * pi * spatial_frequency * RF_xx + spatial_phase));
%     surf(RF_xx, RF_yy, grating);
%     shading interp
% %     view(2)
%     colormap gray
% 
%    imagesc(grating)
%   colormap(gray(256))
%    axis off
%   axis square
    
    
    

end
