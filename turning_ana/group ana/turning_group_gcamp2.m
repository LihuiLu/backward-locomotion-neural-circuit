%% 03022026, lihuilu1912@gmail.com

%% make the right turn as ipsilateral turn
filename1 = '20250903 Vglut2-Cre+ #53 open field_4analysis.mat';
filename2 = '20251010 Vglut2-Cre+ #80 right LDTgV open field_3analysis.mat';
vData1 = importdata(filename1);
vData = vData1;
% vData.angle_mean_l = -vData1.angle_mean_r;
% vData.angle_mean_r = -vData1.angle_mean_l;
% vData.psth1_mean_l = vData1.psth1_mean_r;
% vData.psth1_mean_r = vData1.psth1_mean_l;
vData.angular_v_t_l = -vData1.angular_v_t_r;
vData.angular_v_t_r = -vData1.angular_v_t_l;
vData.psth1_l = vData1.psth1_r;
vData.psth1_r = vData1.psth1_l;
save(filename1,'vData');


vData2 = importdata(filename2);
vData = vData2;
% vData.angle_mean_l = -vData2.angle_mean_r;
% vData.angle_mean_r = -vData2.angle_mean_l;
% vData.psth1_mean_l = vData2.psth1_mean_r;
% vData.psth1_mean_r = vData2.psth1_mean_l;
vData.angular_v_t_l = -vData2.angular_v_t_r;
vData.angular_v_t_r = -vData2.angular_v_t_l;
vData.psth1_l = vData2.psth1_r;
vData.psth1_r = vData2.psth1_l;

save(filename2,'vData');


%%
filename1 = '20250808 Vglut2-Cre+ #31 open field_3analysis.mat';
filename2 = '20250808 Vglut2-Cre+ #32 open field_1analysis.mat';
filename3 = '20251010 Vglut2-Cre+ #78 left LDTgV open field_6analysis.mat';

vData1 = importdata(filename1);
vData = vData1;
vData.angle_mean_l = -vData1.angle_mean_r;
vData.angle_mean_r = -vData1.angle_mean_l;
vData.psth1_mean_l = vData1.psth1_mean_r;
vData.psth1_mean_r = vData1.psth1_mean_l;
vData.angular_v_t_l = -vData1.angular_v_t_r;
vData.angular_v_t_r = -vData1.angular_v_t_l;
vData.psth1_l = vData1.psth1_r;
vData.psth1_r = vData1.psth1_l;
save(filename1,'vData');


vData2 = importdata(filename2);
vData = vData2;
vData.angle_mean_l = -vData2.angle_mean_r;
vData.angle_mean_r = -vData2.angle_mean_l;
vData.psth1_mean_l = vData2.psth1_mean_r;
vData.psth1_mean_r = vData2.psth1_mean_l;
vData.angular_v_t_l = -vData2.angular_v_t_r;
vData.angular_v_t_r = -vData2.angular_v_t_l;
vData.psth1_l = vData2.psth1_r;
vData.psth1_r = vData2.psth1_l;
save(filename2,'vData');

vData3 = importdata(filename3);
vData = vData3;
vData.angle_mean_l = -vData3.angle_mean_r;
vData.angle_mean_r = -vData3.angle_mean_l;
vData.psth1_mean_l = vData3.psth1_mean_r;
vData.psth1_mean_r = vData3.psth1_mean_l;
vData.angular_v_t_l = -vData3.angular_v_t_r;
vData.angular_v_t_r = -vData3.angular_v_t_l;
vData.psth1_l = vData3.psth1_r;
vData.psth1_r = vData3.psth1_l;

save(filename3,'vData');
%%
clc; 
clear; 
close all;
% tic;
file = dir('*Cre*.mat');

xP=0;
xP2 = 0.5;
bin = 1/20;%video framerate is 20
pre_stim = 0.5;
post_stim = 1;
x_vel = -pre_stim:bin:post_stim;
win = [0 0.5];
y_lim_gc = [-5 15]; 
y_lim_vel = [-150 150]; 

bin_gc = 1/50;%fiber photometry sampling frequency is 50 hz
x_gc = -pre_stim:bin_gc:post_stim;

angle_mean_l = [];
angle_mean_r = [];
angle_mean_s = [];
psth1_mean_l = [];
psth1_mean_r = [];
psth1_mean_s = [];

