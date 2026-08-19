function varargout = turning_DLC_GC(varargin)
% using readFrame
% get headPos for fiber implanted mice
% OK 20151123
% modified 20161126
% modified and tested 20170413 by lu lihui
%read LED 20180420 by lu lihui
%read backward frames 20180823 by lu lihui
%gc and turning behavior, 20250902, lu lihui

% Contact liyi@nibs.ac.cn or lulihui@nibs.ac.cn or luominmin@nibs.ac.cn
% TURNING_DLC_GC MATLAB code for turning_DLC_GC.fig
%      TURNING_DLC_GC, by itself, creates a new TURNING_DLC_GC or raises the existing
%      singleton*.
%
%      H = TURNING_DLC_GC returns the handle to a new TURNING_DLC_GC or the handle to
%      the existing singleton*.
%
%      TURNING_DLC_GC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TURNING_DLC_GC.M with the given input arguments.
%
%      TURNING_DLC_GC('Property','Value',...) creates a new TURNING_DLC_GC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before turning_DLC_GC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to turning_DLC_GC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help turning_DLC_GC

% Last Modified by GUIDE v2.5 24-Mar-2026 22:36:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @turning_DLC_GC_OpeningFcn, ...
                   'gui_OutputFcn',  @turning_DLC_GC_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before turning_DLC_GC is made visible.
function turning_DLC_GC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to turning_DLC_GC (see VARARGIN)

% Choose default command line output for turning_DLC_GC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes turning_DLC_GC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = turning_DLC_GC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in boxRead_pb.
function boxRead_pb_Callback(hObject, eventdata, handles)
% hObject    handle to boxRead_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject,handles);
handles = guidata(hObject);
vData = handles.data;
% ppm = str2double(get(handles.ppm_edit,'String'));
% vData.ppm = ppm;
% handles.data = vData;
guidata(hObject,handles);
handles = guidata(hObject);

getMouse(hObject, eventdata, handles);

handles = guidata(hObject);
vData = handles.data;
assignin('base','vData',vData);

%plot the track of the mouse
axes(handles.axes1);
baseImg = imshow(vData.boxRangeRefImg);
hold on
plot(vData.centroids(:,1),vData.centroids(:,2),'b-');
% rectangle ('position', vData.boxPos, 'linewidth', 2, 'EdgeColor', 'k');
hold off

guidata(hObject,handles);
handles = guidata(hObject);




% --- Executes on button press in ROIAna_pb.
function ROIAna_pb_Callback(hObject, eventdata, handles)
% hObject    handle to ROIAna_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
vData = handles.data;
speedPlot(vData,handles);


function filename_edit_Callback(hObject, eventdata, handles)
% hObject    handle to filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename_edit as text
%        str2double(get(hObject,'String')) returns contents of filename_edit as a double


% --- Executes during object creation, after setting all properties.
function filename_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadFile_pb.
function loadFile_pb_Callback(hObject, eventdata, handles)
% hObject    handle to loadFile_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = uigetfile({'*.wmv';'*.mp4';'*.bmp';'*.avi';}, 'Pick AVI files for REF image and data analysis','MultiSelect', 'on');

if isequal(filename,0)
   disp('User selected Cancel')
   return

else
    filename = cellstr(filename);
    if length(filename) == 2
        if strfind(filename{1},'ref')
            refFile = filename{1}; 
            dataFile = filename{2}; 
        else
            dataFile = filename{1};
            refFile = filename{2}; 
        end
    end
    if length(filename) == 1
         refFile = filename{1}; 
         dataFile = filename{1}; 
    end
    [pathstr, name, ext] = fileparts(dataFile);
    set(handles.filename_edit,'String',name);
    matFilename = strrep(dataFile, ext, '.mat');
    handles.data.refFile = refFile;
    handles.data.dataFile = dataFile;
    handles.data.matFilename = matFilename;
    guidata(hObject,handles);
    handles = guidata(hObject);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20200627
    movieFile = refFile; 
    [a, b, c] = fileparts(movieFile);
    if strcmp(c, '.MP4'),
        readerRefObj = VideoReader(movieFile, 'tag', 'REF reader');   
        refImg = read(readerRefObj, 20);   
        axes(handles.axes1);
        baseImg = imshow(refImg);
    end

    if strcmp(c, '.wmv'),
        readerRefObj = VideoReader(movieFile, 'tag', 'REF reader');   
        refImg = read(readerRefObj, 20);   
        axes(handles.axes1);
        baseImg = imshow(refImg);
    end

    if strcmp(c, '.bmp'),
%         readerRefObj = VideoReader(movieFile, 'tag', 'REF reader');   
        refImg = imread(movieFile);   
%         axes(handles.axes1);
        h=figure;
        baseImg = imshow(refImg);
        h1 = imrect(gca,round([94.0677966101695 14.5593220338983 465.118644067797 394.35593220339]));
        setColor(h1,'k');
        boxPos = round(wait(h1));
        bwBoxRange = createMask(h1,baseImg);
        bwBoxRange = uint8(bwBoxRange);
        roi_img = refImg(boxPos(2):boxPos(2)+boxPos(4),boxPos(1):boxPos(1)+boxPos(3));
        
        bmpFileName = [handles.data.matFilename(1:end-4), ' roi.bmp']
        imwrite(roi_img,bmpFileName,'bmp');
        close(h);
    end
    
    getRefImg(hObject, eventdata, handles);
end





%%get reference image and show out;
%% Copyright conserved by liyi & Luo Minmin Lab
% Contact liyi@nibs.ac.cn or luominmin@nibs.ac.cn
function getRefImg(hObject, eventdata, handles)

guidata(hObject,handles);
handles = guidata(hObject);

vData = handles.data;

if strfind(vData.refFile,'wmv')
    vidObj = VideoReader(vData.refFile);

    vidHeight = vidObj.Height;
    vidWidth = vidObj.Width;
    vidFrameRate = vidObj.FrameRate;
    vidDuration = vidObj.Duration;
    totalFrame = round(vidFrameRate*vidDuration)
    % Preallocate movie structure.
    slctFNum = min(20,round(totalFrame*0.01));
    allImg = zeros(vidHeight,vidWidth, 3,slctFNum,'uint8');
    mov(1:slctFNum) = ...
    struct('cdata',zeros(vidHeight,vidWidth, 3,'uint8'),...
           'colormap',[]);
    % ranf = randi([10 min(totalFrame,2000)], slctFNum,1);    
    ranf = randi([10 totalFrame], slctFNum,1);   
    for i = 1:1:slctFNum
        k = ranf(i);
        try
            mov(i).cdata = read(vidObj, k);
            allImg(:,:,:,i) = mov(i).cdata(:,:,:);
        catch
        end
    end
    refImg = uint8(mean(allImg,4));
    refImg = rgb2gray(refImg);
    bmpFileName = strrep(vData.refFile, 'wmv', 'bmp');
    imwrite(refImg,bmpFileName,'bmp');


%To exclude frames where an object is located in the same place across frames, 20260308, Lihui
% vidObj = VideoReader(vData.refFile);
% 
% vidHeight = vidObj.Height;
% vidWidth = vidObj.Width;
% vidFrameRate = vidObj.FrameRate;
% vidDuration = vidObj.Duration;
% totalFrame = round(vidFrameRate * vidDuration);
% 
% % Preallocate movie structure
% slctFNum = max(120, round(totalFrame * 0.01));
% slctFNum=20;
% allImg = zeros(vidHeight, vidWidth, 3, slctFNum, 'uint8');
% mov(1:slctFNum) = ...
%     struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'), ...
%            'colormap', []);
% 
% % Randomly select frames to analyze
% ranf = randi([10 totalFrame], slctFNum, 1);
% 
% % Read frames and store them
% for i = 1:slctFNum
%     k = ranf(i);
%     try
%         % Read the frame
%         mov(i).cdata = read(vidObj, k);
%         allImg(:, :, :, i) = mov(i).cdata;
%     catch
%         % Handle errors (e.g., invalid frame index)
%         disp(['Error processing frame number: ' num2str(k)]);
%     end
% end
% 
% % Convert frames to grayscale for analysis
% grayFrames = zeros(vidHeight, vidWidth, slctFNum, 'uint8');
% for i = 1:slctFNum
%     grayFrames(:, :, i) = rgb2gray(allImg(:, :, :, i));
% end
% 
% % Analyze pixel variance across frames to detect static regions
% varianceMap = std(double(grayFrames), 0, 3); % Compute pixel-wise standard deviation across frames
% 
% % Threshold to identify static regions (low variance indicates static areas)
% threshold = 10; % Adjust this value based on your use case
% threshold2= 120;
% staticRegions = varianceMap < threshold;
% assignin('base','varianceMap',varianceMap);
% assignin('base','grayFrames',grayFrames);
% 
% % Exclude frames with objects in the same location (static regions)
% validFrames = true(1, slctFNum); % Initialize all frames as valid
% for i = 1:slctFNum
%     % Check if the current frame has significant overlap with static regions
%     overlap = sum(sum(staticRegions & (double(grayFrames(:, :, i)) > threshold2))); % Fix size mismatch
%     if overlap > 0.5 * numel(staticRegions) % If significant overlap is detected
%         validFrames(i) = false; % Mark frame as invalid
%     end
% end
% 
% % Use only valid frames to compute the reference image
% filteredFrames = grayFrames(:, :, validFrames);
% if ~isempty(filteredFrames)
%     refImg = uint8(mean(filteredFrames, 3)); % Compute the mean of valid frames
% else
%     disp('No valid frames found. Using all frames for averaging.');
%     refImg = uint8(mean(grayFrames, 3)); % Fallback: average all frames
% end
% 
% % Save the reference image
% bmpFileName = strrep(vData.refFile, 'wmv', 'bmp');
% imwrite(refImg, bmpFileName, 'bmp');

elseif strfind(vData.refFile,'avi')
        vidObj = VideoReader(vData.refFile);

    vidHeight = vidObj.Height;
    vidWidth = vidObj.Width;
    vidFrameRate = vidObj.FrameRate;
    vidDuration = vidObj.Duration;
    totalFrame = vidFrameRate*vidDuration;
    % Preallocate movie structure.
    slctFNum = 20;
    allImg = zeros(vidHeight,vidWidth, 3,slctFNum,'uint8');
    mov(1:slctFNum) = ...
    struct('cdata',zeros(vidHeight,vidWidth, 3,'uint8'),...
           'colormap',[]);
    ranf = randi([10 min(totalFrame,2000)], slctFNum,1);    
    for i = 1:1:slctFNum
        k = ranf(i);
        try
            mov(i).cdata = read(vidObj, k);
            allImg(:,:,:,i) = mov(i).cdata(:,:,:);
        catch
        end
    end
    refImg = uint8(mean(allImg,4));
    refImg = rgb2gray(refImg);
handles.data.matFilename = matFilename;
    bmpFileName = strrep(vData.refFile, 'avi', 'bmp');
    imwrite(refImg,bmpFileName,'bmp');

end

if strfind(vData.refFile,'bmp')
    refImg = uint8(imread(vData.refFile));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
movieFile = vData.refFile; 
[a, b, c] = fileparts(movieFile);
if strcmp(c, '.mp4')
    disp('mp4 file!')
    readerRefObj = VideoReader(movieFile, 'tag', 'REF reader');   
    % Get the number of frames.
    numFrames = get(readerRefObj, 'numberOfFrames');
    maxFrame1 = zeros(readerRefObj.Height, readerRefObj.Width, 3);
    maxFrame2 = zeros(readerRefObj.Height, readerRefObj.Width, 3);
    maxFrame3 = zeros(readerRefObj.Height, readerRefObj.Width, 3);
    maxFrame4 = zeros(readerRefObj.Height, readerRefObj.Width, 3);
    maxFrame5 = zeros(readerRefObj.Height, readerRefObj.Width, 3);        
    initialFrame = read(readerRefObj, 20);   
    for k = 1:5 
        maxFrame = initialFrame; 
        randNum = ceil(rand(1, 8) * 60);
        for i = 1:length(randNum),
            frameNum = randNum(i);
            tmpFrame = read(readerRefObj, frameNum);
            maxFrame = max(maxFrame, tmpFrame);
            %figure; imshow(maxFrame);
        end
        eval(['maxFrame' num2str(k) '=maxFrame;']);
    end  
    finalFrame = zeros(readerRefObj.Height, readerRefObj.Width, 3);
    finalFrame = min(maxFrame1, maxFrame2);
    finalFrame = min(finalFrame, maxFrame3); 
    finalFrame = min(finalFrame, maxFrame4); 
    finalFrame = min(finalFrame, maxFrame5);
    refImg = finalFrame;
    imgSize = size(refImg); 
    imgWidth = imgSize(2); %readerRefObj.Width; 
    imgHeight = imgSize(1); %readerRefObj.Height;
