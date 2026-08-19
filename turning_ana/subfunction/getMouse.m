%%get mouse position from each frame
%% Copyright conserved by liyi & Luo Minmin Lab
% Contact liyi@nibs.ac.cn or luominmin@nibs.ac.cn
function getMouse(hObject, eventdata, handles)
% modified and tested 20170413
guidata(hObject,handles);
handles = guidata(hObject);
tic;
vData = handles.data;
refImg = vData.refImg;
boxPos_LED = vData.boxPos_LED;

vidObj = VideoReader(vData.dataFile);
totalFrame = vidObj.NumberOfFrames;
% vidObj.CurrentTime = 0;
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
vidFrameRate = vidObj.FrameRate;
vidDuration = vidObj.Duration;
totalFrame2 = round(vidFrameRate*vidDuration);


% creat a dynamic waiting bar
h = waitbar(0,'1','Name','Processing images...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)

time2Read = str2double(get(handles.time2Read_edit,'String'));
if time2Read > 0
    readTime = min(floor(time2Read),vidDuration);% acctually readTime is the time caculated,means 300s(5min)
else
    readTime = vidDuration;
end

% temp = vidFrameRate/10;
temp = 1;
data_len = length(1:temp:totalFrame);
centroids = zeros(data_len,2);
headPos = nan(data_len,2);
area = zeros(data_len,1);
thre = zeros(data_len,1);
k = 1;
% while k<=totalFrame   %%% hasFrame(vidObj) & 
for i = 1:1:totalFrame 
    % press cancel then break
    if getappdata(h,'canceling')
        break
    end
    % Report current situation in the waitbar's message field
    waitbar(k/totalFrame,h,sprintf('%.1f%% remaining...',(1-k/totalFrame)*100));
    
%     tmpImg = readFrame(vidObj);
    tmpImg = read(vidObj,i); 
    currentImg = rgb2gray(tmpImg);
    boxRangeCurrentImg = currentImg(vData.rSta:vData.rEnd,vData.cSta:vData.cEnd);
    rMouseRegion = vData.boxRangeRefImg - boxRangeCurrentImg;
    tmp = double(max(max(rMouseRegion)));
    rMouseRegion1 = mat2gray(rMouseRegion,[0 tmp]);
    level = max(graythresh(rMouseRegion1),0.3);
    bwrMouse = im2bw(rMouseRegion1,level);
    bwMouse = bwareaopen(bwrMouse,300);
    CC = bwconncomp(bwMouse);
    L = labelmatrix(CC);
    stats = regionprops(L, 'Area','Centroid');
    [currentArea, idx] = max([stats.Area]);
    if ~isempty(idx) & currentArea < 3000 %3000
        area(k) = stats(idx(1)).Area;
        centroids(k,:) = stats(idx(1)).Centroid;
        bwMouse = ismember(labelmatrix(CC), idx(1));
        % head Position
        bwrHead = imfill(bwMouse,'holes') - bwMouse;
        [r c] = find(bwrHead);
        cHeadPos = floor(median([c r]));
        if ~isnan(cHeadPos)
            headPos(k,:) = cHeadPos;
        end
    elseif k==1
        area(k) = stats(idx(1)).Area;
        centroids(k,:) = stats(idx(1)).Centroid;
    else
        lossTag = 1
        centroids(k,:) = centroids(k-1,:);
        area(k) = area(k-1);
    end
    
        %%%%%%%%%%%%%%%%%read LED frame
    rSta = boxPos_LED(1,2);
    rEnd = boxPos_LED(1,2) + boxPos_LED(1,4) - 1;
    cSta = boxPos_LED(1,1);
    cEnd = boxPos_LED(1,1) + boxPos_LED(1,3) - 1;
    ledImgRef = refImg(rSta:rEnd,cSta:cEnd);
    ledImg = tmpImg;
%     blueLight = ledImg-ledImgRef;
    assignin('base','tmpImg',tmpImg);
    assignin('base','currentImg',currentImg);
    assignin('base','ledImg',ledImg);
    r = ledImg(rSta:rEnd,cSta:cEnd,1);
    g = ledImg(rSta:rEnd,cSta:cEnd,2);
    b = ledImg(rSta:rEnd,cSta:cEnd,3);
    redLight = 1.5*r-g-b;
    thre(k) = sum(any(redLight));
    assignin('base','thre',thre);
    
%     if(mod(vidObj.CurrentTime,100) == 0)
%             vData.totalFramesRead = k;
%             vData.centroids = centroids;%(centroids~=0);
%             vData.area = area;%(area~=0);
%             save(vData.matFilename, '-struct', 'vData');
%             report = ['CurrentTime:' num2str(vidObj.CurrentTime)];
%             disp(report)
%     end
    if vidObj.CurrentTime >= readTime
        break
    end
    k = k+1;
end

delete(h)  

vData.vidHeight = vidHeight;
vData.vidWidth = vidWidth;
vData.vidFrameRate = vidFrameRate;
vData.totalFrame = totalFrame;
vData.totalFrame2 = totalFrame2;

vData.centroids = centroids;
vData.headPos = headPos;
vData.area = area;
vData.readTime = readTime;
vData.thre = thre;

handles.data = vData;

guidata(hObject,handles);
handles = guidata(hObject);
save(vData.matFilename, '-struct', 'vData');
toc;