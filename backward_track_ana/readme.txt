The "backward_track_ana" folder contains customized code for plotting data in Fig. 2, 4, and 5, and Fig. S2. 
The main function is "backward_track_ana5.m", which can be used to read and plot the mouse locomotion track and LED indicator signals in videos.
Portions of this code were generated with assistance from Claude by Anthropic.


The GUI was generated using the 'guide' function and tested in MATLAB 2020a or earlier.

## instructions

Run ‘backward_track_ana5’ to open the GUI
1. Click 'load files', which is located on the right side of 'filename' to load the video
2. Set cmpp and other parameters
3. Click 'Box Read' to analyze the video and get the mouse locations and LED indicator signals
4. Click 'load files' that is located on the right side of 'trigger_times' to load trigger times file. The onset of backward locomotion for each trial was identified by the experimenter through frame-by-frame video review.
5. Click 'load files', which is located on the right side of 'location,' to load animal positions data that was obtained from step 3.
6. Click ‘backward ana2’ to analyze and plot the data. 
An output file will be saved in the end. Scripts for grouping the analyzed data using the above function are located in the 'group_ana' folder
