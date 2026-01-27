%% Load in chain dti data and plot means
thisType = 'MD';
root = ['/Volumes/DRS-CHAIN-Study/MRI/ANALYSIS/dti_data/dti_' thisType '/'];

savedgroup = 'chain_dti';

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/' savedgroup '/'];


files = dir(root);
fileTable = struct2table(files);
fileNames = fileTable.name;
niftiFileNames = fileNames(contains(fileNames,'.nii.gz'));

fprintf('Found %d files\n',length(niftiFileNames))

idx6 = contains(niftiFileNames, 'V6', 'IgnoreCase', true);
idx13 = contains(niftiFileNames, 'V13', 'IgnoreCase', true);
idx20 = contains(niftiFileNames, 'V20', 'IgnoreCase', true);
idx33 = contains(niftiFileNames, 'V33', 'IgnoreCase', true);

filenames_v6 = niftiFileNames(idx6);
filenames_v13 = niftiFileNames(idx13);
filenames_v20 = niftiFileNames(idx20);
filenames_v33 = niftiFileNames(idx33);

fullList = cat(1,filenames_v6,filenames_v13,filenames_v20,filenames_v33);

groupList = [repmat({'v6'},length(filenames_v6),1); ...
    repmat({'v13'},length(filenames_v13),1); ...
    repmat({'v20'},length(filenames_v20),1); ...
    repmat({'v33'},length(filenames_v33),1)];

vm = zeros(length(fullList),1);
for ii = 1:length(fullList)

    thisFile = fullfile(root, fullList{ii});
    thisFileContents = niftiread(thisFile);
    fprintf('Getting nonzero mean of %s\n',fullList{ii})
    v = thisFileContents(:);
    vm(ii) = mean(nonzeros(v));
    vm_std(ii) = std(nonzeros(v));
end

% get labels
idList = cellfun(@(x) x(1:6), fullList, 'UniformOutput', false);

% Build table
T = table(fullList(:), vm, vm_std(:), ...
          'VariableNames', {'Filename','MeanNonZero','StdNonZero'});

% Write CSV
writetable(T, fullfile(root,'voxel_stats.csv'));

%% just plot these out for now
clear g
close all
cmap = {'#2b8cbe','#a6bddb','#ece7f2','#74a9cf'};
cmapped = validatecolor(cmap,'multiple');
comesInBlack = ones(4,3).*0.6;

figure('Position',[100 100 1000 600])
g = gramm('x',groupList,'y',vm);
g.stat_boxplot2('drawoutlier',0);
g.set_names('x','Group','y',['Mean ' thisType]);
%g.set_names('x','ROI','y','Mean T1','color','Group');
%g.set_point_options('base_size',1)
%g.axe_property('XTickLabelRotation',45,'YLim',[0 1],'YGrid','on','XGrid','on');
g.axe_property('XTickLabelRotation',45,'YGrid','on','XGrid','on') %,'YLim',[0.2 0.4]);
g.set_order_options('x',0)
g.set_color_options('map',cmapped)
g.draw();

g.update('y',vm)
g.geom_jitter2()
g.set_color_options('map',comesInBlack)
g.draw()

% g.update('label',idList)
% g.geom_label('dodge',10,'Color','k')
% g.draw()

g.export('file_name', ...
    fullfile(savedir,thisType), ...
    'file_type','pdf');

%% also plot vs age.
% repeat these as different numbers in each visit, some
ages = [58 63 56 57 65 62 61 63 63 57 63 63 56 65,...
    58 63 56 57 65 62 61 63 63 63 56 65,... % rm sub12 and sub14 from v13
    58 63 56 57 65 62 61 63 63 63 63 56 65,... % rm sub12 from v20
    58 63 65 62 61 63 63 63 63 56]; % rm sub3,5, 12, 19

x = ages(:);
y = vm(:);
grp = categorical(groupList(:), {'v6','v13','v20','v33'}, ...
    'Ordinal', false);
%tbl = table(x, y, grp);

% for repeated measures add subject id
SubjectID = categorical(idList);   % may repeat, but some subjects have <4 rows
tbl = table(y(:), x(:), grp(:), SubjectID(:), 'VariableNames', {'y','x','grp','SubjectID'});



%mdl = fitlm(tbl, 'y ~ x + grp'); % this will force same slopes
%mdl = fitlm(tbl, 'y ~ x * grp'); % here add interaction effect (does age differ between groups)

% repeated measures
mdl = fitlme(tbl, 'y ~ x * grp + (1|SubjectID)');

