function [vData] = get_halt_events_v1(vData)
%GET_TURNING_EVENTS Summary of this function goes here

centroids = [vData.centroids(:,1) vData.centroids(:,2)];
vidFrameRate = vData.vidFrameRate;
bin = 1/vidFrameRate;
ppm = vData.ppm;

% caculate speed & update centroids
tmpCentroids = centroids(2:length(centroids),:);
tmpCentroids = [tmpCentroids;centroids(length(centroids),:)];
diff = tmpCentroids-centroids;% the last one is 0
dist = diff(:,1).*diff(:,1)+diff(:,2).*diff(:,2);
speedT = sqrt(dist(:));
speed = smooth(speedT/bin)*ppm;
assignin('base','speed2',speed);
vData.speed=speed;





%% find transitions

static_threshold_halt = 1;
static_threshold_baseline = 3;
movement_minimum_duration = vData.pre_stim*vData.vidFrameRate;
movement_speed_threshold = 2;
%initialize head movement arrays
movement_amplitude = zeros(size(speed));
movement_length = zeros(size(speed));
movement_start_halt = [];

previous_movement_end = 0;
for CURRENT_FRAME = 3*movement_minimum_duration:numel(speed)

    % Velocity must exceed movement_speed_threshold and remain in the same direction for a period of time (movement_minimum_duration)
    if all(abs(speed(CURRENT_FRAME-movement_minimum_duration+1:CURRENT_FRAME)) <static_threshold_halt) && numel(unique(sign(speed(CURRENT_FRAME-movement_minimum_duration+1:CURRENT_FRAME))))==1 
         % find movement onset,halt
        tmp_movement_start = CURRENT_FRAME - movement_minimum_duration+1;
        if tmp_movement_start > 1
            for j = 1:1:100
                % keep advancing backward in time until speed falls to movement_speed_threshold
                if tmp_movement_start - j > 1 &&  abs(speed(tmp_movement_start - j)) > movement_speed_threshold
                    continue;
                else
                    break;
                end
            end
            tmp_movement_start = tmp_movement_start - j;
            if mean(abs(speed(tmp_movement_start-movement_minimum_duration+1:tmp_movement_start+1))) > static_threshold_baseline && tmp_movement_start > previous_movement_end+1*vData.vidFrameRate 
                movement_start_halt = vertcat(movement_start_halt,tmp_movement_start+1);
            end
        end


        % find movement offset
        tmp_movement_end = CURRENT_FRAME;
        if tmp_movement_end < numel(speed)
            for j = 1:1:100
                % keep advancing forward in time until speed falls to movement_speed_threshold
                if tmp_movement_end + j < numel(speed) &&  abs(speed(tmp_movement_end + j)) > movement_speed_threshold
                    continue;
                else
                    break;
                end
            end
            tmp_movement_end = tmp_movement_end + j;
        end
        
        % make sure there's no overlab between movements and save movement amplitude/length 
        if tmp_movement_start > previous_movement_end
            movement_amplitude(tmp_movement_start) = speed(tmp_movement_end) - speed(tmp_movement_start);
            movement_length(tmp_movement_start) = tmp_movement_end - tmp_movement_start;

            previous_movement_end = tmp_movement_end;
        end
        
    end
    
end

vData.movement_amplitude_all = movement_amplitude;
vData.movement_length_all = movement_length;
vData.movement_start_halt = unique(movement_start_halt);




fprintf('number of movement_start_halt is %d\n', length(movement_start_halt));


if length(vData.movement_start_halt) > vData.turning_num 
    % vData.movement_start_halt = vData.movement_start_halt(24:23+vData.turning_num);
    vData.movement_start_halt = vData.movement_start_halt(1:vData.turning_num);
end







end

