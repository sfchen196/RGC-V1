function plot_retina_cortex(S, ctx_select)

% S - input structure of workspace variables

if nargin<2,
    ctx_select = 70;
end;

retina_fig = figure;
plot(S.pos_ON(:,1),S.pos_ON(:,2),'ro');
hold on;
plot(S.pos_OFF(:,1),S.pos_OFF(:,2),'bo');
ax_retina = gca;
title('Retinal cell position, red=ON,blue=OFF');
box off;

ctx_fig = figure;
plot(S.pos_xy(:,1),S.pos_xy(:,2),'go');
hold on;
plot(S.pos_xy(ctx_select,1),S.pos_xy(ctx_select,2),'md');
ax_cortex = gca;
title('Cortical cell position');
box off;

rf_off_fig = figure;
RF_ctx_OFF = S.RF_ctx_OFF(ctx_select,:);
RF_ctx_OFF = reshape(RF_ctx_OFF, sqrt(size(RF_ctx_OFF,2)), sqrt(size(RF_ctx_OFF,2)));
%RF_ctx_OFF = reshape(RF_ctx_OFF, size(RF_ctx_OFF,3), size(RF_ctx_OFF,1)*size(RF_ctx_OFF,2));
imagesc(S.RF_xx(1,:),S.RF_yy(:,1),RF_ctx_OFF);
set(gca,'ydir','normal');
% ax_rf = gca;
title('RF Off');
box off;


rf_on_fig = figure;
RF_ctx_ON = S.RF_ctx_ON(ctx_select,:);
RF_ctx_ON = reshape(RF_ctx_ON, sqrt(size(RF_ctx_ON,2)), sqrt(size(RF_ctx_ON,2)));
imagesc(S.RF_xx(1,:),S.RF_yy(:,1),RF_ctx_ON);
set(gca,'ydir','normal');
% ax_rf = gca;
title('RF On');
box off;


rf_on_fig = figure;
RF_ctx = S.CTX_RF(ctx_select,:);
RF_ctx = reshape(RF_ctx, sqrt(size(RF_ctx,2)), sqrt(size(RF_ctx,2)));
imagesc(S.RF_xx(1,:),S.RF_yy(:,1),RF_ctx, [ -max(abs(RF_ctx(:))) max(abs(RF_ctx(:)))]);
set(gca,'ydir','normal');
% ax_rf = gca;
title('RF total');
box off;



% ctx_OFF_fig = figure;
% ctx_OFF = S.ctx_OFF(ctx_select,:);
% ctx_OFF(end+1:end+3) = [0 0 0];
% ctx_OFF = reshape(ctx_OFF, 12,12);
% imagesc(ctx_OFF);
% % ax_rf = gca;
% title('ctx_OFF');
% box off;

% ctx_ON_fig = figure;
% ctx_ON = S.ctx_ON(ctx_select,:);
% ctx_ON(end+1) = 0;
% ctx_ON = reshape(ctx_ON, 12,12);
% imagesc(ctx_ON);
% title('ctx_ON');
% box off;

% RFs_ON_fig = figure;
% RFs_ON = S.RFs_ON(:, ctx_select);
% RFs_ON = reshape(RFs_ON, 201,201);
% imagesc(RFs_ON);
% title('RFs_ON');
% box off;
% 
% 
% RFs_OFF_fig = figure;
% RFs_OFF = S.RFs_OFF(:, ctx_select);
% RFs_OFF = reshape(RFs_OFF, 201,201);
% imagesc(RFs_OFF);
% title('RFs_OFF');
% box off;
% linkaxes([ax_retina ax_cortex ax_rf]);



%ctx_rf_fig = figure;

