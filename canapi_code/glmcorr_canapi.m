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
    exportgraphics(h, fname_corr, 'ContentType', 'vector', 'Resolution', 300);
    % 
    % h = gcf;
    % set(h, 'Renderer', 'painters'); 
    % set(h, 'PaperOrientation', 'landscape');
    % set(h, 'PaperUnits', 'inches');
    % set(h, 'PaperSize', [14 10]);
    % set(h, 'PaperPosition', [0 0 14 10]);
    % print(h, '-dpdf', fname_corr, '-r300');  % drop -fillpage, it can override PaperPosition


    % VIF for each regressor
    X = Xsc(:, cols);
    n = size(X, 2);
    VIF = zeros(1, n);
    for i = 1:n
        others = X(:, setdiff(1:n, i));
        r2 = 1 - (var(X(:,i) - others*(others\X(:,i))) / var(X(:,i)));
        VIF(i) = 1 / (1 - r2);
    end
    disp(VIF)  % >5-10 is a concern

    figure
    bar(VIF);
    xticks(1:n);
    xticklabels(labels);
    xtickangle(45);
    ylabel('VIF');
    title('Variance Inflation Factor');
    yline(5,  'r--', 'VIF=5',  'LabelHorizontalAlignment','left');
    yline(10, 'r-',  'VIF=10', 'LabelHorizontalAlignment','left');


    fname_corr2 = [savedir 'GLM_reg_vif_' dataset{ii} '.png'];

    h = gcf;
    exportgraphics(h, fname_corr2, 'ContentType', 'vector', 'Resolution', 300);


end