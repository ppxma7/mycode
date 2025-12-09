% chain afirm sashb
% ages = [
%     58 63 56 57 65 62 61 63 63 57 63 63 56 65 ...
%     75 55 47 39 41 65 69 31 64 70 61 70 72 37 55 41 60 67 49 57 73 49 ...
%     57 56 ...
%     ]';

% nexpo
% ages = [19 18 19 19 19 18 18 18 19 19 19 19 19 18 19 18 18 18 18 19 18 19 ...
%         19 19 19 18 18 19 19 18 19 18 19 19 19 19 19 18 18 18 19 18 18 18 18 19 18 18 18 ...
%         34 31 43 38 35 33 49 46 36 45 30 44 46 31 37 39 38 45 34 30 31 35 40 43 33 41 45 ...
%         33 49 45 37 44 42 40 50 50 37 49 47 49 50 46 40 ...
%         39 46 41 32 40 33 35 31 31 37 43 44 33 31 32 33 45 43 47 45 49 45 42 39 38 32 30 ...
%         38 46 38 46 38 43 50 43 47 31 47 41 36 41 38 47 35 43 49 48 46 ...
%         35 47 45 31 46 48 48 47 49 37 49 37 44 45 45 31 50 50 34 36 32 34 39 39 49 40 49 ...
%         45 30 41 49 35 34 32 40 43 42 40 36 43 38 33 33 31 38 30 38 41 35]';

ages = [19	18	19	19	19	18	18	18	19	19	19	19	19	18	19	18	18	18	19	18	19	...
        19	19	19	18	18	19	19	18	19	18	19	19	19	19	19	18	18	18	19	18	18	...
        18	18	19	18	18	18	34	31	43	38	35	33	49	46	36	45	30	44	46	31	37	... 
        39	38	45	34	30	31	35	40	43	33	41	45	33	49	45	37	44	42	40	50	50	...
        37	49	47	49	50	46	40	39	46	41	32	40	33	35	31	31	37	43	44	33	31	...
        32	33	45	43	47	45	49	45	42	39	38	32	30	38	46	38	46	38	43	50	43	...
        47	31	47	41	36	41	38	47	35	43	49	48	46	47	45	31	46	48	48	47	49	...
        37	49	37	44	45	45	31	50	50	34	36	32	34	39	39	49	40	49	45	30	41	...
        49	35	34	32	40	43	42	40	36	43	38	33	33	31	38	30	38	41	35]';


length(ages)

%groupNames = {'AFIRM','CHAIN','SASHB'};
groupNames = {'NEXPO_G1', 'NEXPO_G2', 'NEXPO_G3', 'NEXPO_G4'};
savedgroup = 'dtijustnexpo';
%savedgroup = 'afirm_chain_sashb';

%pathin = '/Volumes/kratos/dti_data/MD/chain_afirm_sash/';
%pathin = '/Volumes/kratos/dti_data/tbss_analysis_wchain/origdata/';
pathin = '/Volumes/kratos/dti_data/MD/nexpo/';
%pathin = '/Volumes/kratos/dti_data/tbss_analysis_justnexpo/';

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/dti_data/' savedgroup '/'];
type = 'MD';

dti_getmean('pathin',pathin,'ages',ages,'groupNames',groupNames,'savedir',savedir,'type',type);



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



files = dir(pathin);
fileTable = struct2table(files);
fileNames = fileTable.name;
niftiFileNames = fileNames(contains(fileNames,'.nii.gz'));

fprintf('Found %d files\n',length(niftiFileNames))

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



%%
if exist('ages','var')
    close all
    x = ages(:);
    y = vm(:);

    % Convert to categorical once
    grp = categorical(plotGroup(:));   % <— DO NOT use the name plotGroup
    %     inside the model formula

    % --- Fit the interaction model ---
    tbl = table(x, y, grp);
    mdl = fitlm(tbl, 'y ~ x + grp');
    disp(mdl)
    coefTable = mdl.Coefficients;

    if sum(contains(groupNames,'CHAIN'))

        % Compare CHAIN vs AFIRM
        C = [0 0 1 0];
        [pF(1), F, DF] = coefTest(mdl, C);
        fprintf('p-value CHAIN vs AFIRM: %.4f\n', pF(1));

        % Compare AFIRM vs SASHB
        C = [0 0 0 1];
        [pF(2), F, DF] = coefTest(mdl, C);
        fprintf('p-value AFIRM vs SASHB: %.4f\n', pF(2));

        % Compare CHAIN vs SASHB
        C = [0 0 -1 1];
        [pF(3), F, DF] = coefTest(mdl, C);
        fprintf('p-value CHAIN vs SASHB: %.4f\n', pF(3));

        p_adj = min(pF * numel(pF), 1);   % Bonferroni correction
        disp(p_adj)


        minN = 3;   % minimum points required for a fit

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
            rightleg = 0.7;
        end

        %legend('Location','best');
        legend('AFIRM','CHAIN','SASHB','FitAFIRM','FitCHAIN','Position',[leftleg rightleg 0.1 0.2]);
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
            comparisons = {'CHAIN vs AFIRM','AFIRM vs SASHB','CHAIN vs SASHB'};

            pairCSVTable = table(comparisons', p_adj', 'VariableNames', {'Comparison','pValue'});
            writetable(pairCSVTable, pvalssave);

            disp('CSV files saved: fitlm_coefficients.csv and pairwise_pvalues.csv');

        end

    elseif contains(groupNames,'NEXPO')
        comparisons = {'G2 vs G1','G3 vs G1','G4 vs G1','G2 vs G3','G2 vs G4','G3 vs G4'};
        
        Cmat = [ 0 0  1  0  0;   % G2 vs G1
                 0 0  0  1  0;   % G3 vs G1
                 0 0  0  0  1;   % G4 vs G1
                 0 0  1 -1  0;   % G2 vs G3
                 0 0  1  0 -1;   % G2 vs G4
                 0 0  0  1 -1];  % G3 vs G4
        
        pF = zeros(size(Cmat,1),1);
        
        for i = 1:size(Cmat,1)
            [pF(i), F, DF] = coefTest(mdl, Cmat(i,:));
            fprintf('%s: p = %.4f\n', comparisons{i}, pF(i));
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
        legend('NEXPO1','NEXPO2','NEXPO3','NEXPO4','FitG1','FitG2','FitG3','FitG4','Position',[leftleg rightleg 0.1 0.2]);
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
            pairCSVTable = table(comparisons', p_adj, 'VariableNames', {'Comparison','pValue'});
            writetable(pairCSVTable, pvalssave);
            
            disp('CSV files saved: fitlm_coefficients.csv and pairwise_pvalues.csv');

        end




    end

else
    error('Not setup for plotting without ages')

end

%%

end