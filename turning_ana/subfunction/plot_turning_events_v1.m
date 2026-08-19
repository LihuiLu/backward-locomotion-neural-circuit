function [vData] = plot_turning_events_v1(vData)
%GET_TURNING_EVENTS Summary of this function goes here
% Left turns were defined as an angular velocity greater than 200° s−1 within 1 s of 0° s−1. Straight events were defined as an 
% angular velocity that remained at ±20° s−1 for 1 s. Right turns were defined as an angular velocity less than −200° s−1 within 1 s of 0° s−1. 
% Event onset was considered 0° s−1. For endoscopic imaging, the first 20 left turns, 20 straight events and 20 right turns were quantified 
% for each animal. For fiber photometry, the first ten left turns, ten straight events and ten right turns were quantified for each animal.
%ref, Cregg et al. 2024. nature neuroscience

%   Detailed explanation goes here
% centroids = location;
%location column 2 3, nose
%column5 6, body center
%column 8 9,tail base

filename = vData.filename;
cmpp = vData.ppm;  %35x35 chanmber,2026
bin = 1/vData.vidFrameRate;
tn = -vData.pre_stim:bin:vData.post_stim;
angular_v = vData.angular_v;

% movement_start_left = vData.movement_start_left;
% movement_start_straight = vData.movement_start_straight;
% movement_start_right = vData.movement_start_right;
movement_start_left = vData.trigger_times_video_l;
movement_start_straight = vData.trigger_times_video_s;
movement_start_right = vData.trigger_times_video_r;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% left turning
% turning_num = vData.turning_num;
pre_stim = vData.pre_stim;
post_stim = vData.post_stim;
peak_angular_vel_thre = vData.peak_angular_vel_thre;

%add a filter to filter out some trials with mild turning or noise
trigger_times_video1 = movement_start_left;
angular_v_t = [];
angular_v_peak = [];
angular_v_m = [];
for i = 1:length(trigger_times_video1)
   start = trigger_times_video1(i);
   if round(start+post_stim/bin) < vData.trigger_times_video(end)
       angular_v_t = [angular_v_t,angular_v(round(start-pre_stim/bin)-1:round(start+post_stim/bin)-1)];
       angular_v_m = [angular_v_m; mean(angular_v(start:round(start+post_stim/bin)-1))];
       angular_v_peak = [angular_v_peak; min(angular_v(start:round(start+post_stim/bin)-1))];
   end
end
angular_v_t = angular_v_t';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angular_v_t_size = size(angular_v_t);
angular_v_t_mean = mean(angular_v_t,"omitnan");
angular_v_t_sem = std(angular_v_t,"omitnan")/sqrt(angular_v_t_size(1)-1);
assignin('base','angular_v_t_mean',angular_v_t_mean);

vData.angular_v_peak_l = angular_v_peak;
vData.angular_v_t_l = angular_v_t;
vData.angle_mean_l = angular_v_t_mean;
vData.tn = tn;
vData.trigger_times_video_l = trigger_times_video1;
assignin('base','vData',vData);

