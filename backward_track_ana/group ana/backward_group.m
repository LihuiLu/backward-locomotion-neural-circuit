%% 09272024, lihuilu1912@gmail.com
%you can run this part of the code once you get the mat file for each
%animal with backward_track_ana3 or other version of codes
% get the speed trace data, peak speed, and delay
clc; 
clear; 
close all;
% tic;
file = dir('*cre*.mat');
% if strfind(file(2).name,'groupData')
%     file = dir('*groupData #*.mat');
% else
%     file = dir('5ms*.mat');
% end

%plot the heatmap of velocity for each mouse
t = tiledlayout(length(file),1,'Padding','Compact');

xP2 = 3;
bin = 0.05;
pre_stim = 3;
post_stim = 6;
x = -pre_stim:bin:post_stim;
win = [0 3];
y_lim = [-50 20]; 

speed_mean = [];
averaged_speed = [];
delay = [];
velocity = {};
for i = 1:length(file)
    cName = file(i).name
    data = importdata(cName);

    speed_mean  = cat(1,speed_mean,data.backward_mean);
    velocity{i} = data.backward;

    temp1 = [mean(data.backward_mean(:,1:(pre_stim)/bin)) mean(data.backward_mean(:,pre_stim/bin+1:(pre_stim+xP2)/bin)) mean(data.backward_mean(:,(pre_stim+xP2)/bin+1:end))];
    averaged_speed = cat(1,averaged_speed, temp1);

    %delay is defined by the time when the change of speed is larger than 2
    %times of SD of the baseline.
    % temp2 = find(abs(abs(data.backward_mean(:,pre_stim/bin+1:(pre_stim+xP2)/bin))-2*std(data.backward_mean(:,1:pre_stim/bin))) > 0,1,'first')
    % temp2 = find(abs(abs(data.backward_mean(:,pre_stim/bin+1:(pre_stim+xP2)/bin))-mean(data.backward_mean(:,1:pre_stim/bin))) > 2,1,'first')
%     temp2 = find(abs(data.backward_mean(:,pre_stim/bin+1:(pre_stim+xP2)/bin))-1 > 0,1,'first');

    stim_vel = data.backward_mean(:,pre_stim/bin+1:(pre_stim+xP2)/bin);
    thre = 0.1*min(data.backward_mean(:,pre_stim/bin+1:(pre_stim+xP2)/bin));
    temp2 = find((stim_vel- thre) < 0,1,'first');
    if isempty(temp2)
        temp2 = 60
    end
    delay = cat(1,delay, temp2*bin); %unit is second

    %plot the heatmap of velocity for each mouse
    nexttile
    imagesc(velocity{i});
end

group_data.speed_mean = speed_mean;
group_data.averaged_speed = averaged_speed;
group_data.delay = delay;
group_data.velocity = velocity;
%specify the name for each group (i.e. each stimulation frequency)
group_data5 = group_data;
% save('groupData','-struct','group_data');
save groupData group_data5;
assignin('base','group_data',group_data);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%----------------------

%% run this code once you load all groups to the workspace. plot 4 traces on the same figure and plot one trace for each figure
trace_num = 4;
if trace_num==4
    averaged_speed = [group_data5.averaged_speed(:,1:2), group_data10.averaged_speed(:,1:2), group_data20.averaged_speed(:,1:2), group_data50.averaged_speed(:,1:2)];
    delay = [group_data5.delay, group_data10.delay, group_data20.delay, group_data50.delay];
else
    averaged_speed = [group_data20.averaged_speed(:,1:2), group_data50.averaged_speed(:,1:2)];
    delay = [group_data20.delay, group_data50.delay];
end
assignin('base','averaged_speed',averaged_speed);
assignin('base','delay',delay);

trace_num = 4;
pre_stim = 3;
post_stim = 6;
xP = 0;
xP2 = 3;
bin = 0.05;
tn = -pre_stim:bin:post_stim;
tn_len = length(tn)


% plot the angular velocity data
angular_v = 1;
speed_ylim = [-50 10]; %%%angular_v   define by yourself


