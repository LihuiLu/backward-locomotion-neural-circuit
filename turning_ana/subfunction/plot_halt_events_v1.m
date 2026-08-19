function [vData] = plot_halt_events_v1(vData)
%GET_TURNING_EVENTS Summary of this function goes here


filename = vData.filename;
cmpp = vData.ppm;  %35x35 chanmber,2026
bin = 1/vData.vidFrameRate;
tn = -vData.pre_stim:bin:vData.post_stim;
speed = vData.speed;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% halt
% turning_num = vData.turning_num;
pre_stim = vData.pre_stim;
post_stim = vData.post_stim;


trigger_times_video1 = vData.trigger_times_video_h;
speed_t = [];
for i = 1:length(trigger_times_video1)
   start = trigger_times_video1(i);
   if round(start+post_stim/bin) < vData.trigger_times_video(end)
       speed_t = [speed_t,speed(round(start-pre_stim/bin)-1:round(start+post_stim/bin)-1)];

   end
end
speed_t = speed_t';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
speed_t_size = size(speed_t);
speed_t_mean = mean(speed_t,"omitnan");
speed_t_sem = std(speed_t,"omitnan")/sqrt(speed_t_size(1)-1);
assignin('base','speed_t_mean',speed_t_mean);

vData.speed_t = speed_t;
vData.speed_mean = speed_t_mean;
vData.tn = tn;
vData.trigger_times_video_h = trigger_times_video1;
assignin('base','vData',vData);

fig1 = figure;
set(gcf, 'Position',  [1000, 100, 800, 700]); hold on
subplot(2,6,1:5)
drawErrorLine(tn,speed_t_mean,speed_t_sem,'k',0.2);
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
set(gca,'xLim',[-pre_stim post_stim]);
set(gca,'yLim',vData.y_lim);
set(gca,'xTick',-pre_stim:0.5:post_stim);
% xlabel('Time (s)','FontSize',20,'FontWeight','Bold');
ylabel(['Speed (cm/s)'],'FontSize',20,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
% line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    [filepath, name, ext] = fileparts(vData.filename);
    filename = [name ext];   % gives 'trial01.mat'
title(filename(1:40),'FontSize',20);
im_filename = [strrep(vData.filename,'.tdms',''),' velocity.png'];
saveas(gcf,im_filename)

if vData.heatmap
    % fig1 = figure;
     subplot(2,6,7:11)
    heatmapPlot(real(vData.speed_t),bin,vData.pre_stim,0.1,fig1,vData.y_lim);
    set(gca,'YDir','normal')
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
    ylabel('Trial #','FontSize',25,'FontWeight','Bold');
    % title('left turning')

    subplot(2,6,12)
    axis off;
    c = colorbar;
    caxis(vData.y_lim);  % Set color axis limits
    c.Label.String = {'Speed', '(cm/s)'};
    c.Label.Rotation = 360;
    c.Label.VerticalAlignment = "middle";
    c.Label.HorizontalAlignment = "center";
    c.Ticks = vData.y_lim;
    c.TickLabels = string(vData.y_lim);

    im_filename = [strrep(vData.filename,'.tdms',''),' velocity heatmap.png'];
    saveas(gcf,im_filename)
end










end

