close all
clear variables
clc


basedir = '/Volumes/DRS-GBPerm/other/outputs/FS_aseg_stats';
xlsxfile = fullfile(basedir,'nexpo_afirm_sashb_chain.xlsx');
%xlsxfile = fullfile(basedir,'nexpo_afirm_sashb_chain_combinehealthies.xlsx');

% --- read Excel metadata ---
meta = readtable(xlsxfile);

% enforce string IDs
meta.ID = string(meta.ID);

% --- list aseg stats ---
files = dir(fullfile(basedir,'aseg_*.stats'));

n = numel(files);

GM  = nan(n,1);
WM  = nan(n,1);
CSF = nan(n,1);
ID  = strings(n,1);

for i = 1:n
    fname = fullfile(basedir,files(i).name);

    tok = regexp(files(i).name,'aseg_(.*)\.stats','tokens','once');
    ID(i) = tok{1};

    [GM(i), WM(i), CSF(i)] = extract_aseg_vols(fname);
end

% --- assemble table ---
asegT = table(ID, GM, WM, CSF);

% --- merge with Excel ---
D = innerjoin(meta, asegT, 'Keys','ID');

% --- normalise by TIV ---
D.GMfrac  = D.GM  ./ D.TIV;
D.WMfrac  = D.WM  ./ D.TIV;
D.CSFfrac = D.CSF ./ D.TIV;

disp(D(:,{'ID','AGE','GROUP','GMfrac','WMfrac','CSFfrac'}));

%% settings

groupNames = '3group_wchain'; % or '4group'
tissueType = 'GM';
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/freesurfer_plots/' groupNames '/'];

%% now plotting and fitting
% switch tissueType   % e.g. 'GM','WM','CSF'
%     case 'GM'
%         y = D.GM;
%     case 'WM'
%         y = D.WM;
%     case 'CSF'
%         y = D.CSF;
% end

% x   = D.AGE;
% grp = categorical(D.GROUP);

% y = vm(:);