if trace_num==2
    speed = group_data20.speed_mean;
    speed_size = size(speed,1);
    speed_mean = mean(speed);
    speed_sem = std(speed)/sqrt(speed_size-1);
        speed = group_data50.speed_mean;
    speed_size2 = size(speed,1);
    speed_mean2 = mean(speed);
    speed_sem2 = std(speed)/sqrt(speed_size-1);
else
        speed = group_data5.speed_mean;
    speed_size = size(speed,1);
    speed_mean = mean(speed);
    speed_sem = std(speed)/sqrt(speed_size-1);
        speed = group_data10.speed_mean;
    speed_size2 = size(speed,1);
    speed_mean2 = mean(speed);
    speed_sem2 = std(speed)/sqrt(speed_size-1);
        speed = group_data20.speed_mean;
    speed_size3 = size(speed,1);
    speed_mean3 = mean(speed);
    speed_sem3 = std(speed)/sqrt(speed_size-1);
        speed = group_data50.speed_mean;
    speed_size4 = size(speed,1);
    speed_mean4 = mean(speed);
    speed_sem4 = std(speed)/sqrt(speed_size-1);
end

    figure
    if trace_num==2
        drawErrorLine(tn,speed_mean,speed_sem,'b',4);hold on;
        drawErrorLine(tn,speed_mean2,speed_sem2,'r',4);hold on;
            set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
        % set(gca,'yLim',[-10 80]);
        box off;
        set(gca,'yLim',speed_ylim);%speed
        set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
        xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        ylabel('Speed (cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        legend('','20 Hz','','50 Hz','Location','best');

                figure
        drawErrorLine(tn,speed_mean,speed_sem,'k',4);hold on;
        set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
        box off;
        set(gca,'yLim',speed_ylim);%speed
        set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
        xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        ylabel('Speed (cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        title ('20 Hz','FontName','Arial','FontSize',25,'FontWeight','Bold')
    
            figure
        drawErrorLine(tn,speed_mean2,speed_sem2,'k',4);hold on;
        set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
        box off;
        set(gca,'yLim',speed_ylim);%speed
        set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
        xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        ylabel('Speed (cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        title ('50 Hz','FontName','Arial','FontSize',25,'FontWeight','Bold')


    else
        drawErrorLine(tn,speed_mean,speed_sem,'c',4);hold on;
        drawErrorLine(tn,speed_mean2,speed_sem2,'m',4);hold on;
        drawErrorLine(tn,speed_mean3,speed_sem3,'b',4);hold on;
        drawErrorLine(tn,speed_mean4,speed_sem4,'r',4);hold on;
            set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
        % set(gca,'yLim',[-10 80]);
        box off;
        set(gca,'yLim',speed_ylim);%speed
        set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
        xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        ylabel('Speed (cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        legend('','5 Hz','','10 Hz','','20 Hz','','50 Hz','Location','best');

            %plot each frequency seperately

        figure
        drawErrorLine(tn,speed_mean,speed_sem,'k',4);hold on;
        set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
        box off;
        set(gca,'yLim',speed_ylim);%speed
        set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
        xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        ylabel('Speed (cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        title ('5 Hz','FontName','Arial','FontSize',25,'FontWeight','Bold')
    
            figure
        drawErrorLine(tn,speed_mean2,speed_sem2,'k',4);hold on;
        set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
        box off;
        set(gca,'yLim',speed_ylim);%speed
        set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
        xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        ylabel('Speed (cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        title ('10 Hz','FontName','Arial','FontSize',25,'FontWeight','Bold')
    
            figure
        drawErrorLine(tn,speed_mean3,speed_sem3,'k',4);hold on;
        set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
        box off;
        set(gca,'yLim',speed_ylim);%speed
        set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
        xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        ylabel('Speed (cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        title ('20 Hz','FontName','Arial','FontSize',25,'FontWeight','Bold')
    
            figure
        drawErrorLine(tn,speed_mean4,speed_sem4,'k',4);hold on;
        set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
        box off;
        set(gca,'yLim',speed_ylim);%speed
        set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
        xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        ylabel('Speed (cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
        line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
        title ('50 Hz','FontName','Arial','FontSize',25,'FontWeight','Bold')
    end



    



% end

%%

t = tiledlayout(length(velocity),1,'Padding','Compact');

for i=1:length(velocity)
    nexttile
    imagesc(velocity{i});
end