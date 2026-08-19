%% 03022026, lihuilu1912@gmail.com


%%
clc; 
clear; 
close all;
% tic;
file = dir('*analysis.mat');

xP=0;
xP2 = 20;
bin = 1/20;%video framerate is 20
pre_stim = 2;
post_stim = 22;
x_vel = -pre_stim:bin:post_stim;
win = [0 20];
yim_gc = [-5 5]; 
yim_vel = [0 30]; 

bin_gc = 1/50;%fiber photometry sampling frequency is 50 hz
x_gc = -pre_stim:bin_gc:post_stim;

velocity_mean = [];
psth1_mean = [];

velocity = [];
psth1 = [];

velocity_mean_quant = [];
velocity_mean_base_quant = [];

psth1_mean_quant = [];
psth1_mean_base_quant = [];

for i = 1:length(file)
    cName = file(i).name
    %%%
    % data = importdata(cName);
    data = load(cName);

    velocity_mean = cat(1,velocity_mean, data.vData.velocity_mean);
    psth1_mean = cat(1,psth1_mean, data.vData.psth1_mean);


    velocity = cat(1,velocity, real(data.vData.velocity));
    psth1 = cat(1,psth1, data.vData.psth1);


    velocity_mean_quant = cat(1,velocity_mean_quant, mean(data.vData.velocity_mean(:,pre_stim/bin+1:(pre_stim+xP2)/bin)));
    velocity_mean_base_quant = cat(1,velocity_mean_base_quant, mean(data.vData.velocity_mean(:,1:(pre_stim)/bin)));

    psth1_mean_quant = cat(1,psth1_mean_quant, mean(data.vData.psth1_mean(:,pre_stim/bin_gc+1:(pre_stim+xP2)/bin_gc)));
    psth1_mean_base_quant = cat(1,psth1_mean_base_quant, mean(data.vData.psth1_mean(:,1:(pre_stim)/bin_gc)));


end


group_data.velocity_mean = velocity_mean;
group_data.psth1_mean = psth1_mean;


group_data.velocity = velocity;
group_data.psth1 = psth1;


group_data.velocity_mean_quant = velocity_mean_quant;
group_data.velocity_mean_base_quant = velocity_mean_base_quant;

group_data.psth1_mean_quant = psth1_mean_quant;
group_data.psth1_mean_base_quant = psth1_mean_base_quant;

% save('groupData','-struct','group_data');
save groupData group_data;
assignin('base','group_data',group_data);
%% plot velocity figures
vData.heatmap=1;

velocity = group_data.velocity(:,:);
velocity_mean = mean(velocity);
velocity_sem = std(velocity)/sqrt(size(velocity,1)-1);

tick = 2;
fig1 = figure;
set(gcf, 'Position',  [100, 100, 800, 700]); hold on
subplot(2,6,1:5)
drawErrorLine(x_vel,velocity_mean,velocity_sem,'k',4);hold on;
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
box off;
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:tick:post_stim);
set(gca,'yLim',yim_vel);
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel(['Speed (cm/s)'],'FontName','Arial','FontSize',25,'FontWeight','Bold');
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);


if vData.heatmap
    % fig1 = figure;
     subplot(2,6,7:11)
    heatmapPlot(real(velocity),bin,pre_stim,0.1,fig1,yim_vel,tick);
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
velocity = group_data.psth1(:,:);
velocity_mean = mean(velocity);
velocity_sem = std(velocity)/sqrt(size(velocity,1)-1);

fig1 = figure;
set(gcf, 'Position',  [1000, 100, 800, 700]); hold on
subplot(2,6,1:5)
drawErrorLine(x_gc,velocity_mean,velocity_sem,'b',4);hold on;
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
box off;
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:tick:post_stim);
set(gca,'yLim',yim_gc);
xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel(['\Delta F/F (z-scored)'],'FontName','Arial','FontSize',25,'FontWeight','Bold');
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
if vData.heatmap
    % fig1 = figure;
     subplot(2,6,7:11)
    heatmapPlot(real(velocity),bin_gc,pre_stim,0.1,fig1,yim_gc,tick);
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

velocity = real([group_data.velocity_mean_base_quant, group_data.velocity_mean_quant]);
psth = [group_data.psth1_mean_base_quant, group_data.psth1_mean_quant];

groups = {'base', 'condition'}; % Group labels

%%%%%%velocity data
% Calculate statistics
mean_vals = mean(velocity, 1); % Mean of each group
std_vals = std(velocity, 0, 1); % Standard deviation of each group
n = size(velocity, 1); % Number of samples in each group
sem_vals = std_vals ./ sqrt(n); % Standard error of the mean

% Plot individual dots and connect them with a line
figure; hold on;
for i = 1:n
    plot(1.2:2.2, velocity(i, :), '-o','color',[0.5 0.5 0.5], 'LineWidth', 1.5, 'MarkerSize', 8); % Connect dots for each individual
end

% Add boxplot
boxplot(velocity, 'Labels', groups, 'Colors', 'k', 'Symbol', 'k+');
% Ensure all parts of the boxplot are black and thicker
set(findobj(gca,'Tag','Box'),     'Color','k','LineWidth',2);
set(findobj(gca,'Tag','Whisker'), 'Color','k','LineWidth',2);
set(findobj(gca,'Tag','Median'),  'Color','k','LineWidth',2);
set(findobj(gca,'Tag','Outliers'),'MarkerEdgeColor','k');

set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
set(gca,'yLim',[0 5]);
% Format plot
set(gca, 'XTick', 1:2, 'XTickLabel', groups, 'FontSize', 12);
ylabel(['Speed (cm/s)'],'FontName','Arial','FontSize',25,'FontWeight','Bold');

% Perform paired t-tests between groups and display results
[~,p12] = ttest(velocity(:, 1), velocity(:, 2)); % Left vs Straight
% [~,p13] = ttest(velocity(:, 1), velocity(:, 3)); % Left vs Right
% [~,p23] = ttest(velocity(:, 2), velocity(:, 3)); % Straight vs Right

fprintf('\nPaired t-test results of velocity:\n');
disp(['base vs halt: p = ' num2str(p12)]);
% disp(['Left vs Right: p = ' num2str(p13)]);
% disp(['Straight vs Right: p = ' num2str(p23)]);


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
set(gca,'yLim',[-5 5]);

% Perform paired t-tests between groups and display results
[~,p12] = ttest(psth(:, 1), psth(:, 2)); % Left vs Straight
% [~,p13] = ttest(psth(:, 1), psth(:, 3)); % Left vs Right
% [~,p23] = ttest(psth(:, 2), psth(:, 3)); % Straight vs Right

fprintf('\nPaired t-test results of gcamp:\n');
% disp('Paired t-test results of gcamp:');
disp(['base vs halt: p = ' num2str(p12)]);
% disp(['Left vs Right: p = ' num2str(p13)]);
% disp(['Straight vs Right: p = ' num2str(p23)]);