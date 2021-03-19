function [best_response, best_response_location, selectivity, angles] = compute_OT(CTX_RF, RF_XX, RF_YY)
% COMPUTE_OT - compute orientation tuning for all cortical cells
% 
% [best_response, best_theta, selectivity] = compute_OT(CTX_RF, RF_XX, RF_YY)


  % make gratings of each orientation (say, 16 steps O = linspace(0,pi,17));
  % O = O(1:end-1); 
  % 
  % G = cat(3, G, gratings(..., O(i), ...)
  n_step = 16;
  spatial_phase = 0;
  spatial_frequency = 10; 
  amplitude = 1;
  orientation = linspace(0,pi,n_step+1);
  orientation = orientation(1:end-1);
  
  gratings = zeros(size(RF_XX,1),size(RF_XX,1), numel(orientation));
  for i=1:n_step
      gratings(:,:,i) = rgcv1.make_grating(RF_XX, RF_YY, orientation(i), spatial_phase, spatial_frequency, amplitude);
  end
  
%   for each cell, compute the response
gratings = reshape(gratings,[size(gratings,1)^2 size(gratings,3)]);
all_responses = CTX_RF * gratings;

% matrix multiplication equivalent to the for loop below:
% CTX_RF = reshape(CTX_RF, size(CTX_RF,1), sqrt(size(CTX_RF,2)), sqrt(size(CTX_RF,2))); % DIM: number of cortical cells X size(RF_XX,1) X size(RF_XX,2) 
% % ALL_RESPONSES is NxO, 
% all_responses = zeros(size(CTX_RF,1), numel(orientation));
% for i=1:n_step
%     grating = repmat(gratings(:,:,i), [1,1, size(CTX_RF,1)]);
%     inputs = CTX_RF .* permute(grating, [3 1 2]);
%     response = sum(inputs,[2 3]);
%     all_responses(:,i) = response;
% end



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
% both best_response and C can take negative values
% selectivity = ( best_response - C )./ ( best_response + C ); 
selectivity = ( best_response - C )./ abs(( C )); 
angles = best_response_location/(n_step+1) * 2*pi;