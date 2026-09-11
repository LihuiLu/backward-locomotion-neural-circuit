The "turning_ana" folder contains customized code for plotting data in Figs. 6 and 7, and Figs. S12, S13, and S15. 
There are two main functions called "turning_DLC.m" and "turning_DLC_GC.m".  

TDMS reader is downloaded from https://www.mathworks.com/matlabcentral/fileexchange/30023-tdms-reader

The GUI was generated using the 'guide' function and tested in MATLAB 2020a or earlier.

## instructions

Run ‘turning_DLC’ to open the GUI
1. Click 'load files' that is located on the right side of 'trigger_times' to load trigger times file
2. Click 'load files' that is located on the right side of 'location' to load animal positions data from deepLabCut
3. Set cmpp and other parameters
4. Click ‘turning_DLC’ to analyze and plot the data. Note that this function can also analyze and plot velocities for forward locomotion and immobility.
An output file will be saved in the end. Scripts for grouping the analyzed data using the above function are located in the 'group_ana' folder


Run ‘turning_DLC_GC’ to open the GUI
1. Click 'load_gc' button to load the EVENT file first and then the GCaMP signal. You can get the 
     trial number in the command window.
2. Click 'load video' to load the video
3. Click 'LED read' to read the LED onsets. It may take several minutes. You will get the trial Number of LED onsets in the command window. Make sure this number
   is the same as the trial number in the fiber photometry system. If not, try adjusting LEDthre and then click ‘LED_recheck’. You will get a CSV file
   named ‘trigger_times_led.csv’.
4. Click 'load files' that is located on the right side of 'trigger_times' to load the above LED onsets file 
5. Click 'load files' that is located on the right side of 'location' to load animal positions data from deepLabCut
6. Click 'read_turning' to get turning events. This step may take over one minute.
7. Click ‘turning_gc’ to analyze and plot the data. 
An output file will be saved in the end. Scripts for grouping the analyzed data using the above function are located in the 'group_ana' folder
