%% 03022026, lihuilu1912@gmail.com


%%
clc; 
clear; 
close all;
% tic;
file = dir('*analysis.mat');

xP=0;
xP2 = 10;
bin = 1/20;%video framerate is 20
pre_stim = 2;
post_stim = 16;
x_vel = -pre_stim:bin:post_stim;
win = [0 0.5];
yim_gc = [-2 6]; 
yim_vel = [0 20]; 

bin_gc = 1/50;%fiber photometry sampling frequency is 50 hz
x_gc = -pre_stim:bin_gc:post_stim;

speed_mean = [];
psth1_mean = [];

speed = [];
psth1 = [];

speed_mean_quant = [];
speed_mean_base_quant = [];

psth1_mean_quant = [];
psth1_mean_base_quant = [];

for i = 1:length(file)
    cName = file(i).name
    %%%
    % data = importdata(cName);
    data = load(cName);

    % speed_mean = cat(1,speed_mean, data.vData.speed_mean);
    psth1_mean = cat(1,psth1_mean, data.vData.psth1_mean);


    % speed = cat(1,speed, real(data.vData.speed_t));
    psth1 = cat(1,psth1, data.vData.psth1);


    % speed_mean_quant = cat(1,speed_mean_quant, mean(data.vData.speed_mean(:,pre_stim/bin+1:(pre_stim+xP2)/bin)));
    % speed_mean_base_quant = cat(1,speed_mean_base_quant, mean(data.vData.speed_mean(:,1:(pre_stim)/bin)));

    psth1_mean_quant = cat(1,psth1_mean_quant, mean(data.vData.psth1_mean(:,pre_stim/bin_gc+1:(pre_stim+xP2)/bin_gc)));
    psth1_mean_base_quant = cat(1,psth1_mean_base_quant, mean(data.vData.psth1_mean(:,1:(pre_stim)/bin_gc)));


end


% group_data.speed_mean = speed_mean;
group_data.psth1_mean = psth1_mean;


% group_data.speed = speed;
group_data.psth1 = psth1;


% group_data.speed_mean_quant = speed_mean_quant;
% group_data.speed_mean_base_quant = speed_mean_base_quant;

group_data.psth1_mean_quant = psth1_mean_quant;
group_data.psth1_mean_base_quant = psth1_mean_base_quant;

% save('groupData','-struct','group_data');
save groupData group_data;
assignin('base','group_data',group_data);
%% plot velocity figures
vData.heatmap=1;

speed = group_data.speed(:,:);
speed_mean = mean(speed);
speed_sem = std(speed)/sqrt(size(speed,1)-1);


fig1 = figure;
set(gcf, 'Position',  [100, 100, 800, 700]); hold on
subplot(2,6,1:5)
drawErrorLine(x_vel,speed_mean,speed_sem,'k',4);hold on;
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
box off;
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:0.5:post_stim);
set(gca,'yLim',yim_vel);
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel(['Speed (cm/s)'],'FontName','Arial','FontSize',25,'FontWeight','Bold');
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);


if vData.heatmap
    % fig1 = figure;
     subplot(2,6,7:11)
    heatmapPlot(real(speed),bin,pre_stim,0.1,fig1,yim_vel);
    set(gca,'YDir','normal')
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
    ylabel('Trial #','FontSize',25,'FontWeight','Bold');
    % title('left turning')

    subplot(2,6,12)
    axis off;
    c = colorbar;
    caxis(yim_vel);  % Set color axis limits
    c.Label.String = {'Speed (cm/s)'};
    c.Label.Rotation = 360;
    c.Label.VerticalAlignment = "middle";
    c.Label.HorizontalAlignment = "center";
    c.Ticks = yim_vel;
    c.TickLabels = string(yim_vel);
end



%% plot gcamp figures
vData.heatmap=1;
speed = group_data.psth1(:,:);
speed_mean = mean(speed);
speed_sem = std(speed)/sqrt(size(speed,1)-1);

