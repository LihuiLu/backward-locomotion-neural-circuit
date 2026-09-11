%% ================================================================
%% Batch-read 'back_max' from .mat files and pool results into one struct
%% ================================================================
%
% Expected file layout:
%   Each .mat file contains a variable/field named 'back_max' with
%   10 values (assumed one file = one animal/session).
%
% Output (mirrors the structure used for event durations):
%   allResults      - 1 x nFiles struct array, one entry per file, with:
%                        .filename   - file name
%                        .nValues    - number of values found (expect 10)
%                        .back_max   - the raw values for this file (column vector)
%   pooledBackMax    - cell array, one cell PER FILE, each cell containing
%                       that file's back_max values (mirrors how
%                       pooledDurations grouped by trial, but here the
%                       natural grouping unit is "per file" since back_max
%                       isn't organized by trial)
%   pooledAllBackMax - single flat numeric vector of every back_max value
%                       across ALL files (mirrors pooledAllValues)

clear; clc;

%% --- Settings ---
folderPath = pwd;   % <-- change to your folder, e.g. 'C:\Data\MyExperiment'
filePattern = fullfile(folderPath, '*.mat');
expectedN = 10;      % expected number of values per file (for a sanity check/warning)

fileList = dir(filePattern);
nFiles = numel(fileList);
fprintf('Found %d .mat file(s) in: %s\n', nFiles, folderPath);

% % --- Storage ---
allResults = struct('filename', {}, 'nValues', {}, 'back_max', {});

pooledBackMax    = {};   % grows across all files (one cell per file)
pooledAllBackMax = [];   % flat vector of every back_max value

