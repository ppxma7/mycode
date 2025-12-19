%
%
% This is the same as the dti_get_mean_script. We want to plot the age vs
% T1 values, correcting for age.


thisRUN = 'AFIRM';
thisTYPE = 'T1';
GMorWM = 'GM';

if strcmpi(thisRUN,'AFIRM')
    % THIS ISNT FIXED YET ON ACCOUNT OF BAD T1 SUBJECTS
    % chain afirm sashb
    ages = [
        34 35 30 39 31 40 43 38 35 33 49 44 46 31 36 45 30 44 46 31 ...
        37 39 38 45 34 30 40 43 33 32 41 45 33 49 45 44 42 40 50 50 37 49 49 46 40 ...
        75 55 47 39 41 65 69 31 64 70 61 70 72 37 55 41 60 67 49 57 73 49 ...
        57 56 57 ...
        ]';

    if strcmpi(thisTYPE,'T1')
        groupNames = {'group2','group5','group6'};
        savedgroup = 'nexpog2_afirm_sashb';
        pathin = '/Volumes/nemosine/SAN/t1mnispace/g2_afirm_sashb_gmwm/';
    else
        error('No other metric here')
    end

elseif strcmpi(thisRUN,'NEXPO')
    % fewer subs here than DTI, recall
    ages = [19 18 19 19 18 18 18 19 19 19 19 19 18 19 18 19 18 18 18 19 18 19 19 19 19 18 18 19 19 18 ...
        19 19 19 19 19 18 18 18 19 18 18 18 18 18 18 18 34 35 30 39 31 40 43 38 35 33 49 44 46 31 ...
        36 45 30 44 46 31 37 39 38 45 34 30 40 43 33 32 41 45 33 49 45 44 42 40 50 50 37 49 49 46 ...
        40 39 46 41 32 40 33 35 31 31 37 44 31 33 45 43 47 45 49 45 39 38 32 30 38 46 38 46 38 43 ...
        50 43 47 31 37 47 41 36 41 38 47 35 43 49 48 46 35 47 45 31 46 48 48 47 49 37 49 37 44 45 ...
        31 50 50 34 36 32 34 39 39 49 40 49 30 49 35 34 32 40 43 42 40 36 43 38 33 31 38 30 38 35]';

    if strcmpi(thisTYPE,'T1')
        groupNames = {'group1', 'group2', 'group3', 'group4'};
        pathin = '/Volumes/nemosine/SAN/t1mnispace/nexpo_gmwm/';
    else
        error('No other metric here')
    end
    savedgroup = 'updates_nexpog1234_wageascov';

else
    error('error, incorrect RUN')

end

length(ages)

%groupNames = {'AFIRM','CHAIN','SASHB'};
%groupNames = {'NEXPOG1', 'NEXPOG2', 'NEXPOG3', 'NEXPOG4'};
%groupNames = {'NEXPO_G1', 'NEXPO_G2', 'NEXPO_G3', 'NEXPO_G4'};

%savedgroup = 'dtijustnexpo';
%savedgroup = 'afirm_chain_sashb';


%pathin = '/Volumes/kratos/dti_data/tbss_analysis_wchain/origdata/';
%pathin = '/Volumes/kratos/dti_data/tbss_analysis_wchain/MD/origMD/';
%pathin = '/Volumes/kratos/dti_data/tbss_analysis_justnexpo/origdata/';
%pathin = '/Volumes/kratos/dti_data/tbss_analysis_justnexpo/MD/origMD/';

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/t1mapping/' savedgroup '/'];

t1_getmean('pathin',pathin,'ages',ages,'groupNames',groupNames,'savedir',savedir,'type',thisTYPE,'gmorwm',GMorWM);



%%
function[]=t1_getmean(varargin)

clc

if sum(strcmp('pathin',varargin))
    pathin = varargin{find(strcmp('pathin',varargin))+1};
else
    error('I need a path')
end

if sum(strcmp('groupNames',varargin))
    groupNames = varargin{find(strcmp('groupNames',varargin))+1};
end

if sum(strcmp('ages',varargin))
    ages = varargin{find(strcmp('ages',varargin))+1};
end

if sum(strcmp('savedir',varargin))
    savedir = varargin{find(strcmp('savedir',varargin))+1};
end

