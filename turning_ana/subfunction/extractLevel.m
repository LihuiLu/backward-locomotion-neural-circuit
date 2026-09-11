function [ts,stateDur] = extractLevel(inState,Fs,thresh)
inState(1) = 0;% start noise
t = (1:1:length(inState))./Fs;
t = t';
tmpInState = [inState(2:end,:);0];% the first one is 0
dif = tmpInState - inState;
idx1 = dif == 1;
level1 = t(idx1);
idx0 = dif == -1;
level0 = t(idx0);
if length(find(idx1)) ~= length(find(idx0)) % start from 1
    disp('Unequal Level Rise and Down!')
else
    inter =  level1(2:end) - level0(1:end-1);
    idx = inter <= 0.1;% too close of the two trials    
    idx1 = logical([0;idx]);
    level1(idx1) = [];
    idx0 = logical([idx;0]);
    level0(idx0) = [];
    
    inter =  level1(2:end) - level1(1:end-1);
    idx = inter < 2;% too close of the two trials    
    idx1 = logical([0;idx]);
    level1(idx1) = [];
    idx0 = logical([idx;0]);
    level0(idx0) = [];
    
    stateDur = level0 - level1;
end

idx = stateDur < thresh;
if any(idx)
    disp('Signal Under Thresh Excluded')
end
level1(idx) = [];
level0(idx) = [];
stateDur = level0 - level1;

ts.level = repmat([1;0],length(level1),1);
ts.times = sort([level1;level0]); % accending order
ts.Fs = Fs;
ts.len = length(level1);