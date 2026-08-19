%% Load data
clear all
tic
BehaviorFilePath = pwd;

% for AnimalIdx = 1:size(Experiment, 1)

    bodycamName = 'Vglut2_80_open field_5.mp4';%replace the filename for each dataset
    left_starts_csv = xlsread('trigger_times_video_L.csv');
    right_starts_csv = xlsread('trigger_times_video_R.csv');
    straight_starts_csv = xlsread('trigger_times_video_S.csv');

    savefilepath = [BehaviorFilePath,'\','cropped_video'];
    if ~exist(savefilepath, 'dir')
        mkdir(savefilepath);
    end

    vidObj = VideoReader(bodycamName);
    % Parameters
    fs          = vidObj.FrameRate;      % sampling frequency (Hz)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    preFrames   = 3*fs;     % frames before the event
    postFrames  = 3*fs;     % frames after the event
    labelFrames = 0.5*fs;      % number of frames to show "sound" before event
    
    %save left  trials
    % Create a VideoReader
    
    % Loop through each event
    for k = 1:numel(left_starts_csv)
        k
        eventFrame = left_starts_csv(k); % already in frames
        
        % Frame range to extract
        startFrame = max(1, eventFrame - preFrames);
        endFrame   = min(vidObj.NumFrames, eventFrame + postFrames);
        
        % Prepare output video
        outName = fullfile(savefilepath, sprintf('left_clip_%d.avi', k));
        writerObj = VideoWriter(outName, 'Uncompressed AVI');
        writerObj.FrameRate = fs; % match original
        open(writerObj);
        
        % Jump to starting frame
        vidObj.CurrentTime = (startFrame-1) / fs;%
        
        % Extract frames
        for f = startFrame:endFrame
            if hasFrame(vidObj)
                frame = readFrame(vidObj);
                if f >= (eventFrame ) && f < eventFrame + labelFrames
                    frame = insertText(frame, [20 15], 'turnning', ...
                                       'FontSize', 18, ...
                                       'BoxOpacity', 0, ...   % no background box
                                       'TextColor', 'red'); % text color
                end

                writeVideo(writerObj, frame);
            end
        end
        
        close(writerObj);
        fprintf('Saved %s (%d to %d)\n', outName, startFrame, endFrame);
    end

    %save right trials
    % Create a VideoReader
    vidObj = VideoReader(bodycamName);
    % Loop through each event
    for k = 1:numel(right_starts_csv)
        
        eventFrame = right_starts_csv(k); % already in frames
        
        % Frame range to extract
        startFrame = max(1, eventFrame - preFrames);
        endFrame   = min(vidObj.NumFrames, eventFrame + postFrames);
        
        % Prepare output video
        outName = fullfile(savefilepath, sprintf('right_clip_%d.avi', k));
        writerObj = VideoWriter(outName, 'Uncompressed AVI');
        writerObj.FrameRate = fs; % match original
        open(writerObj);
        
        % Jump to starting frame
        vidObj.CurrentTime = (startFrame-1) / fs;%
        
        % Extract frames
        for f = startFrame:endFrame
            if hasFrame(vidObj)
                frame = readFrame(vidObj);
                if f >= (eventFrame ) && f < eventFrame + labelFrames
                    frame = insertText(frame, [20 15], 'turning', ...
                                       'FontSize', 18, ...
                                       'BoxOpacity', 0, ...   % no background box
                                       'TextColor', 'red'); % text color
                end


                writeVideo(writerObj, frame);
            end
        end
        
        close(writerObj);
        fprintf('Saved %s (%d to %d)\n', outName, startFrame, endFrame);
    end



     %save straight trials
    % Create a VideoReader
    vidObj = VideoReader(bodycamName);
    % Loop through each event
    for k = 1:numel(straight_starts_csv)
        k
        eventFrame = straight_starts_csv(k); % already in frames
        
        % Frame range to extract
        startFrame = max(1, eventFrame - preFrames);
        endFrame   = min(vidObj.NumFrames, eventFrame + postFrames);
        
        % Prepare output video
        outName = fullfile(savefilepath, sprintf('straight_clip_%d.avi', k));
        writerObj = VideoWriter(outName, 'Uncompressed AVI');
        writerObj.FrameRate = fs; % match original
        open(writerObj);
        
        % Jump to starting frame
        vidObj.CurrentTime = (startFrame-1) / fs;%
        
        % Extract frames
        for f = startFrame:endFrame
            if hasFrame(vidObj)
                frame = readFrame(vidObj);
                if f >= (eventFrame ) && f < eventFrame + labelFrames
                    frame = insertText(frame, [20 15], 'straight', ...
                                       'FontSize', 18, ...
                                       'BoxOpacity', 0, ...   % no background box
                                       'TextColor', 'red'); % text color
                end


                writeVideo(writerObj, frame);
            end
        end
        
        close(writerObj);
        fprintf('Saved %s (%d to %d)\n', outName, startFrame, endFrame);
    end   
% end
toc

