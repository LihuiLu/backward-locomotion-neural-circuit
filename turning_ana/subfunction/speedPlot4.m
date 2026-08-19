function vData = speedPlot4(vData,handles);
% modified and tested 20170413
% guidata(hObject,handles);
% handles = guidata(hObject);
% centroids = [vData.centroids(:,1) vData.centroids(:,2)];

%if dlc file
centroids = [vData.location(:,5) vData.location(:,6)];


vidFrameRate = vData.vidFrameRate;
bin = 1/vidFrameRate;
ppm = handles.ppm;

% caculate speed & update centroids
tmpCentroids = centroids(2:length(centroids),:);
tmpCentroids = [tmpCentroids;centroids(length(centroids),:)];
diff = tmpCentroids-centroids;% the last one is 0
dist = diff(:,1).*diff(:,1)+diff(:,2).*diff(:,2);
speedT = sqrt(dist(:));
% speed = smooth(speedT*vidFrameRate/ppm);  
speed = smooth(speedT/bin)*ppm;
assignin('base','speed2',speed);
% totalFrame = vData.totalFrame;
% totalFrame2 = vData.totalFrame2;

% LED_read = get(handles.radiobutton_LED_read,'value');
trigger = vData.trigger_times_video;%
trigger_times = trigger(:,1);

assignin('base','trigger_times',trigger_times);

%%
pre_stim = str2double(get(handles.edit_pre,'String'));
post_stim = str2double(get(handles.edit_post,'String'));
xp2 = str2double(get(handles.edit_line2,'String'));
clims = str2num(get(handles.edit_clims,'String'));
y_lim = str2num(get(handles.edit_ylim,'String'));
tn = -pre_stim:1/vidFrameRate:post_stim;


%%%
velocity =[];
for i = 1:length(trigger_times)
   start = trigger_times(i);
   velocity = [velocity,speed(round(start-pre_stim/bin)-1:round(start+post_stim/bin)-1)];
 
end
velocity = velocity';
vData.velocity = velocity;
velocity_size = size(velocity);
velocity_mean = mean(velocity);
velocity_sem = std(velocity)/sqrt(velocity_size(1)-1);
vData.velocity_mean = velocity_mean;
vData.velocity_sem = velocity_sem;
assignin('base','vData',vData);
save(vData.matFilename, '-struct', 'vData');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h=figure;
plot(centroids(:,1),centroids(:,2),'b-');
% rectangle ('position', vData.boxPos, 'linewidth', 2, 'EdgeColor', 'k');
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
hold off
title(vData.matFilename,'FontSize',10);
dataFilename = strrep(vData.matFilename, '.mat', ' track.png');
saveas(h,dataFilename,'png');
%reverse y axis
set(gca, 'YDir', 'reverse'); % Reverse the direction of the y-axis


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h=figure; 
subplot(2,1,2);
% plot(tn,velocity);
drawErrorLine(tn,velocity_mean,velocity_sem,'r',0.2);
% set(gca,'yLim',[-18 18]);
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
set(gca,'yLim',y_lim);
set(gca,'yTick',min(y_lim):10:max(y_lim),'yTicklabel',min(y_lim):10:max(y_lim));
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
xlabel('Time(s)','FontSize',25,'FontWeight','Bold');
ylabel('Speed (cm/s)','FontSize',25,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
% xp2 = 3;
% line([xp2 xp2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
% line([-3 6],[0 0],'LineStyle',':','Color',[0 0 0],'LineWidth',3);

subplot(2,1,1);
plotHeatmap(tn,velocity,clims);
colorbar('Position',[0.93 0.7 0.03 0.2],'FontSize',5,'yTick',clims);
%%%'Position',[0.92 0.68 0.03 0.2],'FontSize',10,'yTick',clims
box off;
% colorbar;
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
xlabel('Time(s)','FontSize',25,'FontWeight','Bold');
ylabel('Trial #','FontSize',25,'FontWeight','Bold');
title(vData.matFilename,'FontSize',10);

dataFilename = strrep(vData.matFilename, '.mat', ' speed.png');
saveas(h,dataFilename,'png');
