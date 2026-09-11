tic;
% Input and output file names
inputFile = '20250808 Vglut2-Cre+ #31 test_1.wmv';
outputFile = '20250808 Vglut2-Cre+ #31 test_1.mp4';

% Create video reader
vidReader = VideoReader(inputFile);

% Create video writer (MPEG-4 format)
vidWriter = VideoWriter(outputFile, 'MPEG-4');
vidWriter.FrameRate = vidReader.FrameRate; % preserve frame rate
open(vidWriter);

% Loop through all frames and write to mp4
while hasFrame(vidReader)
    frame = readFrame(vidReader);
    writeVideo(vidWriter, frame);
end

% Close the writer
close(vidWriter);

disp('Conversion finished!');
toc;