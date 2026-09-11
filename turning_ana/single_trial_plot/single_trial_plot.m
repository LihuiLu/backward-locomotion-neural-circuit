function single_trial_plot( )
%FIND_SPEED_MEAN 此处显示有关此函数的摘要
%   此处显示详细说明
%%%%edit on 20210829 by llh
[filename, pathname] = uigetfile('*.mat');
data = load([pathname,filename]);
filename

pre_stim = 3;
post_stim = 6;
xP2 = 3;
bin = 0.05;
y_lim = [-60 30]; 
tn = -pre_stim:bin:post_stim;

speed = data.backward;
speed_size = size(speed);
speed_mean = mean(speed);
speed_sem = std(speed)/sqrt(speed_size(1)-1);


figure
for i =1:size(speed,1)
    plot(tn,speed(i,:),'color',[0.5 0.5 0.5],'LineWidth',1);hold on
end
plot(tn,speed_mean,'r','LineWidth',3);
% drawErrorLine(tn,speedC_mean,speedC_sem,'k',3);hold on;
% drawErrorLine(tn,speed_mean,speed_sem,'r',3);hold on;
% legend('ChR2','Location','northwest');hold on;
% legend('ctrl','Location','southwest');hold on;
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','out');
set(gca,'yLim',y_lim);%forward
% set(gca,'yLim',[0 7]);%turning
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
xlabel('Time from stim (s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
ylabel('Speed (cm/s)','FontName','Arial','FontSize',25,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
end

