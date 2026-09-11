function [ output_args ] = find_peak_auc()
%FIND_10SPEED_TIME 此处显示有关此函数的摘要
%   此处显示详细说明find_change( data,data1,data2,data3 )
%%
file = dir('*3s*.mat');
xP2 = 3;
bin = 0.05;
pre_stim = 3;
post_stim = 6;
x = -pre_stim:bin:post_stim;
win = [0 3];
y_lim = [-50 20]; 


% find group data
speedb_mean = [];
% speedc_mean = [];
for i = 1:length(file)
    cName = file(i).name
    temp = importdata(cName);
    speedb_mean = [speedb_mean;temp.backward_mean];
end
group_data.speedb_mean = speedb_mean;
assignin('base','speedb_mean',speedb_mean);

%%
%%%%%%calculate area under curve (AUC) and peak speed
data = speedb_mean;
speed_auc = [];
speed_max = [];
speed_min = [];
for i = 1:size(data,1)
    temp2 = aucCalculate(x,win,data(i,:));
    speed_auc = [speed_auc;temp2];
    speed_max = [speed_max;max(data(i,(win(1)+pre_stim:pre_stim+win(2))/bin))];
    speed_min = [speed_min;min(data(i,(win(1)+pre_stim:pre_stim+win(2))/bin))];
end
assignin('base','speed_max',speed_max);
assignin('base','speed_auc',speed_auc);
assignin('base','speed_min',speed_min);
% save speed_auc speed_auc
group_data.speed_auc = speed_auc;
group_data.speed_max = speed_max;
group_data.speed_min = speed_min;
save('groupData','-struct','group_data');

%%
speed = speedb_mean;
speed_size = size(speed);
speed_mean = mean(speed);
speed_sem = std(speed)/sqrt(speed_size(1)-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
drawErrorLine(x,speed_mean,speed_sem,'r',3);hold on;
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
set(gca,'yLim',y_lim);
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
xlabel('Time from stim (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel('Velocity (cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);


disp('finished!');
end


