function grating = make_gratings(RF_xx, RF_yy, orientation, spatial_phase, spatial_frequency, amplitude)
    
    % references code from http://courses.washington.edu/matlab1/Matlab4BS_c5.htm
    ramp = cos(orientation)* RF_xx + sin(orientation)* RF_yy;
%     rot = [cos(orientation) sin(orientation); -sin(orientation) cos(orientation)];
%     ramp = rot * [RF_xx(:)'; RF_yy(:)'];
%     RF_xx = 
    grating = amplitude * (sin(2 * pi * spatial_frequency * ramp + spatial_phase);
    
    %% to make 3-D square wave W/O ORIENTATION, use signum() and replace ramp with RF_xx
%     grating = amplitude * sign(sin(2 * pi * spatial_frequency * RF_xx + spatial_phase));
%     surf(RF_xx, RF_yy, grating);
%     shading interp
% %     view(2)
%     colormap gray

    imagesc(grating)
    colormap(gray(256))
    axis off
    axis square
    
    
    

end