if sum(strcmp('type',varargin))
    type = varargin{find(strcmp('type',varargin))+1};
end

if sum(strcmp('gmorwm',varargin))
    gmorwm = varargin{find(strcmp('gmorwm',varargin))+1};
end

% LOADING
vm = [];   % initialise once
thisFileList = {};
% this is complicated because there are 4 group folders
for ii = 1:length(groupNames)
    pathin_tmp = fullfile(pathin, groupNames{ii},gmorwm,'/');

    files = dir(fullfile(pathin_tmp, '*.nii.gz'));
    fprintf('Group %s: Found %d files\n', groupNames{ii}, numel(files))

    for jj = 1:numel(files)
        thisFile = fullfile(pathin_tmp, files(jj).name);
        thisFileContents = niftiread(thisFile);

        fprintf('Getting nonzero mean of %s\n', files(jj).name)
        v = thisFileContents(:);
        v = v(v>100); % fudge threshold for T1 values, otherwise means are unrealistically low

        vm(end+1,1) = mean(nonzeros(v));
        % save filename
        thisFileList{end+1,1} = thisFile;
    end
end

% fix order
orderedFiles = cell(0,1);

for g = 1:numel(groupNames)
    thisGroupFiles = thisFileList(contains(thisFileList, groupNames{g}));
    orderedFiles = [orderedFiles; thisGroupFiles(:)];
end

thisFileList = orderedFiles;

% if exist('group','var')
%     groupMean = mean(vm(contains(niftiFileNames,group,'IgnoreCase',true)));
% end

groupList = strings(numel(thisFileList),1);

for gg = 1:numel(groupNames)
    idx = contains(thisFileList, groupNames{gg});
    groupList(idx) = groupNames{gg};
end

groupList = cellstr(groupList);



mu = mean(vm, 'omitnan');
sd = std(vm,  'omitnan');

z = (vm - mu) ./ sd;
outIdx = abs(z) > 3;
table(thisFileList(outIdx), groupList(outIdx), vm(outIdx), z(outIdx), ...
    'VariableNames', {'File','Group','MeanT1','Z'})




