
thisRUN = 'CHAIN';
thisTYPE = 'FA';
% options are either NEXPO or CHAIN 
% MD or FA
%root = '/Volumes/DRS-GBPerm/other/';
root = '/Volumes/kratos/';
if strcmpi(thisRUN,'CHAIN')
    % chain afirm sashb
    ages = [
        58 63 56 57 65 62 61 63 63 57 63 63 56 65 ...
        75 55 47 39 41 65 69 31 64 70 61 70 72 37 55 41 60 67 49 57 73 49 ... % 56 ...
        57 57 53 83 68 77 ...
        ]';
    groupNames = {'CHAIN','AFIRM','SASHB'};
    savedgroup = 'afirm_chain_sashb_jan2026';
    if strcmpi(thisTYPE,'FA')
        pathin = fullfile(root,'/dti_data/tbss_analysis_wchain_less300/origdata/');
    else
        pathin = fullfile(root,'/dti_data/tbss_analysis_wchain_less300/MD/origMD/');
    end

elseif strcmpi(thisRUN,'NEXPO')
    ages = [19	18	19	19	19	18	18	18	19	19	19	19	19	18	19	18	18	18	19	18	19 ...
        19	19	19	18	18	19	19	18	19	18	19	19	19	19	19	18	18	18	19	18	18 ...
        18	18	19	18	18	18	34	35	30	31	43	38	35	33	49	46	36	45	30	44	46 ...
        31	37	39	38	45	34	30	31	35	40	43	33	32	41	45	33	49	45	37	44	42 ...
        40	50	50	37	49	47	49	50	46	40	39	46	41	32	40	33	35	31	31	37	43 ...
        44	33	31	32	33	45	43	47	45	49	45	42	39	38	32	30	38	46	38	46	38 ...
        43	50	43	47	31	47	41	36	41	38	47	35	43	49	48	46	47	45	31	46	48 ...
        48	47	49	37	49	37	44	45	45	31	50	50	34	36	32	34	39	39	49	40	49 ...
        45	30	41	49	35	34	32	40	43	42	40	36	43	38	33	33	31	38	30	38	41	44	35]';
    if strcmpi(thisTYPE,'FA')
        groupNames = {'NEXPOG1', 'NEXPOG2', 'NEXPOG3', 'NEXPOG4'};
        pathin = fullfile(root,'dti_data/tbss_analysis_justnexpo/origdata/');
    else
        groupNames = {'NEXPO_G1', 'NEXPO_G2', 'NEXPO_G3', 'NEXPO_G4'};
        pathin = fullfile(root,'dti_data/tbss_analysis_justnexpo/MD/origMD/');
    end
    savedgroup = 'dtijustnexpo';

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
%savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/dti_data/' savedgroup '/'];
%type = 'FA';

rootdir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/'];
savedir = fullfile(rootdir,['dti_data/' savedgroup '/']);

% read egfr excel data first
eGFRfile = fullfile(rootdir,'afirm_EGFR.xlsx');
eGFRdata = readtable(eGFRfile,'Sheet',2);

% cleaning up
clearthisguy = contains(eGFRdata.Var2, '16998-002');
eGFRdata(clearthisguy, :) = [];

dti_getmean('pathin',pathin,'ages',ages,'groupNames',groupNames,'savedir',savedir,'type',thisTYPE,'egfr',eGFRdata);



%%
function[]=dti_getmean(varargin)

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

if sum(strcmp('egfr',varargin))
    egfr = varargin{find(strcmp('egfr',varargin))+1};
end



files = dir(pathin);
fileTable = struct2table(files);
fileNames = fileTable.name;
niftiFileNames = fileNames(contains(fileNames,'.nii.gz'));

fprintf('Found %d files\n',length(niftiFileNames))

% fix order
orderedFiles = cell(0,1);

for g = 1:numel(groupNames)
    thisGroupFiles = niftiFileNames(contains(niftiFileNames, groupNames{g}));
    orderedFiles = [orderedFiles; thisGroupFiles(:)];
end

niftiFileNames = orderedFiles;

labels = extractBefore(niftiFileNames,'_dti');

vm = zeros(length(niftiFileNames),1);
for ii = 1:length(niftiFileNames)

    thisFile = fullfile(pathin, niftiFileNames{ii});
    thisFileContents = niftiread(thisFile);
    %thisFileInfo = niftiinfo(thisFile);
    fprintf('Getting nonzero mean of %s\n',niftiFileNames{ii})
    v = thisFileContents(:);
    vm(ii) = mean(nonzeros(v));
end