angle_l = [];
angle_r = [];
angle_s = [];
psth1_l = [];
psth1_r = [];
psth1_s = [];

angle_mean_l_quant = [];
angle_mean_r_quant = [];
angle_mean_s_quant = [];
psth1_mean_l_quant = [];
psth1_mean_r_quant = [];
psth1_mean_s_quant = [];
for i = 1:length(file)
    cName = file(i).name
    %%%
    % data = importdata(cName);
    data = load(cName);

    angle_mean_l = cat(1,angle_mean_l, data.vData.angle_mean_l);
    angle_mean_r = cat(1,angle_mean_r, data.vData.angle_mean_r);
    angle_mean_s = cat(1,angle_mean_s, data.vData.angle_mean_s);
    psth1_mean_l = cat(1,psth1_mean_l, data.vData.psth1_mean_l);
    psth1_mean_r = cat(1,psth1_mean_r, data.vData.psth1_mean_r);
    psth1_mean_s = cat(1,psth1_mean_s, data.vData.psth1_mean_s);

    angle_l = cat(1,angle_l, real(data.vData.angular_v_t_l));
    angle_r = cat(1,angle_r, real(data.vData.angular_v_t_r));
    angle_s = cat(1,angle_s, real(data.vData.angular_v_t_s));
    psth1_l = cat(1,psth1_l, data.vData.psth1_l);
    psth1_r = cat(1,psth1_r, data.vData.psth1_r);
    psth1_s = cat(1,psth1_s, data.vData.psth1_s);

    angle_mean_l_quant = cat(1,angle_mean_l_quant, mean(data.vData.angle_mean_l(:,pre_stim/bin+1:(pre_stim+xP2)/bin)));
    angle_mean_r_quant = cat(1,angle_mean_r_quant, mean(data.vData.angle_mean_r(:,pre_stim/bin+1:(pre_stim+xP2)/bin)));
    angle_mean_s_quant = cat(1,angle_mean_s_quant, mean(data.vData.angle_mean_s(:,pre_stim/bin+1:(pre_stim+xP2)/bin)));
    psth1_mean_l_quant = cat(1,psth1_mean_l_quant, mean(data.vData.psth1_mean_l(:,pre_stim/bin_gc+1:(pre_stim+xP2)/bin_gc)));
    psth1_mean_r_quant = cat(1,psth1_mean_r_quant, mean(data.vData.psth1_mean_r(:,pre_stim/bin_gc+1:(pre_stim+xP2)/bin_gc)));
    psth1_mean_s_quant = cat(1,psth1_mean_s_quant, mean(data.vData.psth1_mean_s(:,pre_stim/bin_gc+1:(pre_stim+xP2)/bin_gc)));
    
    % angle_mean_l_quant = cat(1,angle_mean_l_quant, max(data.vData.angle_mean_l(:,pre_stim/bin+1:(pre_stim+xP2)/bin)));
    % angle_mean_r_quant = cat(1,angle_mean_r_quant, max(data.vData.angle_mean_r(:,pre_stim/bin+1:(pre_stim+xP2)/bin)));
    % angle_mean_s_quant = cat(1,angle_mean_s_quant, max(data.vData.angle_mean_s(:,pre_stim/bin+1:(pre_stim+xP2)/bin)));
    % psth1_mean_l_quant = cat(1,psth1_mean_l_quant, max(data.vData.psth1_mean_l(:,pre_stim/bin_gc+1:(pre_stim+xP2)/bin_gc)));
    % psth1_mean_r_quant = cat(1,psth1_mean_r_quant, max(data.vData.psth1_mean_r(:,pre_stim/bin_gc+1:(pre_stim+xP2)/bin_gc)));
    % psth1_mean_s_quant = cat(1,psth1_mean_s_quant, max(data.vData.psth1_mean_s(:,pre_stim/bin_gc+1:(pre_stim+xP2)/bin_gc)));

end


group_data.angle_mean_l = angle_mean_l;
group_data.angle_mean_r = angle_mean_r;
group_data.angle_mean_s = angle_mean_s;
group_data.psth1_mean_l = psth1_mean_l;
group_data.psth1_mean_r = psth1_mean_r;
group_data.psth1_mean_s = psth1_mean_s;

group_data.angle_l = angle_l;
group_data.angle_r = angle_r;
group_data.angle_s = angle_s;
group_data.psth1_l = psth1_l;
group_data.psth1_r = psth1_r;
group_data.psth1_s = psth1_s;

