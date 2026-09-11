%%
% close all
% % % clc
% % clear;
% 
% tic;
% file = dir('*.csv');
% for i = 1:length(file)
%     cName = file(i).name
% 
%     %%%analysis
%     backward_analysis_v1_ba( cName);
% end
% 
% disp('analysis finished!');
% toc;


%% calculate and save related parameters
% function backward_analysis_v1_ba(filename )
% bodyparts	nose	nose	nose	mass	mass	mass	tail 1	tail 1	tail 1	tail 2	tail 2	tail 2	left ear	left ear	left ear	right ear	right ear	right ear
% coords	x	y	likelihood	x	y	likelihood	x	y	likelihood	x	y	likelihood	x	y	likelihood	x	y	likelihood
% 
% function backward_analysis_v1_ba( )

clear;clc;close all;

disp('open the DLC file for the video')
[filename, pathname] = uigetfile({'*.csv'}, 'Open LFP file');
file_path_and_name = [pathname filename];
if filename == 0
    return;
end

%%%%%%%%%get coordinates
data0 = csvread(filename, 3, 0);
assignin('base','data0',data0);

disp('open the timestamps file indicating backward locomotion')
[filename, pathname] = uigetfile({'*.xlsx'}, 'Open LFP file');
file_path_and_name = [pathname filename];
if filename == 0
    return;
end

%%%%%%%%%get timestamps
data1 = readmatrix(filename);
assignin('base','data1',data1);



% if ~exist('figures', 'dir')
    mkdir('figures');
% end
dpp = 1/7.8;%cm/pixel
PLOT = 1;
vData.fps = 20; 
vData.dpp = dpp;
vData.filename = filename;
x = data0(:,5);
y = data0(:,6);
vData.x = x;
vData.y = y;
distance0 = sqrt(diff(x).^2 + diff(y).^2);
% distance = [distance0;distance0(length(distance0),:)]*dpp;%the unit is cm
distance = [distance0]*dpp;%the unit is cm
% % plot the movement track of the the animal

if PLOT == 1
    % open figure
    % h = figure('visible', 'off');
    h = figure('visible', 'on');
    gcf_Position=[100,100,640,480];
    set(gcf,'Position',gcf_Position);

    plot(x,y,'k','LineWidth',1.5);hold on;
    set(gca,'FontSize',20,'LineWidth',3,'FontWeight','Bold');
    set(gca,'XLim',[0,640],'TickDir','out');
