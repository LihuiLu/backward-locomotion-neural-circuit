%% 09272024, lihuilu1912@gmail.com
clc; 
clear; 
close all;
% tic;
file = dir('*Cre*.mat');
% if strfind(file(2).name,'groupData')
%     file = dir('*groupData #*.mat');
% else
%     file = dir('5ms*.mat');
% end

right_turn = 0;
xP2 = 3;
bin = 0.05;
pre_stim = 3;
post_stim = 6;
x = -pre_stim:bin:post_stim;
win = [0 3];
y_lim = [-50 20]; 

angular_v = [];
angles_cum = [];
angular_v_m = [];
angles_sum = [];
angles_delay = [];
rt_angle = [];

for i = 1:length(file)
    cName = file(i).name
    %%%
    data = importdata(cName);
    angles = mean(data.angles);
    angular_v_mean = mean(data.angular_v);
    angular_v = cat(1,angular_v, angular_v_mean);
    angles_cum = cat(1,angles_cum,data.angles_cum_mean);

    temp1 = [mean(angular_v_mean(:,1:(pre_stim)/bin)) mean(angular_v_mean(:,pre_stim/bin+1:(pre_stim+xP2)/bin)) mean(angular_v_mean(:,(pre_stim+xP2)/bin+1:end))];
    angular_v_m = cat(1,angular_v_m, temp1);

    temp2 = [sum(angles(:,1:pre_stim/bin)) sum(angles(:,pre_stim/bin+1:(pre_stim+xP2)/bin)) sum(angles(:,(pre_stim+xP2)/bin+1:end))];
    angles_sum = cat(1,angles_sum, temp2);

    %delay is defined as the time that the animal turn over 45 degrees
    if right_turn
        temp3 = find(data.angles_cum_mean(:,pre_stim/bin+1:(pre_stim+xP2)/bin)>45,1,'first');
    else
        temp3 = find(data.angles_cum_mean(:,pre_stim/bin+1:(pre_stim+xP2)/bin)-mean(data.angles_cum_mean(:,1:pre_stim/bin)) <-45,1,'first');
    end
    if isempty(temp3)
        temp3 = 60
    end
    angles_delay = cat(1,angles_delay, temp3*bin); %unit is second

    %real time angle, define the first angle as 0 degree
%     temp_direc = data.direction;
%     for j=1:size(angles,1)
%         vector = direction{1,j};
%         p2 = vector(:,1:2);     %nose                   
%         p1 = vector(:,3:4);       %body                 
%         dp = p2-p1;   
%     end
end

% group_data = ['group_data5']
group_data.angular_v = real(angular_v);
group_data.angles_cum = real(angles_cum);
group_data.angular_v_m = real(angular_v_m);
group_data.angles_sum = real(angles_sum);
group_data.angles_delay = angles_delay;

%specify the name for each group
group_data5 = group_data;
% save('groupData','-struct','group_data');
save groupData group_data5;
assignin('base','group_data',group_data);
%%