%     handles.RefMean = RefMean;
%     imshow(RefMean,'Parent',handles.axes1); 
% else
%         refImg = imread(movieFile);
%         imgSize = size(RefMean); 
%         imgWidth = imgSize(2); %readerRefObj.Width; 
%         imgHeight = imgSize(1); %readerRefObj.Height;
end
%     bmpFileName = strrep(vData.refFile, 'wmv', 'bmp');
%     imwrite(refImg,bmpFileName,'bmp');     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%output = 'output.mat';
%save(output,'mov');
%return
%refImg = floor(mean(graymov,3));

disp('Please Select Box Range......');
%msgbox('Please Select Possible Mouse Range......');
set(handles.boxRegion_txt,'Visible','on');
axes(handles.axes1);
baseImg = imshow(refImg);

h1 = imrect(gca,[94.0677966101695 1 475.966101694915 416.050847457627]);%imrect
setColor(h1,'k');
boxPos = round(wait(h1));
bwBoxRange = createMask(h1,baseImg);
bwBoxRange = uint8(bwBoxRange);

%%%%%%%%%set LED range
h2 = imrect(gca,[88.2203389830509 58.8135593220338 67 95.1186440677967]);
setColor(h2,'r');
boxPos_LED = round(wait(h2));

if isempty(bwBoxRange)
    disp('ROI selection canceled!');
    return
end

set(handles.boxRegion_txt,'Visible','off');
rSta = boxPos(1,2);
rEnd = boxPos(1,2) + boxPos(1,4) - 1;
cSta = boxPos(1,1);
cEnd = boxPos(1,1) + boxPos(1,3) - 1;
vData.rSta = rSta;
vData.rEnd = rEnd;
vData.cSta = cSta;
vData.cEnd = cEnd;
boxRangeRefImg = refImg(rSta:rEnd,cSta:cEnd);
vData.refImg = refImg;
vData.boxPos = boxPos;
vData.boxPos_LED = boxPos_LED;
vData.bwBoxRange = bwBoxRange;
vData.boxRangeRefImg = boxRangeRefImg;

handles.data = vData;

disp('box range selected!')
guidata(hObject,handles);
handles = guidata(hObject);


% centroids analysis
% mobile analysis
%% Copyright conserved by liyi & Luo Minmin Lab
% Contact liyi@nibs.ac.cn or luominmin@nibs.ac.cn

function time2Read_edit_Callback(hObject, eventdata, handles)
% hObject    handle to time2Read_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time2Read_edit as text
%        str2double(get(hObject,'String')) returns contents of time2Read_edit as a double
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function time2Read_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time2Read_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function perSecondReadFrames_edit_Callback(hObject, eventdata, handles)
% hObject    handle to perSecondReadFrames_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of perSecondReadFrames_edit as text
%        str2double(get(hObject,'String')) returns contents of perSecondReadFrames_edit as a double


% --- Executes during object creation, after setting all properties.
function perSecondReadFrames_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to perSecondReadFrames_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mouseThresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to mouseThresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mouseThresh_edit as text
%        str2double(get(hObject,'String')) returns contents of mouseThresh_edit as a double


% --- Executes during object creation, after setting all properties.
function mouseThresh_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mouseThresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Copyright conserved by liyi & Luo Minmin Lab
% Contact liyi@nibs.ac.cn or luominmin@nibs.ac.cn
% --- Executes on button press in modThresh_pb.
function modThresh_pb_Callback(hObject, eventdata, handles)
% hObject    handle to modThresh_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);

vData = handles.data;
handles.data = vData;
% vidObj = VideoReader(vData.dataFile);
vidObj = VideoReader(vData.refFile);

nFrames = vidObj.NumberOfFrames;
k = randi(nFrames,1,1);
tmpImg = read(vidObj,k);
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
figure;
subplot(2,1,1);imshow(bwrMouse);
%bwOpenMouseRegion = bwareaopen(bwMouse,100);
[currentArea, idx] = max([stats.Area]);
if ~isempty(idx) & currentArea < 3000
    bwMouse = ismember(labelmatrix(CC), idx(1));
    subplot(2,1,2);imshow(bwMouse);
    hold on 
    centroids = stats(idx(1)).Centroid;
    plot(centroids(:,1), centroids(:,2), 'b*');
    % head Position
    headPos = nan(1,2);
    bwrHead = imfill(bwMouse,'holes') - bwMouse;
%     bwHead = bwareaopen(bwrHead,5);
%     cc = bwconncomp(bwHead);
%     l = labelmatrix(cc);
%     statsHead = regionprops(l, 'Area','Centroid');
%     [~, headIdx] = max([statsHead.Area]);
%     if ~isempty(headIdx)
%         headPos = statsHead(headIdx(1)).Centroid;
%     end
    [r c] = find(bwrHead);
    headPos = floor(median([c r]));
    if isnan(headPos)
        headPos = nan(1,2);
    end
    plot(headPos(:,1),headPos(:,2),'rx');
    hold off
end



function ppm_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ppm_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ppm_edit as text
%        str2double(get(hObject,'String')) returns contents of ppm_edit as a double


