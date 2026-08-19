function speedPlot(vData,handles)
% modified and tested 20170413
% guidata(hObject,handles);
% handles = guidata(hObject);
centroids = [smooth(vData.centroids(:,1)) smooth(vData.centroids(:,2))];
headPos = vData.headPos;
vidFrameRate = vData.vidFrameRate;
ppm = vData.ppm;
area = vData.area;
% caculate speed & update centroids
tmpCentroids = centroids(2:length(centroids),:);
tmpCentroids = [tmpCentroids;centroids(length(centroids),:)];
diff = tmpCentroids-centroids;% the last one is 0
dist = diff(:,1).*diff(:,1)+diff(:,2).*diff(:,2);
speedT = sqrt(dist(:));
speed = smooth(speedT*vidFrameRate/ppm);   %%%mm/s

VLowThresh = 40; % 40 about 2 pixels; can be modified
% VLowThresh = str2double(get(handles.edit_VLowThresh,'String'));
areaLowThresh = 0.75*median(area);
speedDirec = diff;
bodyDirec = headPos - centroids;
len = length(speedDirec);
corrcos = ones(len,1)*0.01;% defaut 0.01
for i = 1:1:len
    a = speedDirec(i,:)';
    b = bodyDirec(i,:)';
    if speed(i) > VLowThresh & area(i)>= areaLowThresh & ~isnan(b) % only mobile state were analyzed
        corrcos(i) = dot(a,b)/(norm(a)*norm(b));
    end
end
corrcos = smooth(corrcos);
backState = corrcos <= 0;% 90 degree to 270 degree turn
[backMov,backStateDur] = extractLevel(backState,vidFrameRate,0.05);
backState2 = corrcos <= -0.867;% 150 degree to 210 degree turn
level1 = backMov.times(logical(backMov.level));
level0 = backMov.times(~logical(backMov.level));
totalBout = backMov.len;
nBackMov = backMov;
idx = [];
for i = 1:1:totalBout
    sIdx = level1(i)*vidFrameRate;
    eIdx = level0(i)*vidFrameRate;
    tag = sum(backState2(sIdx:eIdx));
    if tag == 0 % no obvious back movement
        idx = [idx;2*i-1;2*i];
    end
end
nBackMov.times(idx) = [];
nBackMov.level(idx) = [];
nBackMov.len = nBackMov.len - length(idx)/2;
% caculate total distance
totalDist = sum(speed);

% save data
vData.speed = speed;
vData.backMov = backMov;
vData.nBackMov = nBackMov;
vData.backStateDur = backStateDur;
vData.totalDist = totalDist;
% save(vData.matFilename, '-struct', 'vData');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:2:length(nBackMov.times)
    start = nBackMov.times(i)*vidFrameRate;
    stop = nBackMov.times(i+1)*vidFrameRate;
    speed(start:stop,1) = -speed(start:stop,1);
end

speed = speed/10;  %%%mm/s
a = find(speed>30);
speed(a) = 30;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot speed
figure;
x = (1:1:len)/vidFrameRate;
plot(x,speed,'LineWidth',2);
hold on
stairs([0;nBackMov.times],[0;nBackMov.level]*VLowThresh*0.5,'r-','LineWidth',1)
hold on%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trigger_times = vData.trigger_times;
trigger_se = sort([trigger_times;trigger_times+3]);
trigger_level = zeros(length(trigger_se),1);
trigger_level(1:2:length(trigger_level)) = 1;
stairs([0;trigger_se],[0;trigger_level]*VLowThresh*0.6,'k-','LineWidth',1);%%%%%%%%%%%%%%%%%

% set(gca,'xLim',[0 300]);
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
ylabel('Speed(cm/s)','FontSize',25,'FontWeight','Bold');
box off

%%
pre_stim = str2double(get(handles.edit_pre,'String'));
post_stim = str2double(get(handles.edit_post,'String'));
xp2 = str2double(get(handles.edit_line2,'String'));
clims = str2num(get(handles.edit_clims,'String'));
bin = 1/vidFrameRate;
tn = -pre_stim:bin:post_stim;
n = length(trigger_times);
backward =[];
for i = 1:n
   start = trigger_times(i);
   backward = [backward,speed(round((start-pre_stim)/bin):round((start+post_stim)/bin))];
end
backward = backward';
vData.backward = backward;
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
% plot(tn,backward);
drawErrorLine(tn,backward_mean,backward_sem,'r',0.2);
% set(gca,'yLim',[-18 18]);
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
% set(gca,'yLim',[-25 15]);
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
xlabel('Time(s)','FontSize',25,'FontWeight','Bold');
ylabel('Speed(cm/s)','FontSize',25,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
% xp2 = 3;
line([xp2 xp2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);


subplot(2,1,1);
plotHeatmap(tn,backward,clims);
% colorbar([0.93 0.60 0.03 0.2],'FontSize',5);
% colorbar;
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
xlabel('Time(s)','FontSize',25,'FontWeight','Bold');
ylabel('Trial #','FontSize',25,'FontWeight','Bold');


function outData = modData(vData,inData,timePerPoint,mTag)

len = floor(length(inData)/ (vData.perSecondReadFrames*timePerPoint));% s per point
outData = zeros(len,size(inData,2));
if mTag == 0 
    tmp = sum(inData(1:(vData.perSecondReadFrames*timePerPoint-1)));
    outData(1) = tmp; 
    for i = 2:floor(length(inData)/ (vData.perSecondReadFrames*timePerPoint))
        tmp = sum(inData((i-1)*vData.perSecondReadFrames*timePerPoint:((i*vData.perSecondReadFrames*timePerPoint)-1)));
        outData(i) = tmp;
    end
else if mTag ==1
    tmp = mean(inData(1:(vData.perSecondReadFrames*timePerPoint-1)));
    outData(1) = tmp; 
    for i = 2:floor(length(inData)/ (vData.perSecondReadFrames*timePerPoint))
        tmp = mean(inData((i-1)*vData.perSecondReadFrames*timePerPoint:((i*vData.perSecondReadFrames*timePerPoint)-1)));
        outData(i) = tmp;
    end  
    end
end