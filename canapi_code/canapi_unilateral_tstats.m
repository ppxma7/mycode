close all
clear variables
clc

dataset = {'canapi_sub01_030225', 'canapi_sub02_180325', 'canapi_sub03_180325',...
    'canapi_sub04_280425','canapi_sub05_240625', 'canapi_sub06_240625',...
    'canapi_sub07_010725', 'canapi_sub08_010725', 'canapi_sub09_160725', ...
    'canapi_sub10_160725'};

%dataset = {'canapi_sub01_030225'};

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/unilateral_tstats/'];

myfiles = {'1barR_Lmask.csv','1barR_Rmask.csv','1barL_Rmask.csv','1barL_Lmask.csv'};

tfiles = zeros(length(myfiles),length(dataset));
weightedTs = zeros(length(myfiles),length(dataset));

tic
for iSub = 1:length(dataset)

    disp(['Running subject ' dataset{iSub}])

    for ii = 1:length(myfiles)

        mypath=['/Volumes/kratos/CANAPI/' dataset{iSub} '/spm_analysis/first_level/'];
        
        thisFile = fullfile(mypath,myfiles{ii});

        thisFile_contents = readtable(thisFile);

        % take max of peak T
        tfiles(ii,iSub) = max(thisFile_contents.peak_T);

        % Optional - compute the cluster-size weighted mean T
        Tvals = thisFile_contents.peak_T;
        KEvals = thisFile_contents.clust_ke;
        validIdx = ~isnan(Tvals) & ~isnan(KEvals);
        weightedTs(ii,iSub) = sum(Tvals(validIdx) .* KEvals(validIdx)) / sum(KEvals(validIdx));
        
        % Get the STDEV
        w = KEvals(validIdx);
        x = Tvals(validIdx);
        % Weighted mean (already computed)
        wmean = sum(w .* x) / sum(w);
        % Weighted variance (unbiased form)
        wvar = sum(w .* (x - wmean).^2) / sum(w);
        % Weighted standard deviation
        wstd = sqrt(wvar);
        %weightedTs2(ii,iSub)  = wmean;
        weightedStd(ii,iSub) = wstd;



    end
end
toc
% now plot?

% swap sub10 because he's left handed
weightedTs(:,10) = [weightedTs(3:4,10); weightedTs(1:2,10)];
weightedStd(:,10) = [weightedStd(3:4,10); weightedStd(1:2,10)];

y = weightedTs(:);
y_std = weightedStd(:);



subs = repmat({'sub01','sub02','sub03','sub04','sub05','sub06','sub07','sub08','sub09','sub10'},length(myfiles),1);
subs = subs(:);

filestack = repmat(myfiles(:),length(dataset),1);

cmap = {'#e31a1c','#fd8d3c','#0570b0','#74a9cf'};
cmapped = validatecolor(cmap,'multiple');
%%

legendLabels = filestack; % start with same names

legendLabels(strcmpi(filestack, '1barR_Lmask.csv')) = {'1barR_contralateral'};
legendLabels(strcmpi(filestack, '1barR_Rmask.csv')) = {'1barR_ipsilateral'};
legendLabels(strcmpi(filestack, '1barL_Rmask.csv')) = {'1barL_contralateral'};
legendLabels(strcmpi(filestack, '1barL_Lmask.csv')) = {'1barL_ipsilateral'};

% CAREFUL SWAP THIS FOR PLOTTING

% Example: y = 40x1 double, labels = 40x1 cell array
n = numel(y);

% preallocate
y_swapped = y;
y_swapped_std = y_std;
labels_swapped = legendLabels(:);

% loop through pairs (every 4 if pattern repeats in 4s)
for i = 1:4:n
    % pattern is [R_contra, R_ipsi, L_contra, L_ipsi]
    idx = i:(i+3);
    % new order: [L_contra, L_ipsi, R_contra, R_ipsi]
    new_order = [i+2, i+3, i, i+1];

    y_swapped(idx) = y(new_order);
    y_swapped_std(idx) = y_std(new_order);
    labels_swapped(idx) = legendLabels(new_order);
end

T = table(subs, y_swapped, y_swapped_std, labels_swapped, ...
          'VariableNames', {'Subject','Y','stdev','Label'});
writetable(T, fullfile(savedir,'output.csv'));



%%

