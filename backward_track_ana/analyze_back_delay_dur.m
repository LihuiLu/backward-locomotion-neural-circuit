%% ================================================================
%% Batch-read event-duration Excel files and pool results into one struct
%% ================================================================
%
% Expected file layout (Sheet1):
%   Col 1        = trial number
%   Col 2        = trial onset value
%   Col 3, 4     = event 1 start, end
%   Col 5, 6     = event 2 start, end
%   Col 7, 8     = event 3 start, end
%   ...          = additional event pairs, as many as the file has
%   Missing / empty cells = that event didn't happen on that trial
%
% For each trial (row), this script computes:
%   - duration = even_col - odd_col, for every available event pair,
%     skipping any pair where either value is missing (NaN), since
%     "sometimes there is no event".
%   - delay = col3 - col2 (time from trial onset to the first event's
%     start), NaN if the trial had no event at all.
%
% Output:
%   allResults      - 1 x nFiles struct array, one entry per file, with:
%                        .filename        - file name
%                        .nTrials         - number of trial rows
%                        .nEventPairs     - number of event-pairs in this file
%                        .durationMatrix  - nTrials x nEventPairs, NaN where no event
%                        .durationsByTrial- 1 x nTrials cell, each cell = vector of
%                                           valid (non-NaN) durations for that trial
%                        .delay           - nTrials x 1, = col3 - col2, NaN if no event
%   pooledDurations - single cell array combining EVERY trial's valid
%                      duration vector across ALL files (one cell per trial,
%                      concatenated across files, in file-then-trial order)
%   pooledAllValues - single numeric vector of every individual valid
%                      duration value across all files/trials (flat pool)
%   pooledDelays     - single cell array combining EVERY trial's delay value
%                      across ALL files (one cell per trial; mirrors
%                      pooledDurations in structure/order; empty cell if no event)
%   pooledAllDelays  - single numeric vector of every valid delay value
%                      across all files/trials (flat pool, mirrors pooledAllValues)

clear; clc;

%% --- Settings ---
folderPath = pwd;  
filePattern = fullfile(folderPath, '*.xlsx');

fileList = dir(filePattern);
% Ignore Excel temp/lock files (start with '~$')
fileList = fileList(~startsWith({fileList.name}, '~$'));

nFiles = numel(fileList);
fprintf('Found %d Excel file(s) in: %s\n', nFiles, folderPath);

%% --- Storage ---
allResults = struct('filename', {}, 'nTrials', {}, 'nEventPairs', {}, ...
    'durationMatrix', {}, 'durationsByTrial', {}, 'delay', {});

pooledDurations = {};   % grows across all files/trials
pooledAllValues = [];   % flat vector of every valid duration value
pooledDelays    = {};   % grows across all files/trials (mirrors pooledDurations)
pooledAllDelays = [];   % flat vector of every valid delay value

