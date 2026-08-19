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




%% if inhibition
% speed = data.speed_mean;
% speed = data.pupil_diam_mean;
% speed2 = data2.pupil_diam_mean;

% theta_power = zeros(6,2);
% for i = 1:size(data,1)
%     theta_power(i,1) = mean(data(i,1:451));
%     theta_power(i,2) = mean(data(i,451:951));
% end
% assignin('base','theta_power',theta_power);

%%%calculating locomotion speed change
% speed_min = [];
% for i = 1:size(speed,1)
%     speed_min = [speed_min;min(speed(i,50:100))];
% end
% 
% %%%for speed1
% speed_min1 = [];
% for i = 1:size(speed1,1)
%     speed_min1 = [speed_min1;min(speed1(i,50:100))];
% end
% %%%now for speed2
% speed_min2 = [];
% for i = 1:size(speed2,1)
%     speed_min2 = [speed_min2;min(speed2(i,50:100))];
% end
% 
% group_data.speed_min = speed_min;
% group_data.speed_min_nolc = speed_min1;
% group_data.speed_min_c = speed_min2;

%%%%calculate maximum speed and onset latency
% speed_max5 = [];
% for i = 1:size(data,1)
% %     temp = max(data(i,50:100))-mean(data(i,1:49));
%     temp = max(data(i,50:100));%%%min
%     speed_max5 = [speed_max5;temp];
% end
% speed_max5
% assignin('base','speed_max5',speed_max5);

% latency5 = [];
% for i = 1:size(data,1)
%     temp = resample(data(i,:),10,1);
%     t1 = find(temp(1,500:end) >= 0.1);
%     latency5 = [latency5;t1(1)*10];
% end
% assignin('base','t1',t1);
% assignin('base','latency5',latency5);

% speed_max10 = [];
% for i = 1:size(data1,1)
%     temp = max(data1(i,50:100))-mean(data1(i,1:49));
%     speed_max10 = [speed_max10;temp];
% end
% speed_max20 = [];
% for i = 1:size(data2,1)
%     temp = max(data2(i,50:100))-mean(data2(i,1:49));
%     speed_max20 = [speed_max20;temp];
% end
% speed_max50 = [];
% for i = 1:size(data3,1)
%     temp = max(data3(i,50:100))-mean(data3(i,1:49));
%     speed_max50 = [speed_max50;temp];
% end
% 
% group_data.speed_max5 = speed_max5;
% group_data.latency5 = latency5;
% group_data.speed_max20 = speed_max20;
% group_data.speed_max50 = speed_max50;
% assignin('base','delta_speed',delta_speed);
% group_data = speed_min;
% save group_data group_data;
% save ('GtACR1_speed_min','-struct','group_data');



%%% calculating locomotion reliability
% locomotion =[];
% for i = 1:size(speed,1)
%     locomotion1 = ~isempty(find(speed(i,50:100)>1,1));
%     locomotion = [locomotion;locomotion1];
% end
% locomotion_reliability = sum(locomotion)/size(speed,1);
% locomotion_reliability 


%%%%for stimulation
% for i = 1:size(forward_mean,1)
%     speed_max = max(forward_mean(i,:));
%     t1 = find(forward_mean(i,:) >= speed_max*0.1);
%     t2 = find(forward_mean(i,:) >= speed_max*0.9);
%     stop_time(i,1) = t1(1)/10;
%     stop_time(i,2) = t2(1)/10;
% end

%%% for inhibition
% for i = 1:size(forward_mean,1)
%     speed_max = max(forward_mean(i,:));
%     t1 = find(forward_mean(i,:) <= speed_max*0.9);
%     t2 = find(forward_mean(i,:) <= speed_max*0.2);
%     stop_time(i,1) = t1(1)/10;
%     stop_time(i,2) = t2(1)/10;
% end
% assignin('base','stop_time',stop_time);
% save stop_time stop_time;

% speed_stop = speed(1,80)
% speed_light = speed(51:80);
% speed_latency = find(speed_light > 0.5);
% speed_latency = speed_latency(1)/10
% locomotion_onset = [];
% start_time = [];
% for i = 1:size(speed,1)
%     [locomotion_on,pval, t_orig, crit_t, est_alpha, seed_state] = mult_comp_perm_t1(speed,1000,1,0.05,0,1);
% % % % [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1(data,n_perm,tail,alpha_level,mu,reports,seed_state)
%      locomotion_onset = [locomotion_onset;locomotion_on];
% %     speed_max1 = max(speed(i,50:100));
% %     t1 = find(speed(i,50:100) >= speed_max1*0.1);
% %     start_time = [start_time;t1(1)/10];
% end
% % locomotion_on_mean = mean(locomotion_on)
% % start_time_mean = mean(start_time);
% assignin('base','locomotion_onset',locomotion_onset);
% save locomotion_onset locomotion_onset;
