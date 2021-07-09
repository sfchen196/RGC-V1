function plot_retina_cortex(S, ctx_select)

    % S - input structure of workspace variables, example function call:
    
        % plot_retina_cortex(workspace2struct, 450)
    % This function call will yield plots about the 450th cortical cell
    %%    
    % To run this file, first run code_for_OP_app in order to
    % have every variable needed in the 'base' workspace

    %%
    if nargin<2
        ctx_select = 17*34; 
        % To select V1 cell in the middle of the figure, 
        % use 15*n (where n is any even number)
        
    end

    
    %% plot gratings
   
    index = S.orientations==S.angles(ctx_select);
    figure(); 
%     imagesc(S.RF_xx(:,1) ,S.RF_yy(:,1)', S.gratings(:,:,index,1));
%      imagesc(S.RF_xx(1,:)*S.retina_microns_per_degree,S.RF_yy(:,1)*S.retina_microns_per_degree, ...
%      S.gratings(:,:,index,1));
    imagesc(S.RF_xx(1,:) ,S.RF_yy(:,1), S.gratings(:,:,index,1));
    ax_grating = gca;
    
    %% plot retinal cells
    retina_fig = figure;
    assignin('base','retina_fig',retina_fig);
    plot(S.pos_ON(:,1),S.pos_ON(:,2),'ro');
    hold on;
    plot(S.pos_OFF(:,1),S.pos_OFF(:,2),'bo');
    ax_retina = gca;
    title('Retinal cell position, red=ON,blue=OFF');
    box off;
    
    
    %% plot cortical cells
    ctx_fig = figure;
    plot(S.pos_xy(:,1),S.pos_xy(:,2),'go');
    hold on;
    plot(S.pos_xy(ctx_select,1),S.pos_xy(ctx_select,2),'md');
    ax_cortex = gca;
    title('Cortical cell position');
    box off;
    
    linkaxes([ax_cortex,ax_retina]);
    
    %% plot weights
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


%     ctx_OFF_fig = figure;
    ctx_OFF_select = S.ctx_OFF(ctx_select,:);
%     ctx_OFF_select(end+1:end+3) = [0 0 0];
%     ctx_OFF_select = reshape(ctx_OFF_select, 12,12);
%     imagesc( ctx_OFF_select);
%     t = num2cell(1:numel(ctx_OFF_select));
%     t = cellfun(@num2str, t,'UniformOutput', false);
%     N = numel(ctx_OFF_select);
%     x = repmat(1:ceil(sqrt(N)),ceil(sqrt(N)),1); % generate x-coordinates
%     y = x'; % generate y-coordinates
%     text(x(:), y(:), t, 'HorizontalAlignment', 'Center')
%     ax_rf = gca;
%     title('ctx OFF');
%     box off;


%     ctx_ON_fig = figure;
    ctx_ON_select = S.ctx_ON(ctx_select,:);
%     ctx_ON_select(end+1) = 0;
%     ctx_ON_select = reshape(ctx_ON_select, 12,12);
%     imagesc(ctx_ON_select);
%     t = num2cell(1:numel(ctx_ON_select));
%     t = cellfun(@num2str, t,'UniformOutput', false);
%     N = numel(ctx_ON_select);
%     x = repmat(1:ceil(sqrt(N)),ceil(sqrt(N)),1); % generate x-coordinates
%     y = x'; % generate y-coordinates
%     text(x(:), y(:), t, 'HorizontalAlignment', 'Center')
%     title('ctx ON');
    box off;
    

    %% ANALYZE receptive field and the interaction between the grating and the rf
%     % plot retinal cells that provide significan inputs to the selected cortical cell
%         % hard threshold = 0.005 for ctx-retina weights
%     figure(retina_fig); scatter(S.pos_OFF(ctx_OFF_select>0.005,1), S.pos_OFF(ctx_OFF_select>0.005,2),'filled','MarkerFaceColor','B')
%     figure(retina_fig); scatter(S.pos_ON(ctx_ON_select>0.005,1), S.pos_ON(ctx_ON_select>0.005,2),'filled','MarkerFaceColor','R')
%     
    figure();
    ax1 = axes;
    scatter(ax1, S.pos_ON(:,1), S.pos_ON(:,2), 100, ctx_ON_select, 'filled'); hold on;
    ax2 = axes;
    scatter(ax2, S.pos_OFF(:,1), S.pos_OFF(:,2), 100, ctx_OFF_select, 'filled');
    linkaxes([ax1,ax2])
    ax2.Visible = 'off';
    ax2.XTick = [];
    ax2.YTick = [];
    cm_ON = [linspace(0,1,256)', zeros(256,2)];
    cm_OFF = [zeros(256,2), linspace(0,1,256)'];
    colormap(ax1, cm_ON);
    colormap(ax2, cm_OFF);
    set([ax1,ax2],'Position',[.17 .11 .685 .815]);
    cb1 = colorbar(ax1,'Position',[.045 .11 .0675 .815]);
    cb2 = colorbar(ax2,'Position',[.88 .11 .0675 .815]);

    % plot the selected cortical cell overlapping with the retinal cells
    figure(retina_fig), plot(S.pos_xy(ctx_select,1),S.pos_xy(ctx_select,2),'gx', 'MarkerSize', 10);
    
    % plot nearest ON and OFF retinal cells
    [~, nearest_ON] = min(S.dist_ON(ctx_select,:));
    figure(retina_fig); 
    scatter(S.pos_ON(nearest_ON,1), S.pos_ON(nearest_ON,2), 'rx', 'SizeData', 100); hold on;
    
    [~, nearest_OFF] = min(S.dist_OFF(ctx_select,:));
    hold on;
    scatter(S.pos_OFF(nearest_OFF,1), S.pos_OFF(nearest_OFF,2), 'bx', 'SizeData', 100); hold on;
    
    % plot the line that connects the retinal ON and cortical cells
    plot([S.pos_ON(nearest_ON,1), S.pos_xy(ctx_select,1)], ...
        [S.pos_ON(nearest_ON,2), S.pos_xy(ctx_select,2)]);
    
    % plot the line that connects the retinal OFF and cortical cells
    plot([S.pos_OFF(nearest_OFF,1), S.pos_xy(ctx_select,1)], ...
        [S.pos_OFF(nearest_OFF,2), S.pos_xy(ctx_select,2)]); hold on;
    
    % plot the line that connects the retinal ON and OFF cells
    plot([S.pos_ON(nearest_ON,1), S.pos_OFF(nearest_OFF,1)], ...
        [S.pos_ON(nearest_ON,2), S.pos_OFF(nearest_OFF,2)]);
    
    % calculate the angle (`angle_conn`) formed by the line
    % that connects the nearest ON and OFF cells of the selected V1 cell
    pos_nearest_ON = S.pos_ON(nearest_ON,1) + S.pos_ON(nearest_ON,2)*1j;
    pos_nearest_OFF = S.pos_OFF(nearest_OFF,1) + S.pos_OFF(nearest_OFF,2)*1j;
    angle_conn = angle(pos_nearest_ON-pos_nearest_OFF);
    while angle_conn < 0
        angle_conn = angle_conn + pi;
    end 
    % calculate the angle that is perpendicular to `angle_connect`
    if angle_conn < pi/2
        angle_perp = angle_conn + pi/2; 
    else
        angle_perp = angle_conn - pi/2;
    end 
    disp(['The angle of the connecting line ' ...
        'between the nearest ON and OFF cells is ' num2str(angle_conn)]);
    disp(['The perpendicular angle of the connecting line ' ...
        'between the nearest ON and OFF cells is ' num2str(angle_perp)]);
    disp(['The angle of the gratings is ' num2str(S.angles(ctx_select))]);
    
    % hardcode 17 for num_step+1 (nubmer of different grating angles + 1)
    angle_pool = linspace(0, pi, 17);
    angle_pool = angle_pool(1:end-1);
    disp(['The angle pool of different gratings is ( ' ...
        num2str(angle_pool) ' )']);
    
    %% plot V1 cell's responses to all gratings
    figure; 
    plot(S.all_responses(ctx_select,:));
%     ylim([0 1000]);
%     xlim([0 17]);
end
