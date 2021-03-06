function [Result] = compute_OP(pos_ON,pos_OFF,w0_V1_ON,w0_V1_OFF,w_V1_ON,w_V1_OFF)
pos_ON = (pos_ON(:,1)+1i*pos_ON(:,2)); %% convert each loc to a complex vector (easy to compute angle)
pos_OFF = (pos_OFF(:,1)+1i*pos_OFF(:,2));

% Initial
w0_V1_ON./sum(w0_V1_ON,2); %% matrix consisting of 0's and 1's (but for main2: NaN's)
ON_loc = w0_V1_ON./sum(w0_V1_ON,2) * pos_ON; %% assign one pos_ON for each V1 cell, "expectation" of receptive field of each V1 cell?


OFF_loc = w0_V1_OFF./sum(w0_V1_OFF,2)*pos_OFF; 
op0 = angle(ON_loc-OFF_loc);
% osi0 = abs(ON_loc-OFF_loc);
% ds0 = op0;

% Final
ON_loc = w_V1_ON./sum(w_V1_ON,2)*pos_ON;
OFF_loc = w_V1_OFF./sum(w_V1_OFF,2)*pos_OFF;
op = angle(ON_loc-OFF_loc); %% orientation of ON_loc relative to OFF_loc 
% osi = abs(ON_loc-OFF_loc); %% 
ds = op;

op0(op0<-pi/2) = op0(op0<-pi/2)+pi; %% all angles confined to (-pi/2, pi/2) by reflecting obtuse angles 180 degrees
op0(op0>pi/2) = op0(op0>pi/2)-pi;
op(op<-pi/2) = op(op<-pi/2)+pi;
op(op>pi/2) = op(op>pi/2)-pi;
Result = [op0 op ds];
end