% if exist('group','var')
%     groupMean = mean(vm(contains(niftiFileNames,group,'IgnoreCase',true)));
% end

if exist('groupNames','var')
    for ii = 1:length(groupNames)
        thisCount = sum(contains(niftiFileNames,groupNames{ii}));
        groupList{ii} = repmat(groupNames(ii),thisCount,1);
    end
    plotGroup = vertcat(groupList{:});

end

% save vm_chainafirmsash_fa vm
% save vm_nexpo_fa vm
% save vm_nexpo_md vm
% save vm_chainafirmsash_md vm

% get the subjectID
% [~, fname, ext] = cellfun(@fileparts, thisFileList, 'UniformOutput', false);
% fname = strcat(fname, ext);   % put .nii.gz back
% subjID = erase(fname, ['_T1_to_MPRAGE_' gmorwm '_MNI.nii.gz']);
% 

%% egfr

x24MonthEGFR = NaN(numel(niftiFileNames),1);

% Loop over your 23 EGFR IDs and assign values
for j = 1:height(egfr)
    idx = contains(niftiFileNames, egfr.Var2{j});
    x24MonthEGFR(idx) = egfr.x24MonthEGFR(j);
end


% Optional sanity check: how many matched
sum(~isnan(x24MonthEGFR))   % should be ~23

EGFR_label = strings(size(x24MonthEGFR));
EGFR_label(x24MonthEGFR < 30)  = "low";
EGFR_label(x24MonthEGFR >=30 & x24MonthEGFR <=60) = "medium";
EGFR_label(x24MonthEGFR > 60) = "high";


cLow     = [0.30 0.75 0.93];  % blue
cMedium  = [0.93 0.69 0.13];  % yellow
cHigh    = [0.85 0.33 0.10];  % red
cMissing = [0.7 0.7 0.7];     % grey

% Colour matrix
C = repmat([0.7 0.7 0.7], numel(niftiFileNames),1);  % default grey
C(EGFR_label=="low",:)    = repmat(cLow, sum(EGFR_label=="low"),1);
C(EGFR_label=="medium",:) = repmat(cMedium, sum(EGFR_label=="medium"),1);
C(EGFR_label=="high",:)   = repmat(cHigh, sum(EGFR_label=="high"),1);

groups = strings(numel(niftiFileNames),1);

% Example: determine group from path name
groups(contains(niftiFileNames,"CHAIN"))   = "CHAIN";
groups(contains(niftiFileNames,"AFIRM"))   = "AFIRM";
groups(contains(niftiFileNames,"SASHB"))   = "SASHB";









%%
collapsePatients = true;   % <-- SET THIS