% 
% close all
% clear g
% figure('Position',[100 100 1200 600])
% g = gramm('x', subs, 'y', y_swapped, 'color', labels_swapped);
% %g.geom_jitter2('dodge', 0);  % adds subject dots
% %g.geom_point()
% g.stat_summary('geom', {'bar'}, 'dodge', 0.6);  % mean over subjects
% g.set_names('x','Participant','y','T Stat','color','Task');
% %g.set_title('Max T stat per task');
% g.set_title('Cluster-size weighted average T-score per task');
% 
% g.set_text_options('Font','Helvetica', 'base_size', 16)
% g.set_point_options('base_size',12)
% g.set_color_options("map",cmapped)
% g.set_order_options("color",0)
% 
% g.axe_property('YLim', [0 30]);
% g.draw();
% filename = ('tstat_unilateral_weighted');
% g.export('file_name',filename, ...
%     'export_path',...
%     savedir,...
%     'file_type','pdf')

%% also run ANOVA
anovaLabels = split(T.Label,'_');
RLgroup = anovaLabels(:,1);
ContraIpsigroup = anovaLabels(:,2);

% In your data, each subject contributes multiple repeated measures 
% (four per subject: Left/Right × Contra/Ipsi).
% That means the data points from the same subject are not independent — 
% they share a baseline level of variability.
% If you don't tell MATLAB about this, it assumes all 40 observations are 
% independent — which artificially inflates the error term and 
% weakens your effects (especially the interaction).
%
% that's why we have to add the subjects in and put 

[p, tbl, stats] = anovan(T.Y, ...
    {subs, RLgroup, ContraIpsigroup}, ...
    'random', 1, ...                      % subject is random effect
    'model', 'interaction', ...           % include main + interaction
    'varnames', {'Subject','Task','Hemisphere'});
writecell(tbl,[savedir 'clust_anova_canapi' ],'FileType','spreadsheet')

[c,m,h,gnames] = multcompare(stats, 'Dimension', 2, ...
    'Display','on','CriticalValueType','bonferroni');