fig1 = figure;
set(gcf, 'Position',  [1000, 100, 800, 700]); hold on
subplot(2,6,1:5)
drawErrorLine(tn,angular_v_t_mean,angular_v_t_sem,'k',0.2);
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
set(gca,'xLim',[-pre_stim post_stim]);
set(gca,'yLim',vData.y_lim);
set(gca,'xTick',-pre_stim:0.5:post_stim);
% xlabel('Time (s)','FontSize',20,'FontWeight','Bold');
ylabel(['Angular velocity (',char(176),'/s)'],'FontSize',20,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
% line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    [filepath, name, ext] = fileparts(vData.filename);
    filename = [name ext];   % gives 'trial01.mat'
title(filename(1:40),'FontSize',20);
im_filename = [strrep(vData.filename,'.tdms',''),' left angular velocity.png'];
saveas(gcf,im_filename)

if vData.heatmap
    % fig1 = figure;
     subplot(2,6,7:11)
    heatmapPlot(real(vData.angular_v_t_l),bin,vData.pre_stim,0.1,fig1,vData.y_lim);
    set(gca,'YDir','normal')
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
    ylabel('Trial #','FontSize',25,'FontWeight','Bold');
    title('left turning')

    subplot(2,6,12)
    axis off;
    c = colorbar;
    caxis(vData.y_lim);  % Set color axis limits
    c.Label.String = {'angular', 'velocity', '(° s^{-1})'};
    c.Label.Rotation = 360;
    c.Label.VerticalAlignment = "middle";
    c.Label.HorizontalAlignment = "center";
    c.Ticks = vData.y_lim;
    c.TickLabels = string(vData.y_lim);

    im_filename = [strrep(vData.filename,'.tdms',''),' left angular velocity heatmap.png'];
    saveas(gcf,im_filename)
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% right turning
pre_stim = vData.pre_stim;
post_stim = vData.post_stim;

%add a filter to filter out some trials with mild turning or noise
trigger_times_video2= movement_start_right;
angular_v_t = [];
angular_v_peak = [];
angular_v_m = [];
for i = 1:length(trigger_times_video2)
   start = trigger_times_video2(i);
   if round(start+post_stim/bin) < vData.trigger_times_video(end)
       angular_v_t = [angular_v_t,angular_v(round(start-pre_stim/bin)-1:round(start+post_stim/bin)-1)];
       angular_v_m = [angular_v_m; mean(angular_v(start:round(start+post_stim/bin)-1))];
       angular_v_peak = [angular_v_peak; max(angular_v(start:round(start+post_stim/bin)-1))];
   end
end
angular_v_t = angular_v_t';



angular_v_t_size = size(angular_v_t);
angular_v_t_mean = mean(angular_v_t,"omitnan");
angular_v_t_sem = std(angular_v_t,"omitnan")/sqrt(angular_v_t_size(1)-1);
assignin('base','angular_v_t_mean',angular_v_t_mean);

vData.angular_v_peak_r = angular_v_peak;
vData.angular_v_t_r = angular_v_t;
vData.angle_mean_r = angular_v_t_mean;
vData.trigger_times_video_r = trigger_times_video2;
assignin('base','vData',vData);
% %
figure
set(gcf, 'Position',  [1000, 100, 800, 700]); hold on
subplot(2,6,1:5)
drawErrorLine(tn,angular_v_t_mean,angular_v_t_sem,'k',0.2);
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
set(gca,'xLim',[-pre_stim post_stim]);
set(gca,'yLim',vData.y_lim);
set(gca,'xTick',-pre_stim:0.5:post_stim);
% xlabel('Time (s)','FontSize',20,'FontWeight','Bold');
ylabel(['Angular velocity (',char(176),'/s)'],'FontSize',20,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    [filepath, name, ext] = fileparts(vData.filename);
    filename = [name ext];   % gives 'trial01.mat'
title(filename(1:40),'FontSize',20);
im_filename = [strrep(vData.filename,'.tdms',''),' right angular velocity.png'];
saveas(gcf,im_filename)

if vData.heatmap
    subplot(2,6,7:11)
    heatmapPlot(real(vData.angular_v_t_r),bin,vData.pre_stim,0.1,fig1,vData.y_lim);
    % mycmap = [0 0 0.5625;0 0 0.602272748947144;0 0 0.642045438289642;0 0 0.681818187236786;0 0 0.721590936183929;0 0 0.761363625526428;0 0 0.801136374473572;0 0 0.840909063816071;0 0 0.880681812763214;0 0 0.920454561710358;0 0 0.960227251052856;0 0 1;0.0201307199895382 0.0496732033789158 0.995555579662323;0.0402614399790764 0.0993464067578316 0.991111099720001;0.0603921599686146 0.149019613862038 0.986666679382324;0.0805228799581528 0.198692813515663 0.982222199440002;0.100653596222401 0.248366013169289 0.977777779102325;0.120784319937229 0.298039227724075 0.973333358764648;0.140915036201477 0.347712427377701 0.968888878822327;0.161045759916306 0.397385627031326 0.96444445848465;0.181176483631134 0.447058826684952 0.959999978542328;0.201307192444801 0.496732026338577 0.955555558204651;0.22143791615963 0.546405255794525 0.951111137866974;0.241568639874458 0.596078455448151 0.946666657924652;0.261699348688126 0.645751655101776 0.942222237586975;0.281830072402954 0.695424854755402 0.937777757644653;0.301960796117783 0.745098054409027 0.933333337306976;0.383549779653549 0.774891793727875 0.824242413043976;0.465138792991638 0.804685533046722 0.71515154838562;0.546727776527405 0.83447927236557 0.60606062412262;0.628316760063171 0.864272952079773 0.496969699859619;0.709905803203583 0.894066691398621 0.387878775596619;0.791494786739349 0.923860430717468 0.278787881135941;0.873083770275116 0.953654170036316 0.169696971774101;0.904812812805176 0.965240597724915 0.127272725105286;0.93654191493988 0.976827085018158 0.0848484858870506;0.96827095746994 0.988413572311401 0.0424242429435253;1 1 0;1 0.941176474094391 0;1 0.882352948188782 0;1 0.823529422283173 0;1 0.764705896377563 0;1 0.705882370471954 0;1 0.647058844566345 0;1 0.588235318660736 0;1 0.529411792755127 0;1 0.470588237047195 0;1 0.411764711141586 0;1 0.352941185235977 0;1 0.294117659330368 0;1 0.235294118523598 0;1 0.176470592617989 0;1 0.117647059261799 0;1 0.0588235296308994 0;1 0 0;0.944444417953491 0 0;0.888888895511627 0 0;0.833333313465118 0 0;0.777777791023254 0 0;0.722222208976746 0 0;0.666666686534882 0 0;0.611111104488373 0 0;0.555555582046509 0 0;0.5 0 0];
    % set(gcf,'Colormap',mycmap)
    set(gca,'YDir','normal')
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
    ylabel('Trial #','FontSize',25,'FontWeight','Bold');
    title('right turning')

    subplot(2,6,12)
    axis off;
    c = colorbar;
    caxis(vData.y_lim);  % Set color axis limits
    c.Label.String = {'angular', 'velocity', '(° s^{-1})'};
    c.Label.Rotation = 360;
    c.Label.VerticalAlignment = "middle";
    c.Label.HorizontalAlignment = "center";
    c.Ticks = vData.y_lim;
    c.TickLabels = string(vData.y_lim);

    im_filename = [strrep(vData.filename,'.tdms',''),' right angular velocity heatmap.png'];
    saveas(gcf,im_filename)
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% straight

%add a filter to filter out some trials with mild turning or noise
trigger_times_video3 = movement_start_straight;
angular_v_t = [];
angular_v_peak = [];
angular_v_m = [];
for i = 1:length(trigger_times_video3)
   start = trigger_times_video3(i);
   if round(start+post_stim/bin) < vData.trigger_times_video(end)
       angular_v_t = [angular_v_t,angular_v(round(start-pre_stim/bin)-1:round(start+post_stim/bin)-1)];
       angular_v_m = [angular_v_m; mean(angular_v(start:round(start+post_stim/bin)-1))];
       angular_v_peak = [angular_v_peak; max(angular_v(start:round(start+post_stim/bin)-1))];
   end
end
angular_v_t = angular_v_t';


angular_v_t_size = size(angular_v_t);
angular_v_t_mean = mean(angular_v_t,"omitnan");
angular_v_t_sem = std(angular_v_t,"omitnan")/sqrt(angular_v_t_size(1)-1);
assignin('base','angular_v_t_mean',angular_v_t_mean);

vData.angular_v_peak_s = angular_v_peak;
vData.angular_v_t_s = angular_v_t;
vData.angle_mean_s = angular_v_t_mean;
vData.tn = tn;
vData.trigger_times_video_s = trigger_times_video3;
assignin('base','vData',vData);

figure
set(gcf, 'Position',  [1000, 100, 800, 700]); hold on
subplot(2,6,1:5)
drawErrorLine(tn,angular_v_t_mean,angular_v_t_sem,'k',0.2);
set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
set(gca,'xLim',[-pre_stim post_stim]);
set(gca,'yLim',vData.y_lim);
set(gca,'xTick',-pre_stim:0.5:post_stim);
% xlabel('Time (s)','FontSize',20,'FontWeight','Bold');
ylabel(['Angular velocity (',char(176),'/s)'],'FontSize',20,'FontWeight','Bold');
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
% line([xP2 xP2],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
    [filepath, name, ext] = fileparts(vData.filename);
    filename = [name ext];   % gives 'trial01.mat'
title(filename(1:40),'FontSize',15);
im_filename = [strrep(vData.filename,'.tdms',''),' straight event angular velocity.png'];
saveas(gcf,im_filename)

if vData.heatmap
    subplot(2,6,7:11)
    heatmapPlot(real(vData.angular_v_t_s),bin,vData.pre_stim,0.1,fig1,vData.y_lim);
    % mycmap = [0 0 0.5625;0 0 0.602272748947144;0 0 0.642045438289642;0 0 0.681818187236786;0 0 0.721590936183929;0 0 0.761363625526428;0 0 0.801136374473572;0 0 0.840909063816071;0 0 0.880681812763214;0 0 0.920454561710358;0 0 0.960227251052856;0 0 1;0.0201307199895382 0.0496732033789158 0.995555579662323;0.0402614399790764 0.0993464067578316 0.991111099720001;0.0603921599686146 0.149019613862038 0.986666679382324;0.0805228799581528 0.198692813515663 0.982222199440002;0.100653596222401 0.248366013169289 0.977777779102325;0.120784319937229 0.298039227724075 0.973333358764648;0.140915036201477 0.347712427377701 0.968888878822327;0.161045759916306 0.397385627031326 0.96444445848465;0.181176483631134 0.447058826684952 0.959999978542328;0.201307192444801 0.496732026338577 0.955555558204651;0.22143791615963 0.546405255794525 0.951111137866974;0.241568639874458 0.596078455448151 0.946666657924652;0.261699348688126 0.645751655101776 0.942222237586975;0.281830072402954 0.695424854755402 0.937777757644653;0.301960796117783 0.745098054409027 0.933333337306976;0.383549779653549 0.774891793727875 0.824242413043976;0.465138792991638 0.804685533046722 0.71515154838562;0.546727776527405 0.83447927236557 0.60606062412262;0.628316760063171 0.864272952079773 0.496969699859619;0.709905803203583 0.894066691398621 0.387878775596619;0.791494786739349 0.923860430717468 0.278787881135941;0.873083770275116 0.953654170036316 0.169696971774101;0.904812812805176 0.965240597724915 0.127272725105286;0.93654191493988 0.976827085018158 0.0848484858870506;0.96827095746994 0.988413572311401 0.0424242429435253;1 1 0;1 0.941176474094391 0;1 0.882352948188782 0;1 0.823529422283173 0;1 0.764705896377563 0;1 0.705882370471954 0;1 0.647058844566345 0;1 0.588235318660736 0;1 0.529411792755127 0;1 0.470588237047195 0;1 0.411764711141586 0;1 0.352941185235977 0;1 0.294117659330368 0;1 0.235294118523598 0;1 0.176470592617989 0;1 0.117647059261799 0;1 0.0588235296308994 0;1 0 0;0.944444417953491 0 0;0.888888895511627 0 0;0.833333313465118 0 0;0.777777791023254 0 0;0.722222208976746 0 0;0.666666686534882 0 0;0.611111104488373 0 0;0.555555582046509 0 0;0.5 0 0];
    % set(gcf,'Colormap',mycmap)
    set(gca,'YDir','normal')
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
    ylabel('Trial #','FontSize',25,'FontWeight','Bold');
    title('straight')

    subplot(2,6,12)
    axis off;
    c = colorbar;
    caxis(vData.y_lim);  % Set color axis limits
    c.Label.String = {'angular', 'velocity', '(° s^{-1})'};
    c.Label.Rotation = 360;
    c.Label.VerticalAlignment = "middle";
    c.Label.HorizontalAlignment = "center";
    c.Ticks = vData.y_lim;
    c.TickLabels = string(vData.y_lim);

    im_filename = [strrep(vData.filename,'.tdms',''),' straight event velocity heatmap.png'];
    saveas(gcf,im_filename)
end





end