group_data.angle_mean_l_quant = angle_mean_l_quant;
group_data.angle_mean_r_quant = angle_mean_r_quant;
group_data.angle_mean_s_quant = angle_mean_s_quant;
group_data.psth1_mean_l_quant = psth1_mean_l_quant;
group_data.psth1_mean_r_quant = psth1_mean_r_quant;
group_data.psth1_mean_s_quant = psth1_mean_s_quant;
% save('groupData','-struct','group_data');
save groupData group_data;
assignin('base','group_data',group_data);
%% plot velocity figures
vData.heatmap=1;

speed = group_data.angle_l(1:55,:);
speed_mean = mean(speed);
speed_sem = std(speed)/sqrt(size(speed,1)-1);


fig1 = figure;
set(gcf, 'Position',  [100, 100, 800, 700]); hold on
subplot(2,6,1:5)
drawErrorLine(x_vel,speed_mean,speed_sem,'k',4);hold on;
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
box off;
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:0.5:post_stim);
set(gca,'yLim',y_lim_vel);
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel(['Angular velocity (',char(176),'/s)'],'FontName','Arial','FontSize',25,'FontWeight','Bold');
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);


if vData.heatmap
    % fig1 = figure;
     subplot(2,6,7:11)
    heatmapPlot(real(speed),bin,pre_stim,0.1,fig1,y_lim_vel);
    set(gca,'YDir','normal')
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
    ylabel('Trial #','FontSize',25,'FontWeight','Bold');
    % title('left turning')

    subplot(2,6,12)
    axis off;
    c = colorbar;
    caxis(y_lim_vel);  % Set color axis limits
    c.Label.String = {'angular', 'velocity', '(° s^{-1})'};
    c.Label.Rotation = 360;
    c.Label.VerticalAlignment = "middle";
    c.Label.HorizontalAlignment = "center";
    c.Ticks = y_lim_vel;
    c.TickLabels = string(y_lim_vel);
end

speed = group_data.angle_r(1:55,:);
speed_mean = mean(speed);
speed_sem = std(speed)/sqrt(size(speed,1)-1);

fig1 = figure;
set(gcf, 'Position',  [100, 100, 800, 700]); hold on
subplot(2,6,1:5)
drawErrorLine(x_vel,speed_mean,speed_sem,'k',4);hold on;
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
box off;
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:0.5:post_stim);
set(gca,'yLim',y_lim_vel);
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel(['Angular velocity (',char(176),'/s)'],'FontName','Arial','FontSize',25,'FontWeight','Bold');
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
if vData.heatmap
    % fig1 = figure;
     subplot(2,6,7:11)
    heatmapPlot(real(speed),bin,pre_stim,0.1,fig1,y_lim_vel);
    set(gca,'YDir','normal')
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
    ylabel('Trial #','FontSize',25,'FontWeight','Bold');
    % title('left turning')

    subplot(2,6,12)
    axis off;
    c = colorbar;
    caxis(y_lim_vel);  % Set color axis limits
    c.Label.String = {'angular', 'velocity', '(° s^{-1})'};
    c.Label.Rotation = 360;
    c.Label.VerticalAlignment = "middle";
    c.Label.HorizontalAlignment = "center";
    c.Ticks = y_lim_vel;
    c.TickLabels = string(y_lim_vel);
end

speed = group_data.angle_s(1:55,:);
speed_mean = mean(speed);
speed_sem = std(speed)/sqrt(size(speed,1)-1);

fig1 = figure;
set(gcf, 'Position',  [100, 100, 800, 700]); hold on
subplot(2,6,1:5)
drawErrorLine(x_vel,speed_mean,speed_sem,'k',4);hold on;
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
box off;
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:0.5:post_stim);
set(gca,'yLim',y_lim_vel);
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel(['Angular velocity (',char(176),'/s)'],'FontName','Arial','FontSize',25,'FontWeight','Bold');
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
if vData.heatmap
    % fig1 = figure;
     subplot(2,6,7:11)
    heatmapPlot(real(speed),bin,pre_stim,0.1,fig1,y_lim_vel);
    set(gca,'YDir','normal')
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
    ylabel('Trial #','FontSize',25,'FontWeight','Bold');
    % title('left turning')

    subplot(2,6,12)
    axis off;
    c = colorbar;
    caxis(y_lim_vel);  % Set color axis limits
    c.Label.String = {'angular', 'velocity', '(° s^{-1})'};
    c.Label.Rotation = 360;
    c.Label.VerticalAlignment = "middle";
    c.Label.HorizontalAlignment = "center";
    c.Ticks = y_lim_vel;
    c.TickLabels = string(y_lim_vel);