if sum(contains(groupNames,'3group_wchain'))

    % quick outlier check for AFIRM
    afirmgroup = D(ismember(D.GROUP, 5),:);
    vm = afirmgroup.GMfrac;
    mu = mean(vm, 'omitnan');
    sd = std(vm,  'omitnan');
    z = (vm - mu) ./ sd;
    outIdx = abs(z) > 3;


    useIdx = ismember(D.GROUP, [2 5 6 7]);
    %useIdx = ismember(D.GROUP, [2 5]);
    Dsub   = D(useIdx, :);

    % OPTIONAL: relabel for clarity
    Dsub.GROUP = categorical(Dsub.GROUP, ...
        [2 5 6 7], {'G2','G5','G6','G7'});
    % Dsub.GROUP = categorical(Dsub.GROUP, ...
    %     [2 5], {'NEXPOCHAIN','SASHBAFIRM'});

    % lets collapse groups for the fitting
    Dsub.grp_model = nan(height(Dsub),1);

    % Healthy = 2,7
    Dsub.grp_model(ismember(Dsub.GROUP, {'G2','G7'})) = 0;

    % Patient = 5,6
    Dsub.grp_model(ismember(Dsub.GROUP, {'G5','G6'})) = 1;

    Dsub.grp_model = categorical(Dsub.grp_model, ...
        [0 1], {'Healthy','Patient'});

    grp = Dsub.grp_model;
    x   = Dsub.AGE;
    %grp = Dsub.GROUP;


    switch tissueType   % e.g. 'GM','WM','CSF'
        case 'GM'
            y = Dsub.GMfrac;
        case 'WM'
            y = Dsub.WMfrac;
        case 'CSF'
            y = Dsub.CSFfrac;
    end




    % --- Fit the interaction model ---
    tbl = table(x, y, grp);
    mdl = fitlm(tbl, 'y ~ x * grp');
    % We are using fitlm here instead of simple ANOVA because we need to
    % take age into account as a covariate!
    disp(mdl)
    disp(categories(grp))
    disp(mdl.CoefficientNames')
    coefTable = mdl.Coefficients;

    if length(unique(grp)) > 2
        % Now 6 pairwise slope comparisons
        directions = strings(6,1)';
        pF = zeros(6,1);

        % AFIRM vs G2
        C = [0 0 0 0 0 1 0 0];
        [pF(1),~,~] = coefTest(mdl, C);
        d = C * mdl.Coefficients.Estimate;
        directions(1) = ternary(d>0,'AFIRM','G2');
        fprintf('Slope: AFIRM vs G2 p = %.4f\n', pF(1));

        % SASHB vs G2
        C = [0 0 0 0 0 0 1 0];
        [pF(2),~,~] = coefTest(mdl, C);
        d = C * mdl.Coefficients.Estimate;
        directions(2) = ternary(d>0,'SASHB','G2');
        fprintf('Slope: SASHB vs G2 p = %.4f\n', pF(2));

        % CHAIN vs G2
        C = [0 0 0 0 0 0 0 1];
        [pF(3),~,~] = coefTest(mdl, C);
        d = C * mdl.Coefficients.Estimate;
        directions(3) = ternary(d>0,'CHAIN','G2');
        fprintf('Slope: CHAIN vs G2 p = %.4f\n', pF(3));

        % AFIRM vs SASHB
        C = [0 0 0 0 0 1 -1 0];
        [pF(4),~,~] = coefTest(mdl, C);
        d = C * mdl.Coefficients.Estimate;
        directions(4) = ternary(d>0,'AFIRM','SASHB');
        fprintf('Slope: AFIRM vs SASHB p = %.4f\n', pF(4));

        % AFIRM vs CHAIN
        C = [0 0 0 0 0 1 0 -1];
        [pF(5),~,~] = coefTest(mdl, C);
        d = C * mdl.Coefficients.Estimate;
        directions(5) = ternary(d>0,'AFIRM','CHAIN');
        fprintf('Slope: AFIRM vs CHAIN p = %.4f\n', pF(5));

        % SASHB vs CHAIN
        C = [0 0 0 0 0 0 1 -1];
        [pF(6),~,~] = coefTest(mdl, C);
        d = C * mdl.Coefficients.Estimate;
        directions(6) = ternary(d>0,'SASHB','CHAIN');
        fprintf('Slope: SASHB vs CHAIN p = %.4f\n', pF(6));

        p_adj = min(pF * numel(pF), 1);
        disp(p_adj)

    else

        pF = coefTable.pValue(strcmp(coefTable.Properties.RowNames, ...
            'AGE:grp_Patient'));
        fprintf('Slope difference (Patient vs Healthy): p = %.4f\n', pF);

    end

    minN = 5;   % minimum points required for a fit

    bloop  = figure('Position',[100 100 700 500]); hold on
    set(bloop, 'PaperOrientation', 'landscape');
    origGroups = categories(Dsub.GROUP);
    %groups  = origGroups;
    markers = {'o','o','d','d'};
    faces   = {'none','k','k','none'};

    % ---- Scatter ----
    % for i = 1:numel(groups)
    %     idx = grp == groups{i};
    %
    %     scatter(x(idx), y(idx), 60, ...
    %         'Marker', markers{i}, ...
    %         'MarkerEdgeColor','k', ...
    %         'MarkerFaceColor', faces{i}, ...
    %         'LineWidth',1.2, ...
    %         'DisplayName', char(groups{i}));
    % end

    % ---- Scatter with small horizontal jitter ----
    jitterAmount = 0.5;  % adjust as needed (in same units as x)

    for i = 1:numel(origGroups)
        %idx = grp == groups{i};
        idx = Dsub.GROUP == origGroups{i};
        % Generate random jitter
        xJittered = x(idx) + (rand(sum(idx),1)-0.5)*2*jitterAmount;

        scatter(xJittered, y(idx), 60, ...
            'Marker', markers{i}, ...
            'MarkerEdgeColor','k', ...
            'MarkerFaceColor', faces{i}, ...
            'LineWidth',1.2, ...
            'DisplayName', char(origGroups{i}));
    end

    
    modelGroups = categories(grp);

    xx = linspace(min(x), max(x), 200)';
    lineStyles = {'--','-','-.','-.'};   % solid, dashed, dash-dot
    % Define 4 colors (RGB) for 4 groups
    colors = [
        0.5 0.5 0.5;   % G2
        0   0   0;     % G5
        0   0   0;     % G6
        0.3 0.3 0.3    % G7
        ];
    for i = 1:numel(modelGroups)
        idx = grp == modelGroups{i};

        if sum(idx) < minN
            fprintf('Skipping fit for %s (n = %d)\n', ...
                modelGroups{i}, sum(idx));
            continue
        end

        g = repmat(modelGroups(i), numel(xx), 1);
        Tpred = table(xx, g, 'VariableNames', {'x','grp'});
        yy = predict(mdl, Tpred);

        plot(xx, yy, 'LineStyle', lineStyles{i}, ...
            'Color', colors(i,:), ...
            'LineWidth', 2,...
            'DisplayName', sprintf('Fit%s', char(modelGroups{i})));

    end


    xlabel('Age');
    if strcmpi(tissueType,'GM')
        ylabel('GMV / TIV');
        leftleg = 0.8;
        rightleg = 0.7;
    elseif strcmpi(tissueType,'WM')
        ylabel('WMV / TIV');
        leftleg = 0.8;
        rightleg = 0.65;
    elseif strcmpi(tissueType,'CSF')
        ylabel('CSF / TIV');
        leftleg = 0.15;
        rightleg = 0.65;
    end

    %legend('Location','best');
    legend( ...
        'NEXPOG2','AFIRM','SASHB','CHAIN', ...
        'FitNEXPOCHAIN','FitSASHAFIRM', ...
        'Position',[leftleg rightleg 0.1 0.2]);

    % legend( ...
    %     'NEXPOCHAIN','SASHBAFIRM', ...
    %     'FitNEXPOCHAIN','FitSASHBAFIRM', ...
    %     'Position',[leftleg rightleg 0.1 0.2]);
    box on;
    grid on;

    if exist('savedir','var')
        h = gcf;

        if length(unique(grp)) > 2
            if strcmpi(tissueType,'GM')
                thisFilename = fullfile(savedir,'GM_plot');
                lmcoefs = fullfile(savedir,'GM_fitlm_coefficients.csv');
                pvalssave = fullfile(savedir,'GM_pairwise_pvalues.csv');
            elseif strcmpi(tissueType,'WM')
                thisFilename = fullfile(savedir,'WM_plot');
                lmcoefs = fullfile(savedir,'WM_fitlm_coefficients.csv');
                pvalssave = fullfile(savedir,'WM_pairwise_pvalues.csv');
            elseif strcmpi(tissueType,'CSF')
                thisFilename = fullfile(savedir,'CSF_plot');
                lmcoefs = fullfile(savedir,'CSF_fitlm_coefficients.csv');
                pvalssave = fullfile(savedir,'CSF_pairwise_pvalues.csv');
            end
        else
            if strcmpi(tissueType,'GM')
                thisFilename = fullfile(savedir,'GM_plot_combinedhealthies');
                lmcoefs = fullfile(savedir,'GM_fitlm_coefficients_combinedhealthies.csv');
                pvalssave = fullfile(savedir,'GM_pairwise_pvalues_combinedhealthies.csv');
            elseif strcmpi(tissueType,'WM')
                thisFilename = fullfile(savedir,'WM_plot_combinedhealthies');
                lmcoefs = fullfile(savedir,'WM_fitlm_coefficients_combinedhealthies.csv');
                pvalssave = fullfile(savedir,'WM_pairwise_pvalues_combinedhealthies.csv');
            elseif strcmpi(tissueType,'CSF')
                thisFilename = fullfile(savedir,'CSF_plot_combinedhealthies');
                lmcoefs = fullfile(savedir,'CSF_fitlm_coefficients_combinedhealthies.csv');
                pvalssave = fullfile(savedir,'CSF_pairwise_pvalues_combinedhealthies.csv');
            end
        end


        print(h, '-dpdf', thisFilename, '-r300');


        %% --- Save model coefficients ---
        coefTable = mdl.Coefficients;          % table with Estimate, SE, tStat, pValue
        coefCSV = [coefTable.Properties.RowNames, ...
            num2cell(coefTable.Estimate), ...
            num2cell(coefTable.SE), ...
            num2cell(coefTable.tStat), ...
            num2cell(coefTable.pValue)];

        % Convert to table for writing
        coefCSVTable = cell2table(coefCSV, ...
            'VariableNames', {'Coefficient','Estimate','SE','tStat','pValue'});

        writetable(coefCSVTable, lmcoefs);

        %% --- Save pairwise p-values ---
        % Your previously computed contrasts
        %comparisons = {'NEXPOG2 vs AFIRM','AFIRM vs SASHB','NEXPOG2 vs SASHB'};

        if length(unique(grp)) > 2
            comparisons = {
                'NEXPOG2 vs AFIRM'
                'NEXPOG2 vs SASHB'
                'NEXPOG2 vs CHAIN'
                'AFIRM vs SASHB'
                'AFIRM vs CHAIN'
                'SASHB vs CHAIN'
                };
            %pairCSVTable = table(comparisons', p_adj', 'VariableNames', {'Comparison','pValue'});
            pairCSVTable = table(comparisons, p_adj, directions', 'VariableNames', {'Comparison','pValue','HigherGroup'});

            writetable(pairCSVTable, pvalssave);

            disp('CSV files saved: fitlm_coefficients.csv and pairwise_pvalues.csv');
        else
            disp('skip')
        end

    end

elseif contains(groupNames,'4group')

    useIdx = ismember(D.GROUP, [1 2 3 4]);
    Dsub   = D(useIdx, :);

    x   = Dsub.AGE;
    grp = categorical(Dsub.GROUP);
    switch tissueType   % e.g. 'GM','WM','CSF'
        case 'GM'
            y = Dsub.GMfrac;
        case 'WM'
            y = Dsub.WMfrac;
        case 'CSF'
            y = Dsub.CSFfrac;
    end


    % --- Fit the interaction model ---
    tbl = table(x, y, grp);
    mdl = fitlm(tbl, 'y ~ x * grp');
    % We are using fitlm here instead of simple ANOVA because we need to
    % take age into account as a covariate!
    disp(mdl)
    disp(categories(grp))
    disp(mdl.CoefficientNames')
    coefTable = mdl.Coefficients;

    comparisons = {'G2 vs G1','G3 vs G1','G4 vs G1','G2 vs G3','G2 vs G4','G3 vs G4'};

    Cmat = [
        0 0 0 0 0 1 0 0;  % G2 vs G1
        0 0 0 0 0 0 1 0;  % G3 vs G1
        0 0 0 0 0 0 0 1;  % G4 vs G1
        0 0 0 0 0 1 -1 0; % G2 vs G3
        0 0 0 0 0 1 0 -1; % G2 vs G4
        0 0 0 0 0 0 1 -1; % G3 vs G4
        ];

    pF = zeros(size(Cmat,1),1);
    directions = strings(size(Cmat,1),1);  % store direction strings

    % for i = 1:size(Cmat,1)
    %     [pF(i), F, DF] = coefTest(mdl, Cmat(i,:));
    %     fprintf('%s: p = %.4f\n', comparisons{i}, pF(i));
    % end

    for i = 1:size(Cmat,1)
        C = Cmat(i,:);
        [pF(i), F, DF] = coefTest(mdl, C);
        fprintf('%s: p = %.4f\n', comparisons{i}, pF(i));

        % Determine which group is higher
        d = C * mdl.Coefficients.Estimate;
        % For positive d, first group in comparison is higher
        % Extract group names from string 'G2 vs G1' etc
        parts = split(comparisons{i}, ' vs ');
        directions(i) = ternary(d>0, parts{1}, parts{2});
    end

    % Bonferroni correction
    p_adj = min(pF * numel(pF), 1);
    disp('Bonferroni-corrected p-values:');
    disp(table(comparisons', pF, p_adj, 'VariableNames', {'Comparison','p','p_adj'}));



    minN = 5;   % minimum points required for a fit

    bloop  = figure('Position',[100 100 700 500]); hold on
    set(bloop, 'PaperOrientation', 'landscape');
    groups  = categories(grp);
    markers = {'o','o','s','^'};         % last group = triangle
    faces   = {'none','k','none','k'};
    lineStyles = {'--','-','-.','-'};    % 4 line styles
    colors = [0.5 0.5 0.5; 0 0 0; 0 0 0; 0.7 0.7 0.7];  % RGB for 4 lines


    % ---- Scatter ----
    for i = 1:numel(groups)
        idx = grp == groups{i};

        scatter(x(idx), y(idx), 60, ...
            'Marker', markers{i}, ...
            'MarkerEdgeColor','k', ...
            'MarkerFaceColor', faces{i}, ...
            'LineWidth',1.2, ...
            'DisplayName', char(groups{i}));
    end


    xx = linspace(min(x), max(x), 200)';

    for i = 1:numel(groups)
        idx = grp == groups{i};

        if sum(idx) < minN
            fprintf('Skipping fit for %s (n = %d)\n', ...
                groups{i}, sum(idx));
            continue
        end

        g = repmat(groups(i), numel(xx), 1);
        Tpred = table(xx, g, 'VariableNames', {'x','grp'});
        yy = predict(mdl, Tpred);

        plot(xx, yy, 'LineStyle', lineStyles{i}, ...
            'Color', colors(i,:), ...
            'LineWidth', 2);

    end


    xlabel('Age');
    if strcmpi(tissueType,'GM')
        ylabel('GMV / TIV');
        leftleg = 0.3;
        rightleg = 0.65;
    elseif strcmpi(tissueType,'WM')
        ylabel('WMV / TIV');
        leftleg = 0.3;
        rightleg = 0.65;
    elseif strcmpi(tissueType,'CSF')
        ylabel('CSF / TIV');
        leftleg = 0.3;
        rightleg = 0.65;
    end

    %legend('Location','best');
    legend('NEXPO1','NEXPO2','NEXPO3','NEXPO4','FitG1','FitG2','FitG3','FitG4','Position',[leftleg rightleg 0.1 0.2]);
    box on;
    grid on;

    if exist('savedir','var')
        h = gcf;
        if strcmpi(tissueType,'GM')
            thisFilename = fullfile(savedir,'GM_plot');
            lmcoefs = fullfile(savedir,'GM_fitlm_coefficients.csv');
            pvalssave = fullfile(savedir,'GM_pairwise_pvalues.csv');
        elseif strcmpi(tissueType,'WM')
            thisFilename = fullfile(savedir,'WM_plot');
            lmcoefs = fullfile(savedir,'WM_fitlm_coefficients.csv');
            pvalssave = fullfile(savedir,'WM_pairwise_pvalues.csv');
        elseif strcmpi(tissueType,'CSF')
            thisFilename = fullfile(savedir,'CSF_plot');
            lmcoefs = fullfile(savedir,'CSF_fitlm_coefficients.csv');
            pvalssave = fullfile(savedir,'CSF_pairwise_pvalues.csv');

        end

        print(h, '-dpdf', thisFilename, '-r300');


        %% --- Save model coefficients ---
        coefTable = mdl.Coefficients;          % table with Estimate, SE, tStat, pValue
        coefCSV = [coefTable.Properties.RowNames, ...
            num2cell(coefTable.Estimate), ...
            num2cell(coefTable.SE), ...
            num2cell(coefTable.tStat), ...
            num2cell(coefTable.pValue)];

        % Convert to table for writing
        coefCSVTable = cell2table(coefCSV, ...
            'VariableNames', {'Coefficient','Estimate','SE','tStat','pValue'});

        writetable(coefCSVTable, lmcoefs);

        %% --- Save pairwise p-values ---
        % Your previously computed contrasts
        % This should match your 4-group contrasts
        % comparisons = {'G2 vs G1','G3 vs G1','G4 vs G1','G2 vs G3','G2 vs G4','G3 vs G4'};
        %pairCSVTable = table(comparisons', p_adj, 'VariableNames', {'Comparison','pValue'});

        pairCSVTable = table(comparisons', pF, p_adj, directions, ...
            'VariableNames', {'Comparison','pValue','p_adj','HigherGroup'});
        writetable(pairCSVTable, pvalssave);

        disp('CSV files saved: fitlm_coefficients.csv and pairwise_pvalues.csv');

    end




end





%%
function [GM, WM, CSF] = extract_aseg_vols(fname)

fid = fopen(fname,'r');
assert(fid > 0, 'Cannot open %s', fname);

seg = [];
vol = [];

while ~feof(fid)
    line = fgetl(fid);

    if isempty(line) || startsWith(line,'#')
        continue
    end

    % Split on whitespace (robust)
    parts = regexp(strtrim(line),'\s+','split');

    % Expect: Index SegId NVoxels Volume_mm3 StructName
    if numel(parts) < 4
        continue
    end

    seg(end+1) = str2double(parts{2}); %#ok<AGROW>
    vol(end+1) = str2double(parts{4}); %#ok<AGROW>
end

fclose(fid);

% Canonical FreeSurfer aseg labels
GM  = sum(vol(ismember(seg,[3 42])));
WM  = sum(vol(ismember(seg,[2 41])));
CSF = sum(vol(ismember(seg,[4 5 14 15])));
end

%%
function out = ternary(cond,trueVal,falseVal)
if cond
    out = trueVal;
else
    out = falseVal;
end
end
