function [ output_args ] = average_ana_turn(data,data2,data3,data4)
%AVERAGE_ANA 此处显示有关此函数的摘要
% 09272024, lihuilu1912@gmail.com
%average_ana_turn(group_data5,group_data10,group_data20,group_data50)
%   此处显示详细说明average_ana_spt3(speed_mean5,speed_mean10,speed_mean20,speed_mean50)
% [ output_args ] = average_ana_spt3(data,data2,data3,data4)
% [filename, pathname] = uigetfile('*.mat');
% data = load([pathname,filename]);
% speed = data.vglut5Hz;
% nargin

pre_stim = 3;
post_stim = 6;
xP = 0;
xP2 = 3;
bin = 0.05;
tn = -pre_stim:bin:post_stim-bin;
tn_len = length(tn)


%% plot the angular velocity data
angular_v = 1;
speed_ylim = [-100 400]; %%%angular_v   define by yourself


if nargin==2
    speed = data;
    speed_size = size(speed,1);
    speed_mean = mean(speed);
    speed_sem = std(speed)/sqrt(speed_size-1);
        speed = data2;
    speed_size2 = size(speed,1);
    speed_mean2 = mean(speed);
    speed_sem2 = std(speed)/sqrt(speed_size-1);
else
    if angular_v
            speed = data.angular_v;
        speed_size = size(speed,1);
        speed_mean = mean(speed);
        speed_sem = std(speed)/sqrt(speed_size-1);
            speed = data2.angular_v;
        speed_size2 = size(speed,1);
        speed_mean2 = mean(speed);
        speed_sem2 = std(speed)/sqrt(speed_size-1);
            speed = data3.angular_v;
        speed_size3 = size(speed,1);
        speed_mean3 = mean(speed);
        speed_sem3 = std(speed)/sqrt(speed_size-1);
            speed = data4.angular_v;
        speed_size4 = size(speed,1);
        speed_mean4 = mean(speed);
        speed_sem4 = std(speed)/sqrt(speed_size-1);
    else
            speed = data.angles_cum;
        speed_size = size(speed,1);
        speed_mean = mean(speed);
        speed_sem = std(speed)/sqrt(speed_size-1);
            speed = data2.angles_cum;
        speed_size2 = size(speed,1);
        speed_mean2 = mean(speed);
        speed_sem2 = std(speed)/sqrt(speed_size-1);
            speed = data3.angles_cum;
        speed_size3 = size(speed,1);
        speed_mean3 = mean(speed);
        speed_sem3 = std(speed)/sqrt(speed_size-1);
            speed = data4.angles_cum;
        speed_size4 = size(speed,1);
        speed_mean4 = mean(speed);
        speed_sem4 = std(speed)/sqrt(speed_size-1);
    end