if exist('ages','var')

    if sum(contains(groupNames,'CHAIN'))

        x = ages(:);
        %x = x - mean(x);   % centre age this is so you can compare intercepts at mean age
        y = vm(:);
        % Convert to categorical once
        %grp = categorical(plotGroup(:));   % <— DO NOT use the name plotGroup
        %     inside the model formula
        grp = categorical(plotGroup(:), {'CHAIN','AFIRM','SASHB'}, ...
            'Ordinal', false);
        origGroups = categories(grp); % for plotting later
        grpPlot = grp;
        if collapsePatients
            grp_model = grp;
            grp_model(grp == 'AFIRM' | grp == 'SASHB') = 'Patient';
            grp_model = categorical(grp_model, {'CHAIN','Patient'});
        else
            grp_model = grp;
        end


        grp = grp_model;

        % --- Fit the interaction model ---
        tbl = table(x, y, grp);
        %mdl = fitlm(tbl, 'y ~ x + grp'); % this will force same slopes
        mdl = fitlm(tbl, 'y ~ x * grp'); % here add interaction effect (does age differ between groups)
        % We are using fitlm here instead of simple ANOVA because we need to
        % take age into account as a covariate!
        disp(mdl)
        disp(categories(grp))
        disp(mdl.CoefficientNames')
        coefTable = mdl.Coefficients;
        
        if numel(categories(grp)) == 2
            % patient vs chain
            rowName = 'x:grp_Patient';
            pF = coefTable.pValue(strcmp(coefTable.Properties.RowNames, rowName));
            fprintf('Slope difference (Patient vs CHAIN): p = %.4f\n', pF);
        else

            directions = strings(3,1)';

            % AFIRM vs CHAIN (slope difference)
            C = [0 0 0 0 1 0];
            [pF(1),~,~] = coefTest(mdl, C);
            d = C * mdl.Coefficients.Estimate;
            directions(1) = ternary(d>0,'AFIRM','CHAIN');
            fprintf('Slope: AFIRM vs CHAIN p = %.4f\n', pF(1));

            % SASHB vs CHAIN (slope difference)
            C = [0 0 0 0 0 1];
            [pF(2),~,~] = coefTest(mdl, C);
            d = C * mdl.Coefficients.Estimate;
            directions(2) = ternary(d>0,'SASHB','CHAIN');
            fprintf('Slope: SASHB vs CHAIN p = %.4f\n', pF(2));

            % AFIRM vs SASHB (slope difference)
            C = [0 0 0 0 1 -1];
            [pF(3),~,~] = coefTest(mdl, C);
            d = C * mdl.Coefficients.Estimate;
            directions(3) = ternary(d>0,'AFIRM','SASHB');
            fprintf('Slope: AFIRM vs SASHB p = %.4f\n', pF(3));

            p_adj = min(pF * numel(pF), 1);
            disp(p_adj)
        end

        % now intercept differences
        % pI = zeros(3,1);
        % directionsI = strings(3,1)';
        % 
        % % AFIRM vs CHAIN
        % C = [0 0 1 0 0 0];
        % [pI(1),~,~] = coefTest(mdl, C);
        % d = C * mdl.Coefficients.Estimate;
        % directionsI(1) = ternary(d>0,'AFIRM','CHAIN');
        % fprintf('Intercept (mean age): AFIRM vs CHAIN p = %.4f\n', pI(1));
        % 
        % % SASHB vs CHAIN
        % C = [0 0 0 1 0 0];
        % [pI(2),~,~] = coefTest(mdl, C);
        % d = C * mdl.Coefficients.Estimate;
        % directionsI(2) = ternary(d>0,'SASHB','CHAIN');
        % fprintf('Intercept (mean age): SASHB vs CHAIN p = %.4f\n', pI(2));
        % 
        % % AFIRM vs SASHB
        % C = [0 0 1 -1 0 0];
        % [pI(3),~,~] = coefTest(mdl, C);
        % d = C * mdl.Coefficients.Estimate;
        % directionsI(3) = ternary(d>0,'AFIRM','SASHB');
        % fprintf('Intercept (mean age): AFIRM vs SASHB p = %.4f\n', pI(3));
        % 
        % % Bonferroni correction
        % pI_adj = min(pI * numel(pI), 1);
        % disp(pI_adj)


        minN = 2;   % minimum points required for a fit

        bloop  = figure('Position',[100 100 700 500]); hold on
        set(bloop, 'PaperOrientation', 'landscape');
        groups  = categories(grp);
        markers = {'o','o','d'};
        faces   = {'none','k','k'};
        groupFaceRGB = {[1 1 1],[0 0 0],[0 0 0]};

        % % ---- Scatter ----
        % for i = 1:numel(origGroups)
        %     idx = grpPlot == origGroups{i};
        % 
        %     scatter(x(idx), y(idx), 60, ...
        %         'Marker', markers{i}, ...
        %         'MarkerEdgeColor','k', ...
        %         'MarkerFaceColor', faces{i}, ...
        %         'LineWidth',1.2, ...
        %         'DisplayName', char(origGroups{i}));
        %     % %Add text labels
        %     % text(x(idx), y(idx), labels(idx), ...
        %     %     'FontSize',8, ...
        %     %     'VerticalAlignment','bottom', ...
        %     %     'HorizontalAlignment','left');
        % end

        for i = 1:numel(origGroups)
            idx = grpPlot == origGroups{i};

            groupIdx = find(idx);
            hasEGFR   = ~isnan(x24MonthEGFR(groupIdx));

            faceColorsRGB = repmat(groupFaceRGB{i}, sum(idx),1);       % default faces
            faceColorsRGB(hasEGFR,:) = C(groupIdx(hasEGFR),:); % override with EGFR colours

            scatter(x(idx), y(idx), 60, faceColorsRGB,...
                'Marker', markers{i}, ...
                'MarkerEdgeColor','k', ...
                'MarkerFaceColor', 'flat', ...
                'LineWidth',1.2, ...
                'DisplayName', char(origGroups{i}));


            % Add EGFR value labels to check it's correctly assigning
            % text(x(idx), y(idx), string(x24MonthEGFR(idx)), ...
            %     'FontSize',8, ...
            %     'HorizontalAlignment','center', ...
            %     'VerticalAlignment','bottom');

            text(x(idx), y(idx), labels(idx), ...
                'FontSize',8, ...
                'HorizontalAlignment','center', ...
                'VerticalAlignment','bottom');
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
                'LineWidth', 2);

        end


        xlabel('Age');
        if strcmpi(type,'MD')
            ylabel('Mean Diffusivity');
            leftleg = 0.4;
            rightleg = 0.7;
        elseif strcmpi(type,'FA')
            ylabel('Fractional Anisotropy');
            leftleg = 0.2;
            rightleg = 0.2;
        end

        %legend('Location','best');
        legend('CHAIN','AFIRM','SASHB','FitCHAIN','FitPATIENT','Position', [leftleg rightleg 0.1 0.1]);
        %legend('CHAIN','AFIRM','SASHB','FitCHAIN','FitPATIENT','Location', 'best');
        %legend('AFIRM','CHAIN','SASHB','FitAFIRM','FitCHAIN','Location','best');
        box on;
        grid on;

        if exist('savedir','var')
            h = gcf;
            if numel(categories(grp)) > 2
                if strcmpi(type,'MD')
                    thisFilename = fullfile(savedir,'MD_plot');
                    lmcoefs = fullfile(savedir,'MD_fitlm_coefficients.csv');
                    pvalssave = fullfile(savedir,'MD_pairwise_pvalues.csv');
                elseif strcmpi(type,'FA')
                    thisFilename = fullfile(savedir,'FA_plot');
                    lmcoefs = fullfile(savedir,'FA_fitlm_coefficients.csv');
                    pvalssave = fullfile(savedir,'FA_pairwise_pvalues.csv');
                end
            else
                if strcmpi(type,'MD')
                    thisFilename = fullfile(savedir,'MD_plot_combined_subjid');
                    lmcoefs = fullfile(savedir,'MD_fitlm_coefficients_combined.csv');
                    pvalssave = fullfile(savedir,'MD_pairwise_pvalues_combined.csv');
                elseif strcmpi(type,'FA')
                    thisFilename = fullfile(savedir,'FA_plot_combined_subjid');
                    lmcoefs = fullfile(savedir,'FA_fitlm_coefficients_combined.csv');
                    pvalssave = fullfile(savedir,'FA_pairwise_pvalues_combined.csv');
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
            if numel(categories(grp)) > 2
                comparisons_slope = {'AFIRM vs CHAIN','SASHB vs CHAIN','AFIRM vs SASHB'};
                pairCSVTable = table(comparisons_slope', p_adj', directions', 'VariableNames', {'Comparison','pValue','HigherGroup'});
                writetable(pairCSVTable, pvalssave);

                % comparisons_intercept = {'AFIRM vs CHAIN','SASHB vs CHAIN','AFIRM vs SASHB'};
                % interceptCSVFile = fullfile(savedir, 'intercept_pairwise_pvalues.csv');
                % pairInterceptTable = table(comparisons_intercept', pI_adj, directionsI', ...
                %                            'VariableNames', {'Comparison','pValue','HigherGroup'});
                % writetable(pairInterceptTable, interceptCSVFile);

                disp('CSV files saved: fitlm_coefficients.csv and pairwise_pvalues.csv');
            else
                disp('skip')
            end

        end

    elseif contains(groupNames,'NEXPO')


        x = ages(:);
        %x = x - mean(x);   % centre age this is so you can compare intercepts at mean age
        y = vm(:);
        % Convert to categorical once
        %grp = categorical(plotGroup(:));   % <— DO NOT use the name plotGroup
        %     inside the model formula
        grp = categorical(plotGroup(:), groupNames, ...
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
        if strcmpi(type,'MD')
            ylabel('Mean Diffusivity');
            leftleg = 0.3;
            rightleg = 0.7;
        elseif strcmpi(type,'FA')
            ylabel('Fractional Anisotropy');
            leftleg = 0.3;
            rightleg = 0.7;
        end

        %legend('Location','best');
        %legend('NEXPO1','NEXPO2','NEXPO3','NEXPO4','FitG1','FitG2','FitG3','FitG4','Position',[leftleg rightleg 0.1 0.2]);
        legend('NEXPO1','NEXPO2','NEXPO3','NEXPO4','FitG1','FitG2','FitG3','FitG4','Location','best');
        box on;
        grid on;

        if exist('savedir','var')
            h = gcf;
            if strcmpi(type,'MD')
                thisFilename = fullfile(savedir,'MD_plot');
                lmcoefs = fullfile(savedir,'MD_fitlm_coefficients.csv');
                pvalssave = fullfile(savedir,'MD_pairwise_pvalues.csv');
            elseif strcmpi(type,'FA')
                thisFilename = fullfile(savedir,'FA_plot');
                lmcoefs = fullfile(savedir,'FA_fitlm_coefficients.csv');
                pvalssave = fullfile(savedir,'FA_pairwise_pvalues.csv');

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