% We are using fitlm here instead of simple ANOVA because we need to
% take age into account as a covariate!
disp(mdl)
disp(categories(grp))
disp(mdl.CoefficientNames')
coefTable = mdl.Coefficients;

pF = zeros(6,1);
directions = strings(6,1);

% v13 vs v6 (reference)
C = [0 0 0 0 0 1 0 0];
[pF(1),~,~] = coefTest(mdl, C);
d = C * mdl.Coefficients.Estimate;
directions(1) = ternary(d > 0, 'v13', 'v6');
fprintf('Slope: v13 vs v6, p = %.4f\n', pF(1));

% v20 vs v6
C = [0 0 0 0 0 0 1 0];
[pF(2),~,~] = coefTest(mdl, C);
d = C * mdl.Coefficients.Estimate;
directions(2) = ternary(d > 0, 'v20', 'v6');
fprintf('Slope: v20 vs v6, p = %.4f\n', pF(2));

% v33 vs v6
C = [0 0 0 0 0 0 0 1];
[pF(3),~,~] = coefTest(mdl, C);
d = C * mdl.Coefficients.Estimate;
directions(3) = ternary(d > 0, 'v33', 'v6');
fprintf('Slope: v33 vs v6, p = %.4f\n', pF(3));

% v13 vs v20
C = [0 0 0 0 0 1 -1 0];
[pF(4),~,~] = coefTest(mdl, C);
d = C * mdl.Coefficients.Estimate;
directions(4) = ternary(d > 0, 'v13', 'v20');
fprintf('Slope: v13 vs v20, p = %.4f\n', pF(4));

% v13 vs v33
C = [0 0 0 0 0 1 0 -1];
[pF(5),~,~] = coefTest(mdl, C);
d = C * mdl.Coefficients.Estimate;
directions(5) = ternary(d > 0, 'v13', 'v33');
fprintf('Slope: v13 vs v33, p = %.4f\n', pF(5));

% v20 vs v33
C = [0 0 0 0 0 0 1 -1];
[pF(6),~,~] = coefTest(mdl, C);
d = C * mdl.Coefficients.Estimate;
directions(6) = ternary(d > 0, 'v20', 'v33');
fprintf('Slope: v20 vs v33, p = %.4f\n', pF(6));

% Multiple-comparison correction (Bonferroni)
p_adj = min(pF * numel(pF), 1);
disp(table(pF, p_adj, directions, ...
    'VariableNames', {'p_raw','p_adj','SteeperSlope'}))


% now plot
% ---- Parameters ----
minN = 2;   % minimum points for plotting a fit
xxPoints = 200; % number of points in fit line

visits = categories(grp); % {'v6','v13','v20','v33'}
nVisits = numel(visits);

% Create a tiled layout
figure('Position',[100 100 1200 1000]);
tl = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');

for v = 1:nVisits
    thisVisit = visits{v};
    idx = grp == thisVisit;

    % Skip if not enough data
    if sum(idx) < minN
        fprintf('Skipping %s (n=%d)\n', thisVisit, sum(idx));
        continue
    end

    % Next tile
    ax = nexttile;

    % ---- Scatter ----
    scatter(x(idx), y(idx), 60, ...
        'Marker','o', ...
        'MarkerEdgeColor','k', ...
        'MarkerFaceColor','none', ...
        'LineWidth',1.2);
    hold on

    % ---- Fit line (fixed effects) ----
    xx = linspace(min(x(idx)), max(x(idx)), xxPoints)';

    % Prediction table (use any real SubjectID)
    Tpred = table( ...
        xx, ...
        repmat(categorical({thisVisit}), numel(xx), 1), ...
        repmat(SubjectID(1), numel(xx), 1), ...
        'VariableNames', {'x','grp','SubjectID'} ...
        );

    yy = predict(mdl, Tpred, 'Conditional', false);  % fixed effects only
    plot(xx, yy, 'k-', 'LineWidth', 2);

    % ---- Axes & Labels ----
    xlabel('Age');
    if strcmpi(thisType,'MD')
        ylabel('Mean Diffusivity');
    elseif strcmpi(thisType,'FA')
        ylabel('Fractional Anisotropy');
    end

    title(sprintf('Visit %s', thisVisit));
    box on; grid on;

    % Optional: add legend
    %legend({'Data','Population Fit'}, 'Location','best');
end

% % Save figure if needed
% if exist('savedir','var')
%     outname = fullfile(savedir, sprintf('%s_all_visits', upper(thisType)));
%     print(gcf, '-dpdf', outname, '-r300');
% end



% ---- Saving ----
if exist('savedir','var')

    % --- Filenames based on type ---
    switch upper(thisType)
        case 'MD'
            thisFilename = fullfile(savedir,'MD_plot_4groups.pdf');
            lmcoefs     = fullfile(savedir,'MD_fitlme_coefficients.csv');
            pvalssave   = fullfile(savedir,'MD_pairwise_pvalues.csv');
        case 'FA'
            thisFilename = fullfile(savedir,'FA_plot_4groups.pdf');
            lmcoefs     = fullfile(savedir,'FA_fitlme_coefficients.csv');
            pvalssave   = fullfile(savedir,'FA_pairwise_pvalues.csv');
        otherwise
            error('Unknown data type: %s', thisType);
    end

    % --- Save figure as PDF ---
    print(gcf, '-dpdf', thisFilename, '-r300');

    % --- Save fixed-effects coefficients ---
    coefTable = mdl.Coefficients;  % table from fitlme

    coefCSVTable = table( ...
        coefTable.Name, ...
        coefTable.Estimate, ...
        coefTable.SE, ...
        coefTable.tStat, ...
        coefTable.pValue, ...
        'VariableNames', {'Coefficient','Estimate','SE','tStat','pValue'});

    writetable(coefCSVTable, lmcoefs);

    % --- Save pairwise slope comparisons ---
    % 6 comparisons for 4 visits
    comparisons_slope = {
        'v13 vs v6'
        'v20 vs v6'
        'v33 vs v6'
        'v13 vs v20'
        'v13 vs v33'
        'v20 vs v33'
    };

    % Ensure p_adj and directions are column vectors
    pairCSVTable = table( ...
        comparisons_slope, ...
        p_adj(:), ...
        directions(:), ...
        'VariableNames', {'Comparison','pValue_adj','SteeperSlope'});

    writetable(pairCSVTable, pvalssave);

    fprintf('Saved: %s (figure), %s (coefficients), %s (pairwise p-values)\n', ...
        thisFilename, lmcoefs, pvalssave);
end




%%

function out = ternary(cond,trueVal,falseVal)
if cond
    out = trueVal;
else
    out = falseVal;
end
end