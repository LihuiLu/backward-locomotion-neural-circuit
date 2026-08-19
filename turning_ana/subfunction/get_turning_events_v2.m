function [vData] = get_turning_events_v2(location,vData)
%GET_TURNING_EVENTS Summary of this function goes here
% Left turns were defined as an angular velocity greater than 200° s−1 within 1 s of 0° s−1. Straight events were defined as an 
% angular velocity that remained at ±20° s−1 for 1 s. Right turns were defined as an angular velocity less than −200° s−1 within 1 s of 0° s−1. 
% Event onset was considered 0° s−1. For endoscopic imaging, the first 20 left turns, 20 straight events and 20 right turns were quantified 
% for each animal. For fiber photometry, the first ten left turns, ten straight events and ten right turns were quantified for each animal.
%ref, Cregg et al. 2024. nature neuroscience

%   Detailed explanation goes here
centroids = location;
%location column 2 3, nose
%column5 6, body center
%column 8 9,tail base

filename = vData.filename;
cmpp = vData.ppm;  %room 148  45x45 chanmber
bin = 1/vData.vidFrameRate;
tn = -vData.pre_stim:bin:vData.post_stim;
turning_num = vData.turning_num;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  raw trace
% figure;
% % plot(centroids(:,2), centroids(:,3),'Color','r','LineWidth',0.8); hold on;
% plot(centroids(:,5), centroids(:,6),'Color','k','LineWidth',0.8); hold on;
% % plot(centroids(:,8), centroids(:,9),'Color','b','LineWidth',0.8); hold on;
% set(gca, 'xlim', [0 640], 'ylim', [0 480], 'YDir', 'reverse');
% set(gca,'FontSize',15,'LineWidth',3,'FontWeight','Bold');
% % legend('nose','body','tail','')
% legend('body','')
% xlabel('X (pixel)','FontName','Arial','FontSize',20,'FontWeight','Bold');
% ylabel('Y (pixel)','FontName','Arial','FontSize',20,'FontWeight','Bold');
% % title(strrep(vData.filename,'tdms','mat'));
% im_filename = [strrep(vData.filename,'.tdms',''),' all tracks.png'];
% saveas(gcf,im_filename)



%% angular speed  %ipsilateral turning
temp_centroids = centroids;
s = size(temp_centroids);
angles1 = zeros(s(1)-1,1);
temp = zeros(s(1)-1,2);
for p = 1:s(1)-1
    A = temp_centroids(p,2:3)-temp_centroids(p,8:9);
    B = temp_centroids(p+1,2:3)- temp_centroids(p+1,8:9);