%% --- Process each file ---
for f = 1:nFiles
    fname = fileList(f).name;
    fpath = fullfile(fileList(f).folder, fname);
    fprintf('  [%d/%d] Reading %s ... ', f, nFiles, fname);

    try
        data = readmatrix(fpath, 'Sheet', 1);
    catch ME
        fprintf('FAILED to read (%s)\n', ME.message);
        continue;
    end

    if isempty(data) || size(data, 2) < 4
        fprintf('skipped (fewer than 4 columns, no event pairs present)\n');
        continue;
    end

    nCols = size(data, 2);
    nTrials = size(data, 1);

    % --- number of event pairs available after column 2 ---
    nEventPairs = floor((nCols - 2) / 2);

    durationMatrix = nan(nTrials, nEventPairs);
    for p = 1:nEventPairs
        oddCol  = 2 + 2*p - 1;   % 3, 5, 7, ...
        evenCol = 2 + 2*p;       % 4, 6, 8, ...
        durationMatrix(:, p) = data(:, evenCol) - data(:, oddCol);
    end

    % --- delay = col3 (first event start) - col2 (trial onset) ---
    delay = data(:, 3) - data(:, 2);   % nTrials x 1, NaN if trial had no event

    % --- per-trial cell of valid (non-NaN) durations ---
    durationsByTrial = cell(1, nTrials);
    for t = 1:nTrials
        rowVals = durationMatrix(t, :);
        durationsByTrial{t} = rowVals(~isnan(rowVals));
    end

    % --- per-trial cell of delay values (mirrors durationsByTrial structure) ---
    delayByTrial = cell(1, nTrials);
    for t = 1:nTrials
        if ~isnan(delay(t))
            delayByTrial{t} = delay(t);
        else
            delayByTrial{t} = [];   % no event on this trial -> no delay value
        end
    end

    % --- store per-file result ---
    allResults(end+1) = struct( ...                                    %#ok<SAGROW>
        'filename', fname, ...
        'nTrials', nTrials, ...
        'nEventPairs', nEventPairs, ...
        'durationMatrix', durationMatrix, ...
        'durationsByTrial', {durationsByTrial}, ...
        'delay', delay);

    % --- pool into the combined outputs ---
    pooledDurations = [pooledDurations, durationsByTrial];              %#ok<AGROW>
    pooledAllValues = [pooledAllValues, [durationsByTrial{:}]];         %#ok<AGROW>
    pooledDelays    = [pooledDelays, delayByTrial];                     %#ok<AGROW>
    pooledAllDelays = [pooledAllDelays, delay(~isnan(delay))'];         %#ok<AGROW>

    fprintf('done. %d trials, %d event pair(s).\n', nTrials, nEventPairs);
end

%% --- Summary ---
fprintf('\n=== Summary ===\n');
fprintf('Total files processed : %d\n', numel(allResults));
fprintf('Total trials pooled   : %d\n', numel(pooledDurations));
fprintf('Total event durations : %d\n', numel(pooledAllValues));
fprintf('Total delay values    : %d\n', numel(pooledAllDelays));

%% --- Save results ---
save('pooled_event_durations.mat', 'allResults', 'pooledDurations', 'pooledAllValues', ...
    'pooledDelays', 'pooledAllDelays');
fprintf('\nSaved results to pooled_event_durations.mat\n');



%% plot
%% ================================================================
%% Plot distribution of pooledDurations
%% ================================================================
% Assumes pooled_event_durations.mat (from pool_event_durations.m)
% has already been generated and contains: pooledDurations

clear; clc;
framerate = 20;
% % --- Load pooled results ---
load('pooled_event_durations_ctr_pre_dt.mat', 'pooledDelays');

% % --- Flatten pooledDelays (cell array of per-trial vectors) into one vector ---
allDurations = [pooledDelays{:}]/framerate;
allDurations = allDurations(~isnan(allDurations));   % safety: drop any stray NaNs

fprintf('Total events pooled: %d\n', numel(allDurations));
fprintf('Mean = %.2f | Median = %.2f | SD = %.2f | Min = %.2f | Max = %.2f\n', ...
    mean(allDurations), median(allDurations), std(allDurations), ...
    min(allDurations), max(allDurations));

figure('Name', 'Distribution with Density Overlay and Boxplot');
histogram(allDurations, 'Normalization', 'pdf', ...
    'FaceColor', [0.2 0.4 0.8], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on;
[f, xi] = ksdensity(allDurations);
plot(xi, f, 'k-', 'LineWidth', 2);

% % --- Load pooled results ---
load('pooled_event_durations_ctr_post_dt.mat', 'pooledDelays');

% % --- Flatten pooledDelays (cell array of per-trial vectors) into one vector ---
allDurations = [pooledDelays{:}]/framerate;
allDurations = allDurations(~isnan(allDurations));   % safety: drop any stray NaNs
histogram(allDurations, 'Normalization', 'pdf', ...
    'FaceColor', [1 0.4 0.2], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on;
[f, xi] = ksdensity(allDurations);
plot(xi, f, 'r-', 'LineWidth', 2);
set(gca,'xLim',[-0.2 0.6],'yLim',[0 20])
xlabel('Event duration (s)');
ylabel('Density');
title('Histogram with kernel density estimate');
set(gca,'fontsize',22,'LineWidth',3,'FontWeight','Bold')
box off
print(gcf, '-dmeta', 'control pre dt delay.emf'); 


%% ================================================================
% Assumes pooled_event_durations.mat (from pool_event_durations.m)
% has already been generated and contains: pooledDurations

clear; clc;
framerate = 20;
% % --- Load pooled results ---
load('pooled_event_durations_exp_pre_dt.mat', 'pooledDelays');

% % --- Flatten pooledDelays (cell array of per-trial vectors) into one vector ---
allDurations = ([pooledDelays{:}]/framerate);
allDurations = allDurations(~isnan(allDurations));   % safety: drop any stray NaNs

fprintf('Total events pooled: %d\n', numel(allDurations));
fprintf('Mean = %.2f | Median = %.2f | SD = %.2f | Min = %.2f | Max = %.2f\n', ...
    mean(allDurations), median(allDurations), std(allDurations), ...
    min(allDurations), max(allDurations));

figure('Name', 'Distribution with Density Overlay and Boxplot');
histogram(allDurations, 'Normalization', 'pdf', ...
    'FaceColor', [0.2 0.4 0.8], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on;
[f, xi] = ksdensity(allDurations);
plot(xi, f, 'k-', 'LineWidth', 2);

% % --- Load pooled results ---
load('pooled_event_durations_exp_post_dt.mat', 'pooledDelays');

% % --- Flatten pooledDelays (cell array of per-trial vectors) into one vector ---
allDurations = [pooledDelays{:}]/framerate;
allDurations = allDurations(~isnan(allDurations));   % safety: drop any stray NaNs
histogram(allDurations, 'Normalization', 'pdf', ...
    'FaceColor', [1 0.4 0.2], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on;
[f, xi] = ksdensity(allDurations);
plot(xi, f, 'r-', 'LineWidth', 2);

set(gca,'xLim',[-0.2 0.6],'yLim',[0 20])
xlabel('Event duration (s)');
ylabel('Density');
title('Histogram with kernel density estimate');
set(gca,'fontsize',22,'LineWidth',3,'FontWeight','Bold')
box off
print(gcf, '-dmeta', 'exp pre dt delay.emf'); 










%% Bar plot: mean event duration per condition (4 bars), averaged
%% per animal first, with individual-animal scatter overlay
%% ================================================================

clear; clc;
framerate = 20;

condFiles  = { 'pooled_event_durations_ctr_pre_dt.mat', ...
    'pooled_event_durations_ctr_post_dt.mat', ...
    'pooled_event_durations_exp_pre_dt.mat', ...
    'pooled_event_durations_exp_post_dt.mat' };

condLabels = { 'Ctrl Pre-DT', 'Ctrl Post-DT', 'Exp Pre-DT', 'Exp Post-DT' };
nConds = numel(condFiles);

% % --- Load each condition's allResults and compute per-animal means ---
animalMeans = cell(1, nConds);   % each cell = vector of per-animal mean durations

for c = 1:nConds
    S = load(condFiles{c}, 'allResults');   % load the struct, not just pooledDurations
    allResults = S.allResults;

    nAnimals = numel(allResults);
    means_c = nan(nAnimals, 1);
    for a = 1:nAnimals
        durMat = allResults(a).delay;
        means_c(a) = mean(durMat(:), 'omitnan');   % average across trials & event-pairs
    end

    animalMeans{c} = means_c;
    fprintf('%s: %d animals, group mean = %.2f (frames) = %.2f s\n', ...
        condLabels{c}, nAnimals, mean(means_c, 'omitnan'), ...
        mean(means_c, 'omitnan') / framerate);
end

% % --- Convert to seconds (comment out if you want to keep frame units) ---
animalMeans_sec = cellfun(@(v) v / framerate, animalMeans, 'UniformOutput', false);

% % --- Compute group mean and SEM for the bar heights ---
groupMean = nan(1, nConds);
groupSEM  = nan(1, nConds);
for c = 1:nConds
    v = animalMeans_sec{c};
    v = v(~isnan(v));
    groupMean(c) = mean(v);
    groupSEM(c)  = std(v) / sqrt(numel(v));
end

%% ================================================================
%% Bar plot with per-animal scatter overlay
%% ================================================================
figure('Name', 'Mean Event Duration by Condition');
condColors = [0.5 0.5 0.5; 0.5 0.5 0.5; 0.85 0.33 0.1; 0.85 0.33 0.1];   % gray for ctrl, orange for exp

b = bar(1:nConds, groupMean, 0.6); hold on;
b.FaceColor = 'flat';
for c = 1:nConds
    b.CData(c, :) = condColors(c, :);
end
b.FaceAlpha = 0.7;

errorbar(1:nConds, groupMean, groupSEM, 'k.', 'LineWidth', 1.2, 'CapSize', 10);

% --- scatter individual animal points with jitter ---
for c = 1:nConds
    v = animalMeans_sec{c};
    v = v(~isnan(v));
    n = numel(v);
    jitter = (rand(n, 1) - 0.5) * 0.25;
    scatter(c + jitter, v, 35, 'k', 'filled', ...
        'MarkerFaceAlpha', 0.6, 'MarkerEdgeColor', 'none');
end

set(gca, 'XTick', 1:nConds, 'XTickLabel', condLabels);
ylabel('Mean event duration (s)');
title('Mean backward Duration per Condition (per-animal average)');

set(gca,'fontsize',22,'LineWidth',3,'FontWeight','Bold')
box off
print(gcf, '-dmeta', 'delay to backward bar lot.emf');


%% ================================================================
%% STATISTICS: pairwise comparisons between the four conditions
%% ================================================================
% Assumption (2x2 design: genotype x pre/post-DT):
%   - Ctrl Pre-DT vs Ctrl Post-DT   -> PAIRED (same ctrl animals, pre/post)
%   - Exp  Pre-DT vs Exp  Post-DT   -> PAIRED (same exp animals, pre/post)
%   - All other pairs (Ctrl vs Exp) -> UNPAIRED (different animals)
% If animal counts don't match for a "paired" comparison, this script
% automatically falls back to an unpaired test and prints a note.

pairedPairs = [1 2; 3 4];   % indices into condLabels/animalMeans_sec that are paired

allPairs = nchoosek(1:nConds, 2);
nPairs = size(allPairs, 1);

pval_raw   = nan(nPairs, 1);
testUsed   = cell(nPairs, 1);
pairLabels = cell(nPairs, 1);

for p = 1:nPairs
    i = allPairs(p, 1);
    j = allPairs(p, 2);
    pairLabels{p} = sprintf('%s vs %s', condLabels{i}, condLabels{j});

    v1 = animalMeans_sec{i}(~isnan(animalMeans_sec{i}));
    v2 = animalMeans_sec{j}(~isnan(animalMeans_sec{j}));

    isPairedPair = any(all(pairedPairs == [i j], 2));

    if isPairedPair && numel(v1) == numel(v2) && numel(v1) >= 3
        pval_raw(p) = signrank(v1, v2);
        testUsed{p} = 'signrank (paired)';
    else
        if isPairedPair
            fprintf('Note: %s intended as paired but animal counts differ (%d vs %d) - using unpaired test.\n', ...
                pairLabels{p}, numel(v1), numel(v2));
        end
        if numel(v1) >= 3 && numel(v2) >= 3
            pval_raw(p) = ranksum(v1, v2);
            testUsed{p} = 'ranksum (unpaired)';
        else
            testUsed{p} = 'skipped (n<3)';
        end
    end
end

%% --- Multiple comparison correction (Holm-Bonferroni + BH-FDR) ---
validIdx = ~isnan(pval_raw);
pval_adj_holm = nan(nPairs, 1);
pval_adj_bh   = nan(nPairs, 1);

if any(validIdx)
    sortedP = sort(pval_raw(validIdx));
    [~, sortIdx] = sort(pval_raw(validIdx));
    m = numel(sortedP);

    adjP_holm = nan(m, 1);
    for i = 1:m
        adjP_holm(i) = min(1, max(sortedP(i) * (m - i + 1), (i > 1) * adjP_holm(max(i-1,1))));
    end

    adjP_bh = nan(m, 1);
    for i = m:-1:1
        val = sortedP(i) * m / i;
        if i == m
            adjP_bh(i) = min(1, val);
        else
            adjP_bh(i) = min(adjP_bh(i+1), min(1, val));
        end
    end

    origOrder = find(validIdx);
    pval_adj_holm(origOrder(sortIdx)) = adjP_holm;
    pval_adj_bh(origOrder(sortIdx))   = adjP_bh;
end

%% --- Print results ---
fprintf('\n=== Pairwise comparisons: mean event duration ===\n');
for p = 1:nPairs
    if isnan(pval_raw(p))
        fprintf('  %-30s: %s\n', pairLabels{p}, testUsed{p});
        continue;
    end
    sig = '';
    if pval_adj_holm(p) < 0.001; sig = '***';
    elseif pval_adj_holm(p) < 0.01; sig = '**';
    elseif pval_adj_holm(p) < 0.05; sig = '*';
    end
    fprintf('  %-30s [%s]: raw p=%.4f | Holm p=%.4f | BH-FDR p=%.4f %s\n', ...
        pairLabels{p}, testUsed{p}, pval_raw(p), pval_adj_holm(p), pval_adj_bh(p), sig);
end

%% --- Summary table ---
statsTable = table(pairLabels, testUsed, pval_raw, pval_adj_holm, pval_adj_bh, ...
    'VariableNames', {'Comparison', 'Test', 'p_raw', 'p_adj_Holm', 'p_adj_BH_FDR'});
disp(statsTable);