end

    figure
    if nargin==2
        drawErrorLine(tn,speed_mean2,speed_sem2,'k',4);hold on;
        drawErrorLine(tn,speed_mean,speed_sem,'r',4);hold on;
        
    else
        drawErrorLine(tn,speed_mean,speed_sem,'c',4);hold on;
        drawErrorLine(tn,speed_mean2,speed_sem2,'m',4);hold on;
        drawErrorLine(tn,speed_mean3,speed_sem3,'b',4);hold on;
        drawErrorLine(tn,speed_mean4,speed_sem4,'r',4);hold on;
            
        %%%%%horizontal
    %     line(get(gca,'XLim'),[xP xP],'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    end

    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    % set(gca,'yLim',[-10 80]);
    box off;
    set(gca,'yLim',speed_ylim);%speed
    % set(gca,'yLim',[80 160]);%pupil
    % set(gca,'xLim',[1 1481],'xTick',[491 991],'xTicklabel',[0 5]);%%%lick signal
    % set(gca,'xLim',[1 300],'xTick',0:50:300,'xTicklabel',-5:5:30);
    % set(gca,'xLim',[1 1401],'xTick',[451 951],'xTicklabel',[5 10]);
    set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
    xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('Change in theta power (%)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     xlabel('Frequency (Hz)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('Speed (cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('DeltaF/F (%)','FontName','Arial','FontSize',25,'FontWeight','Bold');
if angular_v
    ylabel('Angular velocity (degree/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
else
    ylabel('Turning angle (degree)','FontName','Arial','FontSize',25,'FontWeight','Bold');
end

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
if angular_v
    ylabel('Angular velocity (degree/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
else
    ylabel('Turning angle (degree)','FontName','Arial','FontSize',25,'FontWeight','Bold');
end
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
if angular_v
    ylabel('Angular velocity (degree/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
else
    ylabel('Turning angle (degree)','FontName','Arial','FontSize',25,'FontWeight','Bold');
end
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
if angular_v
    ylabel('Angular velocity (degree/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
else
    ylabel('Turning angle (degree)','FontName','Arial','FontSize',25,'FontWeight','Bold');
end
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
if angular_v
    ylabel('Angular velocity (degree/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
else
    ylabel('Turning angle (degree)','FontName','Arial','FontSize',25,'FontWeight','Bold');
end
    line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    title ('50 Hz','FontName','Arial','FontSize',25,'FontWeight','Bold')



%% plot the cumulative angle change data
angular_v = 0;
speed_ylim = [-100 800]; %%%define by yourself

if nargin==2
    speed = data;
    speed_size = size(speed,1);
    speed_mean = mean(speed);
    speed_sem = std(speed)/sqrt(speed_size-1);
        speed = data2;
    speed_size2 = size(speed,1);
    speed_mean2 = mean(speed);
    speed_sem2 = std(speed)/sqrt(speed_size-1);
else
    if angular_v
            speed = data.angular_v;
        speed_size = size(speed,1);
        speed_mean = mean(speed);
        speed_sem = std(speed)/sqrt(speed_size-1);
            speed = data2.angular_v;
        speed_size2 = size(speed,1);
        speed_mean2 = mean(speed);
        speed_sem2 = std(speed)/sqrt(speed_size-1);
            speed = data3.angular_v;
        speed_size3 = size(speed,1);
        speed_mean3 = mean(speed);
        speed_sem3 = std(speed)/sqrt(speed_size-1);
            speed = data4.angular_v;
        speed_size4 = size(speed,1);
        speed_mean4 = mean(speed);
        speed_sem4 = std(speed)/sqrt(speed_size-1);
    else
            speed = data.angles_cum;
        speed_size = size(speed,1);
        speed_mean = mean(speed);
        speed_sem = std(speed)/sqrt(speed_size-1);
            speed = data2.angles_cum;
        speed_size2 = size(speed,1);
        speed_mean2 = mean(speed);
        speed_sem2 = std(speed)/sqrt(speed_size-1);
            speed = data3.angles_cum;
        speed_size3 = size(speed,1);
        speed_mean3 = mean(speed);
        speed_sem3 = std(speed)/sqrt(speed_size-1);
            speed = data4.angles_cum;
        speed_size4 = size(speed,1);
        speed_mean4 = mean(speed);
        speed_sem4 = std(speed)/sqrt(speed_size-1);
    end

end

    figure
    if nargin==2
        drawErrorLine(tn,speed_mean2,speed_sem2,'k',4);hold on;
        drawErrorLine(tn,speed_mean,speed_sem,'r',4);hold on;
        
    else
        drawErrorLine(tn,speed_mean,speed_sem,'c',4);hold on;
        drawErrorLine(tn,speed_mean2,speed_sem2,'m',4);hold on;
        drawErrorLine(tn,speed_mean3,speed_sem3,'b',4);hold on;
        drawErrorLine(tn,speed_mean4,speed_sem4,'r',4);hold on;
            
        %%%%%horizontal
    %     line(get(gca,'XLim'),[xP xP],'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    end

    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    % set(gca,'yLim',[-10 80]);
    box off;
    set(gca,'yLim',speed_ylim);%speed
    % set(gca,'yLim',[80 160]);%pupil
    % set(gca,'xLim',[1 1481],'xTick',[491 991],'xTicklabel',[0 5]);%%%lick signal
    % set(gca,'xLim',[1 300],'xTick',0:50:300,'xTicklabel',-5:5:30);
    % set(gca,'xLim',[1 1401],'xTick',[451 951],'xTicklabel',[5 10]);
    set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
    xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('Change in theta power (%)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     xlabel('Frequency (Hz)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('Speed (cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('DeltaF/F (%)','FontName','Arial','FontSize',25,'FontWeight','Bold');
if angular_v
    ylabel('Angular velocity (degree/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
else
    ylabel('Turning angle (degree)','FontName','Arial','FontSize',25,'FontWeight','Bold');
end

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
if angular_v
    ylabel('Angular velocity (degree/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
else
    ylabel('Turning angle (degree)','FontName','Arial','FontSize',25,'FontWeight','Bold');
end
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
if angular_v
    ylabel('Angular velocity (degree/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
else
    ylabel('Turning angle (degree)','FontName','Arial','FontSize',25,'FontWeight','Bold');
end
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
if angular_v
    ylabel('Angular velocity (degree/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
else
    ylabel('Turning angle (degree)','FontName','Arial','FontSize',25,'FontWeight','Bold');
end
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
if angular_v
    ylabel('Angular velocity (degree/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
else
    ylabel('Turning angle (degree)','FontName','Arial','FontSize',25,'FontWeight','Bold');
end
    line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    title ('50 Hz','FontName','Arial','FontSize',25,'FontWeight','Bold')



% if arousal_plot
% 
%     speed = data.pupil_diam_mean;    
%     speed_size = size(speed);
%     speed_mean = mean(speed);
%     speed_sem = std(speed)/sqrt(speed_size(1)-1);
% 
%     figure
%     drawErrorLine_light(tn,speed_mean,speed_sem,'r',4);hold on;
%     % legend('mGFP');
%     set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
%     box off;
%     set(gca,'yLim',pupil_ylim);%speed
%     set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:5:post_stim);
%     xlabel('Time (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     ylabel('Pupil diameter change (%)','FontName','Arial','FontSize',25,'FontWeight','Bold');
%     xP = 0;
%     % xP = 491;
%     % xP3 = speed_onset;
%     line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
%     line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
%     % if ~isnan(xP3)
%     %     line([xP3 xP3],get(gca,'YLim'),'LineStyle',':','Color','m','LineWidth',3);
%     % end
% end


end

