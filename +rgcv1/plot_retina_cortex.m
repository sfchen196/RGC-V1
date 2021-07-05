function plot_retina_cortex(S, ctx_select)

    % S - input structure of workspace variables

    if nargin<2,
        ctx_select = 70;
        
    end;

    n_step = 16;
    
    % plot gratings
   
    index = find(linspace(0,pi,n_step+1)==S.angles(ctx_select));
    figure(); 
    imagesc(S.RF_xx(:,1),S.RF_yy(:,1)', S.gratings(:,:,index,1));
    ax_grating = gca;
    
    retina_fig = figure;
    assignin('base','retina_fig',retina_fig);
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
    
    linkaxes([ax_grating,ax_cortex,ax_retina]);

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


    rf_ctx_fig = figure;
    RF_ctx = S.CTX_RF(ctx_select,:);
    RF_ctx = reshape(RF_ctx, sqrt(size(RF_ctx,2)), sqrt(size(RF_ctx,2)));
    imagesc(S.RF_xx(1,:),S.RF_yy(:,1),RF_ctx, [ -max(abs(RF_ctx(:))) max(abs(RF_ctx(:)))]);
    set(gca,'ydir','normal');
    % ax_rf = gca;
    title('RF total');
    box off;



    ctx_OFF_fig = figure;
    ctx_OFF_select = S.ctx_OFF(ctx_select,:);
    ctx_OFF_select(end+1:end+3) = [0 0 0];
    ctx_OFF_select = reshape(ctx_OFF_select, 12,12);
    imagesc( ctx_OFF_select);
    t = num2cell(1:numel(ctx_OFF_select));
    t = cellfun(@num2str, t,'UniformOutput', false);
    N = numel(ctx_OFF_select);
    x = repmat(1:ceil(sqrt(N)),ceil(sqrt(N)),1); % generate x-coordinates
    y = x'; % generate y-coordinates
    text(x(:), y(:), t, 'HorizontalAlignment', 'Center')
    ax_rf = gca;
    title('ctx OFF');
    box off;
% 
    ctx_ON_fig = figure;
    assignin('base','ctx_ON_fig',ctx_ON_fig);
    ctx_ON_select = S.ctx_ON(ctx_select,:);
    assignin('base','ctx_ON_select', ctx_ON_select);

    ctx_ON_select(end+1) = 0;
    ctx_ON_select = reshape(ctx_ON_select, 12,12);
    imagesc(ctx_ON_select);
    t = num2cell(1:numel(ctx_ON_select));
    t = cellfun(@num2str, t,'UniformOutput', false);
    N = numel(ctx_ON_select);
    x = repmat(1:ceil(sqrt(N)),ceil(sqrt(N)),1); % generate x-coordinates
    y = x'; % generate y-coordinates
    text(x(:), y(:), t, 'HorizontalAlignment', 'Center')
    title('ctx ON');
    box off;
    

    %% ANALYZE receptive field and the interaction between the grating and the rf
    figure(retina_fig); scatter(S.pos_OFF(ctx_OFF_select>0.005,1), S.pos_OFF(ctx_OFF_select>0.005,2),'filled','MarkerFaceColor','B')
    figure(retina_fig); scatter(S.pos_ON(ctx_ON_select>0.005,1), S.pos_ON(ctx_ON_select>0.005,2),'filled','MarkerFaceColor','R')
end