%         由每一帧的 质心点→鼻尖点 确定本帧的向量，相邻两帧向量夹角差 【(后帧-前帧)/单位时间(0.05 s)】为一个瞬时角速度点，整个图共180个瞬时角速度点。
%         angle_temp = acos(A*B'/norm(A)/norm(B));
    % Compute dot product and magnitudes
    dot_product = dot(A, B);
    magnitude_product = norm(A) * norm(B);
    % Calculate angle in radians
    angle_temp = acos(dot_product / magnitude_product);
    angles1(p) = angle_temp;
    temp(p,1:4) = [temp_centroids(p,2:3), temp_centroids(p,8:9)];
end
temp(p+1,1:4) = [temp_centroids(p+1,2:3), temp_centroids(p+1,8:9)];%save the last frame
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%define the direction of the angle---------------------
dir1 = temp(:,1:2)-temp(:,3:4); %nose-body
dir2 = atan2d(dir1(:,2),dir1(:,1));%Four-quadrant inverse tangent in degrees
dir2_df = diff(dir2);

if vData.left
    dir2_decrease = find(dir2_df<0);
    angles1(dir2_decrease) = -angles1(dir2_decrease);
    assignin('base','dir2_decrease',dir2_decrease);
else
    dir2_increase = find(dir2_df>0);
    angles1(dir2_increase) = -angles1(dir2_increase);
    assignin('base','dir2_increase',dir2_increase);
end
assignin('base','temp',temp);  
assignin('base','dir2_df',dir2_df);    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angles = angles1;
angles = rad2deg(angles); %the unit is degree
angular_v = angles/bin;    %degree/s
vData.dir2_df = dir2_df;
vData.angular_v = angular_v;
vData.angles = angles;





%% find transitions

static_threshold_straight = 20;
static_threshold_baseline = 50;
movement_minimum_duration = vData.pre_stim*vData.vidFrameRate;
movement_angular_v_threshold = vData.peak_angular_vel_thre;
%initialize head movement arrays
movement_amplitude = zeros(size(angular_v));
movement_length = zeros(size(angular_v));
movement_start_left = [];
movement_start_right = [];
movement_start_straight = [];

previous_movement_end = 0;
for CURRENT_FRAME = 3*movement_minimum_duration:numel(angular_v)

    % Velocity must exceed movement_angular_v_threshold and remain in the same direction for a period of time (movement_minimum_duration)
    if all(angular_v(CURRENT_FRAME-movement_minimum_duration+1:CURRENT_FRAME) < -movement_angular_v_threshold) && numel(unique(sign(angular_v(CURRENT_FRAME-movement_minimum_duration+1:CURRENT_FRAME))))==1 
        
        % find movement onset,left
        tmp_movement_start = CURRENT_FRAME - movement_minimum_duration+1;
        if tmp_movement_start > 1
            for j = 1:1:100
                % keep advancing backward in time until angular_v sign switches or angular_v falls to 20% of movement_angular_v_threshold
                if tmp_movement_start - j > 1 && sign(angular_v(tmp_movement_start - j)) == sign(angular_v(tmp_movement_start)) && abs(angular_v(tmp_movement_start - j)) >movement_angular_v_threshold/5
                    continue;
                else
                    break;
                end
            end
            tmp_movement_start = tmp_movement_start - j;
            if max(abs(angular_v(tmp_movement_start-movement_minimum_duration+1:tmp_movement_start+1))) < static_threshold_baseline 
                movement_start_left = vertcat(movement_start_left,tmp_movement_start+1);
            end
        end


    elseif all(angular_v(CURRENT_FRAME-movement_minimum_duration+1:CURRENT_FRAME) > movement_angular_v_threshold) && numel(unique(sign(angular_v(CURRENT_FRAME-movement_minimum_duration+1:CURRENT_FRAME))))==1 
        % find movement onset,right
        tmp_movement_start = CURRENT_FRAME - movement_minimum_duration+1;
        if tmp_movement_start > 1
            for j = 1:1:100
                % keep advancing backward in time until angular_v sign switches or angular_v falls to 20% of movement_angular_v_threshold
                if tmp_movement_start - j > 1 && sign(angular_v(tmp_movement_start - j)) == sign(angular_v(tmp_movement_start)) && abs(angular_v(tmp_movement_start - j)) > movement_angular_v_threshold/5
                    continue;
                else
                    break;
                end
            end
            tmp_movement_start = tmp_movement_start - j;
            if max(abs(angular_v(tmp_movement_start-movement_minimum_duration+1:tmp_movement_start+1))) < static_threshold_baseline 
                movement_start_right = vertcat(movement_start_right,tmp_movement_start+1);
            end
        end

    elseif all(abs(angular_v(CURRENT_FRAME-movement_minimum_duration+1:CURRENT_FRAME)) <static_threshold_straight) && numel(unique(sign(angular_v(CURRENT_FRAME-movement_minimum_duration+1:CURRENT_FRAME))))==1 
         % find movement onset,straight
        tmp_movement_start = CURRENT_FRAME - movement_minimum_duration+1;
        if tmp_movement_start > 1
            for j = 1:1:100
                % keep advancing backward in time until angular_v sign switches or angular_v falls to 20% of movement_angular_v_threshold
                if tmp_movement_start - j > 1 && sign(angular_v(tmp_movement_start - j)) == sign(angular_v(tmp_movement_start)) && abs(angular_v(tmp_movement_start - j)) > movement_angular_v_threshold/5
                    continue;
                else
                    break;
                end
            end
            tmp_movement_start = tmp_movement_start - j;
            if max(abs(angular_v(tmp_movement_start-movement_minimum_duration+1:tmp_movement_start+1))) < static_threshold_baseline && tmp_movement_start > previous_movement_end+1*vData.vidFrameRate 
                movement_start_straight = vertcat(movement_start_straight,tmp_movement_start+1);
            end
        end


        % find movement offset
        tmp_movement_end = CURRENT_FRAME;
        if tmp_movement_end < numel(angular_v)
            for j = 1:1:100
                % keep advancing forward in time until angular_v sign switches or angular_v falls to 20% of movement_angular_v_threshold
                if tmp_movement_end + j < numel(angular_v) && sign(angular_v(tmp_movement_end + j)) == sign(angular_v(tmp_movement_end)) && abs(angular_v(tmp_movement_end + j)) > movement_angular_v_threshold/5
                    continue;
                else
                    break;
                end
            end
            tmp_movement_end = tmp_movement_end + j;
        end
        
        % make sure there's no overlab between movements and save movement amplitude/length 
        if tmp_movement_start > previous_movement_end
            movement_amplitude(tmp_movement_start) = angular_v(tmp_movement_end) - angular_v(tmp_movement_start);
            movement_length(tmp_movement_start) = tmp_movement_end - tmp_movement_start;

            previous_movement_end = tmp_movement_end;
        end
        
    end
    
end

vData.movement_amplitude_all = movement_amplitude;
vData.movement_length_all = movement_length;
vData.movement_start_left = unique(movement_start_left);
vData.movement_start_straight = unique(movement_start_straight);
vData.movement_start_right = unique(movement_start_right);


fprintf('number of movement_start_left is %d\n', length(movement_start_left));
fprintf('number of movement_start_right is %d\n', length(movement_start_right));
fprintf('number of movement_start_straight is %d\n', length(movement_start_straight));

if length(vData.movement_start_left) > turning_num 
    vData.movement_start_left = vData.movement_start_left(1:turning_num);
end
if length(vData.movement_start_right) > turning_num 
    vData.movement_start_right = vData.movement_start_right(1:turning_num);
end
if length(vData.movement_start_straight) > turning_num 
    vData.movement_start_straight = vData.movement_start_straight(1:turning_num);
end
%% plot angular velocity and transitions
% figure;
% plot(1:length(angular_v),angular_v);hold on
% % for i = 1:length(vData.trigger_times_video)
% %     xP = vData.trigger_times_video(i);
% %     line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
% % end
% for i = 1:length(vData.movement_start_left)
%     xP = vData.movement_start_left(i,1);
%     line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[1 0 0],'LineWidth',3);
% end
% for i = 1:length(vData.movement_start_right)
%     xP = vData.movement_start_right(i,1);
%     line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 1 0.2],'LineWidth',3);
% end
% for i = 1:length(vData.movement_start_straight)
%     xP = vData.movement_start_straight(i,1);
%     line([xP xP],get(gca,'YLim'),'LineStyle',':','Color',[0 0 0],'LineWidth',3);
% end
% set(gca,'LineWidth',3,'FontSize',20,'TickDir','out');
% set(gca,'xLim',[1 length(angular_v)],'yLim',[-500 500]);
% set(gca,'xTick',0:100/bin:length(angular_v),'xTicklabel',0:100:length(angular_v)*bin);
% xlabel('Time (s)','FontSize',20,'FontWeight','Bold');
% ylabel(['Angular speed (',char(176),'/s)'],'FontSize',20,'FontWeight','Bold');
% legend('','red left','green right','black straight','location','eastoutside')
% im_filename = [strrep(vData.filename,'.tdms',''),' angular velocity.png'];
% saveas(gcf,im_filename)






end