%         axis tight
    set(gca,'YLim',[0 480],'TickDir','out');
    xlabel('Width (pixel)','FontName','Arial','FontSize',25,'FontWeight','Bold');
    ylabel('Height (pixel)','FontName','Arial','FontSize',15,'FontWeight','Bold');
    title(strrep(filename(1:end-24), '\', '\\'));
    
% % %         SAVE plot
    outputfilename = [pwd,'\figures\',filename(1:end-5) ' mass location.png']
    % outputfilename = [filename(1:end-47) ' mass location.png'];
    saveas(h,outputfilename,'png');
end


% % calculate the backward bout number, duration, and the time between backward bouts
% Calculate bout durations
vData.bout_durations = (data1(:, 2) - data1(:, 1)+1)/vData.fps;
% Calculate duration between bouts
vData.between_bout_durations = (data1(2:end, 1) - data1(1:end-1, 2)+1)/vData.fps;

% Calculate bout numbers for each behavioral state
vData.num_rearing_bouts = sum(data1(:, 3) == 1);
vData.num_other_bouts = sum(isnan(data1(:, 3)));
vData.num_bouts = size(data1,1);


% % calculate the backward bout velocity
num_frames = length(distance); % Total number of video frames (length of distance array)

% Initialize state array
state_array = zeros(num_frames, 1); % Default state is 0 (between bouts)

% Loop through each bout event and update the state array
velocity_b = [];
for i = 1:size(data1, 1)
    start_time = data1(i, 1);
    stop_time = data1(i, 2);
    state_array(start_time:stop_time) = 1; % Mark frames within the bout event as 1
    distance_temp = sum(distance(start_time-1:stop_time))/vData.bout_durations(i);
    velocity_b = vertcat(velocity_b,distance_temp);
end
vData.velocity_b = velocity_b;
% 
% % You can plot the state array alongside the distance array to visualize
% figure;
% subplot(2, 1, 1);
% plot(distance);
% set(gca,'FontSize',20,'FontWeight','Bold','linewidth',3);
% set(gca,'xLim',[0 num_frames]);
% title('Distance Array');
% xlabel('Frame');
% ylabel('Distance (cm)');
% 
% subplot(2, 1, 2);
% plot(state_array, 'r');
% set(gca,'FontSize',20,'FontWeight','Bold','linewidth',3);
% set(gca,'xLim',[0 num_frames]);
% title('State Array');
% xlabel('Frame');
% ylabel('State');

% Create the figure
h=figure;
t = (1:num_frames)/vData.fps;%unit is second

% Subplot 1: Distance Array
subplot(2, 1, 1);
plot(t,distance, 'b', 'LineWidth', 2); % Distance array plot
set(gca, 'FontSize', 20, 'FontWeight', 'Bold', 'LineWidth', 3);
set(gca, 'XLim', [0 t(num_frames)]);
title('Distance Array');
xlabel('Time (s)');
ylabel('Distance (cm)');

% Subplot 2: State Array with imagesc
subplot(2, 1, 2);
% Ensure state_array is a row vector (1 x num_frames)
state_array = reshape(state_array, 1, []); % Reshape to a 1xN row vector if needed
% Use imagesc to create a rectangular schematic for states
imagesc(t, 1,state_array); % State array as a single-row image
colormap([0.8 0.8 0.8; 1 0 0;]); % Example colormap: red, green, blue for 3 states
caxis([0 1]); % Ensure color limits match states (0, 1, 2)

% Adjust axis properties
set(gca, 'FontSize', 20, 'FontWeight', 'Bold', 'LineWidth', 3);
set(gca, 'XLim', [0 t(num_frames)]);
title('State Array');
xlabel('Time (s)');
ylabel('State');
yticks([])

% Optional: Add a colorbar to indicate state values
colorbar('Ticks', [0, 1], 'TickLabels', {'other', 'backward'});
outputfilename = [pwd,'\figures\',filename(1:end-5) ' behavior state.png']
saveas(h,outputfilename,'png');




% %  save data
assignin('base','vData',vData);
Data_filename = [filename(1:end-5),' analysis.mat'];
save(Data_filename, '-struct', 'vData');





% end


%% Group Data
close all;

% Get a list of all .mat files in the folder
fileList = dir(fullfile(pwd, '*analysis.mat'));

% Initialize arrays to store metrics for CNO and saline files
CNO_bout_durations = [];
CNO_between_bout_durations = [];
CNO_num_rearing_bouts = [];
CNO_num_other_bouts = [];
CNO_num_bouts = [];
CNO_velocity_b = [];

saline_bout_durations = [];
saline_between_bout_durations = [];
saline_num_rearing_bouts = [];
saline_num_other_bouts = [];
saline_num_bouts = [];
saline_velocity_b = [];

% Loop through each file and process it
for i = 1:length(fileList)
    % Get the file name
    fileName = fileList(i).name;
    
    % Load the .mat file
    filePath = fullfile(pwd, fileName);
    data = load(filePath);
    
    % Check if the required variables exist in the loaded file
    if isfield(data, 'bout_durations') && isfield(data, 'between_bout_durations') && ...
       isfield(data, 'num_rearing_bouts') && isfield(data, 'num_other_bouts') && ...
       isfield(data, 'num_bouts') && isfield(data, 'velocity_b')
   
        % Extract metrics
        bout_durations = data.bout_durations;
        between_bout_durations = data.between_bout_durations;
        num_rearing_bouts = data.num_rearing_bouts;
        num_other_bouts = data.num_other_bouts;
        num_bouts = data.num_bouts;
        velocity_b = data.velocity_b;
        
        % Identify whether the file belongs to CNO or saline group
        if contains(fileName, 'CNO', 'IgnoreCase', true)
            % Append metrics to CNO arrays
            CNO_bout_durations = [CNO_bout_durations; bout_durations];
            CNO_between_bout_durations = [CNO_between_bout_durations; between_bout_durations];
            CNO_num_rearing_bouts = [CNO_num_rearing_bouts; num_rearing_bouts];
            CNO_num_other_bouts = [CNO_num_other_bouts; num_other_bouts];
            CNO_num_bouts = [CNO_num_bouts; num_bouts];
            CNO_velocity_b = [CNO_velocity_b; velocity_b];
            
        elseif contains(fileName, 'saline', 'IgnoreCase', true)
            % Append metrics to saline arrays
            saline_bout_durations = [saline_bout_durations; bout_durations];
            saline_between_bout_durations = [saline_between_bout_durations; between_bout_durations];
            saline_num_rearing_bouts = [saline_num_rearing_bouts; num_rearing_bouts];
            saline_num_other_bouts = [saline_num_other_bouts; num_other_bouts];
            saline_num_bouts = [saline_num_bouts; num_bouts];
            saline_velocity_b = [saline_velocity_b; velocity_b];
        end
    else
        % Display a warning if required variables are not found
        warning(['Required variables not found in file: ', fileName]);
    end
end

% Save the grouped data into a structure
group_data.CNO_bout_durations = CNO_bout_durations;
group_data.CNO_between_bout_durations = CNO_between_bout_durations;
group_data.CNO_num_rearing_bouts = CNO_num_rearing_bouts;
group_data.CNO_num_other_bouts = CNO_num_other_bouts;
group_data.CNO_num_bouts = CNO_num_bouts;
group_data.CNO_velocity_b = CNO_velocity_b;

group_data.saline_bout_durations = saline_bout_durations;
group_data.saline_between_bout_durations = saline_between_bout_durations;
group_data.saline_num_rearing_bouts = saline_num_rearing_bouts;
group_data.saline_num_other_bouts = saline_num_other_bouts;
group_data.saline_num_bouts = saline_num_bouts;
group_data.saline_velocity_b = saline_velocity_b;

% Save the grouped data to a .mat file
save('group_data.mat', 'group_data');

%% plot it
% Plot the metrics for CNO and saline groups
figure;

% Subplot 1: Mean Bout Duration
subplot(3, 2, 1);
bar([mean(CNO_bout_durations), mean(saline_bout_durations)]);
xticks([1 2]);
xticklabels({'CNO', 'Saline'});
ylabel('Bout Duration');
title('Mean Bout Duration');

% Subplot 2: Mean Time Between Bouts
subplot(3, 2, 2);
bar([mean(CNO_between_bout_durations), mean(saline_between_bout_durations)]);
xticks([1 2]);
xticklabels({'CNO', 'Saline'});
ylabel('Time Between Bouts');
title('Mean Time Between Bouts');

% Subplot 3: Number of Rearing Bouts
subplot(3, 2, 3);
bar([mean(CNO_num_rearing_bouts), mean(saline_num_rearing_bouts)]);
xticks([1 2]);
xticklabels({'CNO', 'Saline'});
ylabel('Number of Rearing Bouts');
title('Number of Rearing Bouts');

% Subplot 4: Number of Other Bouts
subplot(3, 2, 4);
bar([mean(CNO_num_other_bouts), mean(saline_num_other_bouts)]);
xticks([1 2]);
xticklabels({'CNO', 'Saline'});
ylabel('Number of Other Bouts');
title('Number of Other Bouts');

% Subplot 5: Total Number of Bouts
subplot(3, 2, 5);
bar([mean(CNO_num_bouts), mean(saline_num_bouts)]);
xticks([1 2]);
xticklabels({'CNO', 'Saline'});
ylabel('Number of Bouts');
title('Total Number of Bouts');

% Subplot 6: Velocity
subplot(3, 2, 6);
bar([mean(CNO_velocity_b), mean(saline_velocity_b)]);
xticks([1 2]);
xticklabels({'CNO', 'Saline'});
ylabel('Velocity');
title('Velocity');

% Adjust figure layout for better visualization
sgtitle('Metrics for CNO and Saline Groups'); % Add a super title