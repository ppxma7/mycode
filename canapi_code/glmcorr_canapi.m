% check correlation of regressors
% Pearson correlation (r) between every pair of regressors in the filtered,
% scaled design matrix. Each cell is r between column i and column j, ranging -1 to +1.

close all
clc
mypath = '/Volumes/kratos/CANAPI/';

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/GLM_correlations/'];

dataset = {'canapi_sub02_180325', 'canapi_sub03_180325',...
    'canapi_sub04_280425','canapi_sub05_240625', 'canapi_sub06_240625',...
    'canapi_sub07_010725', 'canapi_sub08_010725', 'canapi_sub09_160725', ...
    'canapi_sub10_160725','canapi_sub11', 'canapi_sub12','canapi_sub13', 'canapi_sub14', 'canapi_sub15', 'canapi_sub16'};

%dataset = {'canapi_sub08_010725'}

for ii = 1:length(dataset)

    load(fullfile(mypath,dataset{ii},'spm_analysis/first_level_waccel','SPM.mat'));

    Xsc = SPM.xX.xKXs.X;
    names = SPM.xX.name;

    % Find task and motion columns
    task_idx = find(~cellfun(@isempty, regexp(names, 'bf\(')));
    motion_idx = find(~cellfun(@isempty, regexp(names, ' R\d+$')));

    % Keep original column order
    cols = sort([task_idx, motion_idx]);
    C = corr(Xsc(:, cols));
    labels = names(cols);

    % Shorten labels
    labels = strrep(labels, 'Sn(', 'S');
    labels = strrep(labels, ') ON*bf(1)', ' HRF');
    labels = strrep(labels, ') ON*bf(2)', ' deriv');
    labels = regexprep(labels, '\) R', ' R');

    figure('Position',[100 100 1200 800])
    imagesc(C, [-1 1]);
    colorbar; colormap(jet);
    xticks(1:numel(cols)); yticks(1:numel(cols));
    xticklabels(labels); yticklabels(labels);
    xtickangle(45);
    title('Full GLM: task & motion regressors (design order)');
    colormap viridis
    axis square;

    fname_corr = [savedir 'GLM_reg_corr_' dataset{ii} '.png'];
    h = gcf;
    %exportgraphics(h, fname_corr, 'ContentType', 'vector', 'Resolution', 300);

    n_sessions = 4;
    VIF_task = [];
    VIF_labels = {};

    for s = 1:n_sessions
        sn_str = sprintf('Sn(%d)', s);

        %s_task = find(cellfun(@(x) contains(x, sn_str) && contains(x, 'bf('), names));
        s_task = find(cellfun(@(x) contains(x, sn_str) && contains(x, 'bf(1)'), names)); % just look at task regressor not derivtive
        s_motion = find(cellfun(@(x) contains(x, sn_str) && contains(x, ' R'), names));

        for vi = 1:numel(s_task)
            y = Xsc(:, s_task(vi));
            M = Xsc(:, s_motion);
            yhat = M * (M \ y);
            r2 = 1 - var(y - yhat) / var(y); % regression how well can motion parameters reconstruct the task regressor
            VIF_task(end+1) = 1 / (1 - r2); % R² = 1 - (unexplained / total) = proportion of task regressor variance explained by motion
            VIF_labels{end+1} = names{s_task(vi)};
        end
    end

    %The 1/(1-R²) transformation amplifies sensitivity at high R² values
    % % — the scale is intentionally nonlinear to flag severe collinearity clearly.
    %%%% example
    % R² 1 - R² VIF
    % 0.0 1.0 1 — motion explains nothing
    % 0.5 0.5 2 — modest overlap
    % 0.8 0.2 5 — concerning
    % 0.9 0.1 10 — serious
    % 0.99 0.01 100 — near-perfect collinearity



    %%
    figure
    bar(VIF_task);


    xticks(1:numel(VIF_task));
    xticklabels(VIF_labels);

    xtickangle(45);


    title('Task regressor VIF (w.r.t. motion parameters only)');    
    ylabel('VIF');
    %title('Variance Inflation Factor');
    yline(5,  'r--', 'VIF=5',  'LabelHorizontalAlignment','left');
    yline(10, 'r-',  'VIF=10', 'LabelHorizontalAlignment','left');


    fname_corr2 = [savedir 'GLM_reg_vif_' dataset{ii} '.png'];

    h = gcf;
    %exportgraphics(h, fname_corr2, 'ContentType', 'vector', 'Resolution', 300);


end