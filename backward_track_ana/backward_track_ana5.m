function varargout = backward_track_ana5(varargin)
% using readFrame
% get headPos for fiber implanted mice
% OK 20151123
% modified 20161126
% modified and tested 20170413 by lu lihui
%read LED 20180420 by lu lihui
%read backward frames 20180823 by lu lihui

% Contact liyi@nibs.ac.cn or lulihui@nibs.ac.cn or luominmin@nibs.ac.cn
% BACKWARD_TRACK_ANA5 MATLAB code for backward_track_ana5.fig
%      BACKWARD_TRACK_ANA5, by itself, creates a new BACKWARD_TRACK_ANA5 or raises the existing
%      singleton*.
%
%      H = BACKWARD_TRACK_ANA5 returns the handle to a new BACKWARD_TRACK_ANA5 or the handle to
%      the existing singleton*.
%
%      BACKWARD_TRACK_ANA5('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BACKWARD_TRACK_ANA5.M with the given input arguments.
%
%      BACKWARD_TRACK_ANA5('Property','Value',...) creates a new BACKWARD_TRACK_ANA5 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before backward_track_ana5_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to backward_track_ana5_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help backward_track_ana5

% Last Modified by GUIDE v2.5 27-Jul-2025 20:29:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @backward_track_ana5_OpeningFcn, ...
                   'gui_OutputFcn',  @backward_track_ana5_OutputFcn, ...
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


% --- Executes just before backward_track_ana5 is made visible.
function backward_track_ana5_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to backward_track_ana5 (see VARARGIN)

% Choose default command line output for backward_track_ana5
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes backward_track_ana5 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = backward_track_ana5_OutputFcn(hObject, eventdata, handles) 
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
filename = uigetfile({'*.bmp';'*.wmv';'*.avi';'*.mp4';}, 'Pick AVI files for REF image and data analysis','MultiSelect', 'on');

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
    
    if strcmp(c, '.bmp'),
%         readerRefObj = VideoReader(movieFile, 'tag', 'REF reader');   
        refImg = imread(movieFile);   
%         axes(handles.axes1);
        h=figure;
        baseImg = imshow(refImg);
        h1 = imrect(gca,round([1469 468 210 70]));
        setColor(h1,'k');
        boxPos = round(wait(h1));
        bwBoxRange = createMask(h1,baseImg);
        bwBoxRange = uint8(bwBoxRange);
        roi_img = refImg(boxPos(2):boxPos(2)+boxPos(4),boxPos(1):boxPos(1)+boxPos(3));
        
        bmpFileName = [handles.data.matFilename(1:end-4), ' roi.bmp']
        imwrite(roi_img,bmpFileName,'bmp');
        close(h);
    end
    
%     getRefImg(hObject, eventdata, handles);
end





%%get reference image and show out;
%% Copyright conserved by liyi & Luo Minmin Lab
% Contact liyi@nibs.ac.cn or luominmin@nibs.ac.cn
function getRefImg(hObject, eventdata, handles)

guidata(hObject,handles);
handles = guidata(hObject);

vData = handles.data;

% if strfind(vData.refFile,'wmv')
%     vidObj = VideoReader(vData.refFile);
% 
%     vidHeight = vidObj.Height;
%     vidWidth = vidObj.Width;
%     vidFrameRate = vidObj.FrameRate;
%     vidDuration = vidObj.Duration;
%     totalFrame = vidFrameRate*vidDuration;
%     % Preallocate movie structure.
%     slctFNum = 20;
%     allImg = zeros(vidHeight,vidWidth, 3,slctFNum,'uint8');
%     mov(1:slctFNum) = ...
%     struct('cdata',zeros(vidHeight,vidWidth, 3,'uint8'),...
%            'colormap',[]);
%     ranf = randi([10 min(totalFrame,2000)], slctFNum,1);    
%     for i = 1:1:slctFNum
%         k = ranf(i);
%         try
%             mov(i).cdata = read(vidObj, k);
%             allImg(:,:,:,i) = mov(i).cdata(:,:,:);
%         catch
%         end
%     end
%     refImg = uint8(mean(allImg,4));
%     refImg = rgb2gray(refImg);
%     bmpFileName = strrep(vData.refFile, 'wmv', 'bmp');
%     imwrite(refImg,bmpFileName,'bmp');
% elseif strfind(vData.refFile,'avi')
%         vidObj = VideoReader(vData.refFile);
% 
%     vidHeight = vidObj.Height;
%     vidWidth = vidObj.Width;
%     vidFrameRate = vidObj.FrameRate;
%     vidDuration = vidObj.Duration;
%     totalFrame = vidFrameRate*vidDuration;
%     % Preallocate movie structure.
%     slctFNum = 20;
%     allImg = zeros(vidHeight,vidWidth, 3,slctFNum,'uint8');
%     mov(1:slctFNum) = ...
%     struct('cdata',zeros(vidHeight,vidWidth, 3,'uint8'),...
%            'colormap',[]);
%     ranf = randi([10 min(totalFrame,2000)], slctFNum,1);    
%     for i = 1:1:slctFNum
%         k = ranf(i);
%         try
%             mov(i).cdata = read(vidObj, k);
%             allImg(:,:,:,i) = mov(i).cdata(:,:,:);
%         catch
%         end
%     end
%     refImg = uint8(mean(allImg,4));
%     refImg = rgb2gray(refImg);
% handles.data.matFilename = matFilename;
%     bmpFileName = strrep(vData.refFile, 'avi', 'bmp');
%     imwrite(refImg,bmpFileName,'bmp');
%     
% end
% 
% if strfind(vData.refFile,'bmp')
%     refImg = uint8(imread(vData.refFile));
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
movieFile = vData.refFile; 
[a, b, c] = fileparts(movieFile);
if strcmp(c, '.MP4'),
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
h1 = imrect(gca,[10.5263157894736 1.78947368421052 598.105263157895 473.052631578947]);
setColor(h1,'k');
boxPos = round(wait(h1));
bwBoxRange = createMask(h1,baseImg);
bwBoxRange = uint8(bwBoxRange);

%%%%%%%%%set LED range
h2 = imrect(gca,[495.578947368421 330.210526315789 67.578947368421 68.8421052631579]);
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
[filename,pathname]=uigetfile('*.xlsx','*.csv','open file');
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
vData.trigger_times = trigger_times;
handles.data = vData;
stopT = size(trigger_times,1);
set(handles.edit_stopT,'string',num2str(stopT));
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
[filename, pathname] = uigetfile('*.mat', 'Open Stimulus file');
file_path_and_name = [pathname filename];
if filename == 0
    return;
end
set(handles.edit_location, 'String', filename);
Triggers = importdata(file_path_and_name);
% set(handles.edit_trial_number,'String',num2str(length(Triggers.level)));   
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
disp('LED times calculating......');
LED_thre = str2double(get(handles.LED_thre,'String'));
% trigger = str2double(get(handles.edit_trigger,'String'));
% frameRead = str2double(get(handles.edit_frameRead,'String'));
% trigger = 43;
% frameRead = 1320;
vData = handles.data;
boxPos_LED = vData.boxPos_LED;
vidObj = VideoReader(vData.dataFile);
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
vidFrameRate = vidObj.FrameRate;
vidDuration = vidObj.Duration;
% totalFrame = round(vidFrameRate*vidDuration);
totalFrame = vidObj.NumberOfFrames;
% frame_readT = trigger*vidFrameRate;

time2Read = str2double(get(handles.time2Read_edit,'String'));
if time2Read > 0
    readTime = min(floor(time2Read),vidDuration);% acctually readTime is the time caculated,means 300s(5min)
else
    readTime = vidDuration;
end

temp = vidFrameRate/10;
data_len = length(1:temp:totalFrame);
thre = zeros(data_len,1);
thre2 = zeros(data_len,1);
% k = 1;
% figure;
% set(gcf,'Position',[1,1,700,700]);
k = 1; 
for i = 1:1:totalFrame 
    tmpImg = read(vidObj,i);
%     assignin('base','tmpImg',tmpImg);
%     r = tmpImg(:,:,1);
%     g = tmpImg(:,:,2);
%     b = tmpImg(:,:,3);
%     blueLight = 2*b-g-r;
%     thre(k) = sum(any(blueLight));
%     k = k+1;
%     c = 10*r-g-b;
%     assignin('base','blueLight',blueLight);
%     subplot(5,5,i-frame_readT+1);
%     imshow(tmpImg);hold on
            %%%%%%%%%%%%%%%%%read LED frame
    rSta = boxPos_LED(1,2);
    rEnd = boxPos_LED(1,2) + boxPos_LED(1,4) - 1;
    cSta = boxPos_LED(1,1);
    cEnd = boxPos_LED(1,1) + boxPos_LED(1,3) - 1;
%     ledImgRef = refImg(rSta:rEnd,cSta:cEnd);
    ledImg = tmpImg;
%     blueLight = ledImg-ledImgRef;
    assignin('base','tmpImg',tmpImg);
    assignin('base','ledImg',ledImg);
    r = ledImg(rSta:rEnd,cSta:cEnd,1);
    g = ledImg(rSta:rEnd,cSta:cEnd,2);
    b = ledImg(rSta:rEnd,cSta:cEnd,3);
    redLight = 1.5*r-g-b;
    thre(i) = sum(any(redLight));
    thre2(i) = sum(any(redLight));
    assignin('base','thre',thre);
    assignin('base','thre2',thre2);
    if vidObj.CurrentTime >= readTime
        break
    end
    k = k+1;
end
% thre = thre';
% tmpImg = read(vidObj,1220);
assignin('base','thre',thre);

p  = 1;
stimOnset = zeros(length(thre),1);
led_thre = smooth(thre);
assignin('base','led_thre',led_thre);
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
%     trigger_pupil_down = find(stimOnsetDiff == -1)+1;
assignin('base','stimOnset',stimOnset);
trigger_times = led_up;
assignin('base','trigger_times',trigger_times);
allign_data = zeros(length(trigger_times)+1,2);
allign_data(2:end,1) = 1:length(trigger_times);
allign_data(2:end,2) = trigger_times;
assignin('base','allign_data',allign_data);
filename = vData.matFilename;
csvwrite('trigger_times.csv',trigger_times);
vData.trigger_times = trigger_times;
vData.stimOnset = stimOnset;
vData.thre = thre;
disp('finished!');
toc;



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


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
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

%resample the data because of jagged data
temp_centroids = vData.centroids(1:2:end,:);
temp_centroids2 = resample(temp_centroids,vData.vidFrameRate,10);

xLocation = temp_centroids2(round(start-pre_stim/bin):round(start+post_stim/bin)-1,1);
yLocation = temp_centroids2(round(start-pre_stim/bin):round(start+post_stim/bin)-1,2);
length_xl = length(xLocation)

%get velocity information
dfx = diff(xLocation);
dfy = diff(yLocation);% y is 580 mm x is 500 mm
speed = [0;sqrt(dfx.*dfx + dfy.*dfy)/bin/ppm];% mm/s
speed = smooth(speed);

if ~isempty(back_times)
       temp_bt = back_times(exampleT,:);
       temp = find(temp_bt>0);
       temp_bt = temp_bt(temp);
       backN = length(temp_bt)
       for j=1:backN/2
           back_s = back_times(exampleT,2*j-1)-round(start-pre_stim/bin);
           back_e = back_times(exampleT,2*j)-round(start-pre_stim/bin);
           speed(back_s:back_e,1) = -speed(back_s:back_e,1);
            % plot(xLocation(back_s:back_e,:), yLocation(back_s:back_e,:),'Color','r','LineWidth',2); hold on;
       end
else
    display('there are no backward behavior!')
end

plot_2D = 1;

if plot_2D
    figure; 
    plot(xLocation(1,1), yLocation(1,1),'*','Color','k','LineWidth',6); hold on;
    plot(xLocation, yLocation,'Color','k','LineWidth',2); hold on;
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    % plot(xLocation(pre_stim/bin+1:post_stim/bin,:), yLocation(pre_stim/bin+1:post_stim/bin,:),'Color','b','LineWidth',5); hold on;
    % 2D Color plot of speed (using scatter as an alternative for better coloring)
    % scatter(xLocation, yLocation, 20, speed, 'filled');
    % Create a colored line using surface
    x = xLocation(:)';
    y = yLocation(:)';
    c = speed(:)';
    
    % Build 2-row matrix for surface trick
    surface([x; x], [y; y], [zeros(size(x)); zeros(size(x))], ...
        [c; c], ...
        'FaceColor', 'none', ...
        'EdgeColor', 'interp', ...
        'LineWidth', 3);
    
    colorbar;
    colormap(jet); % or any other colormap like parula, hot, etc.
    cb = colorbar;
    cb.Label.String = 'Velocity (cm/s)';
    cb.Label.FontSize = 12;
    % title('Trajectory with Speed Encoding');
    
    imgWidth = 640;
    imgHeight = 480;
    offset = 0;
    set(gca, 'xlim', [offset imgWidth-offset], 'YDir', 'reverse');
    % set(gca, 'xlim', [offset imgWidth-offset]);
    set(gca, 'ylim', [offset imgHeight-offset], 'YDir', 'reverse');
    xlabel('X Position (pixels)');
    ylabel('Y Position (pixels)');
else
    % 3D plot of trajectory: Z axis is time
    x = xLocation(:)';
    y = yLocation(:)';
    % z = linspace(0, 1, length(x));  % Normalized time, or use actual timestamps if available
    % frame_time = bin;  % e.g., 0.05 s per frame for 20 Hz
    % z = (0:length(x)-1) * frame_time;  % Time in seconds
    z = (-pre_stim : bin : post_stim - bin);  % or size-adjusted version
    c = speed(:)';
    
    % Create a 3D colored line using surface
    figure;
    surface([x; x], [y; y], [z; z], [c; c], ...
        'FaceColor', 'none', ...
        'EdgeColor', 'interp', ...
        'LineWidth', 3);

    colormap(jet);
    % colorbar;
    cb = colorbar;
    cb.Label.String = 'Velocity (cm/s)';
    cb.Label.FontSize = 12;
    % plot3(x,y,z)
    xlim([0 640])
    set(gca, 'ylim', [0 480], 'YDir', 'reverse');
    zlim([-3 6]);
    xlabel('X Position (pixels)');
    ylabel('Y Position (pixels)');
    zlabel('Time (s)');
    % title('3D Trajectory with Speed Encoding');
    
    view(3); % 3D view
    % grid on;
end

figure
t = linspace(-pre_stim, post_stim, length(speed));
plot(t, speed, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Speed (cm/s)');
title('Speed Over Time');
grid on;


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
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

%resample the data because of jagged data
temp_centroids = vData.centroids(1:2:end,:);
temp_centroids2 = resample(temp_centroids,vData.vidFrameRate,10);

xLocation = temp_centroids2(round(start-pre_stim/bin):round(start+post_stim/bin)-1,1);
yLocation = temp_centroids2(round(start-pre_stim/bin):round(start+post_stim/bin)-1,2);
length_xl = length(xLocation)

%get velocity information
dfx = diff(xLocation);
dfy = diff(yLocation);% y is 580 mm x is 500 mm
speed = [0;sqrt(dfx.*dfx + dfy.*dfy)/bin/ppm];% mm/s
speed = smooth(speed);

if ~isempty(back_times)
       temp_bt = back_times(exampleT,:);
       temp = find(temp_bt>0);
       temp_bt = temp_bt(temp);
       backN = length(temp_bt)
       for j=1:backN/2
           back_s = back_times(exampleT,2*j-1)-round(start-pre_stim/bin);
           back_e = back_times(exampleT,2*j)-round(start-pre_stim/bin);
           speed(back_s:back_e,1) = -speed(back_s:back_e,1);
            % plot(xLocation(back_s:back_e,:), yLocation(back_s:back_e,:),'Color','r','LineWidth',2); hold on;
       end
else
    display('there are no backward behavior!')
end





plot_2D = 0;

if plot_2D
    figure; 
    plot(xLocation(1,1), yLocation(1,1),'*','Color','k','LineWidth',6); hold on;
    plot(xLocation, yLocation,'Color','k','LineWidth',2); hold on;
    % plot(xLocation(pre_stim/bin+1:post_stim/bin,:), yLocation(pre_stim/bin+1:post_stim/bin,:),'Color','b','LineWidth',5); hold on;
    % 2D Color plot of speed (using scatter as an alternative for better coloring)
    % scatter(xLocation, yLocation, 20, speed, 'filled');
    % Create a colored line using surface
    x = xLocation(:)';
    y = yLocation(:)';
    c = speed(:)';
    
    % Build 2-row matrix for surface trick
    surface([x; x], [y; y], [zeros(size(x)); zeros(size(x))], ...
        [c; c], ...
        'FaceColor', 'none', ...
        'EdgeColor', 'interp', ...
        'LineWidth', 3);
    
    colorbar;
    colormap(jet); % or any other colormap like parula, hot, etc.
    title('Trajectory with Speed Encoding');
    
    imgWidth = 640;
    imgHeight = 480;
    offset = 0;
    set(gca, 'xlim', [offset imgWidth-offset], 'YDir', 'reverse');
    set(gca, 'ylim', [offset imgHeight-offset], 'YDir', 'reverse');
    xlabel('X Position (pixels)');
    ylabel('Y Position (pixels)');
else
    % 3D plot of trajectory: Z axis is time
    x = xLocation(:)';
    y = yLocation(:)';
    % z = linspace(0, 1, length(x));  % Normalized time, or use actual timestamps if available
    % frame_time = bin;  % e.g., 0.05 s per frame for 20 Hz
    % z = (0:length(x)-1) * frame_time;  % Time in seconds
    z = (-pre_stim : bin : post_stim - bin);  % or size-adjusted version
    c = speed(:)';
    
    % Create a 3D colored line using surface
    figure;
    surface([x; x], [y; y], [z; z], [c; c], ...
        'FaceColor', 'none', ...
        'EdgeColor', 'interp', ...
        'LineWidth', 3);
    

    colormap(jet);
    % colorbar;
    cb = colorbar;
    cb.Label.String = 'Velocity (cm/s)';
    cb.Label.FontSize = 12;
    % plot3(x,y,z)
    xlim([0 640])
    set(gca, 'ylim', [0 480], 'YDir', 'reverse');
    % set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    zlim([-3 6]);
    xlabel('X Position (pixels)');
    ylabel('Y Position (pixels)');
    zlabel('Time (s)');
    % title('3D Trajectory with Speed Encoding');
    
    view(3); % 3D view
    % grid on;
end

figure
t = linspace(-pre_stim, post_stim, length(speed));
plot(t, speed, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Speed (cm/s)');
title('Speed Over Time');
grid on;
