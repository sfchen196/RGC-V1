function [best_response, best_response_location, selectivity, angles] = compute_OT(CTX_RF, RF_XX, RF_YY, spatial_frequency)
% COMPUTE_OT - compute orientation tuning for all cortical cells
% 
% [best_response, best_theta, selectivity] = compute_OT(CTX_RF, RF_XX, RF_YY)

plotit = 1;

  % make gratings of each orientation (say, 16 steps O = linspace(0,pi,17));
  % O = O(1:end-1); 
  % 
  % G = cat(3, G, gratings(..., O(i), ...)
  n_step = 16;
  spatial_phase = 0;
%   spatial_frequency = 0.1; 
  amplitude = 1;
  orientation = linspace(0,pi,n_step+1);
  orientation = orientation(1:end-1);
  assignin('base', 'orientations', orientation);   
  
  phases = 0:pi/6:2*pi-pi/6;
  % gratings: 2d-matrix of retina cells by (number of orientations*number of phases)
  gratings = zeros(size(RF_XX,1),size(RF_XX,2), numel(orientation),numel(phases)); 
 
  for i=1:n_step
      phase_idx = 1;
      for spatial_phase = phases
          gratings(:,:,i,phase_idx) = rgcv1.make_grating(RF_XX, RF_YY, orientation(i), spatial_phase, spatial_frequency, amplitude);
          phase_idx = phase_idx + 1;
      end
  end
  
  disp("Finish gratings");
  assignin('base','gratings', gratings);
%   if plotit,
%       f = figure;
%   end;
%   for i=1:n_step
%       for j=0:pi/6:2*pi-pi/6,
%           gratings(:,:,i) = rgcv1.make_grating(RF_XX, RF_YY, orientation(i), j, spatial_frequency, amplitude);
%           if plotit,
%               figure(f);
%               imagesc(RF_XX(:,1),RF_YY(:,1)', gratings(:,:,i));
%               if j==2*pi-pi/6,pause(4);else, pause(1); end;
%               
%           end;
%       end;
%   end
%   
%   
%   for each cell, compute the response
% gratings = reshape(gratings,[size(gratings,1)*size(gratings,2), size(gratings,3)]);
% all_responses = CTX_RF * gratings;

% matrix multiplication equivalent to the for loop below:
% CTX_RF = reshape(CTX_RF, size(CTX_RF,1), sqrt(size(CTX_RF,2)), sqrt(size(CTX_RF,2))); % DIM: number of cortical cells X size(RF_XX,1) X size(RF_XX,2) 
% ALL_RESPONSES is NxO, 

all_responses = zeros(size(CTX_RF,1), numel(orientation));
% for c=1:size(CTX_RF,1)
%                              
%     rf_shape = rf_shape(end:-1:1,:,:);
%     for i=1:n_step
%         for j=1:numel(phases),
%             inputs = rf_shape  .* gratings(:,:,i,j);
%             response = rectify(sum(sum(inputs)));
%             all_responses(c,i) = all_responses(c,i)+response;
%         end;
%     end;
% end


% disp("finished responses");

g_copy = reshape(gratings, size(gratings,1)*size(gratings,2), ...
    size(gratings,3), size(gratings,4));

  
for i=1:n_step
    gratings_phases = reshape(g_copy(:,i,:), size(g_copy,1), size(g_copy,3));
    all_responses_phases = rectify(CTX_RF*gratings_phases);
    all_responses(:,i) = sum(all_responses_phases,2);
end
disp("finished responses");

%% Sum the responses for each orientation over phases
% all_responses = reshape(all_responses, size(all_responses,1), numel(orientation), numel(phases));
% all_responses = rectify(all_responses);
% all_responses = sum(all_responses,3);

%   find the best response for each cell

% BEST_RESPONSE is Nx1 (value of the best response)
% BEST_THETA is Nx1 with the theta (O) that gives the best response
% SELECTIVITY is Nx1 with selectivity  
%(Response_at_best - Respose_at_best+90 degrees)/Response_at_best)
[best_response,best_response_location] = max(all_responses,[],2);
orthogonal_response_location = 1 + mod(best_response_location + n_step/2 - 1, n_step);
% code below from: https://www.mathworks.com/matlabcentral/answers/27499-how-to-select-one-element-from-each-row-of-a-matrix-a-based-on-a-column-matrix-b
I = (1 : size(all_responses, 1)) .';
J = reshape(orthogonal_response_location, [], 1);
k = sub2ind(size(all_responses), I, J);
C = all_responses(k);
assignin('base','C',C)
assignin('base','all_responses',all_responses)
% both best_response and C can take negative values
selectivity = ( rectify(best_response) - rectify(C) )./ ( rectify(best_response) + rectify(C) ); 
%selectivity = ( best_response - C )./ abs(( C )); 
angles = best_response_location/(n_step) * pi;
assignin('base','angles',angles)
assignin('base','selectivity',selectivity)