end

%% plot gcamp figures
speed = group_data.psth1_l(1:55,:);
speed_mean = mean(speed);
speed_sem = std(speed)/sqrt(size(speed,1)-1);

fig1 = figure;
set(gcf, 'Position',  [1000, 100, 800, 700]); hold on
subplot(2,6,1:5)
drawErrorLine(x_gc,speed_mean,speed_sem,'b',4);hold on;
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
box off;
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:0.5:post_stim);
set(gca,'yLim',y_lim_gc);
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel(['\Delta F/F (z-scored)'],'FontName','Arial','FontSize',25,'FontWeight','Bold');
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
if vData.heatmap
    % fig1 = figure;
     subplot(2,6,7:11)
    heatmapPlot(real(speed),bin_gc,pre_stim,0.1,fig1,y_lim_gc);
    set(gca,'YDir','normal')
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
    ylabel('Trial #','FontSize',25,'FontWeight','Bold');
    % title('left turning')

    subplot(2,6,12)
    axis off;
    c = colorbar;
    caxis(y_lim_gc);  % Set color axis limits
    c.Label.String = {'\Delta F/F'};
    c.Label.Rotation = 360;
    c.Label.VerticalAlignment = "middle";
    c.Label.HorizontalAlignment = "center";
    c.Ticks = y_lim_gc;
    c.TickLabels = string(y_lim_gc);
end

speed = group_data.psth1_r(1:55,:);
speed_mean = mean(speed);
speed_sem = std(speed)/sqrt(size(speed,1)-1);

fig1 = figure;
set(gcf, 'Position',  [1000, 100, 800, 700]); hold on
subplot(2,6,1:5)
drawErrorLine(x_gc,speed_mean,speed_sem,'b',4);hold on;
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
box off;
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:0.5:post_stim);
set(gca,'yLim',y_lim_gc);
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel(['\Delta F/F (z-scored)'],'FontName','Arial','FontSize',25,'FontWeight','Bold');
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
if vData.heatmap
    % fig1 = figure;
     subplot(2,6,7:11)
    heatmapPlot(real(speed),bin_gc,pre_stim,0.1,fig1,y_lim_gc);
    set(gca,'YDir','normal')
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
    ylabel('Trial #','FontSize',25,'FontWeight','Bold');
    % title('left turning')

    subplot(2,6,12)
    axis off;
    c = colorbar;
    caxis(y_lim_gc);  % Set color axis limits
    c.Label.String = {'\Delta F/F'};
    c.Label.Rotation = 360;
    c.Label.VerticalAlignment = "middle";
    c.Label.HorizontalAlignment = "center";
    c.Ticks = y_lim_gc;
    c.TickLabels = string(y_lim_gc);
end

speed = group_data.psth1_s(1:55,:);
speed_mean = mean(speed);
speed_sem = std(speed)/sqrt(size(speed,1)-1);

fig1 = figure;
set(gcf, 'Position',  [1000, 100, 800, 700]); hold on
subplot(2,6,1:5)
drawErrorLine(x_gc,speed_mean,speed_sem,'b',4);hold on;
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
box off;
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:0.5:post_stim);
set(gca,'yLim',y_lim_gc);
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel(['\Delta F/F (z-scored)'],'FontName','Arial','FontSize',25,'FontWeight','Bold');
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
if vData.heatmap
    % fig1 = figure;
     subplot(2,6,7:11)
    heatmapPlot(real(speed),bin_gc,pre_stim,0.1,fig1,y_lim_gc);
    set(gca,'YDir','normal')
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
    ylabel('Trial #','FontSize',25,'FontWeight','Bold');
    % title('left turning')

    subplot(2,6,12)
    axis off;
    c = colorbar;
    caxis(y_lim_gc);  % Set color axis limits
    c.Label.String = {'\Delta F/F'};
    c.Label.Rotation = 360;
    c.Label.VerticalAlignment = "middle";
    c.Label.HorizontalAlignment = "center";
    c.Ticks = y_lim_gc;
    c.TickLabels = string(y_lim_gc);
end

%% bar plot and statistic