tbldom = array2table(c, 'VariableNames', ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A") = gnames(tbldom.("Group A"));
tbldom.("Group B") = gnames(tbldom.("Group B"));
title('Right vs Left task')
writetable(tbldom,[savedir 'clust_mult_d2_canapi' ],'FileType','spreadsheet')

[c,m,h,gnames] = multcompare(stats, 'Dimension', 3, ...
    'Display','on','CriticalValueType','bonferroni');
tbldom = array2table(c, 'VariableNames', ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A") = gnames(tbldom.("Group A"));
tbldom.("Group B") = gnames(tbldom.("Group B"));
title('Contra vs Ipsi')
writetable(tbldom,[savedir 'clust_mult_d3_canapi' ],'FileType','spreadsheet')

[c,m,h,gnames] = multcompare(stats, 'Dimension', [2 3], ...
    'Display','on','CriticalValueType','bonferroni');
tbldom = array2table(c, 'VariableNames', ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A") = gnames(tbldom.("Group A"));
tbldom.("Group B") = gnames(tbldom.("Group B"));
title('Interaction')
writetable(tbldom,[savedir 'clust_mult_d23_canapi' ],'FileType','spreadsheet')
%

%[p,tbl,stats] = anovan(T.Y, {RLgroup,ContraIpsigroup},'model','interaction');




%% plot with error bars gramm style

T.ymin = T.Y - T.stdev;
T.ymax = T.Y + T.stdev;


clc
close all
figure('Position',[100 100 1000 500]);

dodgeVal = 0.8;

g = gramm( ...
    'x', T.Subject, ...
    'y', T.Y, ...
    'color', T.Label, ...
    'ymin', T.ymin, ...
    'ymax', T.ymax);

% Bars + your own SD errorbars
g.geom_bar('width',0.8, 'stacked',false,'dodge',dodgeVal,'LineWidth',0.2) 
%g.geom_interval('geom','errorbar','dodge',0.5,'width',1);   % <- uses ymin/ymax that you defined

% Optional styling
g.set_names('x',[],'y','Mean T','color','Condition');
g.set_title('fMRI Cluster-weighted T-values');
g.axe_property('FontSize',12,'ylim',[0 35],'XGrid','on','YGrid','on');
g.set_order_options('x',0,'color',0)
g.set_color_options('map',cmapped)
g.no_legend
g.draw();

g.update()
g.geom_interval('geom','errorbar','dodge',dodgeVal,'width',0.6);   % <- uses ymin/ymax that you defined
comesInBlack = ones(4,3).*0.3;
g.set_color_options('map',comesInBlack)
g.no_legend
g.draw()

filename = ('tstatfmriplot_grammstyle');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')




%% manual plot - optional with error bars (stdev)
% close all
% clc
% 
% uniqueSubs = unique(subs);
% uniqueTasks = unique(labels_swapped);
% 
% nSub = numel(uniqueSubs);
% nTask = numel(uniqueTasks);
% 
% 
% % turn into 4 columns of 10
% Y = reshape(y_swapped,nTask,nSub)';
% Yerr = reshape(y_swapped_std,nTask,nSub)';
% 
% bloop = figure('Position',[100 100 1200 600]);
% set(bloop, 'PaperOrientation', 'landscape');
% hb = bar(Y, 'grouped'); % each row = subject, each column = task
% hold on
% 
% for i = 1:numel(hb)
%     hb(i).FaceColor = cmapped(i,:);  % RGB for task i
% end
% 
% % Add error bars
% [ngroups, nbars] = size(Y);
% groupwidth = min(0.8, nbars/(nbars + 1.5));
% 
% for ibar = 1:nbars
%     x = (1:ngroups) - groupwidth/2 + (2*ibar-1) * groupwidth / (2*nbars); % x positions for bars in group
%     errorbar(x, Y(:,ibar), Yerr(:,ibar), 'k', 'linestyle', 'none', 'LineWidth', 1.5);
% end
% 
% % Labels
% set(gca,'XTick',1:nSub,'XTickLabel',uniqueSubs)
% ylabel('Cluster-size weighted T')
% ylim([0 35])
% legend(uniqueTasks,'Location','Best','Interpreter', 'none')
% title('Cluster-size weighted average T-score per task')
% grid on
% (cmapped)
% h = gcf;
% 
% thisFilename = [savedir 'tstat_unilateral_weighted_wstdevbars'];
% print(h, '-dpdf', thisFilename, '-r300');  % -r300 sets the resolution to 300 DPI
% 
% 
% 


 %% also plot separately
% weightedTs_R = weightedTs(1:2,:);
% weightedTs_L = weightedTs(3:4,:);
% yR = weightedTs_R(:);
% yL = weightedTs_L(:);
% subs = repmat({'sub01','sub02','sub03','sub04','sub05','sub06','sub07','sub08','sub09','sub10'},2,1);
% subs = subs(:);
% filestackR = repmat(myfiles(1:2),length(dataset),1);
% filestackL = repmat(myfiles(3:4),length(dataset),1);
% filestackR = filestackR';
% filestackL = filestackL';
% filestackR = filestackR(:);
% filestackL = filestackL(:);
% 
% legendLabelsR = filestackR; % start with same names
% legendLabelsR(strcmpi(filestackR, '1barR_Lmask.csv')) = {'1barR_contralateral'};
% legendLabelsR(strcmpi(filestackR, '1barR_Rmask.csv')) = {'1barR_ipsilateral'};
% legendLabelsL = filestackL; % start with same names
% legendLabelsL(strcmpi(filestackL, '1barL_Lmask.csv')) = {'1barL_ipsilateral'};
% legendLabelsL(strcmpi(filestackL, '1barL_Rmask.csv')) = {'1barL_contralateral'};
% 
% 
% close all
% clear g
% figure('Position',[100 100 1200 600])
% g = gramm('x', subs, 'y', yR, 'color', legendLabelsR);
% %g.geom_jitter2('dodge', 0);  % adds subject dots
% %g.geom_point()
% g.stat_summary('geom', {'bar'}, 'dodge', 0.6);  % mean over subjects
% g.set_names('x','Participant','y','T Stat','color','Task');
% %g.set_title('Max T stat per task');
% g.set_title('Cluster-size weighted average T-score per task');
% 
% g.set_text_options('Font','Helvetica', 'base_size', 16)
% g.set_point_options('base_size',12)
% g.set_color_options("map",cmapped)
% g.set_order_options("color",0)
% 
% g.axe_property('YLim', [0 30]);
% g.draw();
% filename = ('tstat_unilateral_weighted_R');
% g.export('file_name',filename, ...
%     'export_path',...
%     savedir,...
%     'file_type','pdf')
% 
% close all
% clear g
% figure('Position',[100 100 1200 600])
% g = gramm('x', subs, 'y', yL, 'color', legendLabelsL);
% %g.geom_jitter2('dodge', 0);  % adds subject dots
% %g.geom_point()
% g.stat_summary('geom', {'bar'}, 'dodge', 0.6);  % mean over subjects
% g.set_names('x','Participant','y','T Stat','color','Task');
% %g.set_title('Max T stat per task');
% g.set_title('Cluster-size weighted average T-score per task');
% 
% g.set_text_options('Font','Helvetica', 'base_size', 16)
% g.set_point_options('base_size',12)
% g.set_color_options("map",cmapped(3:4,:))
% g.set_order_options("color",0)
% 
% g.axe_property('YLim', [0 30]);
% g.draw();
% filename = ('tstat_unilateral_weighted_L');
% g.export('file_name',filename, ...
%     'export_path',...
%     savedir,...
%     'file_type','pdf')



%% can we load in the EMG RMS and correlate here??

emgrmspath = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/miscdata/'];

% Load EMG RMS data and correlate with T-statistics
%emgDataStruct = load(fullfile(emgrmspath, 'canapi_rms_emg.mat'));
emgDataStruct = load(fullfile(emgrmspath, 'canapi_xcorr_emg.mat')); % cheeky try looking at amplitude xcorr not RMS

%emgData = emgDataStruct.ch1_vs_ch2;
emgData = emgDataStruct.ch1vch2_xcorr_peakXC;



% correlationResults = corr(weightedTs(:), emgData.RMS);
% disp(['Correlation between T-statistics and EMG RMS: ', num2str(correlationResults)]);

% Assume you have:
% rms_data (4x10)
% fmri_data (4x10)

% Select rows of interest: 1barR (row 1) and 1barL (row 3)
% swap sub10 because he's left handed
emgData(:,10) = [emgData(3:4,10); emgData(1:2,10)];

emg_1barR = emgData(1,:); % 1 x 10
emg_1barL = emgData(3,:); % 1 x 10

emg_1barR = emg_1barR(:);
emg_1barL = emg_1barL(:);


fmri_1barR_contra = weightedTs(1,:); % contralateral
fmri_1barR_ipsi   = weightedTs(2,:); % ipsilateral
fmri_1barL_contra = weightedTs(3,:);
fmri_1barL_ipsi   = weightedTs(4,:);

% Compute ratios (contralateral / ipsilateral * 100)
fmri_ratio_1barR = (fmri_1barR_contra ./ fmri_1barR_ipsi) * 100;
fmri_ratio_1barL = (fmri_1barL_contra ./ fmri_1barL_ipsi) * 100;

fmri_ratio_1barR = fmri_ratio_1barR(:);
fmri_ratio_1barL = fmri_ratio_1barL(:);


disp('fMRI Contra/Ipsi ratio (%):')
disp('1barR:')
disp(fmri_ratio_1barR)
disp('1barL:')
disp(fmri_ratio_1barL)

[r_R, p_R] = corr(emg_1barR, fmri_ratio_1barR,'Type','Spearman');
[r_L, p_L] = corr(emg_1barL, fmri_ratio_1barL,'Type','Spearman');

fprintf('Correlation 1barR: r=%.3f, p=%.3f\n', r_R, p_R);
fprintf('Correlation 1barL: r=%.3f, p=%.3f\n', r_L, p_L);
%% plotting
nSubjects = 10;

%colors = cbrewer('qual', 'Set3', nSubjects);

% Define your custom colors as an n×3 RGB matrix (scaled 0–1)
colors = [
    166 206 227
     31 120 180
    178 223 138
     51 160  44
    251 154 153
    227  26  28
    253 191 111
    255 127   0
    202 178 214
    106  61 154
] ./ 255;  % convert from 0–255 to 0–1

subject_labels = compose('sub%02d', 1:nSubjects);
close all
clear g
figure('Position',[100 100 1000 500])
g(1,1) = gramm('x',emg_1barL,'y',fmri_ratio_1barL) ;
g(1,1).stat_glm('geom','line');
g(1,1).set_title(['r=' num2str(r_L) ' p=' num2str(p_L)]);

g(1,2) = gramm('x',emg_1barR,'y',fmri_ratio_1barR);
g(1,2).stat_glm('geom','line');
g(1,2).set_title(['r=' num2str(r_R) ' p=' num2str(p_R)]);
g.draw()
g(1,1).update('color',subject_labels);
g(1,1).geom_point()
g(1,2).update('color',subject_labels);
g(1,2).geom_point()


g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',12)
g.set_color_options("map",colors)
g.set_order_options("color",0)
g.axe_property('XGrid',1,'YGrid',1) %,'YLim',[80 200],'XLim',[0 800])
g.set_names('x','Amp XCorr EMG','y','fMRI Contra/Ipsi (%)','color','Participant');

g.draw()


ax = gcf;             % current figure
allAxes = findall(ax, 'type', 'axes');

for i = 1:numel(allAxes)
    axes(allAxes(i));  % make this subplot active
    xline(100, '--k', 'LineWidth', 1.2);  % example at x=100
end

filename = ('xcorr_vs_tstat');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')


%% plot emg xcorr again
run_labels = {'1barL', '1barR'};
run_labels_stack = repmat(run_labels,1,length(dataset))';
subs = repmat({'sub01','sub02','sub03','sub04','sub05','sub06','sub07','sub08','sub09','sub10'},length(run_labels),1);
subs = subs(:);

cmap = {'#238b45','#66c2a4','#b2e2e2','#edf8fb'};
cmapped = validatecolor(cmap,'multiple');

channel_labels = {'EMG ch1', 'EMG ch2'};

emgData_forplot = [emgData(3,:); emgData(1,:)];
emgData_forplot = emgData_forplot(:);

% remove subject3
sub3dex = strcmpi(subs,'sub03');
subs_no3 = subs(~sub3dex);
emgData_forplot_no3 = emgData_forplot(~sub3dex);
run_labels_stack_no3 = run_labels_stack(~sub3dex);
removeSub3 = 'True';

dodgeVal = 0.8;
clear g
figure('Position',[100 100 1000 500])
if removeSub3
    g = gramm('x', subs_no3, 'y', emgData_forplot_no3, 'color', run_labels_stack_no3);
else
    g = gramm('x', subs, 'y', emgData_forplot, 'color', run_labels_stack);
end

g.geom_bar('width',0.8, 'stacked',false,'dodge',dodgeVal,'LineWidth',0.2) 
%g.stat_summary('geom', {'bar'}, 'dodge', 0.6);  % mean over subjects
g.set_names('x',[],'y','Amplitude cross-correlation','color','Task');
%g.set_title('Max T stat per task');
g.set_title('EMG leg 1 and leg 2 cross-correlation');

g.set_text_options('Font','Helvetica', 'base_size', 12) 
g.axe_property('FontSize',16,'ylim',[0 16],'XGrid','on','YGrid','on');
g.set_color_options("map",cmapped)
g.set_order_options("color",0)
g.no_legend()

% Optional styling
% g.set_names('x',[],'y','Mean T','color','Condition');
% g.set_title('fMRI T-values');
% g.axe_property('FontSize',12,'ylim',[0 16],'XGrid','on','YGrid','on');
% g.set_order_options('x',0,'color',0)
% g.set_color_options('map',cmapped)
% g.no_legend
% g.draw();


%g.axe_property('YLim', [0 30]);
g.draw();
if removeSub3
    filename = 'xcorr_emg_no3';
else
    filename = 'xcorr_emg';
end
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

%% stats
[B I] = sort(run_labels_stack_no3);
emgData_sorted = emgData_forplot_no3(I);
emgData_leftVals = emgData_sorted(1:9);
emgData_rightVals = emgData_sorted(10:18);
[~, p, ~, stats] = ttest(emgData_leftVals, emgData_rightVals);
%fprintf('Paired t-test: t(%d) = %.3f, p = %.4f\n', stats.df, stats.tstat, p);

% Format the output string
outstr = sprintf('Paired t-test: t(%d) = %.3f, p = %.4f\n', stats.df, stats.tstat, p);
fprintf(outstr)
outfile = fullfile(savedir, 'emg_pairedttest_results.txt');
writelines(outstr, outfile)

%% matrix
% 
% figure('Position', [100 100 600 200])
% imagesc(tfiles)
% %clim([0 12])
% colorbar
% colormap inferno
% xlabel('Participant');
% ylabel('Task');
% %title('RMS of EMG traces');
% h = gcf;
% thisFilename = [savedir 'tstat_unilateral_matrix'];
% %print(h, '-dpdf', thisFilename, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI
% print(h, '-dpdf', thisFilename, '-r300');  % -r300 sets the resolution to 300 DPI
% 
% 
% 
% 
% 