fig1 = figure;
set(gcf, 'Position',  [1000, 100, 800, 700]); hold on
subplot(2,6,1:5)
drawErrorLine(x_gc,speed_mean,speed_sem,'b',4);hold on;
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
box off;
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:2:post_stim);
set(gca,'yLim',yim_gc);
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel(['\Delta F/F (z-scored)'],'FontName','Arial','FontSize',25,'FontWeight','Bold');
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
if vData.heatmap
    % fig1 = figure;
     subplot(2,6,7:11)
    heatmapPlot(real(speed),bin_gc,pre_stim,0.1,fig1,yim_gc,2);
    % set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:2:post_stim);
    set(gca,'YDir','normal')
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
    ylabel('Trial #','FontSize',25,'FontWeight','Bold');
    % title('left turning')

    subplot(2,6,12)
    axis off;
    c = colorbar;
    caxis(yim_gc);  % Set color axis limits
    c.Label.String = {'\Delta F/F'};
    c.Label.Rotation = 360;
    c.Label.VerticalAlignment = "middle";
    c.Label.HorizontalAlignment = "center";
    c.Ticks = yim_gc;
    c.TickLabels = string(yim_gc);
end



%% bar plot and statistic

speed = real([group_data.speed_mean_base_quant, group_data.speed_mean_quant]);
psth = [group_data.psth1_mean_base_quant, group_data.psth1_mean_quant];

groups = {'base', 'halt'}; % Group labels

%%%%%%velocity data
% Calculate statistics
mean_vals = mean(speed, 1); % Mean of each group
std_vals = std(speed, 0, 1); % Standard deviation of each group
n = size(speed, 1); % Number of samples in each group
sem_vals = std_vals ./ sqrt(n); % Standard error of the mean

% Plot individual dots and connect them with a line
figure; hold on;
for i = 1:n
    plot(1.2:2.2, speed(i, :), '-o','color',[0.5 0.5 0.5], 'LineWidth', 1.5, 'MarkerSize', 8); % Connect dots for each individual
end

% Add boxplot
boxplot(speed, 'Labels', groups, 'Colors', 'k', 'Symbol', 'k+');
% Ensure all parts of the boxplot are black and thicker
set(findobj(gca,'Tag','Box'),     'Color','k','LineWidth',2);
set(findobj(gca,'Tag','Whisker'), 'Color','k','LineWidth',2);
set(findobj(gca,'Tag','Median'),  'Color','k','LineWidth',2);
set(findobj(gca,'Tag','Outliers'),'MarkerEdgeColor','k');

set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
set(gca,'yLim',[0 25]);
% Format plot
set(gca, 'XTick', 1:2, 'XTickLabel', groups, 'FontSize', 12);
ylabel(['Speed (cm/s)'],'FontName','Arial','FontSize',25,'FontWeight','Bold');

% Perform paired t-tests between groups and display results
[~,p12] = ttest(speed(:, 1), speed(:, 2)); % Left vs Straight
% [~,p13] = ttest(speed(:, 1), speed(:, 3)); % Left vs Right
% [~,p23] = ttest(speed(:, 2), speed(:, 3)); % Straight vs Right

fprintf('\nPaired t-test results of velocity:\n');
disp(['base vs halt: p = ' num2str(p12)]);
% disp(['Left vs Right: p = ' num2str(p13)]);
% disp(['Straight vs Right: p = ' num2str(p23)]);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%gcamp signal data
% Calculate statistics
psth = [group_data.psth1_mean_base_quant, group_data.psth1_mean_quant];
groups = {'base', 'restraint'}; % Group labels

mean_vals = mean(psth, 1); % Mean of each group
std_vals = std(psth, 0, 1); % Standard deviation of each group
n = size(psth, 1); % Number of samples in each group
sem_vals = std_vals ./ sqrt(n); % Standard error of the mean

% Plot individual dots and connect them with a line
figure; hold on;
for i = 1:n
    plot(1.2:2.2, psth(i, :), '-o','color','b', 'LineWidth', 1.5, 'MarkerSize', 8); % Connect dots for each individual
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
set(gca, 'XTick', 1:2, 'XTickLabel', groups, 'FontSize', 12);
ylabel(['\Delta F/F (z-scored)'],'FontName','Arial','FontSize',25,'FontWeight','Bold');
set(gca,'yLim',[-2 8]);

% Perform paired t-tests between groups and display results
[~,p12] = ttest(psth(:, 1), psth(:, 2)); % Left vs Straight
% [~,p13] = ttest(psth(:, 1), psth(:, 3)); % Left vs Right
% [~,p23] = ttest(psth(:, 2), psth(:, 3)); % Straight vs Right

fprintf('\nPaired t-test results of gcamp:\n');
% disp('Paired t-test results of gcamp:');
disp(['base vs halt: p = ' num2str(p12)]);
% disp(['Left vs Right: p = ' num2str(p13)]);
% disp(['Straight vs Right: p = ' num2str(p23)]);