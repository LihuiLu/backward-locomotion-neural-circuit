%% 01_adjust_threshold_mouse_contour.m
% ------------------------------------------------------------
% 目的：
% 1. 读入一个 MP4 视频
% 2. 用多个视频帧取平均，生成 reference/background 图像
% 3. 对指定的 3 个帧进行 background subtraction
% 4. 通过阈值法得到小鼠轮廓：
%       背景 = 黑色
%       小鼠 = 白色
% 5. 显示原始图和二值轮廓图，方便手动调整 threshold
%
% 注意：
% - threshold 越小，轮廓越大，可能包含噪声或尾巴
% - threshold 越大，轮廓越小，可能漏掉身体边缘
% - 你的目标是让白色轮廓尽量匹配“去掉尾巴后的小鼠身体大小”
% ------------------------------------------------------------

clear; clc; close all;

%% ========== 用户需要调整的参数 ==========

% 阈值，范围一般是 0 到 255
% 建议先试 20, 30, 40, 50, 60, 80 等
thresholdValue = 80;

% 用多少帧来生成 reference/background
% 数值越大，reference 越稳定，但运行越慢
numFramesForReference = 200;

% 显示哪 3 帧来检查阈值效果
% 如果你不确定总帧数，可以先用下面默认设置：
% 程序会自动选取视频前段、中段、后段的 3 帧
useAutomaticCheckFrames = true;

% 如果 useAutomaticCheckFrames = false，则使用这里指定的帧号
manualCheckFrames = [100, 500, 1000];

% 去除小噪点的最小面积，单位是 pixel
% 太小：噪声可能保留
% 太大：可能误删小鼠身体
minObjectArea = 100;

% 是否对轮廓做填洞
fillHoles = true;

% 是否只保留最大连通区域
% 推荐 true，因为视频里通常只有一只小鼠
keepLargestObjectOnly = true;

%% ========== 选择 MP4 文件 ==========

[fileName, filePath] = uigetfile({'*.mp4;*.MP4', 'MP4 video files (*.mp4)'}, ...
    '请选择一个 MP4 视频文件');

if isequal(fileName, 0)
    error('没有选择视频文件，程序终止。');
end

videoFile = fullfile(filePath, fileName);
v = VideoReader(videoFile);

fprintf('已读取视频文件：%s\n', videoFile);
fprintf('视频帧率：%.3f fps\n', v.FrameRate);
fprintf('视频时长：%.3f 秒\n', v.Duration);

% 估算总帧数
totalFrames = floor(v.Duration * v.FrameRate);
fprintf('估算总帧数：%d\n', totalFrames);

%% ========== 用多个帧生成 reference/background ==========

fprintf('正在生成 reference/background 图像...\n');

% 从视频全程均匀抽取若干帧
numFramesForReference = min(numFramesForReference, totalFrames);
referenceFrameIdx = round(linspace(1, totalFrames, numFramesForReference));

% 初始化
v.CurrentTime = 0;
firstFrame = readFrame(v);
firstGray = convertToGrayDouble(firstFrame);
[height, width] = size(firstGray);

referenceStack = zeros(height, width, numFramesForReference);

for i = 1:numFramesForReference
    frameIdx = referenceFrameIdx(i);

    % VideoReader 用时间定位，帧号转换为时间
    v.CurrentTime = max((frameIdx - 1) / v.FrameRate, 0);

    if hasFrame(v)
        frame = readFrame(v);
        grayFrame = convertToGrayDouble(frame);
        referenceStack(:, :, i) = grayFrame;
    end
end

% 用平均图作为 reference
% 如果小鼠在不同位置移动，平均后小鼠会被大幅削弱，接近空背景
referenceImage = mean(referenceStack, 3);

fprintf('reference/background 图像生成完成。\n');

%% ========== 自动选择 3 个检查帧 ==========

if useAutomaticCheckFrames
    checkFrames = round([0.2, 0.5, 0.8] * totalFrames);
else
    checkFrames = manualCheckFrames;
end

% 防止帧号越界
checkFrames(checkFrames < 1) = 1;
checkFrames(checkFrames > totalFrames) = totalFrames;

fprintf('用于检查阈值的帧号为：%d, %d, %d\n', ...
    checkFrames(1), checkFrames(2), checkFrames(3));

%% ========== 显示原始帧和阈值分割后的小鼠轮廓 ==========

figure('Name', sprintf('Threshold = %g', thresholdValue), ...
       'Color', 'w', ...
       'Position', [100, 100, 1200, 700]);