% --- Executes during object creation, after setting all properties.
function ppm_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ppm_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_trigger_times_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trigger_times (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trigger_times as text
%        str2double(get(hObject,'String')) returns contents of edit_trigger_times as a double


% --- Executes during object creation, after setting all properties.
function edit_trigger_times_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trigger_times (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton_trigger_times.
function pushbutton_trigger_times_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_trigger_times (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.csv';'*.xlsx';},'open file');
if filename == 0
    return;
end
file_path_and_name = [pathname filename];
set(handles.edit_trigger_times,'string',filename);
data1 = get(handles.edit_trigger_times,'string');
xlsRead = str2double(get(handles.edit_xlsRead,'string'));
data = xlsread(data1,xlsRead);

% set(handles.edit_stimulus, 'String', filename);

trigger_times = data;
% assignin('base','trigger_times',trigger_times);
% trigger_times(18:20,:) = [];
handles.trigger_times = trigger_times;
vData.trigger_times_video = trigger_times;
handles.data = vData;
stopT = size(trigger_times,1);
set(handles.edit_stopT,'string',num2str(stopT));




disp('loading trigger_times_led file finished!')

guidata(hObject,handles);
handles = guidata(hObject);



function edit_location_Callback(hObject, eventdata, handles)
% hObject    handle to edit_location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_location as text
%        str2double(get(hObject,'String')) returns contents of edit_location as a double


% --- Executes during object creation, after setting all properties.
function edit_location_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_location.
function pushbutton_location_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
[filename, pathname] = uigetfile({'*.csv';'*.mat';}, 'Open Stimulus file','MultiSelect', 'on');
file_path_and_name = [pathname filename];
if filename == 0
    return;
end
set(handles.edit_location, 'String', filename);

[a, b, c] = fileparts(filename);
if strcmp(c, '.mat')
    Triggers = importdata(file_path_and_name);
    % set(handles.edit_trial_number,'String',num2str(length(Triggers.level))); 
else
    Triggers = csvread(filename, 3, 0);
    assignin('base','Triggers',Triggers);
    disp('loading DLC file finished!')
end
set(handles.edit_location, 'UserData', Triggers);
handles.filename = filename;


guidata(hObject,handles);
handles = guidata(hObject);


% --- Executes on button press in pushbutton_backward_ana2.
function pushbutton_backward_ana2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_backward_ana2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
ppm = str2double(get(handles.ppm_edit,'String'));
LED_thre = str2double(get(handles.LED_thre,'String'));
LED_read = get(handles.radiobutton_LED_read,'value');
startT = str2double(get(handles.edit_startT,'String'));
stopT = str2double(get(handles.edit_stopT,'String'));
deleteT = str2double(get(handles.edit_deleteT,'String'));
handles.ppm = ppm;
vData.ppm = ppm;
handles.vData = vData;
vData = get(handles.edit_location, 'UserData');
assignin('base','vData',vData);
if LED_read
     k  = 1;
%      led_thre = smooth(vData.thre,0.01,'moving');
     led_thre = smooth(vData.thre);
     assignin('base','led_thre',led_thre);
    while k<=length(led_thre)
        %%%set a threshold again
%              if k>5800 && k<6200
%                 readBox_LED(k) = 0;
%             end

%         if k<7500
            if led_thre(k) > LED_thre
                stimOnset(k) = 1;
                else
                stimOnset(k) = 0;
            end
%         end
%         if k>8500 
%             if readBox_LED(k) > 60
%             stimOnset(k) = 1;
%             else
%             stimOnset(k) = 0;
%             end
%         end
        k = k+1;
    end
    %%%find trigger times again
    stimOnsetDiff = diff(stimOnset);
    led_up = find(stimOnsetDiff == 1)+1;
%     trigger_pupil_down = find(stimOnsetDiff == -1)+1;
    assignin('base','stimOnsetDiff',stimOnsetDiff);
    assignin('base','led_up',led_up);
    vData.trigger_times = led_up/10;
else
    trigger_times = handles.trigger_times;
    trigger_times = trigger_times(startT:stopT,:);
    if ~isnan(deleteT)
    trigger_times(deleteT) = [];
    end
    vData.trigger_times = trigger_times;
end

% vData = handles.data;
guidata(hObject,handles);
handles = guidata(hObject);
speedPlot2(vData,handles);

guidata(hObject,handles);
handles = guidata(hObject);


% --- Executes on button press in pushbutton_LED_read.
function pushbutton_LED_read_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_LED_read (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
tic;

disp('LED onset calculating......');
% LED_thre = str2double(get(handles.LED_thre,'String'))
vData = handles.data;
vData.filename = handles.file_path_and_name_cal;
boxPos_LED = vData.boxPos_LED;
vidObj = VideoReader(vData.dataFile);
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
vidFrameRate = vidObj.FrameRate;
vidDuration = vidObj.Duration;
totalFrame = round(vidFrameRate*vidDuration);
% totalFrame = vidObj.NumberOfFrames;
assignin('base','vidObj',vidObj);

time2Read = str2double(get(handles.time2Read_edit,'String'));
if time2Read > 0
    readTime = min(floor(time2Read),vidDuration);
else
    readTime = vidDuration;
end

data_len = length(1:totalFrame);
thre = zeros(data_len,1);
% thre2 = zeros(data_len,1);
disp('using green led as indicator')
k = 1; 
for i = 1:totalFrame 
    tmpImg = read(vidObj,i);
    %%%%%%%%%%%%%%%%%read LED frame
    rSta = boxPos_LED(1,2);
    rEnd = boxPos_LED(1,2) + boxPos_LED(1,4) - 1;
    cSta = boxPos_LED(1,1);
    cEnd = boxPos_LED(1,1) + boxPos_LED(1,3) - 1;
    ledImg = tmpImg;
    assignin('base','ledImg',ledImg);
    r = ledImg(rSta:rEnd,cSta:cEnd,1);
    g = ledImg(rSta:rEnd,cSta:cEnd,2);
    b = ledImg(rSta:rEnd,cSta:cEnd,3);
    % redLight = 1.5*r-g-b;
    %blue led for turning behavior, should keep it consistant; check this line if you change the color of the led
    % redLight = 1.5*b-g-r;
    
    redLight = 1.5*g-b-r;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    thre(i) = sum(any(redLight));
    % thre2(i) = sum(any(redLight));
    if vidObj.CurrentTime >= readTime
        break
    end
    k = k+1;
end
assignin('base','thre',thre);


%% get the led onset timing
LED_thre = str2double(get(handles.LED_thre,'String'))
stimOnset = zeros(length(thre),1);
led_thre = smooth(thre);
% led_thre = thre;
assignin('base','led_thre',led_thre);
figure;
histogram(led_thre,10);     % 30 bins
ylim([0 500])
xlabel('led intensity')
ylabel('Count')
title('Distribution of data')

p  = 1;
while p<=length(led_thre)
        if led_thre(p) > LED_thre
            stimOnset(p) = 1;
        else
            stimOnset(p) = 0;
        end
    p = p+1;
end
%%%find trigger times again
stimOnsetDiff = diff(stimOnset);
led_up = find(stimOnsetDiff == 1);
assignin('base','stimOnset',stimOnset);
trigger_times = led_up;
assignin('base','trigger_times',trigger_times);


% allign_data = zeros(length(trigger_times)+1,2);
% allign_data(2:end,1) = 1:length(trigger_times);
% allign_data(2:end,2) = trigger_times;
% assignin('base','allign_data',allign_data);

%visualize the led intensity of the video; check the threshold and signal to noise ratio
figure;
plot(led_thre);hold on
plot(stimOnset,'r');hold on
ylabel('led intensity')
xlabel('Time (frame)')
%% save data
% csvwrite('trigger_times_led.csv',trigger_times);
csvwrite([vData.filename(1:end-5),' trigger_times_led.csv'],trigger_times);
fprintf('video led mark number is %d\n', length(trigger_times));


vData.trigger_times_video = trigger_times;
vData.stimOnset = stimOnset;
vData.thre = thre;
handles.data = vData;
disp('LED onset calculating finished!');
toc;
guidata(hObject,handles);
handles = guidata(hObject);



function edit_pre_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pre as text
%        str2double(get(hObject,'String')) returns contents of edit_pre as a double


% --- Executes during object creation, after setting all properties.
function edit_pre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_post_Callback(hObject, eventdata, handles)
% hObject    handle to edit_post (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_post as text
%        str2double(get(hObject,'String')) returns contents of edit_post as a double


% --- Executes during object creation, after setting all properties.
function edit_post_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_post (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_line2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_line2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_line2 as text
%        str2double(get(hObject,'String')) returns contents of edit_line2 as a double


% --- Executes during object creation, after setting all properties.
function edit_line2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_line2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_clims_Callback(hObject, eventdata, handles)
% hObject    handle to edit_clims (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_clims as text
%        str2double(get(hObject,'String')) returns contents of edit_clims as a double


% --- Executes during object creation, after setting all properties.
function edit_clims_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_clims (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LED_thre_Callback(hObject, eventdata, handles)
% hObject    handle to LED_thre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LED_thre as text
%        str2double(get(hObject,'String')) returns contents of LED_thre as a double


% --- Executes during object creation, after setting all properties.
function LED_thre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LED_thre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_xlsRead_Callback(hObject, eventdata, handles)
% hObject    handle to edit_xlsRead (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xlsRead as text
%        str2double(get(hObject,'String')) returns contents of edit_xlsRead as a double


% --- Executes during object creation, after setting all properties.
function edit_xlsRead_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xlsRead (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ylim_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ylim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ylim as text
%        str2double(get(hObject,'String')) returns contents of edit_ylim as a double


% --- Executes during object creation, after setting all properties.
function edit_ylim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ylim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_LED_read.
function radiobutton_LED_read_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_LED_read (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_LED_read



function edit_startT_Callback(hObject, eventdata, handles)
% hObject    handle to edit_startT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_startT as text
%        str2double(get(hObject,'String')) returns contents of edit_startT as a double


% --- Executes during object creation, after setting all properties.
function edit_startT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_startT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_stopT_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stopT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stopT as text
%        str2double(get(hObject,'String')) returns contents of edit_stopT as a double


% --- Executes during object creation, after setting all properties.
function edit_stopT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stopT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_deleteT_Callback(hObject, eventdata, handles)
% hObject    handle to edit_deleteT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_deleteT as text
%        str2double(get(hObject,'String')) returns contents of edit_deleteT as a double


% --- Executes during object creation, after setting all properties.
function edit_deleteT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_deleteT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_locomotion_plot.
function pushbutton_locomotion_plot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_locomotion_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
ppm = str2double(get(handles.ppm_edit,'String'));
LED_thre = str2double(get(handles.LED_thre,'String'));
LED_read = get(handles.radiobutton_LED_read,'value');
startT = str2double(get(handles.edit_startT,'String'));
stopT = str2double(get(handles.edit_stopT,'String'));
deleteT = str2double(get(handles.edit_deleteT,'String'));
exampleT = str2double(get(handles.edit_exampleT,'String'));

handles.ppm = ppm;
vData.ppm = ppm;
handles.vData = vData;
vData = get(handles.edit_location, 'UserData');

trigger_times = handles.trigger_times;
trigger_times = trigger_times(startT:stopT,:);
if ~isnan(deleteT)
trigger_times(deleteT) = [];
end
vData.trigger_times = trigger_times;


%%%%%%trigger times
trigger = vData.trigger_times;
trigger_times = trigger(:,2);
n = size(trigger,2);
if n>2
    back_times = trigger(:,3:n)
end

%%
pre_stim = str2double(get(handles.edit_pre,'String'));
post_stim = str2double(get(handles.edit_post,'String'));
xp2 = str2double(get(handles.edit_line2,'String'));
clims = str2num(get(handles.edit_clims,'String'));
y_lim = str2num(get(handles.edit_ylim,'String'));
bin = 1/20;
tn = -pre_stim:bin:post_stim;
length(tn);
n = length(trigger_times);

%%%%%set backward speed into negative speed
backward =[];
back_max = [];
start = trigger_times(exampleT)
xLocation = vData.centroids(round(start-pre_stim/bin):round(start+post_stim/bin)-1,1);
yLocation = vData.centroids(round(start-pre_stim/bin):round(start+post_stim/bin)-1,2);
length_xl = length(xLocation)

figure; 
plot(xLocation(1,1), yLocation(1,1),'*','Color','k','LineWidth',6); hold on;
plot(xLocation, yLocation,'Color','k','LineWidth',2); hold on;
plot(xLocation(pre_stim/bin+1:post_stim/bin,:), yLocation(pre_stim/bin+1:post_stim/bin,:),'Color','b','LineWidth',5); hold on;

    if ~isempty(back_times)
           temp_bt = back_times(exampleT,:);
           temp = find(temp_bt>0);
           temp_bt = temp_bt(temp);
           backN = length(temp_bt)
           for j=1:backN/2
               back_s = back_times(exampleT,2*j-1)-round(start-pre_stim/bin);
               back_e = back_times(exampleT,2*j)-round(start-pre_stim/bin);
%                speed(back_s:back_e,1) = -speed(back_s:back_e,1);
                plot(xLocation(back_s:back_e,:), yLocation(back_s:back_e,:),'Color','r','LineWidth',2); hold on;
           end
    else
        display('there are no backward behavior!')
    end

imgWidth = 640;
imgHeight = 480;
offset = 0;
set(gca, 'xlim', [offset imgWidth-offset], 'YDir', 'reverse');
set(gca, 'ylim', [offset imgHeight-offset], 'YDir', 'reverse');


function edit_exampleT_Callback(hObject, eventdata, handles)
% hObject    handle to edit_exampleT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_exampleT as text
%        str2double(get(hObject,'String')) returns contents of edit_exampleT as a double


% --- Executes during object creation, after setting all properties.
function edit_exampleT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_exampleT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_img_save.
function pushbutton_img_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_img_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
% vData = handles.data;
vData = handles.data;
vidObj = VideoReader(vData.dataFile);
xp2 = str2double(get(handles.edit_line2,'String'));
sFrame = read(vidObj, xp2); 
imshow(sFrame);

handles.data.matFilename;
% bmpFileName = strrep([handles.data.matFilename(1:end-4), num2str(xp2)], '', '.bmp')
bmpFileName = [handles.data.matFilename(1:end-4),' ', num2str(xp2), '.bmp']
imwrite(sFrame,bmpFileName,'bmp');


% --- Executes on button press in pushbutton_turning.
function pushbutton_turning_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_turning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);

ppm = str2double(get(handles.ppm_edit,'String'));
y_lim = str2num(get(handles.edit_ylim,'String'));
xP2 =  str2double(get(handles.edit_line2,'String'));
pre_stim = str2double(get(handles.edit_pre,'String'));
post_stim =  str2double(get(handles.edit_post,'String'));

trial_start = str2double(get(handles.edit_startT,'String'));
trial_stop = str2double(get(handles.edit_stopT,'String'));
deleteT = str2double(get(handles.edit_deleteT,'String'));
exampleT = str2double(get(handles.edit_exampleT,'String'));
clims = str2num(get(handles.edit_clims,'String'));


handles.ppm = ppm;
vData.ppm = ppm;
handles.vData = vData;
vData = get(handles.edit_location, 'UserData');

trigger_times = handles.trigger_times;
trigger_times = trigger_times(trial_start:trial_stop,:);
if ~isnan(deleteT)
    trigger_times(deleteT,:) = [];
end
vData.trigger_times = trigger_times;


%%%%%%trigger times
trigger = vData.trigger_times;
trigger_times = trigger(:,2);
assignin('base','trigger_times',trigger_times);

centroids = vData.centroids;
filename = handles.filename;
cmpp = ppm;  %room 148  45x45 chanmber
% cmpp = 45/354;   %room 151 45x45 chanmber
bin = 1/vData.vidFrameRate;
tn = -pre_stim:bin:post_stim-bin;
n = length(trigger_times);


xLocation = centroids(:,1); 
yLocation = centroids(:,2); 
xdiff = diff(xLocation);
ydiff = diff(yLocation);
travel_distance = sqrt(xdiff.^2 + ydiff.^2);
travel_distance = travel_distance.*cmpp; % travel distance (cm)
% travel_distance = sum(travel_distance)/100;
totalTravel = sum(travel_distance)/100;
assignin('base','travel_distance',travel_distance);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
% roiP = [200,127,241,247];
plot(centroids(:,1), centroids(:,2),'Color','b','LineWidth',0.8); 
imgWidth = 640;
imgHeight = 480;
offset = imgWidth/18;
set(gca, 'xlim', [0 640], 'ylim', [0 480], 'YDir', 'reverse');
title(strrep(filename, '\', '\\'));
% rectangle ('position', roiP, 'linewidth', 2, 'EdgeColor', [1 0 0]);
title([strrep(filename(1:end-4), '\', '\\') '  Distance = ' num2str(totalTravel, 6),'(m)']);
% hold on

% s_all = size(centroids,1);
% origin = mean(centroids);
% angles_all = zeros(s_all-1,1);
% for k = 1:s_all-1
%     A = centroids(k,:) - origin;
%     B = centroids(k+1,:) - origin;
%     angles_all(k) = acos(A*B'/norm(A)/norm(B));
% end
% assignin('base','angles_all',angles_all);

%%%%%%%%%%%%%%%%%
% figure('position',[1 1 1200 500]);
% time = 1:s_all-1;
% plot(time,angles_all);
% % xlim([time(1) time(end)]);
% set(gca,'xTickLabel',0:100:600);
% xlabel('Time (s)');
% ylabel('Angle (rad)');
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
for j = 1:n
    start = round(trigger_times(j));
    baseline = centroids(start-pre_stim/bin:start,:);
    stim = centroids(start:start+xP2/bin,:);
    origin1 = mean(centroids(start:start+xP2/bin,:));
    temp_centroids = centroids(start-pre_stim/bin:start+post_stim/bin,:);
    subplot(4,3,j)
    plot(temp_centroids(:,1), temp_centroids(:,2),'Color','b','LineWidth',0.8); hold on
    plot(baseline(:,1), baseline(:,2),'Color','k','LineWidth',0.8); hold on
    plot(stim(:,1), stim(:,2),'Color','r','LineWidth',0.8); hold on
    plot(origin1(:,1), origin1(:,2),'c*','LineWidth',0.8); hold on
%     set(gca, 'xlim', [0 640], 'ylim', [0 480], 'YDir', 'reverse');

end
im_filename = [filename(1:end-4),' single trial track.png'];
saveas(gcf,im_filename)

%%
speedT = travel_distance/bin/ppm;
speedT = smooth(speedT);
speed = [];
for i = 1:length(trigger_times)
   start = trigger_times(i);
   speed = [speed,speedT(round(start-pre_stim/bin):round(start+post_stim/bin)-1)];
end
speed = speed';
speed_size = size(speed);
speed_mean = mean(speed);
speed_sem = std(speed)/sqrt(speed_size(1)-1);
vData.speed = speed;
vData.speed_mean = speed_mean;
vData.speed_sem = speed_sem;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure; 
% subplot(2,1,2);
for i=1:size(speed,1)
    plot(tn,speed(i,:),'Color',[0.8 0.8 0.8],'LineWidth',0.8);hold on
end
drawErrorLine(tn,speed_mean,speed_sem,'r',0.2);
% set(gca,'yLim',[-18 18]);
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
% set(gca,'yLim',y_lim);
% set(gca,'yTick',min(y_lim):10:max(y_lim),'yTicklabel',min(y_lim):10:max(y_lim));
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
ylabel('Speed (cm/s)','FontSize',25,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);

im_filename = [filename(1:end-4),' speed.png'];
saveas(gcf,im_filename)

%% direction
angles = cell(1,length(trigger_times));

for j = 1:n
    start = round(trigger_times(j));
    temp_centroids = centroids(start-pre_stim/bin-1:start+post_stim/bin-1,:);
    s = size(temp_centroids);
    angles1 = zeros(s(1)-1,1);
    temp = zeros(s(1)-1,4);
    for p = 1:s(1)-1
%         A = temp_centroids(p+1,:)-temp_centroids(p,:);
%         B = temp_centroids(p+2,:)- temp_centroids(p+1,:);
        A = temp_centroids(pre_stim/bin+2,:)-temp_centroids(pre_stim/bin+1,:);
        B = temp_centroids(p+1,:)- temp_centroids(p,:);
        angles1(p) = acos(A*B'/norm(A)/norm(B));
        temp(p,1:2) = A;
        temp(p,3:4) = B;
    end
%     angles1 = smooth(angles1);
    angles{1,j} = angles1;
end
angles = cell2mat(angles)';

%%%%%%%%%%%%%%%%%%%%%%%
% angular_v = abs(angles/bin);    %rad/s
angular_v = angles;
angular_v_size = size(angular_v);
angular_v_mean = mean(angular_v,"omitnan");
angular_v_sem = std(angular_v,"omitnan")/sqrt(angular_v_size(1)-1);
assignin('base','angular_v_mean',angular_v_mean);
vData.angle = angular_v;
vData.angle_mean = angular_v_mean;

figure
for i=1:size(angular_v,1)
    plot(tn,angular_v(i,:),'Color',[0.8 0.8 0.8],'LineWidth',0.8);hold on
end
drawErrorLine(tn,angular_v_mean,angular_v_sem,'k',0.2);
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
set(gca,'xLim',[-pre_stim post_stim]);
set(gca,'xTick',-pre_stim:1:post_stim);
xlabel('Time (s)','FontSize',20,'FontWeight','Bold');
ylabel('Angular (rad)','FontSize',20,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);

im_filename = [filename(1:end-4),' angle.png'];
saveas(gcf,im_filename)



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
angles = cell(1,length(trigger_times));
for j = 1:n
    start = round(trigger_times(j));
    baseline = centroids(start-pre_stim/bin:start,:);
    stim = centroids(start:start+xP2/bin,:);
    origin1 = mean(centroids(start:start+xP2/bin,:));
    temp_centroids = centroids(start-pre_stim/bin:start+post_stim/bin,:);
    s = size(temp_centroids);
    angles1 = zeros(s(1)-1,1);
    for p = 1:s(1)-1
        A = temp_centroids(p,:) - origin1;
        B = temp_centroids(p+1,:) - origin1;
        angles1(p) = acos(A*B'/norm(A)/norm(B));
    end
angles1 = smooth(angles1);

% subplot(4,3,j)
% plot(temp_centroids(:,1), temp_centroids(:,2),'Color','b','LineWidth',0.8); hold on
% plot(baseline(:,1), baseline(:,2),'Color','k','LineWidth',0.8); hold on
% plot(stim(:,1), stim(:,2),'Color','r','LineWidth',0.8); hold on
% plot(origin1(:,1), origin1(:,2),'c*','LineWidth',0.8); hold on
% set(gca, 'xlim', [0 640], 'ylim', [0 480], 'YDir', 'reverse');


angles{1,j} = angles1;
end
angles = cell2mat(angles)';
angles_mean = mean(angles);
assignin('base','angles_mean',angles_mean);
assignin('base','angles',angles);
% max(angles)
% min(angles)

% im_filename = [filename(1:end-4),' single trial.png'];
% saveas(gcf,im_filename)



%% %calculate the whole turning angle
turning_angle1 = [];
for i = 1:size(angles,1)
    turning_angle1 = [turning_angle1,sum(angles(i,pre_stim/bin:(pre_stim+xP2)/bin))];
end
turning_angle = mean(turning_angle1);
assignin('base','turning_angle1',turning_angle1);
assignin('base','turning_angle',turning_angle);

%%%%%%%%%%%%%%%%%%%%%%%
angular_v = abs(angles/bin);    %rad/s
angular_v_size = size(angular_v);
angular_v_mean = mean(angular_v);
angular_v_sem = std(angular_v)/sqrt(angular_v_size(1)-1);
assignin('base','angular_v_mean',angular_v_mean);

%% save data
vData.turning_angle1 = turning_angle1;
vData.totalTravel = totalTravel;
vData.angular_v2 = angular_v;
vData.angular_v_mean2 = angular_v_mean;

assignin('base','vData',vData);
matFilename = [filename(1:end-4),' turning analysis.mat'];
save(matFilename, '-struct', 'vData');


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure; 
% % subplot(2,1,1);
% % plotHeatmap(tn,angular_v,clims);
% % % set(gca,'xTick',-pre_stim:1:post_stim);
% % % set(gca,'xTick',-pre_stim:1:post_stim);
% % % colorbar([0.93 0.60 0.03 0.2],'FontSize',5);
% % % colorbar
% % set(gca,'xTickLabel',-pre_stim:1:post_stim);
% % % set(gca,'xTickLabel',-5:1:8);
% % xlabel('Time (s)','FontSize',12,'FontWeight','Bold');
% % ylabel('Trail #','FontSize',12,'FontWeight','Bold');
% % title(strrep(filename, '\', '\\'));
% title([strrep(filename(1:end-4), '\', '\\') '  Turning Angle = ' num2str(turning_angle, 4),'(rad)']);
% % 
% % 
% % subplot(2,1,2);
% for i=1:size(angular_v,1)
%     plot(tn,angular_v(i,:),'Color',[0.8 0.8 0.8],'LineWidth',0.8);hold on
% end
% drawErrorLine(tn,angular_v_mean,angular_v_sem,'k',0.2);
% set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
% set(gca,'xLim',[-pre_stim post_stim]);
% set(gca,'xTick',-pre_stim:1:post_stim);
% xlabel('Time (s)','FontSize',15,'FontWeight','Bold');
% ylabel('Angular velocity (rad/s)','FontSize',15,'FontWeight','Bold');
% xP = 0;
% line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
% line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
% % save([strrep(filename(1:end-4), '\', '\\') ' turning.mat']);
% disp([strrep(filename(1:end-4), '\', '\\') '  Total Distance = ' num2str(totalTravel, 6),' (m)','  Turning Angle = ' num2str(turning_angle, 6),'(rad)']);
% 
% 
% im_filename = [filename(1:end-4),' angular speed.png'];
% saveas(gcf,im_filename)


% --- Executes on button press in pushbutton_turning_DLC.
function pushbutton_turning_DLC_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_turning_DLC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);

ppm = str2double(get(handles.ppm_edit,'String'));
y_lim = str2num(get(handles.edit_ylim,'String'));
xP2 =  str2double(get(handles.edit_line2,'String'));
pre_stim = str2double(get(handles.edit_pre,'String'));
post_stim =  str2double(get(handles.edit_post,'String'));

trial_start = str2double(get(handles.edit_startT,'String'));
trial_stop = str2double(get(handles.edit_stopT,'String'));
deleteT = str2double(get(handles.edit_deleteT,'String'));
exampleT = str2double(get(handles.edit_exampleT,'String'));
clims = str2num(get(handles.edit_clims,'String'));
left = get(handles.radiobutton_left, 'Value');

handles.ppm = ppm;
vData.ppm = ppm;
handles.vData = vData;
location = get(handles.edit_location, 'UserData');

trigger_times = handles.trigger_times;
trigger_times = trigger_times(trial_start:trial_stop,:);
if ~isnan(deleteT)
    trigger_times(deleteT,:) = [];
end
vData.trigger_times = trigger_times;


%%%%%%trigger times
trigger = vData.trigger_times;
trigger_times = trigger(:,2);
assignin('base','trigger_times',trigger_times);

centroids = location;
%location column 2 3, nose
%column5 6, body center
%column 8 9,tail

filename = handles.filename;
cmpp = ppm;  %room 148  45x45 chanmber
% cmpp = 45/354;   %room 151 45x45 chanmber
vData.vidFrameRate = 20;
bin = 1/vData.vidFrameRate;
tn = -pre_stim:bin:post_stim-bin;
n = length(trigger_times);


xLocation = centroids(:,5); 
yLocation = centroids(:,6); 
xdiff = diff(xLocation);
ydiff = diff(yLocation);
travel_distance = sqrt(xdiff.^2 + ydiff.^2);
travel_distance = travel_distance.*cmpp; % travel distance (cm)
totalTravel = sum(travel_distance)/100;
assignin('base','travel_distance',travel_distance);
vData.totalTravel = totalTravel;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  raw trace
figure;
% roiP = [200,127,241,247];
plot(centroids(:,2), centroids(:,3),'Color','r','LineWidth',0.8); hold on;
plot(centroids(:,5), centroids(:,6),'Color','g','LineWidth',0.8); hold on;
plot(centroids(:,8), centroids(:,9),'Color','b','LineWidth',0.8); hold on;
set(gca, 'xlim', [0 640], 'ylim', [0 480], 'YDir', 'reverse');
set(gca,'FontSize',15,'LineWidth',3,'FontWeight','Bold');
legend('nose','body','tail','')
    xlabel('X (pixel)','FontName','Arial','FontSize',20,'FontWeight','Bold');
    ylabel('Y (pixel)','FontName','Arial','FontSize',20,'FontWeight','Bold');
% title(strrep(filename, '\', '\\'));

% rectangle ('position', roiP, 'linewidth', 2, 'EdgeColor', [1 0 0]);
title([strrep(filename(1:35), '\', '\\') '  Distance = ' num2str(totalTravel, 6),'(m)']);

im_filename = [filename(1:end-4),' all tracks.png'];
saveas(gcf,im_filename)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% single trial track
figure
for j = 1:n
    start = round(trigger_times(j));
    baseline = centroids(start-pre_stim/bin-1:start,5:6);
    stim = centroids(start:start+xP2/bin,5:6);
    origin1 = centroids(start-pre_stim/bin-1,5:6);
    temp_centroids = centroids(start-pre_stim/bin-1:start+post_stim/bin-1,5:6);
    subplot(4,3,j)
    plot(temp_centroids(:,1), temp_centroids(:,2),'Color','b','LineWidth',0.8); hold on
    plot(baseline(:,1), baseline(:,2),'Color','k','LineWidth',0.8); hold on
    plot(stim(:,1), stim(:,2),'Color','r','LineWidth',0.8); hold on
    plot(origin1(:,1), origin1(:,2),'k*','LineWidth',0.8); hold on
%     set(gca, 'xlim', [0 640], 'ylim', [0 480], 'YDir', 'reverse');

end
im_filename = [filename(1:end-4),' single trial track.png'];
saveas(gcf,im_filename)

%% track plot 3D
t = bin:bin:size(centroids,1)/vData.vidFrameRate;
exampleT
figure
% plot3(centroids(:,5),centroids(:,6),t);hold on
for j = exampleT
    start = round(trigger_times(j));
    baseline = centroids(start-pre_stim/bin-1:start,5:6);
    stim = [centroids(start:start+xP2/bin,5:6) t(start:start+xP2/bin)'];
    origin1 = centroids(start-pre_stim/bin-1,5:6);
    temp_centroids = centroids(start-pre_stim/bin-1:start+post_stim/bin-1,5:6);
    plot3(temp_centroids(:,1), temp_centroids(:,2),t(start-pre_stim/bin-1:start+post_stim/bin-1)','Color','b','LineWidth',0.8); hold on
    plot3(baseline(:,1), baseline(:,2),t(start-pre_stim/bin-1:start)','Color','k','LineWidth',0.8); hold on
    plot3(stim(:,1), stim(:,2),stim(:,3),'Color','r','LineWidth',0.8); hold on
%     plot3(origin1(:,1), origin1(:,2),t(start:start+xP2/bin)','k*','LineWidth',0.8); hold on
%     set(gca, 'xlim', [0 640], 'ylim', [0 480], 'YDir', 'reverse');

end
set(gca,'FontSize',15,'LineWidth',3,'FontWeight','Bold');
xlabel('X (pixel)','FontName','Arial','FontSize',20,'FontWeight','Bold');
ylabel('Y (pixel)','FontName','Arial','FontSize',20,'FontWeight','Bold');
zlabel('Time (s)','FontName','Arial','FontSize',20,'FontWeight','Bold');


%% speed
speedT = travel_distance/bin;
% speedT = smooth(speedT);
speed = [];
for i = 1:length(trigger_times)
   start = trigger_times(i);
   speed = [speed,speedT(round(start-pre_stim/bin):round(start+post_stim/bin)-1)];
end
speed = speed';
speed_size = size(speed);
speed_mean = mean(speed);
speed_sem = std(speed)/sqrt(speed_size(1)-1);
vData.speed = speed;
vData.speed_mean = speed_mean;
vData.speed_sem = speed_sem;
assignin('base','speed',speed);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure; 
% subplot(2,1,2);
for i=1:size(speed,1)
    plot(tn,speed(i,:),'Color',[0.8 0.8 0.8],'LineWidth',0.8);hold on
end
drawErrorLine(tn,speed_mean,speed_sem,'r',0.2);
% set(gca,'yLim',[-18 18]);
set(gca,'xLim',[-pre_stim post_stim],'xTick',-pre_stim:1:post_stim);
% set(gca,'yLim',y_lim);
% set(gca,'yTick',min(y_lim):10:max(y_lim),'yTicklabel',min(y_lim):10:max(y_lim));
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
ylabel('Speed (cm/s)','FontSize',25,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);

im_filename = [filename(1:end-4),' speed.png'];
saveas(gcf,im_filename)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure; 
% plotHeatmap(tn,speed,clims);
% set(gca,'xTick',-pre_stim:1:post_stim);
% set(gca,'xTick',-pre_stim:1:post_stim);
% colorbar([0.93 0.60 0.03 0.2],'FontSize',5);
% colorbar
% set(gca,'xTickLabel',-pre_stim:1:post_stim);
% set(gca,'xTickLabel',-5:1:8);
% xlabel('Time (s)','FontSize',12,'FontWeight','Bold');
% ylabel('Trail #','FontSize',12,'FontWeight','Bold');
%% angular speed  %ipsilateral turning
angles = cell(1,length(trigger_times));
direction = cell(1,length(trigger_times));
for j = 1:n
    start = round(trigger_times(j));
    temp_centroids = centroids(start-pre_stim/bin-1:start+post_stim/bin-1,:);
    s = size(temp_centroids);
    angles1 = zeros(s(1)-1,1);
    temp = zeros(s(1)-1,2);
    for p = 1:s(1)-1
        A = temp_centroids(p,2:3)-temp_centroids(p,5:6);
        B = temp_centroids(p+1,2:3)- temp_centroids(p+1,5:6);
%         由每一帧的 质心点→鼻尖点 确定本帧的向量，相邻两帧向量夹角差 【(后帧-前帧)/单位时间(0.05 s)】为一个瞬时角速度点，整个图共180个瞬时角速度点。
%         angle_temp = acos(A*B'/norm(A)/norm(B));
        % Compute dot product and magnitudes
        dot_product = dot(A, B);
        magnitude_product = norm(A) * norm(B);
        
        % Calculate angle in radians
        angle_temp = acos(dot_product / magnitude_product);

        angles1(p) = angle_temp;
        temp(p,1:4) = [temp_centroids(p,2:3), temp_centroids(p,5:6)];
%         temp(p,3:4) = B;
    end
    temp(p+1,1:4) = [temp_centroids(p+1,2:3), temp_centroids(p+1,5:6)];%save the last frame
%     angles1 = smooth(angles1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%define the direction of the angle---------------------
    dir1 = temp(:,1:2)-temp(:,3:4); %nose-body
    dir2 = atan2d(dir1(:,2),dir1(:,1));%Four-quadrant inverse tangent in degrees
    dir2_df = diff(dir2);
    
    if left
        dir2_decrease = find(dir2_df<0);
        angles1(dir2_decrease) = -angles1(dir2_decrease);
        assignin('base','dir2_decrease',dir2_decrease);
    else
        dir2_increase = find(dir2_df>0);
        angles1(dir2_increase) = -angles1(dir2_increase);
        assignin('base','dir2_increase',dir2_increase);
    end
    assignin('base','temp',temp);  
    assignin('base','dir2_df',dir2_df);    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    direction{1,j} = temp;
    angles{1,j} = angles1;
end
angles = cell2mat(angles)';
angles = rad2deg(angles); %the unit is degree




%%%%%%%%%%%%%%%%%%%%%%%
angular_v = angles/bin;    %degree/s
% angular_v = angles;
angular_v_size = size(angular_v);
angular_v_mean = mean(angular_v,"omitnan");
angular_v_sem = std(angular_v,"omitnan")/sqrt(angular_v_size(1)-1);
assignin('base','angular_v_mean',angular_v_mean);
vData.angles = angles;
vData.angular_v = angular_v;
vData.angle_mean = angular_v_mean;
vData.direction = direction;
assignin('base','vData',vData);

figure
for i=1:size(angular_v,1)
    plot(tn,angular_v(i,:),'Color',[0.8 0.8 0.8],'LineWidth',0.8);hold on
end
drawErrorLine(tn,angular_v_mean,angular_v_sem,'k',0.2);
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
set(gca,'xLim',[-pre_stim post_stim]);
set(gca,'xTick',-pre_stim:1:post_stim);
xlabel('Time (s)','FontSize',20,'FontWeight','Bold');
ylabel(['Angular speed (',char(176),'/s)'],'FontSize',20,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);

im_filename = [filename(1:end-4),' angular speed.png'];
saveas(gcf,im_filename)


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% direction
vector = direction{1,exampleT};
% vector = vector(2*vData.vidFrameRate:7*vData.vidFrameRate,:);

figure

p2 = vector(:,1:2);     %nose                   
p1 = vector(:,3:4);       %body                 
dp = p2-p1;                         % Difference
vData.dp = dp;
x1 = 1:length(p1(:,1));
x2 = zeros(length(p1(:,2)),1);
q = quiver(x1',x2,dp(:,1),dp(:,2),0);hold on
q.AutoScale = 'on';
q.AutoScaleFactor = 0.4;
set(gca,'xLim',[0 200]);
set(gca,'xTick',0:20:200);
set(gca,'xTicklabel',-pre_stim:1:post_stim+1);
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
line([60 60],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
line([120 120],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
xlabel('Time (s)','FontSize',20,'FontWeight','Bold');
ylabel('Direction','FontSize',20,'FontWeight','Bold');
title(['Example trial: ',num2str(exampleT)]);

im_filename = [filename(1:end-4),' direction vector plot.png'];
saveas(gcf,im_filename)
%% %calculate the whole turning angle
turning_angle = [];
for i = 1:size(angles,1)
    turning_angle = [turning_angle,sum(angles(i,pre_stim/bin:(pre_stim+xP2)/bin))];
end
vData.turning_angle = turning_angle;



%% direction degree
angles_cum = cumsum(angles,2);
angles_cum_size = size(angles_cum);
angles_cum_mean = mean(angles_cum,"omitnan");
angles_cum_sem = std(angles_cum,"omitnan")/sqrt(angles_cum_size(1)-1);

vData.angles_cum = angles_cum;
vData.angles_cum_mean = angles_cum_mean;

figure
for i=1:size(angles_cum,1)
    plot(tn,angles_cum(i,:),'Color',[0.8 0.8 0.8],'LineWidth',0.8);hold on
end
drawErrorLine(tn,angles_cum_mean,angles_cum_sem,'k',0.2);
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
set(gca,'xLim',[-pre_stim post_stim]);
set(gca,'xTick',-pre_stim:1:post_stim);
xlabel('Time (s)','FontSize',20,'FontWeight','Bold');
ylabel(['Direction (',char(176),')'],'FontSize',20,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);

im_filename = [filename(1:end-4),' direction.png'];
saveas(gcf,im_filename)

%% save data

assignin('base','vData',vData);
matFilename = [filename(1:end-4),' turning analysis.mat'];
save(matFilename, '-struct', 'vData');
set(handles.edit_deleteT,'string',[])


% --- Executes on button press in radiobutton_left.
function radiobutton_left_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_left


% --- Executes on button press in pushbutton_loc_plot3D.
function pushbutton_loc_plot3D_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loc_plot3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
ppm = str2double(get(handles.ppm_edit,'String'));
LED_thre = str2double(get(handles.LED_thre,'String'));
LED_read = get(handles.radiobutton_LED_read,'value');
startT = str2double(get(handles.edit_startT,'String'));
stopT = str2double(get(handles.edit_stopT,'String'));
deleteT = str2double(get(handles.edit_deleteT,'String'));
exampleT = str2double(get(handles.edit_exampleT,'String'));

handles.ppm = ppm;
vData.ppm = ppm;
handles.vData = vData;
vData = get(handles.edit_location, 'UserData');

trigger_times = handles.trigger_times;
trigger_times = trigger_times(startT:stopT,:);
if ~isnan(deleteT)
trigger_times(deleteT) = [];
end
vData.trigger_times = trigger_times;


%%%%%%trigger times
trigger = vData.trigger_times;
trigger_times = trigger(:,2);
n = size(trigger,2);
if n>2
    back_times = trigger(:,3:n)
end

%%
pre_stim = str2double(get(handles.edit_pre,'String'));
post_stim = str2double(get(handles.edit_post,'String'));
xp2 = str2double(get(handles.edit_line2,'String'));
clims = str2num(get(handles.edit_clims,'String'));
y_lim = str2num(get(handles.edit_ylim,'String'));
bin = 1/20;
tn = -pre_stim:bin:post_stim;
length(tn);
n = length(trigger_times);

%%%%%set backward speed into negative speed
backward =[];
back_max = [];
start = trigger_times(exampleT)
xLocation = vData.centroids(round(start-pre_stim/bin):round(start+post_stim/bin)-1,1);
yLocation = vData.centroids(round(start-pre_stim/bin):round(start+post_stim/bin)-1,2);
length_xl = length(xLocation)

figure; 
plot(xLocation(1,1), yLocation(1,1),'*','Color','k','LineWidth',6); hold on;
plot(xLocation, yLocation,'Color','k','LineWidth',2); hold on;
plot(xLocation(pre_stim/bin+1:post_stim/bin,:), yLocation(pre_stim/bin+1:post_stim/bin,:),'Color','b','LineWidth',5); hold on;

    if ~isempty(back_times)
           temp_bt = back_times(exampleT,:);
           temp = find(temp_bt>0);
           temp_bt = temp_bt(temp);
           backN = length(temp_bt)
           for j=1:backN/2
               back_s = back_times(exampleT,2*j-1)-round(start-pre_stim/bin);
               back_e = back_times(exampleT,2*j)-round(start-pre_stim/bin);
%                speed(back_s:back_e,1) = -speed(back_s:back_e,1);
                plot(xLocation(back_s:back_e,:), yLocation(back_s:back_e,:),'Color','r','LineWidth',2); hold on;
           end
    else
        display('there are no backward behavior!')
    end

imgWidth = 640;
imgHeight = 480;
offset = 0;
set(gca, 'xlim', [offset imgWidth-offset], 'YDir', 'reverse');
set(gca, 'ylim', [offset imgHeight-offset], 'YDir', 'reverse');


% --- Executes on button press in pushbutton_turning_gc.
function pushbutton_turning_gc_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_turning_gc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);

vData = handles.data;
ppm = str2double(get(handles.ppm_edit,'String'));
vData.y_lim = str2num(get(handles.edit_ylim,'String'));
xP2 =  str2double(get(handles.edit_line2,'String'));
vData.pre_stim = str2double(get(handles.edit_pre,'String'));
vData.post_stim =  str2double(get(handles.edit_post,'String'));
trial_from = str2double(get(handles.edit_startT,'String'));
vData.trial_stop = str2double(get(handles.edit_stopT,'String'));
deleteT = str2double(get(handles.edit_deleteT,'String'));
exampleT = str2double(get(handles.edit_exampleT,'String'));
vData.clims = str2num(get(handles.edit_clims,'String'));
vData.left = get(handles.radiobutton_left, 'Value');
set(handles.edit_deleteT,'String',[]);

handles.ppm = ppm;
vData.ppm = ppm;
vData.filename = handles.file_path_and_name_cal;
vData.vidFrameRate = 20;
vData.heatmap = 1;
vData.z_score = 1;
length_cal=handles.length_cal;
vData.pre_time = str2double(get(handles.edit_pre,'String'));
vData.post_time = str2double(get(handles.edit_post,'String'));
vData.clims = str2num(get(handles.edit_clims,'String'));
vData.control_time = [-vData.pre_time(1) 0];

vData.current_offset = mean(handles.current_cal(1:100));
fprintf('current_offset is %d\n', vData.current_offset);
interval_cue=0.001;
interval=handles.interval_cal;
vData.interval = interval;
upindex = round((handles.upindex)*interval_cue/interval);
trialnum = handles.trialnum ;
% upindex
trialnumtemp = trialnum;
for i=1:trialnum
    if upindex(i) < round(vData.pre_time/interval)
        upindex(i)=0;
        trialnumtemp = trialnumtemp-1;
    end
end
upindex(upindex==0)=[];
trialnum=trialnumtemp;
for i =1:trialnum
    if upindex(i)+round(vData.post_time/interval)>length_cal
        upindex(i)=0;
        trialnumtemp = trialnumtemp-1;
    end
end
trialnum = trialnumtemp;
upindex(upindex==0)=[];
values = handles.current_cal;
sti1_number = trialnum;
vData.values = values;

trigger1_times_photometry = trigger_times_pretreatment(upindex,trial_from,interval,sti1_number);
vData.trigger1_times_photometry = trigger1_times_photometry;
%% get left turns and right turns for each mouse
csv_file = 1;
%get event start data from the excel which can be double-checked based on the video
if csv_file
    disp('loading left turning csv file')
    [filename,pathname]=uigetfile({'*.csv';'*.xlsx';},'open file');
    if filename == 0
        return;
    end
    vData.trigger_times_video_l = xlsread(filename,1);
    
    disp('loading right turning csv file')
    [filename,pathname]=uigetfile({'*.csv';'*.xlsx';},'open file');
    if filename == 0
        return;
    end
    vData.trigger_times_video_r = xlsread(filename,1);
    
    disp('loading straight csv file')
    [filename,pathname]=uigetfile({'*.csv';'*.xlsx';},'open file');
    if filename == 0
        return;
    end
    vData.trigger_times_video_s = xlsread(filename,1);
else
    %get event start data from the last step
    vData.trigger_times_video_l = vData.movement_start_left;
    vData.trigger_times_video_r = vData.movement_start_right;
    vData.trigger_times_video_s = vData.movement_start_straight;
end


fprintf('\nphotometry mark number is %d\n', length(vData.trigger1_times_photometry));
fprintf('\nvideo led mark number is %d\n', length(vData.trigger_times_video));
if length(vData.trigger1_times_photometry) > length(vData.trigger_times_video)
    disp('did not find all led onset in the video; try adjusting LED_threshold')
elseif length(vData.trigger1_times_photometry) < length(vData.trigger_times_video)
    disp('find more led onset in the video than it actually does; try adjusting LED_threshold')
end

vData.trigger_times_video_l =vData.trigger_times_video_l(vData.trigger_times_video_l>vData.trigger_times_video(1) & vData.trigger_times_video_l<vData.trigger_times_video(end));
vData.trigger_times_video_r =vData.trigger_times_video_r(vData.trigger_times_video_r>vData.trigger_times_video(1) & vData.trigger_times_video_r<vData.trigger_times_video(end));
vData.trigger_times_video_s =vData.trigger_times_video_s(vData.trigger_times_video_s>vData.trigger_times_video(1) & vData.trigger_times_video_s<vData.trigger_times_video(end));

% pick the first ten trials
% turning_num = vData.turning_num;
% if length(vData.trigger_times_video_l) > turning_num 
%     vData.trigger_times_video_l = vData.trigger_times_video_l(1:turning_num);
% end
% if length(vData.trigger_times_video_r) > turning_num 
%     vData.trigger_times_video_r = vData.trigger_times_video_r(1:turning_num);
% end
% if length(vData.trigger_times_video_s) > turning_num 
%     vData.trigger_times_video_s = vData.trigger_times_video_s(1:turning_num);
% end


%synchronize the video and the calcium signal!!!!!!!!important
vData.fpLeft = interp1(vData.trigger_times_video, vData.trigger1_times_photometry, vData.trigger_times_video_l);
vData.fpRight = interp1(vData.trigger_times_video, vData.trigger1_times_photometry, vData.trigger_times_video_r);
vData.fpStraight = interp1(vData.trigger_times_video, vData.trigger1_times_photometry, vData.trigger_times_video_s);
assignin('base','vData',vData);

% figure;
% plot(vData.trigger_times_video,vData.trigger1_times_photometry,'*k');hold on
% plot(vData.trigger_times_video_l,vData.fpLeft,'*r');hold on
% plot(vData.trigger_times_video_r,vData.fpRight,'*c');hold on
% xlabel('video time')
% ylabel('photometry time')

%%
[vData] = plot_turning_events_v1(vData);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[vData] = plot_turning_gc_events_v1(vData);

%save and assign vData
save(strrep(handles.file_path_and_name_cal,'.tdms','analysis.mat'),'vData');
assignin('base','vData',vData);




% --- Executes on button press in pushbutton_halt_gc.
function pushbutton_halt_gc_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_halt_gc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);

vData = handles.data;
ppm = str2double(get(handles.ppm_edit,'String'));
vData.y_lim = str2num(get(handles.edit_ylim,'String'));
xP2 =  str2double(get(handles.edit_line2,'String'));
vData.pre_stim = str2double(get(handles.edit_pre,'String'));
vData.post_stim =  str2double(get(handles.edit_post,'String'));
trial_from = str2double(get(handles.edit_startT,'String'));
vData.trial_stop = str2double(get(handles.edit_stopT,'String'));
deleteT = str2double(get(handles.edit_deleteT,'String'));
exampleT = str2double(get(handles.edit_exampleT,'String'));
vData.clims = str2num(get(handles.edit_clims,'String'));
vData.left = get(handles.radiobutton_left, 'Value');
set(handles.edit_deleteT,'String',[]);

handles.ppm = ppm;
vData.ppm = ppm;
vData.filename = handles.file_path_and_name_cal;
vData.vidFrameRate = 20;
vData.heatmap = 1;
vData.z_score = 1;
length_cal=handles.length_cal;
vData.pre_time = str2double(get(handles.edit_pre,'String'));
vData.post_time = str2double(get(handles.edit_post,'String'));
vData.clims = str2num(get(handles.edit_clims,'String'));
vData.control_time = [-vData.pre_time(1) 0];

vData.current_offset = mean(handles.current_cal(1:100));
fprintf('current_offset is %d\n', vData.current_offset);
interval_cue=0.001;
interval=handles.interval_cal;
vData.interval = interval;
upindex = round((handles.upindex)*interval_cue/interval);
trialnum = handles.trialnum ;
% upindex
trialnumtemp = trialnum;
for i=1:trialnum
    if upindex(i) < round(vData.pre_time/interval)
        upindex(i)=0;
        trialnumtemp = trialnumtemp-1;
    end
end
upindex(upindex==0)=[];
trialnum=trialnumtemp;
for i =1:trialnum
    if upindex(i)+round(vData.post_time/interval)>length_cal
        upindex(i)=0;
        trialnumtemp = trialnumtemp-1;
    end
end
trialnum = trialnumtemp;
upindex(upindex==0)=[];
values = handles.current_cal;
sti1_number = trialnum;
vData.values = values;

trigger1_times_photometry = trigger_times_pretreatment(upindex,trial_from,interval,sti1_number);
vData.trigger1_times_photometry = trigger1_times_photometry;
%% get left turns and right turns for each mouse
csv_file = 1;
%get event start data from the excel which can be double-checked based on the video
if csv_file
    disp('loading halt csv file')
    [filename,pathname]=uigetfile({'*.csv';'*.xlsx';},'open file');
    if filename == 0
        return;
    end
    vData.trigger_times_video_h = xlsread(filename,1);
    

else
    %get event start data from the last step
    vData.trigger_times_video_h = vData.movement_start_halt;
end


fprintf('\nphotometry mark number is %d\n', length(vData.trigger1_times_photometry));
fprintf('\nvideo led mark number is %d\n', length(vData.trigger_times_video));
if length(vData.trigger1_times_photometry) > length(vData.trigger_times_video)
    disp('did not find all led onset in the video; try adjusting LED_threshold')
    % vData.trigger1_times_photometry = vData.trigger1_times_photometry(1:length(vData.trigger_times_video));
elseif length(vData.trigger1_times_photometry) < length(vData.trigger_times_video)
    disp('find more led onset in the video than it actually does; try adjusting LED_threshold')
end

vData.trigger_times_video_h =vData.trigger_times_video_h(vData.trigger_times_video_h>vData.trigger_times_video(1) & vData.trigger_times_video_h<vData.trigger_times_video(end));


%synchronize the video and the calcium signal!!!!!!!!important
vData.fp_halt = interp1(vData.trigger_times_video, vData.trigger1_times_photometry, vData.trigger_times_video_h);

assignin('base','vData',vData);



%%
[vData] = plot_halt_events_v1(vData);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[vData] = plot_halt_gc_events_v2(vData);

%save and assign vData
save(strrep(handles.file_path_and_name_cal,'.tdms','analysis.mat'),'vData');
assignin('base','vData',vData);

% --- Executes on button press in pushbutton_load_gc.
function pushbutton_load_gc_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load_gc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
deleteT = str2double(get(handles.edit_deleteT,'String'))
disp('load cue!')
[filename, pathname] = uigetfile('*.tdms', 'Open cue_data file');
% [filename,pathname]=uigetfile({'*.tdms'},'Open cue_data file','MultiSelect','on');%读取多个mat文件
% handles.file_path_and_name_cue = fullfile(pathname, filename(i));
if isequal(filename,0)
    return;
end
ncue=zeros(1,4);

handles.file_path_and_name_cue = fullfile(pathname, filename);
handles.filenumber=1;
file = TDMS_readTDMSFile(handles.file_path_and_name_cue);
cue=cat(1,file.data{3:end})';
handles.channelnum_cue=size(cue,2);
ncue=[ncue;cue];

ncue=ncue(2:end,:);
handles.length_cue=size(ncue,1);
handles.channelnum_cue=size(ncue,2);
% set(handles.edit_file, 'String', pathname);
% set(handles.pm_cue,'String',num2str((1:1:handles.channelnum_cue)'));
% set(handles.pm_cue,'Value',2);%20171228_yzw

for i=1:handles.channelnum_cue
    eval(['handles.cue',num2str(i),'=','ncue(:,i)',';']);
end
%%%%%%修复下降沿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%cue1 is the cue signal 
disp('cue1 is the cue signal ')
cue=smooth(handles.cue1,10);
cue(cue<1)=0;
cue(cue>=1)=1;
handles.current_cue=cue;
handles.upindex=1+find(diff(handles.current_cue)==1)'-4;
if ~isnan(deleteT)
    handles.upindex(deleteT) = [];

end
% upindex=handles.upindex;
%%%%%%%%%%%%%%%%%%%修复过近的trial存在
interval=0.001;
trialnum = size(handles.upindex);%yzw
trialnum=trialnum(2);
if trialnum>1
    for i=1:trialnum-1
        for j=(i+1):trialnum
            if (handles.upindex(j)-handles.upindex(i))*interval<1
                handles.upindex(j)=0;
            end
        end
    end
    handles.upindex(handles.upindex==0)=[];
end
%%%%%%
trialnum = size(handles.upindex);
handles.trialnum = trialnum(2);
% set(handles.edit_sti1, 'String', num2str(handles.trialnum));
% guidata(hObject, handles);
fprintf('photometry mark number is %d\n', trialnum(2));
upindex=handles.upindex';
assignin('base','upindex',upindex)
%%
disp('load gcamp signal!')
[filename, pathname] = uigetfile('*.tdms', 'Open calcium_data file');
% [filename,pathname]=uigetfile({'*.tdms'},'Open calcium_data file','MultiSelect','on');
if isequal(filename,0)
    return;
end


handles.file_path_and_name_cal = fullfile(pathname, filename);
%     string=char(handles.file_path_and_name_cue(1));
% is_cal_adjust = get(handles.cal_adjust,'value');
% if is_cal_adjust
%     file = evalin('base','file2');%20190605
%     disp('cal is file2');
% else
file = TDMS_readTDMSFile(handles.file_path_and_name_cal);
% end
cal=cat(1,file.data{3:end})';
ncal=zeros(1,size(cal,2));
ncal=[ncal;cal];

% handles.file_path_and_name_cal = fullfile(pathname, filename);
% set(handles.edit_file_cal, 'String', pathname);
handles.edit_file_cal = pathname;
cal=ncal(2:end,:);
handles.channelnum_cal = size(cal,2)-2;
handles.length_cal = size(cal,1);
% set(handles.cal_rate,'Value',2);
% cal_number=get(handles.cal_rate,'Value');
handles.interval_cal=1/50;
% set(handles.pm_cal,'String',num2str((1:1:handles.channelnum_cal)'));
% set(handles.pm_cal,'Value',1);

for i = 1:handles.channelnum_cal
    eval(['handles.cal',num2str(i),'=','cal(:,i+2)',';']);
end
%%%%%%%%%%%%%%%%%%%%%%%%%
% disp('channel3 is the calcium signal ')
% handles.current_cal = handles.cal3;

disp('channel1 is the calcium signal ')
handles.current_cal = handles.cal1;

%20260331 new data
handles.current_cal = handles.cal1;
handles.current_cal_num = 1;
assignin('base','handles',handles);
disp('loading finished!')


guidata(hObject, handles);
handles = guidata(hObject);


% --- Executes on button press in pushbutton_drawAll.
function pushbutton_drawAll_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_drawAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% interval = 1/str2num(get(handles.TB_SampleRate,'String'));
interval=0.001;
color=['r','g','b','c','m','y','k'];
if isfield(handles,'channelnum_cue')
    figure;
    t=interval*(1:1:handles.length_cue);
    for i=1:handles.channelnum_cue
        eval(['plot(t,handles.cue',num2str(i),'+(handles.channelnum_cue-i)*1.1',',''',color(i),'''',');']);
        hold on;
    end
    xlabel('Time (s)');
end
if isfield(handles,'channelnum_cal')
    figure;
    interval_cal=handles.interval_cal;
    t=interval_cal*(1:1:handles.length_cal);
    for i=1:handles.channelnum_cal
        eval(['plot(t,handles.cal',num2str(i),',''',color(i),'''',');']);
        hold on;
    end
    xlabel('Time (s)');
end


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
handles = guidata(hObject);
vData.filename = handles.file_path_and_name_cal;
vData = handles.data;
thre = vData.thre;
%% get the led onset timing
LED_thre = str2double(get(handles.LED_thre,'String'))
stimOnset = zeros(length(thre),1);
led_thre = smooth(thre);
% led_thre = thre;
assignin('base','led_thre',led_thre);
figure;
histogram(led_thre,10);     % 30 bins
ylim([0 500])
xlabel('led intensity')
ylabel('Count')
title('Distribution of data')

p  = 1;
while p<=length(led_thre)
        if led_thre(p) > LED_thre
            stimOnset(p) = 1;
        else
            stimOnset(p) = 0;
        end
    p = p+1;
end
%%%find trigger times again
stimOnsetDiff = diff(stimOnset);
led_up = find(stimOnsetDiff == 1);
assignin('base','stimOnset',stimOnset);

disp('only pick up those triggers that have a larger interval')
interval_thre = 1500;
fprintf('interval_thre is %d\n', interval_thre);
assignin('base','led_up',led_up);
temp = find(diff(led_up)>interval_thre);
trigger_times = [led_up(1);led_up(temp+1)];
assignin('base','trigger_times',trigger_times);


% allign_data = zeros(length(trigger_times)+1,2);
% allign_data(2:end,1) = 1:length(trigger_times);
% allign_data(2:end,2) = trigger_times;
% assignin('base','allign_data',allign_data);

%visualize the led intensity of the video; check the threshold and signal to noise ratio
figure;
plot(led_thre);hold on
plot(stimOnset,'r');hold on
ylabel('led intensity')
xlabel('Time (frame)')
%% save data
% csvwrite('trigger_times_led.csv',trigger_times);
csvwrite([vData.filename(1:end-5),' trigger_times_led.csv'],trigger_times);
fprintf('video led mark number \n(based on the adjusted led_threshold) is %d\n', length(trigger_times));

vData.trigger_times_video = trigger_times;
vData.stimOnset = stimOnset;
vData.thre = thre;
handles.data = vData;

guidata(hObject,handles);
handles = guidata(hObject);


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
tic
vData = handles.data;
vData = get(handles.edit_location, 'UserData');
% vData = handles.data;
assignin('base','vData',vData);

ppm = str2double(get(handles.ppm_edit,'String'));
vData.y_lim = str2num(get(handles.edit_ylim,'String'));
xP2 =  str2double(get(handles.edit_line2,'String'));
vData.pre_stim = str2double(get(handles.edit_pre,'String'));
vData.post_stim =  str2double(get(handles.edit_post,'String'));
trial_start = str2double(get(handles.edit_startT,'String'));
vData.trial_stop = str2double(get(handles.edit_stopT,'String'));
deleteT = str2double(get(handles.edit_deleteT,'String'));
exampleT = str2double(get(handles.edit_exampleT,'String'));
left = get(handles.radiobutton_left, 'Value');
location = get(handles.edit_location, 'UserData');
assignin('base','location',location);


%%%%%%turning numbers to be analyzed. 
vData.turning_num = 15;
%%%%%%%%%%%%%%%%%%%%%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

handles.ppm = ppm;
vData.ppm = ppm;
vData.filename = handles.file_path_and_name_cal;
vData.vidFrameRate = 20;
vData.left = left;
vData.heatmap = 1;



%% get left turns and right turns for each mouse
disp('searching for turning events...be patient!')
[vData] = get_halt_events_v1(vData);


assignin('base','vData',vData);
trigger_times_videoH = vData.movement_start_halt;

%% save data
% csvwrite('trigger_times_video_H.csv',trigger_times_videoH);
csvwrite([handles.file_path_and_name_cal(1:end-5),' trigger_times_video_H.csv'],trigger_times_videoH);

save(strrep(handles.file_path_and_name_cal,'.tdms','analysis.mat'),'vData');

handles.data = vData;
disp('halt events searching finished!');
toc
guidata(hObject,handles);
handles = guidata(hObject);

% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
tic
vData = handles.data;
ppm = str2double(get(handles.ppm_edit,'String'));
vData.y_lim = str2num(get(handles.edit_ylim,'String'));
xP2 =  str2double(get(handles.edit_line2,'String'));
vData.pre_stim = str2double(get(handles.edit_pre,'String'));
vData.post_stim =  str2double(get(handles.edit_post,'String'));
trial_start = str2double(get(handles.edit_startT,'String'));
vData.trial_stop = str2double(get(handles.edit_stopT,'String'));
deleteT = str2double(get(handles.edit_deleteT,'String'));
exampleT = str2double(get(handles.edit_exampleT,'String'));
left = get(handles.radiobutton_left, 'Value');
location = get(handles.edit_location, 'UserData');
assignin('base','location',location);
%%%%%%turning numbers to be analyzed. 
vData.turning_num = 13;
vData.peak_angular_vel_thre = 30; %if nothing output, that means this threshold is too high
fprintf('peak_angular_velocity_threshold is %d\n', vData.peak_angular_vel_thre);
%%%%%%%%%%%%%%%%%%%%%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

handles.ppm = ppm;
vData.ppm = ppm;
vData.filename = handles.file_path_and_name_cal;
vData.vidFrameRate = 20;
vData.left = left;
vData.heatmap = 1;



%% get left turns and right turns for each mouse
disp('searching for turning events...be patient!')
[vData] = get_turning_events_v2(location,vData);




% [vData] = plot_turning_events_v1(vData);

assignin('base','vData',vData);
trigger_times_videoL = vData.movement_start_left;
trigger_times_videoR = vData.movement_start_right;
trigger_times_videoS = vData.movement_start_straight;
%% save data
csvwrite('trigger_times_video_L.csv',trigger_times_videoL);
csvwrite('trigger_times_video_R.csv',trigger_times_videoR);
csvwrite('trigger_times_video_S.csv',trigger_times_videoS);

save(strrep(handles.file_path_and_name_cal,'.tdms','analysis.mat'),'vData');

handles.data = vData;
disp('turning events searching finished!');
toc
guidata(hObject,handles);
handles = guidata(hObject);


% --- Executes on button press in pushbutton_turning_gc_example.
function pushbutton_turning_gc_example_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_turning_gc_example (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
tic

vData = handles.data;
vData.vidFrameRate = 20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%you can change this parameter for the example plotting
vData.example_start = [800 900]*vData.vidFrameRate;%frame, time in video dataset


ppm = str2double(get(handles.ppm_edit,'String'));
vData.y_lim = str2num(get(handles.edit_ylim,'String'));
xP2 =  str2double(get(handles.edit_line2,'String'));
vData.pre_stim = str2double(get(handles.edit_pre,'String'));
vData.post_stim =  str2double(get(handles.edit_post,'String'));
trial_start = str2double(get(handles.edit_startT,'String'));
vData.trial_stop = str2double(get(handles.edit_stopT,'String'));
deleteT = str2double(get(handles.edit_deleteT,'String'));
exampleT = str2double(get(handles.edit_exampleT,'String'));
left = get(handles.radiobutton_left, 'Value');
location = get(handles.edit_location, 'UserData');

%%%%%%turning numbers to be analyzed. 
vData.turning_num = 500;
vData.peak_angular_vel_thre = 100; %if nothing output, that means this threshold is too high
fprintf('peak_angular_velocity_threshold is %d\n', vData.peak_angular_vel_thre);
%%%%%%%%%%%%%%%%%%%%%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

handles.ppm = ppm;
vData.ppm = ppm;
vData.filename = handles.file_path_and_name_cal;

vData.left = left;
vData.heatmap = 1;
z_score = 1;
length_cal= handles.length_cal;
pre_time = str2double(get(handles.edit_pre,'String'));
post_time = str2double(get(handles.edit_post,'String'));
vData.clims = str2num(get(handles.edit_clims,'String'));
control_time = [-pre_time(1) -0.5];
trial_from = 1;
current_offset = mean(handles.current_cal(1:100));
interval_cue = 0.001;
interval = handles.interval_cal;
vData.interval = interval;



%% fet cue times in photometry dataset
upindex = round((handles.upindex)*interval_cue/interval);
trialnum = handles.trialnum ;
% upindex
trialnumtemp = trialnum;
for i=1:trialnum
    if upindex(i) < round(pre_time/interval)
        upindex(i)=0;
        trialnumtemp = trialnumtemp-1;
    end
end
upindex(upindex==0)=[];
trialnum=trialnumtemp;
for i =1:trialnum
    if upindex(i)+round(post_time/interval)>length_cal
        upindex(i)=0;
        trialnumtemp = trialnumtemp-1;
    end
end
trialnum = trialnumtemp;
upindex(upindex==0)=[];
values_gc = handles.current_cal;%gc signal
sti1_number = trialnum;

trigger1_times_photometry = trigger_times_pretreatment(upindex,trial_from,interval,sti1_number);
vData.trigger1_times_photometry = trigger1_times_photometry; %the unit is second



%%   Detailed explanation goes here
centroids = location;
%location column 2 3, nose
%column5 6, body center
%column 8 9,tail

filename = vData.filename;
cmpp = vData.ppm;  %room 148  45x45 chanmber
bin = 1/vData.vidFrameRate;
tn = -vData.pre_stim:bin:vData.post_stim;


%% angular speed  %ipsilateral turning
temp_centroids = centroids;
s = size(temp_centroids);
angles1 = zeros(s(1)-1,1);
temp = zeros(s(1)-1,2);
for p = 1:s(1)-1
    A = temp_centroids(p,2:3)-temp_centroids(p,8:9);
    B = temp_centroids(p+1,2:3)- temp_centroids(p+1,8:9);
%         由每一帧的 质心点→鼻尖点 确定本帧的向量，相邻两帧向量夹角差 【(后帧-前帧)/单位时间(0.05 s)】为一个瞬时角速度点，整个图共180个瞬时角速度点。
%         angle_temp = acos(A*B'/norm(A)/norm(B));
    % Compute dot product and magnitudes
    dot_product = dot(A, B);
    magnitude_product = norm(A) * norm(B);
    % Calculate angle in radians
    angle_temp = acos(dot_product / magnitude_product);
    angles1(p) = angle_temp;
    temp(p,1:4) = [temp_centroids(p,2:3), temp_centroids(p,8:9)];
end
temp(p+1,1:4) = [temp_centroids(p+1,2:3), temp_centroids(p+1,8:9)];%save the last frame
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%define the direction of the angle---------------------
dir1 = temp(:,1:2)-temp(:,3:4); %nose-body
dir2 = atan2d(dir1(:,2),dir1(:,1));%Four-quadrant inverse tangent in degrees
dir2_df = diff(dir2);

if vData.left
    dir2_decrease = find(dir2_df<0);
    angles1(dir2_decrease) = -angles1(dir2_decrease);
    assignin('base','dir2_decrease',dir2_decrease);
else
    dir2_increase = find(dir2_df>0);
    angles1(dir2_increase) = -angles1(dir2_increase);
    assignin('base','dir2_increase',dir2_increase);
end
assignin('base','temp',temp);  
assignin('base','dir2_df',dir2_df);    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angles = angles1;
angles = rad2deg(angles); %the unit is degree
angular_v = angles/bin;    %degree/s
vData.dir2_df = dir2_df;
vData.angular_v = angular_v;
vData.angles = angles;

figure;
plot(1:length(angular_v),angular_v);hold on
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
set(gca,'xLim',[1 length(angular_v)],'yLim',[-500 500]);
set(gca,'xTick',0:100/bin:length(angular_v),'xTicklabel',0:100:length(angular_v)*bin);
xlabel('Time (s)','FontSize',20,'FontWeight','Bold');
ylabel(['Angular velocity (',char(176),'/s)'],'FontSize',20,'FontWeight','Bold');
% im_filename = [strrep(vData.filename,'.tdms',''),' angular velocity.png'];
% saveas(gcf,im_filename)

figure;
plot(1:length(values_gc),values_gc)
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
set(gca,'xLim',[1 length(values_gc)]);
set(gca,'xTick',0:100/interval:length(values_gc),'xTicklabel',0:100:length(values_gc)*interval);
xlabel('Time (s)','FontSize',20,'FontWeight','Bold');
ylabel(['Gcamp sginal'],'FontSize',20,'FontWeight','Bold');


%%
a = floor((vData.trigger_times_video(end)-vData.trigger_times_video(1))/(100/bin));
b = vData.trigger_times_video(1):100/bin:vData.trigger_times_video(end);
for i=1:a-1
    vData.example_start = [b(i) b(i+1)];
    %% %synchronize the video and the calcium signal!!!!!!!!important!!!  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf('photometry mark number is %d\n', length(vData.trigger1_times_photometry));
    fprintf('video led mark number is %d\n', length(vData.trigger_times_video));
    if length(vData.trigger1_times_photometry) > length(vData.trigger_times_video)
        disp('did not find all led onset in the video; try adjusting LED_threshold')
    elseif length(vData.trigger1_times_photometry) < length(vData.trigger_times_video)
        disp('find more led onset in the video than it actually does; try adjusting LED_threshold')
    end
    
    vData.example_start_fp = interp1(vData.trigger_times_video, vData.trigger1_times_photometry, vData.example_start);
    assignin('base','vData',vData);
    
    % figure;
    % plot(vData.trigger_times_video,vData.trigger1_times_photometry,'*k');hold on
    % plot(vData.example_start,vData.example_start_fp,'*r');hold on
    % % plot(vData.trigger_times_video_r,vData.fpRight,'*c');hold on
    % xlabel('video time')
    % ylabel('photometry time')
    %%
    gc_example = values_gc(round(vData.example_start_fp(1)/interval):round(vData.example_start_fp(2)/interval));
    gc_example_z = (gc_example-mean(gc_example))/std(gc_example);
    % gc_example_z = resample(gc_example_z,1/bin,1/interval);
    angular_example = angular_v(vData.example_start(1):vData.example_start(2));
    
    
    % Sampling frequencies (Hz)
    fs1 = 1/bin;   % replace with angular_example sampling frequency
    fs2 = 1/interval;    % replace with gc_example_z sampling frequency
    
    % Time vectors
    t1 = (0:length(angular_example)-1) / fs1;
    t2 = (0:length(gc_example_z)-1)    / fs2;
    
    figure;
    set(gcf,'position',[50 50 1500,500])
    % Plot angular_example on left y-axis (blue)
    yyaxis left
    plot(t1, angular_example, 'b-', 'LineWidth', 1.2);
    set(gca,'yLim',[-500 500]);
    set(gca,'xLim',[t1(1) t1(end)]);
    xlabel('Time (s)','FontSize',20,'FontWeight','Bold');
    ylabel(['Angular velocity (',char(176),'/s)'],'FontSize',20,'FontWeight','Bold');
    ax = gca;
    ax.YColor = 'b';   % set left y-axis color to blue
    
    % Plot gc_example_z on right y-axis (red)
    yyaxis right
    plot(t2, gc_example_z, 'r-', 'LineWidth', 1.2);
    set(gca,'yLim',[-8 6]);
    ylabel(['Z-score'],'FontSize',20,'FontWeight','Bold');
    ax.YColor = 'r';   % set right y-axis color to red
    
    set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
    
    [filepath, name, ext] = fileparts(vData.filename);
    filename = [name ext];   % gives 'trial01.mat'
    title(filename);
    % legend({'Angular Example','GC Example Z'});
    % grid on;
    im_filename = [strrep(vData.filename,'.tdms',''),' angular velocity and gcamp example trace.png'];
    saveas(gcf,im_filename)

end


% --- Executes on button press in pushbutton_feacondition.
function pushbutton_feacondition_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_feacondition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
ppm = str2double(get(handles.ppm_edit,'String'));
LED_thre = str2double(get(handles.LED_thre,'String'));
LED_read = get(handles.radiobutton_LED_read,'value');
trial_from = str2double(get(handles.edit_startT,'String'));
stopT = str2double(get(handles.edit_stopT,'String'));
deleteT = str2double(get(handles.edit_deleteT,'String'));
handles.ppm = ppm;

vData = handles.data;
vData.ppm = ppm;
handles.vData = vData;
vData.location = get(handles.edit_location, 'UserData');

assignin('base','vData',vData);



vData.filename = handles.file_path_and_name_cal;
vData.vidFrameRate = 20;
vData.heatmap = 1;
vData.z_score = 1;
length_cal=handles.length_cal;
vData.pre_time = str2double(get(handles.edit_pre,'String'));
vData.post_time = str2double(get(handles.edit_post,'String'));
vData.clims = str2num(get(handles.edit_clims,'String'));
vData.control_time = [-vData.pre_time(1) 0];

vData.current_offset = mean(handles.current_cal(1:100));
fprintf('current_offset is %d\n', vData.current_offset);
interval_cue=0.001;
interval=handles.interval_cal;
vData.interval = interval;
upindex = round((handles.upindex)*interval_cue/interval);
trialnum = handles.trialnum ;
% upindex
trialnumtemp = trialnum;
for i=1:trialnum
    if upindex(i) < round(vData.pre_time/interval)
        upindex(i)=0;
        trialnumtemp = trialnumtemp-1;
    end
end
upindex(upindex==0)=[];
trialnum=trialnumtemp;
for i =1:trialnum
    if upindex(i)+round(vData.post_time/interval)>length_cal
        upindex(i)=0;
        trialnumtemp = trialnumtemp-1;
    end
end
trialnum = trialnumtemp;
upindex(upindex==0)=[];
values = handles.current_cal;
sti1_number = trialnum;
vData.values = values;

trigger1_times_photometry = trigger_times_pretreatment(upindex,trial_from,interval,sti1_number);
vData.trigger1_times_photometry = trigger1_times_photometry;

vData.matFilename = strrep(handles.file_path_and_name_cal,'.tdms','analysis.mat');
%% plot velocity
vData = speedPlot4(vData,handles);

%% plot gcamp signal
[vData] = plot_halt_gc_events_v1(vData);

%save and assign vData
save(strrep(handles.file_path_and_name_cal,'.tdms','analysis.mat'),'vData');
assignin('base','vData',vData);




guidata(hObject,handles);
handles = guidata(hObject);


% --- Executes on button press in pushbutton_gc_plot.
function pushbutton_gc_plot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gc_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
handles = guidata(hObject);
ppm = str2double(get(handles.ppm_edit,'String'));
LED_thre = str2double(get(handles.LED_thre,'String'));
LED_read = get(handles.radiobutton_LED_read,'value');
trial_from = str2double(get(handles.edit_startT,'String'));
stopT = str2double(get(handles.edit_stopT,'String'));
deleteT = str2double(get(handles.edit_deleteT,'String'))
handles.ppm = ppm;
vData.ppm = ppm;
handles.vData = vData;
% vData = get(handles.edit_location, 'UserData');
% vData = handles.data;
assignin('base','vData',vData);



vData.filename = handles.file_path_and_name_cal;
vData.vidFrameRate = 20;
vData.heatmap = 1;
vData.z_score = 1;
length_cal=handles.length_cal;
vData.pre_time = str2double(get(handles.edit_pre,'String'));
vData.post_time = str2double(get(handles.edit_post,'String'));
vData.clims = str2num(get(handles.edit_clims,'String'));
vData.control_time = [-vData.pre_time(1) 0];

vData.current_offset = mean(handles.current_cal(1:100));
fprintf('current_offset is %d\n', vData.current_offset);
interval_cue=0.001;
interval=handles.interval_cal;
vData.interval = interval;
upindex = round((handles.upindex)*interval_cue/interval);
trialnum = handles.trialnum ;
% upindex
trialnumtemp = trialnum;
for i=1:trialnum
    if upindex(i) < round(vData.pre_time/interval)
        upindex(i)=0;
        trialnumtemp = trialnumtemp-1;
    end
end
upindex(upindex==0)=[];
trialnum=trialnumtemp;
for i =1:trialnum
    if upindex(i)+round(vData.post_time/interval)>length_cal
        upindex(i)=0;
        trialnumtemp = trialnumtemp-1;
    end
end
trialnum = trialnumtemp;
upindex(upindex==0)=[];
values = handles.current_cal;
sti1_number = trialnum;
vData.values = values;

trigger1_times_photometry = trigger_times_pretreatment(upindex,trial_from,interval,sti1_number);
if ~isnan(deleteT)
    trigger1_times_photometry(deleteT) = [];
end
vData.trigger1_times_photometry = trigger1_times_photometry;

% %% plot velocity
% vData = speedPlot4(vData,handles);

%% plot gcamp signal
[vData] = plot_halt_gc_events_v1(vData);

%save and assign vData
save(strrep(handles.file_path_and_name_cal,'.tdms','analysis.mat'),'vData');
assignin('base','vData',vData);




guidata(hObject,handles);
handles = guidata(hObject);