% % --- Process each file ---
for f = 1:nFiles
    fname = fileList(f).name;
    fpath = fullfile(fileList(f).folder, fname);
    fprintf('  [%d/%d] Reading %s ... ', f, nFiles, fname);

    try
        S = load(fpath, 'back_max');
    catch ME
        fprintf('FAILED to read (%s)\n', ME.message);
        continue;
    end

    if ~isfield(S, 'back_max')
        fprintf('skipped (no back_max field found)\n');
        continue;
    end

    vals = S.back_max(:);   % force to a column vector regardless of original shape
    nValues = numel(vals);

    if nValues ~= expectedN
        fprintf('WARNING: found %d values (expected %d). ', nValues, expectedN);
    end

    % --- store per-file result ---
    allResults(end+1) = struct( ...             %#ok<SAGROW>
        'filename', fname, ...
        'nValues', nValues, ...
        'back_max', vals);

    % --- pool into the combined outputs ---
    pooledBackMax    = [pooledBackMax, {vals'}];        %#ok<AGROW>  % one cell per file
    pooledAllBackMax = [pooledAllBackMax, vals'];        %#ok<AGROW>  % flat pool

    fprintf('done. %d value(s).\n', nValues);
end

% % --- Summary ---
fprintf('\n=== Summary ===\n');
fprintf('Total files processed  : %d\n', numel(allResults));
fprintf('Total back_max groups  : %d (one per file)\n', numel(pooledBackMax));
fprintf('Total back_max values  : %d\n', numel(pooledAllBackMax));

% % --- Save results ---
save('pooled_back_max.mat', 'allResults', 'pooledBackMax', 'pooledAllBackMax');
fprintf('\nSaved results to pooled_back_max.mat\n');






%%
%% --- Settings ---
folderPath = pwd;   % <-- change to your folder, e.g. 'C:\Data\MyExperiment'
filePattern = fullfile(folderPath, '*.mat');
expectedN = 10;      % expected number of values per file (for a sanity check/warning)
colRange = 61:121;   % columns to average across, for 'backward' -> backward_m

fileList = dir(filePattern);
nFiles = numel(fileList);
fprintf('Found %d .mat file(s) in: %s\n', nFiles, folderPath);

% % --- Storage ---
allResults = struct('filename', {}, 'nValues', {}, 'back_max', {}, 'backward_m', {});
pooledBackMax     = {};   % grows across all files (one cell per file)
pooledAllBackMax  = [];   % flat vector of every back_max value
pooledBackwardM   = {};   % grows across all files (one cell per file)
pooledAllBackwardM = [];  % flat vector of every backward_m value

% % --- Process each file ---
for f = 1:nFiles
    fname = fileList(f).name;
    fpath = fullfile(fileList(f).folder, fname);
    fprintf('  [%d/%d] Reading %s ... ', f, nFiles, fname);

    try
        S = load(fpath, 'back_max', 'backward');
    catch ME
        fprintf('FAILED to read (%s)\n', ME.message);
        continue;
    end

    if ~isfield(S, 'back_max')
        fprintf('skipped (no back_max field found)\n');
        continue;
    end

    vals = S.back_max(:);   % force to a column vector regardless of original shape
    nValues = numel(vals);

    if nValues ~= expectedN
        fprintf('WARNING: found %d values (expected %d). ', nValues, expectedN);
    end

    % --- compute backward_m: row-wise mean of columns 61:121 in 'backward' ---
    if ~isfield(S, 'backward')
        fprintf('WARNING: no backward field found, backward_m set to []. ');
        backward_m = [];
    else
        backwardMat = S.backward;
        if size(backwardMat, 2) < max(colRange)
            fprintf('WARNING: backward has only %d columns (need >= %d), backward_m set to []. ', ...
                size(backwardMat, 2), max(colRange));
            backward_m = [];
        else
            backward_m = mean(backwardMat(:, colRange), 2, 'omitnan');   % nRows x 1
        end
    end

    % --- store per-file result ---
    allResults(end+1) = struct( ...             %#ok<SAGROW>
        'filename', fname, ...
        'nValues', nValues, ...
        'back_max', vals, ...
        'backward_m', backward_m);

    % --- pool into the combined outputs ---
    pooledBackMax    = [pooledBackMax, {vals'}];              %#ok<AGROW>  % one cell per file
    pooledAllBackMax = [pooledAllBackMax, vals'];              %#ok<AGROW>  % flat pool

    pooledBackwardM    = [pooledBackwardM, {backward_m'}];     %#ok<AGROW>  % one cell per file
    pooledAllBackwardM = [pooledAllBackwardM, backward_m'];    %#ok<AGROW>  % flat pool

    fprintf('done. %d value(s), %d backward_m row(s).\n', nValues, numel(backward_m));
end

% % --- Summary ---
fprintf('\n=== Summary ===\n');
fprintf('Total files processed     : %d\n', numel(allResults));
fprintf('Total back_max groups     : %d (one per file)\n', numel(pooledBackMax));
fprintf('Total back_max values     : %d\n', numel(pooledAllBackMax));
fprintf('Total backward_m groups   : %d (one per file)\n', numel(pooledBackwardM));
fprintf('Total backward_m values   : %d\n', numel(pooledAllBackwardM));

% % --- Save results ---
save('pooled_back_max.mat', 'allResults', 'pooledBackMax', 'pooledAllBackMax', ...
    'pooledBackwardM', 'pooledAllBackwardM');
fprintf('\nSaved results to pooled_back_max.mat\n');










%% plot
%% ================================================================
%% Plot distribution of pooledDurations
%% ================================================================
% Assumes pooled_back_max.mat (from pool_back_max.m)
% has already been generated and contains: pooledDurations

clear; clc;
framerate = 20;
% % --- Load pooled results ---
load('pooled_back_max_ctr_pre_dt.mat', 'pooledAllBackMax');

% % --- Flatten pooledAllBackMax (cell array of per-trial vectors) into one vector ---
allDurations = [pooledAllBackMax];
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
load('pooled_back_max_ctr_post_dt.mat', 'pooledAllBackMax');

% % --- Flatten pooledAllBackMax (cell array of per-trial vectors) into one vector ---
allDurations = [pooledAllBackMax];
allDurations = allDurations(~isnan(allDurations));   % safety: drop any stray NaNs
histogram(allDurations, 'Normalization', 'pdf', ...
    'FaceColor', [1 0.4 0.2], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on;
[f, xi] = ksdensity(allDurations);
plot(xi, f, 'r-', 'LineWidth', 2);

set(gca,'xLim',[-90 10],'yLim',[0 0.08])
xlabel('backward vel (cm/s)');
ylabel('Density');
title('Histogram with kernel density estimate');
set(gca,'fontsize',22,'LineWidth',3,'FontWeight','Bold')
box off
print(gcf, '-dmeta', 'control pre dt back vel.emf'); 


%% ================================================================
% Assumes pooled_back_max.mat (from pool_back_max.m)
% has already been generated and contains: pooledDurations

clear; clc;
framerate = 20;
% % --- Load pooled results ---
load('pooled_back_max_exp_pre_dt.mat', 'pooledAllBackMax');

% % --- Flatten pooledAllBackMax (cell array of per-trial vectors) into one vector ---
allDurations = ([pooledAllBackMax]);
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
load('pooled_back_max_exp_post_dt.mat', 'pooledAllBackMax');

% % --- Flatten pooledAllBackMax (cell array of per-trial vectors) into one vector ---
allDurations = [pooledAllBackMax];
allDurations = allDurations(~isnan(allDurations));   % safety: drop any stray NaNs
histogram(allDurations, 'Normalization', 'pdf', ...
    'FaceColor', [1 0.4 0.2], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on;
[f, xi] = ksdensity(allDurations);
plot(xi, f, 'r-', 'LineWidth', 2);

set(gca,'xLim',[-90 10],'yLim',[0 0.08])
xlabel('backward vel (cm/s)');
ylabel('Density');
title('Histogram with kernel density estimate');
set(gca,'fontsize',22,'LineWidth',3,'FontWeight','Bold')
box off
print(gcf, '-dmeta', 'exp pre dt back vel.emf'); 








%% Bar plot: mean event duration per condition (4 bars), averaged
%% per animal first, with individual-animal scatter overlay
%% ================================================================

clear; clc;
framerate = 20;

condFiles  = { 'pooled_back_max_ctr_pre_dt.mat', ...
    'pooled_back_max_ctr_post_dt.mat', ...
    'pooled_back_max_exp_pre_dt.mat', ...
    'pooled_back_max_exp_post_dt.mat' };

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
        durMat = allResults(a).back_max;
        means_c(a) = mean(durMat(:), 'omitnan');   % average across trials & event-pairs
    end

    animalMeans{c} = means_c;
    fprintf('%s: %d animals, group mean = %.2f (frames) = %.2f s\n', ...
        condLabels{c}, nAnimals, mean(means_c, 'omitnan'), ...
        mean(means_c, 'omitnan') / framerate);
end

% % --- Convert to seconds (comment out if you want to keep frame units) ---
animalMeans_sec = animalMeans;

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
ylabel('Peak backward vel (cm/s)');
title('Mean backward vel per Condition (per-animal average)');

set(gca,'fontsize',22,'LineWidth',3,'FontWeight','Bold')
box off
print(gcf, '-dmeta', 'peak backward vel bar lot.emf');


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

%%



















%%
%% plot
%% ================================================================
%% Plot distribution of pooledDurations
%% ================================================================
% Assumes pooled_back_max.mat (from pool_back_max.m)
% has already been generated and contains: pooledDurations

clear; clc;
framerate = 20;
% % --- Load pooled results ---
load('pooled_back_max_ctr_pre_dt.mat', 'pooledAllBackwardM');

% % --- Flatten pooledAllBackwardM (cell array of per-trial vectors) into one vector ---
allDurations = [pooledAllBackwardM];
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
load('pooled_back_max_ctr_post_dt.mat', 'pooledAllBackwardM');

% % --- Flatten pooledAllBackwardM (cell array of per-trial vectors) into one vector ---
allDurations = [pooledAllBackwardM];
allDurations = allDurations(~isnan(allDurations));   % safety: drop any stray NaNs
histogram(allDurations, 'Normalization', 'pdf', ...
    'FaceColor', [1 0.4 0.2], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on;
[f, xi] = ksdensity(allDurations);
plot(xi, f, 'r-', 'LineWidth', 2);

set(gca,'xLim',[-70 20],'yLim',[0 0.08])
xlabel('backward vel (cm/s)');
ylabel('Density');
title('Histogram with kernel density estimate');
set(gca,'fontsize',22,'LineWidth',3,'FontWeight','Bold')
box off
print(gcf, '-dmeta', 'control pre dt back mean vel.emf'); 


%% ================================================================
% Assumes pooled_back_max.mat (from pool_back_max.m)
% has already been generated and contains: pooledDurations

clear; clc;
framerate = 20;
% % --- Load pooled results ---
load('pooled_back_max_exp_pre_dt.mat', 'pooledAllBackwardM');

% % --- Flatten pooledAllBackwardM (cell array of per-trial vectors) into one vector ---
allDurations = ([pooledAllBackwardM]);
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
load('pooled_back_max_exp_post_dt.mat', 'pooledAllBackwardM');

% % --- Flatten pooledAllBackwardM (cell array of per-trial vectors) into one vector ---
allDurations = [pooledAllBackwardM];
allDurations = allDurations(~isnan(allDurations));   % safety: drop any stray NaNs
histogram(allDurations, 'Normalization', 'pdf', ...
    'FaceColor', [1 0.4 0.2], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on;
[f, xi] = ksdensity(allDurations);
plot(xi, f, 'r-', 'LineWidth', 2);

set(gca,'xLim',[-70 20],'yLim',[0 0.08])
xlabel('backward vel (cm/s)');
ylabel('Density');
title('Histogram with kernel density estimate');
set(gca,'fontsize',22,'LineWidth',3,'FontWeight','Bold')
box off
print(gcf, '-dmeta', 'exp pre dt back mean vel.emf'); 








%% Bar plot: mean event duration per condition (4 bars), averaged
%% per animal first, with individual-animal scatter overlay
%% ================================================================

clear; clc;
framerate = 20;

condFiles  = { 'pooled_back_max_ctr_pre_dt.mat', ...
    'pooled_back_max_ctr_post_dt.mat', ...
    'pooled_back_max_exp_pre_dt.mat', ...
    'pooled_back_max_exp_post_dt.mat' };

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
        durMat = allResults(a).backward_m;
        means_c(a) = mean(durMat(:), 'omitnan');   % average across trials & event-pairs
    end

    animalMeans{c} = means_c;
    fprintf('%s: %d animals, group mean = %.2f (frames) = %.2f s\n', ...
        condLabels{c}, nAnimals, mean(means_c, 'omitnan'), ...
        mean(means_c, 'omitnan') / framerate);
end

% % --- Convert to seconds (comment out if you want to keep frame units) ---
animalMeans_sec = animalMeans;

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
ylabel('Mean backward vel (cm/s)');
title('Mean backward vel per Condition (per-animal average)');

set(gca,'fontsize',22,'LineWidth',3,'FontWeight','Bold')
box off
print(gcf, '-dmeta', 'mean backward vel bar lot.emf');


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