for i = 1:length(checkFrames)
    frameIdx = checkFrames(i);

    % 读取指定帧
    v.CurrentTime = max((frameIdx - 1) / v.FrameRate, 0);
    frame = readFrame(v);
    grayFrame = convertToGrayDouble(frame);

    % 得到小鼠轮廓 mask
    [mouseMask, foregroundImage] = getMouseMaskFromFrame( ...
        grayFrame, referenceImage, thresholdValue, ...
        minObjectArea, fillHoles, keepLargestObjectOnly);

    % 计算质心，仅用于显示
    stats = regionprops(mouseMask, 'Centroid', 'Area');

    % 第一行：原始图
    subplot(2, length(checkFrames), i);
    imshow(frame);
    title(sprintf('原始帧 #%d', frameIdx), 'FontSize', 12);

    % 如果检测到小鼠，则把质心画在原图上
    hold on;
    if ~isempty(stats)
        centroid = stats(1).Centroid;
        plot(centroid(1), centroid(2), 'r+', 'MarkerSize', 15, 'LineWidth', 2);
    end
    hold off;

    % 第二行：反色/阈值后轮廓图
    subplot(2, length(checkFrames), i + length(checkFrames));
    imshow(mouseMask);
    title(sprintf('轮廓图，threshold = %g', thresholdValue), 'FontSize', 12);

    hold on;
    if ~isempty(stats)
        centroid = stats(1).Centroid;
        plot(centroid(1), centroid(2), 'r+', 'MarkerSize', 15, 'LineWidth', 2);
    end
    hold off;
end

%% ========== 额外显示 reference 和 foreground difference，帮助理解 ==========

figure('Name', 'Reference and foreground example', ...
       'Color', 'w', ...
       'Position', [150, 150, 1000, 400]);

exampleFrameIdx = checkFrames(2);
v.CurrentTime = max((exampleFrameIdx - 1) / v.FrameRate, 0);
exampleFrame = readFrame(v);
exampleGray = convertToGrayDouble(exampleFrame);

[exampleMask, exampleForeground] = getMouseMaskFromFrame( ...
    exampleGray, referenceImage, thresholdValue, ...
    minObjectArea, fillHoles, keepLargestObjectOnly);

subplot(1, 3, 1);
imshow(referenceImage, []);
title('平均 reference/background');

subplot(1, 3, 2);
imshow(exampleForeground, []);
title('当前帧与 reference 的差异图');

subplot(1, 3, 3);
imshow(exampleMask);
title(sprintf('最终小鼠轮廓，threshold = %g', thresholdValue));

fprintf('\n当前 threshold = %g\n', thresholdValue);
fprintf('请观察白色轮廓是否与真实小鼠身体大小一致。\n');
fprintf('如果轮廓太大，增大 threshold；如果轮廓太小，减小 threshold。\n');

%% ========== 本脚本用到的局部函数 ==========

function grayFrame = convertToGrayDouble(frame)
    % 把 RGB 或灰度图转换成 double 灰度图，范围 0 到 255

    if ndims(frame) == 3
        grayFrame = rgb2gray(frame);
    else
        grayFrame = frame;
    end

    grayFrame = double(grayFrame);
end

function [mouseMask, foregroundImage] = getMouseMaskFromFrame( ...
    grayFrame, referenceImage, thresholdValue, ...
    minObjectArea, fillHoles, keepLargestObjectOnly)

    % 计算当前帧和 reference/background 的差异
    % 小鼠所在区域与 background 不同，因此差异值较大
    foregroundImage = abs(grayFrame - referenceImage);

    % 阈值分割：
    % foregroundImage >= thresholdValue 的区域设为 1，即白色小鼠区域
    % 其余区域设为 0，即黑色背景
    mouseMask = foregroundImage >= thresholdValue;

    % 去除小面积噪声
    mouseMask = bwareaopen(mouseMask, minObjectArea);

    % 填补小鼠身体内部可能出现的小洞
    if fillHoles
        mouseMask = imfill(mouseMask, 'holes');
    end

    % 只保留最大连通区域
    % 对单只小鼠视频来说，最大连通区域通常就是小鼠身体
    if keepLargestObjectOnly
        cc = bwconncomp(mouseMask);

        if cc.NumObjects > 0
            numPixels = cellfun(@numel, cc.PixelIdxList);
            [~, largestIdx] = max(numPixels);

            newMask = false(size(mouseMask));
            newMask(cc.PixelIdxList{largestIdx}) = true;
            mouseMask = newMask;
        end
    end
end