angle = real([group_data.angle_mean_r_quant, group_data.angle_mean_s_quant, group_data.angle_mean_l_quant]);
psth = [group_data.psth1_mean_r_quant, group_data.psth1_mean_s_quant, group_data.psth1_mean_l_quant];

groups = {'Ipsilateral', 'Straight', 'Contralateral'}; % Group labels

%%%%%%velocity data
% Calculate statistics
mean_vals = mean(angle, 1); % Mean of each group
std_vals = std(angle, 0, 1); % Standard deviation of each group
n = size(angle, 1); % Number of samples in each group
sem_vals = std_vals ./ sqrt(n); % Standard error of the mean

% Plot individual dots and connect them with a line
figure; hold on;
for i = 1:n
    plot(1.2:3.2, angle(i, :), '-o','color',[0.5 0.5 0.5], 'LineWidth', 1.5, 'MarkerSize', 8); % Connect dots for each individual
end

% Add boxplot
boxplot(angle, 'Labels', groups, 'Colors', 'k', 'Symbol', 'k+');
% Ensure all parts of the boxplot are black and thicker
set(findobj(gca,'Tag','Box'),     'Color','k','LineWidth',2);
set(findobj(gca,'Tag','Whisker'), 'Color','k','LineWidth',2);
set(findobj(gca,'Tag','Median'),  'Color','k','LineWidth',2);
set(findobj(gca,'Tag','Outliers'),'MarkerEdgeColor','k');

set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
set(gca,'yLim',[-150 150]);
% Format plot
set(gca, 'XTick', 1:3, 'XTickLabel', groups, 'FontSize', 12);
ylabel(['Angular velocity (',char(176),'/s)'],'FontName','Arial','FontSize',25,'FontWeight','Bold');

% Perform paired t-tests between groups and display results
[~,p12] = ttest(angle(:, 1), angle(:, 2)); % Left vs Straight
[~,p13] = ttest(angle(:, 1), angle(:, 3)); % Left vs Right
[~,p23] = ttest(angle(:, 2), angle(:, 3)); % Straight vs Right

fprintf('\nPaired t-test results of velocity:\n');
disp(['Left vs Straight: p = ' num2str(p12)]);
disp(['Left vs Right: p = ' num2str(p13)]);
disp(['Straight vs Right: p = ' num2str(p23)]);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%gcamp signal data
% Calculate statistics
mean_vals = mean(psth, 1); % Mean of each group
std_vals = std(psth, 0, 1); % Standard deviation of each group
n = size(psth, 1); % Number of samples in each group
sem_vals = std_vals ./ sqrt(n); % Standard error of the mean

% Plot individual dots and connect them with a line
figure; hold on;
for i = 1:n
    plot(1.2:3.2, psth(i, :), '-o','color','b', 'LineWidth', 1.5, 'MarkerSize', 8); % Connect dots for each individual
end

% Add boxplot
% boxplot(psth, 'Labels', groups, 'Colors', 'k', 'Symbol', 'k+');
boxplot(psth, 'Labels', groups, 'Colors', 'k');
% Ensure all parts of the boxplot are black and thicker
set(findobj(gca,'Tag','Box'),     'Color','k','LineWidth',2);
set(findobj(gca,'Tag','Whisker'), 'Color','k','LineWidth',2);
set(findobj(gca,'Tag','Median'),  'Color','k','LineWidth',2);
set(findobj(gca,'Tag','Outliers'),'MarkerEdgeColor','k');

set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');

% Format plot
set(gca, 'XTick', 1:3, 'XTickLabel', groups, 'FontSize', 12);
ylabel(['\Delta F/F (z-scored)'],'FontName','Arial','FontSize',25,'FontWeight','Bold');
set(gca,'yLim',[-5 10]);

% Perform paired t-tests between groups and display results
[~,p12] = ttest(psth(:, 1), psth(:, 2)); % Left vs Straight
[~,p13] = ttest(psth(:, 1), psth(:, 3)); % Left vs Right
[~,p23] = ttest(psth(:, 2), psth(:, 3)); % Straight vs Right

fprintf('\nPaired t-test results of gcamp:\n');
% disp('Paired t-test results of gcamp:');
disp(['Left vs Straight: p = ' num2str(p12)]);
disp(['Left vs Right: p = ' num2str(p13)]);
disp(['Straight vs Right: p = ' num2str(p23)]);