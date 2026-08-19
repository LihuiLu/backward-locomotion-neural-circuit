function speedPlot2(vData,handles)
% modified and tested 20170413
% guidata(hObject,handles);
% handles = guidata(hObject);
centroids = [vData.centroids(:,1) vData.centroids(:,2)];
% centroids = resample(centroids,10,30);
vidFrameRate = vData.vidFrameRate;
bin = 1/vidFrameRate;
%headPos = vData.headPos;

temp = vidFrameRate/10;
ppm = handles.ppm;
% ppm = 0.77;
%area = vData.area;
% caculate speed & update centroids
tmpCentroids = centroids(2:length(centroids),:);
tmpCentroids = [tmpCentroids;centroids(length(centroids),:)];
diff = tmpCentroids-centroids;% the last one is 0
dist = diff(:,1).*diff(:,1)+diff(:,2).*diff(:,2);
speedT = sqrt(dist(:));
% speed = smooth(speedT*vidFrameRate/ppm);  
speed = smooth(speedT/bin/ppm);
% speed = resample(speed,10,30);
assignin('base','speed2',speed);
totalFrame = vData.totalFrame;
totalFrame2 = vData.totalFrame2;
p = abs(totalFrame2 - totalFrame);
% p = 46;
LED_read = get(handles.radiobutton_LED_read,'value');
if LED_read
    trigger_times = vData.trigger_times;
else
    trigger = vData.trigger_times;
    trigger_times = trigger(:,2);
    n = size(trigger,2);
    if n>2
    back_times = trigger(:,3:n)
    end
end

%%
pre_stim = str2double(get(handles.edit_pre,'String'));
post_stim = str2double(get(handles.edit_post,'String'));
xp2 = str2double(get(handles.edit_line2,'String'));
clims = str2num(get(handles.edit_clims,'String'));
y_lim = str2num(get(handles.edit_ylim,'String'));
% bin = 1/vidFrameRate;
tn = -pre_stim:1/vidFrameRate:post_stim;
length(tn);
n = length(trigger_times);

%%%%%set backward speed into negative speed
backward =[];
back_max = [];
for i = 1:length(trigger_times)
    if ~isempty(back_times)
           temp_bt = back_times(i,:);
           temp = find(temp_bt>0);
           temp_bt = temp_bt(temp);
           backN = length(temp_bt)
           for j=1:backN/2
               back_s = back_times(i,2*j-1);
               back_e = back_times(i,2*j);
               speed(back_s:back_e,1) = -speed(back_s-1:back_e-1,1);
           end
    else
        display('there are no backward behavior!')
    end
    %%%%%%edit 20180823 by lu lihui
   start = trigger_times(i);
   backward = [backward,speed(round(start-pre_stim/bin)-1:round(start+post_stim/bin)-1)];
   backward_temp = speed(round(start-pre_stim/bin)-1:round(start+post_stim/bin)-1);
   back_max = [back_max;min(backward_temp)];
   
   %%%plot single trial
%    figure;
%     plot(tn,backward_temp,'k','LineWidth',2);
%     set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
% %     set(gca,'yLim',[-50 50]);
%     set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
%     xlabel('Time(s)','FontSize',25,'FontWeight','Bold');
%     ylabel('Speed (cm/s)','FontSize',25,'FontWeight','Bold');
%     xP = 0;
%     line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
%     % xp2 = 3;
%     line([xp2 xp2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
%     title(['trial ', num2str(i)]);
end
speed_direction = speed;

backward = backward';
vData.speed_direction = speed_direction;   %%%add 20180823
vData.backward = backward;
vData.back_max = back_max;
backward_size = size(backward);
backward_mean = mean(backward);
backward_sem = std(backward)/sqrt(backward_size(1)-1);
vData.backward_mean = backward_mean;
vData.backward_sem = backward_sem;
% assignin('base','backward_mean',backward_mean);
% assignin('base','backward_sem',backward_sem);
assignin('base','vData',vData);
save(vData.matFilename, '-struct', 'vData');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure; 
subplot(2,1,2);
for i=1:size(backward,1)
    plot(tn,backward(i,:));hold on
end
drawErrorLine(tn,backward_mean,backward_sem,'r',0.2);
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
line([xp2 xp2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
line([-3 6],[0 0],'LineStyle',':','Color',[0 0 0],'LineWidth',3);

subplot(2,1,1);
plotHeatmap(tn,backward,clims);
colorbar('Position',[0.93 0.7 0.03 0.2],'FontSize',5,'yTick',clims);
%%%'Position',[0.92 0.68 0.03 0.2],'FontSize',10,'yTick',clims
box off;
% colorbar;
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
xlabel('Time(s)','FontSize',25,'FontWeight','Bold');
ylabel('Trial #','FontSize',25,'FontWeight','Bold');
title(vData.matFilename,'FontSize',10);

% %%%plot sigle trial
% for k = 
%     
% end
% function outData = modData(vData,inData,timePerPoint,mTag)
% 
% len = floor(length(inData)/ (vData.perSecondReadFrames*timePerPoint));% s per point
% outData = zeros(len,size(inData,2));
% if mTag == 0 
%     tmp = sum(inData(1:(vData.perSecondReadFrames*timePerPoint-1)));
%     outData(1) = tmp; 
%     for i = 2:floor(length(inData)/ (vData.perSecondReadFrames*timePerPoint))
%         tmp = sum(inData((i-1)*vData.perSecondReadFrames*timePerPoint:((i*vData.perSecondReadFrames*timePerPoint)-1)));
%         outData(i) = tmp;
%     end
% else if mTag ==1
%     tmp = mean(inData(1:(vData.perSecondReadFrames*timePerPoint-1)));
%     outData(1) = tmp; 
%     for i = 2:floor(length(inData)/ (vData.perSecondReadFrames*timePerPoint))
%         tmp = mean(inData((i-1)*vData.perSecondReadFrames*timePerPoint:((i*vData.perSecondReadFrames*timePerPoint)-1)));
%         outData(i) = tmp;
%     end  
%     end
% end