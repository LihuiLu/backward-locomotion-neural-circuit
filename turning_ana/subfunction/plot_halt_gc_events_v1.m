function [vData] = plot_halt_gc_events_v1(vData)
%GET_TURNING_EVENTS Summary of this function goes here
interval = vData.interval;
values= vData.values;
pre_time= vData.pre_time;
post_time= vData.post_time;
control_time(1)= vData.control_time(1);
control_time(2)= vData.control_time(2);
current_offset= vData.current_offset;
z_score = 1;
%% get psth data, left turning
assignin('base','values',values);
[psth1,psth1_mean,psth1_sem] = psth_wave2(vData.trigger1_times_photometry,interval,values,pre_time,post_time,control_time(1),control_time(2),current_offset,z_score);
times = -pre_time:interval:post_time;
assignin('base','a_psth1',psth1);
assignin('base','times',times);

%%
fig1=figure;
set(gcf, 'Position',  [200, 100, 800, 700]); hold on
subplot(2,6,1:5)
drawErrorLine(times,psth1_mean,psth1_sem,[0.3333 0.6275 0.9843],0.7);
set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
% xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
set(gca,'Tickdir','out');
xlim([-pre_time post_time]);
set(gca,'yLim',vData.clims);
if z_score==1
    ylabel('z-score','FontSize',25,'FontWeight','Bold');
else
    ylabel('deltaF/F(%)','FontSize',25,'FontWeight','Bold');
end
xP = 0;
line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
[pathstr, name, ext] = fileparts(vData.filename);
title(name)
% im_filename = [strrep(vData.filename,'.tdms',''),' left turning gcamp.png'];
% saveas(gcf,im_filename)

if vData.heatmap
    subplot(2,6,7:11)
    heatmapPlot(psth1,interval,pre_time,0.1,fig1,vData.clims,5);
    % mycmap = [0 0 0.5625;0 0 0.602272748947144;0 0 0.642045438289642;0 0 0.681818187236786;0 0 0.721590936183929;0 0 0.761363625526428;0 0 0.801136374473572;0 0 0.840909063816071;0 0 0.880681812763214;0 0 0.920454561710358;0 0 0.960227251052856;0 0 1;0.0201307199895382 0.0496732033789158 0.995555579662323;0.0402614399790764 0.0993464067578316 0.991111099720001;0.0603921599686146 0.149019613862038 0.986666679382324;0.0805228799581528 0.198692813515663 0.982222199440002;0.100653596222401 0.248366013169289 0.977777779102325;0.120784319937229 0.298039227724075 0.973333358764648;0.140915036201477 0.347712427377701 0.968888878822327;0.161045759916306 0.397385627031326 0.96444445848465;0.181176483631134 0.447058826684952 0.959999978542328;0.201307192444801 0.496732026338577 0.955555558204651;0.22143791615963 0.546405255794525 0.951111137866974;0.241568639874458 0.596078455448151 0.946666657924652;0.261699348688126 0.645751655101776 0.942222237586975;0.281830072402954 0.695424854755402 0.937777757644653;0.301960796117783 0.745098054409027 0.933333337306976;0.383549779653549 0.774891793727875 0.824242413043976;0.465138792991638 0.804685533046722 0.71515154838562;0.546727776527405 0.83447927236557 0.60606062412262;0.628316760063171 0.864272952079773 0.496969699859619;0.709905803203583 0.894066691398621 0.387878775596619;0.791494786739349 0.923860430717468 0.278787881135941;0.873083770275116 0.953654170036316 0.169696971774101;0.904812812805176 0.965240597724915 0.127272725105286;0.93654191493988 0.976827085018158 0.0848484858870506;0.96827095746994 0.988413572311401 0.0424242429435253;1 1 0;1 0.941176474094391 0;1 0.882352948188782 0;1 0.823529422283173 0;1 0.764705896377563 0;1 0.705882370471954 0;1 0.647058844566345 0;1 0.588235318660736 0;1 0.529411792755127 0;1 0.470588237047195 0;1 0.411764711141586 0;1 0.352941185235977 0;1 0.294117659330368 0;1 0.235294118523598 0;1 0.176470592617989 0;1 0.117647059261799 0;1 0.0588235296308994 0;1 0 0;0.944444417953491 0 0;0.888888895511627 0 0;0.833333313465118 0 0;0.777777791023254 0 0;0.722222208976746 0 0;0.666666686534882 0 0;0.611111104488373 0 0;0.555555582046509 0 0;0.5 0 0];
    % set(gcf,'Colormap',mycmap)
    set(gca,'YDir','normal')
    set(gca,'LineWidth',3,'FontSize',20,'FontWeight','Bold','TickDir','in');
    xlabel('Time (s)','FontSize',25,'FontWeight','Bold');
    ylabel('Trial #','FontSize',25,'FontWeight','Bold');
    box off
    % title('left turning gcamp')

    subplot(2,6,12)
    axis off;
    c = colorbar;
    caxis(vData.clims);  % Set color axis limits
    c.Label.String = {'z-score'};
    % c.Label.Rotation = 360;
    c.Label.VerticalAlignment = "middle";
    c.Label.HorizontalAlignment = "center";
    c.Ticks = vData.clims;
    c.TickLabels = string(vData.clims);

    im_filename = [strrep(vData.filename,'.tdms',''),' gcamp signal heatmap.png'];
    saveas(gcf,im_filename)
end

%% save results for grouping
vData.times = times;
vData.psth1 = psth1;
vData.psth1_mean = psth1_mean;
vData.psth1_sem = psth1_sem;








end