%%
if exist('ages','var')

    if sum(contains(groupNames,'group5'))


        x = ages(:);
        %x = x - mean(x);   % centre age this is so you can compare intercepts at mean age
        y = vm(:);
        % Convert to categorical once
        %grp = categorical(plotGroup(:));   % <— DO NOT use the name plotGroup
        %     inside the model formula
        grp = categorical(groupList(:), {'group2','group5','group6'}, ...
            'Ordinal', false);
        % Preallocate
        directions = strings(3,1)';

        % --- Fit the interaction model ---
        tbl = table(x, y, grp);
        mdl = fitlm(tbl, 'y ~ x * grp');
        % We are using fitlm here instead of simple ANOVA because we need to
        % take age into account as a covariate!
        disp(mdl)
        disp(categories(grp))
        disp(mdl.CoefficientNames')
        coefTable = mdl.Coefficients;

        % Preallocate
        directions = strings(3,1)';

        % AFIRM vs G2 (slope difference)
        C = [0 0 0 0 1 0];
        [pF(1),~,~] = coefTest(mdl, C);
        d = C * mdl.Coefficients.Estimate;
        directions(1) = ternary(d>0,'AFIRM','G2');
        fprintf('Slope: AFIRM vs G2 p = %.4f\n', pF(1));

        % SASHB vs G2 (slope difference)
        C = [0 0 0 0 0 1];
        [pF(2),~,~] = coefTest(mdl, C);
        d = C * mdl.Coefficients.Estimate;
        directions(2) = ternary(d>0,'SASHB','G2');
        fprintf('Slope: SASHB vs G2 p = %.4f\n', pF(2));

        % AFIRM vs SASHB (slope difference)
        C = [0 0 0 0 1 -1];
        [pF(3),~,~] = coefTest(mdl, C);
        d = C * mdl.Coefficients.Estimate;
        directions(3) = ternary(d>0,'AFIRM','SASHB');
        fprintf('Slope: AFIRM vs SASHB p = %.4f\n', pF(3));

        p_adj = min(pF * numel(pF), 1);
        disp(p_adj)


        minN = 5;   % minimum points required for a fit

        bloop  = figure('Position',[100 100 700 500]); hold on
        set(bloop, 'PaperOrientation', 'landscape');
        groups  = categories(grp);
        markers = {'o','o','s'};
        faces   = {'none','k','none'};

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
        lineStyles = {'--','-','-.'};   % solid, dashed, dash-dot
        colors     = [0.5 0.5 0.5; 0 0 0; 0 0 0];  % RGB, black/gray/black

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
                'LineWidth', 2,...
                'DisplayName', sprintf('Fit%s', char(groups{i})));

        end


        xlabel('Age');
        if strcmpi(gmorwm,'GM')
            ylabel('GM');
            leftleg = 0.7;
            rightleg = 0.65;
        elseif strcmpi(gmorwm,'WM')
            ylabel('WM');
            leftleg = 0.8;
            rightleg = 0.65;
        end

        %legend('Location','best');
        legend('NEXPOG2','AFIRM','SASHB','FitNEXPOG2','FitAFIRM','Location','best')
        box on;
        grid on;

        if exist('savedir','var')
            h = gcf;
            if strcmpi(gmorwm,'GM')
                thisFilename = fullfile(savedir,'GM_plot');
                lmcoefs = fullfile(savedir,'GM_fitlm_coefficients.csv');
                pvalssave = fullfile(savedir,'GM_pairwise_pvalues.csv');
            elseif strcmpi(gmorwm,'WM')
                thisFilename = fullfile(savedir,'WM_plot');
                lmcoefs = fullfile(savedir,'WM_fitlm_coefficients.csv');
                pvalssave = fullfile(savedir,'WM_pairwise_pvalues.csv');
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
            comparisons = {'NEXPOG2 vs AFIRM','AFIRM vs SASHB','NEXPOG2 vs SASHB'};

            %pairCSVTable = table(comparisons', p_adj', 'VariableNames', {'Comparison','pValue'});
            pairCSVTable = table(comparisons', p_adj', directions', 'VariableNames', {'Comparison','pValue','HigherGroup'});

            writetable(pairCSVTable, pvalssave);

            disp('CSV files saved: fitlm_coefficients.csv and pairwise_pvalues.csv');

        end

    elseif sum(contains(groupNames,'group1')) % NEXPO

        x = ages(:);
        %x = x - mean(x);   % centre age this is so you can compare intercepts at mean age
        y = vm(:);
        % Convert to categorical once
        %grp = categorical(plotGroup(:));   % <— DO NOT use the name plotGroup
        %     inside the model formula
        grp = categorical(groupList(:), groupNames, ...
            'Ordinal', false);

        % --- Fit the interaction model ---
        tbl = table(x, y, grp);
        %mdl = fitlm(tbl, 'y ~ x + grp'); % this will force same slopes
        mdl = fitlm(tbl, 'y ~ x * grp'); % here add interaction effect (does age differ between groups)
        % We are using fitlm here instead of simple ANOVA because we need to
        % take age into account as a covariate!
        disp(mdl)
        disp(categories(grp))
        disp(mdl.CoefficientNames')

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



        minN = 3;   % minimum points required for a fit

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
        if strcmpi(gmorwm,'GM')
            ylabel('GM');
            leftleg = 0.7;
            rightleg = 0.65;
        elseif strcmpi(gmorwm,'WM')
            ylabel('WM');
            leftleg = 0.8;
            rightleg = 0.65;
        end

        %legend('Location','best');
        legend('NEXPO1','NEXPO2','NEXPO3','NEXPO4','FitG1','FitG2','FitG3','FitG4','Location','best');
        box on;
        grid on;

        if exist('savedir','var')
            h = gcf;
            if strcmpi(gmorwm,'GM')
                thisFilename = fullfile(savedir,'GM_plot');
                lmcoefs = fullfile(savedir,'GM_fitlm_coefficients.csv');
                pvalssave = fullfile(savedir,'GM_pairwise_pvalues.csv');
            elseif strcmpi(gmorwm,'WM')
                thisFilename = fullfile(savedir,'WM_plot');
                lmcoefs = fullfile(savedir,'WM_fitlm_coefficients.csv');
                pvalssave = fullfile(savedir,'WM_pairwise_pvalues.csv');
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

else
    error('Not setup for plotting without ages')

end

%%

end

function out = ternary(cond,trueVal,falseVal)
if cond
    out = trueVal;
else
    out = falseVal;
end
end
