close all
clear variables
clc

dataset = {'canapi_sub01_030225', 'canapi_sub02_180325', 'canapi_sub03_180325',...
    'canapi_sub04_280425','canapi_sub05_240625', 'canapi_sub06_240625',...
    'canapi_sub07_010725', 'canapi_sub08_010725', 'canapi_sub09_160725', ...
    'canapi_sub10_160725'};

%dataset = {'canapi_sub01_030225', 'canapi_sub02_180325'};

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/CANAPI Study (Ankle injury) - General/data/unilateral_tstats_raw/'];

if ~exist(savedir, 'dir')
    mkdir(savedir);
end

sigVal = 3.1;
sigValneg = -3.1;

% Right leg task
onebarR = 'spmT_0001.nii';
% Left leg task
onebarL = 'spmT_0003.nii';

% left hemisphere
maskL = '/Volumes/kratos/canapi_raw_tstats/prepostsmaCG_L_bin.nii';
vmaskL = niftiread(maskL);
% right hemisphere
maskR = '/Volumes/kratos/canapi_raw_tstats/prepostsmaCG_R_bin.nii';
vmaskR = niftiread(maskR);

tic
for iSub = 1:length(dataset)
    disp(['Running subject ' dataset{iSub}])

    % --- Paths to t-maps ---
    if iSub == 10
        % swap these round because sub10 is left handed
        tRfile = ['/Volumes/kratos/' dataset{iSub} '/spm_analysis/first_level/spmT_0003.nii']; % Right leg
        tLfile = ['/Volumes/kratos/' dataset{iSub} '/spm_analysis/first_level/spmT_0001.nii']; % Left leg
    elseif iSub ~= 10
        tRfile = ['/Volumes/kratos/' dataset{iSub} '/spm_analysis/first_level/spmT_0001.nii']; % Right leg
        tLfile = ['/Volumes/kratos/' dataset{iSub} '/spm_analysis/first_level/spmT_0003.nii']; % Left leg
    end
    
    % --- Load SPM volumes ---
    vT_R = spm_vol(tRfile);
    vT_L = spm_vol(tLfile);
    tR = spm_read_vols(vT_R);
    tL = spm_read_vols(vT_L);
    
    % --- Resample masks to match t-map grid (nearest neighbour, no mean image) ---
    flags = struct('mask', false, 'mean', false, 'interp', 0, 'which', 1, ...
                   'wrap', [0 0 0], 'prefix', 'r');
    
    % Expected resliced filenames
    rMaskL = fullfile(fileparts(maskL), ['r' spm_file(maskL,'filename')]);
    rMaskR = fullfile(fileparts(maskR), ['r' spm_file(maskR,'filename')]);
    
    % Reslice only if not already done
    if ~isfile(rMaskL)
        fprintf('🧭 Reslicing left mask...\n');
        P = char(vT_R.fname, maskL);
        spm_reslice(P, flags);
    else
        fprintf('⏭️ Skipping left mask (already resliced)\n');
    end
    
    if ~isfile(rMaskR)
        fprintf('🧭 Reslicing right mask...\n');
        P = char(vT_R.fname, maskR);
        spm_reslice(P, flags);
    else
        fprintf('⏭️ Skipping right mask (already resliced)\n');
    end
    
    % --- Read resampled masks ---
    maskL_res = spm_read_vols(spm_vol(rMaskL));
    maskR_res = spm_read_vols(spm_vol(rMaskR));
    
    % Binarize to clean up any interpolation noise
    maskL_res = maskL_res > 0.5;
    maskR_res = maskR_res > 0.5;
    
    % mask
    RbyL = tR.*maskL_res;
    RbyR = tR.*maskR_res;
    LbyR = tL.*maskR_res;
    LbyL = tL.*maskL_res;
    
    %vectorise
    vRbyL = RbyL(:);
    vRbyR = RbyR(:);
    vLbyR = LbyR(:);
    vLbyL = LbyL(:);
    
    % get pos and neg separately and threshold
    vRbyL_pos = vRbyL(vRbyL>sigVal);
    vRbyL_neg = vRbyL(vRbyL<sigValneg);
    vRbyR_pos = vRbyR(vRbyR>sigVal);
    vRbyR_neg = vRbyR(vRbyR<sigValneg);
    vLbyR_pos = vLbyR(vLbyR>sigVal);
    vLbyR_neg = vLbyR(vLbyR<sigValneg);
    vLbyL_pos = vLbyL(vLbyL>sigVal);
    vLbyL_neg = vLbyL(vLbyL<sigValneg);

    % now do means separately
    % --- Compute mean and SD for each ---
    % pairs = {
    %     'RbyL_pos', vRbyL_pos;
    %     'RbyL_neg', vRbyL_neg;
    %     'RbyR_pos', vRbyR_pos;
    %     'RbyR_neg', vRbyR_neg;
    %     'LbyR_pos', vLbyR_pos;
    %     'LbyR_neg', vLbyR_neg;
    %     'LbyL_pos', vLbyL_pos;
    %     'LbyL_neg', vLbyL_neg;
    % };

    pairs = {
        'RbyL_pos', vRbyL_pos;
        'RbyL_neg', vRbyL_neg;
        'RbyR_pos', vRbyR_pos;
        'RbyR_neg', vRbyR_neg;
        'LbyR_pos', vLbyR_pos;
        'LbyR_neg', vLbyR_neg;
        'LbyL_pos', vLbyL_pos;
        'LbyL_neg', vLbyL_neg;
    };
    
    means = nan(height(cell2table(pairs)),1);
    stds  = nan(height(cell2table(pairs)),1);
    numVals = nan(height(cell2table(pairs)),1);
    labels = pairs(:,1);
    
    for idex = 1:numel(labels)
        vals = pairs{idex,2};
        vals = vals(isfinite(vals));
        if isempty(vals)
            means(idex) = NaN;
            stds(idex)  = NaN;
            numVals(idex) = NaN;
            fprintf('⚠️ %s: no voxels passed threshold\n', labels{idex});
        else
            means(idex) = mean(vals);
            stds(idex)  = std(vals);
            numVals(idex) = numel(vals);
            fprintf('%s → mean = %.3f, SD = %.3f (n=%d)\n', ...
                    labels{idex}, means(idex), stds(idex), numel(vals));
        end
    end

    meansG(:,iSub) = means;
    stdsG(:,iSub) = stds;
    labelsG(:,iSub) = labels;
    valsG(:,iSub) = numVals;


    % sanity check
    % figure
    % tiledlayout(2,2)
    % nexttile
    % histogram(vRbyL_pos)
    % xlim([0 20])
    % nexttile
    % histogram(vRbyL_neg)
    % xlim([-20 0])

    % sanity check
    % sliceNum = 70;
    % figure
    % tiledlayout(2,2)
    % nexttile
    % imagesc(tR(:,:,sliceNum))
    % nexttile
    % imagesc(maskL_res(:,:,sliceNum))
    % nexttile
    % imagesc(RbyL(:,:,sliceNum))
        
end
toc



%% now we can plot

posDex = [1 3 5 7];
negDex = [2 4 6 8];

meansG_pos = meansG(posDex,:);
meansG_neg = meansG(negDex,:);
stdsG_pos = stdsG(posDex,:);
stdsG_neg = stdsG(negDex,:);
labelsG_pos = labelsG(posDex,:);
labelsG_neg = labelsG(negDex,:);
valsG_pos = valsG(posDex,:);
valsG_neg = valsG(negDex,:);

subs = repmat({'sub01','sub02','sub03','sub04','sub05','sub06','sub07','sub08','sub09','sub10'},4,1);
subs = subs(:);

% we need to swap rows for plotting on left
meansG_pos = [meansG_pos(3:4,:); meansG_pos(1:2,:)];
stdsG_pos = [stdsG_pos(3:4,:); stdsG_pos(1:2,:)];
meansG_neg = [meansG_neg(3:4,:); meansG_neg(1:2,:)];
stdsG_neg = [stdsG_neg(3:4,:); stdsG_neg(1:2,:)];
labelsG_pos = [labelsG_pos(3:4,:); labelsG_pos(1:2,:)];
labelsG_neg = [labelsG_neg(3:4,:); labelsG_neg(1:2,:)];
valsG_pos = [valsG_pos(3:4,:); valsG_pos(1:2,:)];
valsG_neg = [valsG_neg(3:4,:); valsG_neg(1:2,:)];

posStack = table(meansG_pos(:), stdsG_pos(:), labelsG_pos(:),subs,valsG_pos(:),...
    'VariableNames', {'Mean','Std','Label','Subject','numVox'});
negStack = table(meansG_neg(:), stdsG_neg(:), labelsG_neg(:),subs,valsG_neg(:),...
    'VariableNames', {'Mean','Std','Label','Subject','numVox'});

%writetable(posStack, fullfile(savedir,'outputraw.csv'));

newLabel = repmat({'1barL_contralateral','1barL_ipsilateral','1barR_contralateral','1barR_ipsilateral'}',10,1);
newTable = table(posStack.Subject, posStack.Mean, posStack.Std,newLabel,...
    'VariableNames', {'Subject','Y','stdev','Label'});
writetable(newTable, fullfile(savedir,'outputraw_rearrangedfornikki.csv'));


% just name, bit easier for legend
posStack.Label = newLabel;
negStack.Label = newLabel;


% Compute error limits for gramm
posStack.ymin = posStack.Mean - posStack.Std;
posStack.ymax = posStack.Mean + posStack.Std;

negStack.ymin = negStack.Mean - negStack.Std;
negStack.ymax = negStack.Mean + negStack.Std;



cmap = {'#e31a1c','#fd8d3c','#0570b0','#74a9cf'};
cmapped = validatecolor(cmap,'multiple');

%% can we run stats on the differences?

evenDex = 2:2:40;
oddDex = 1:2:40;
conipsi_diff = zeros(20,1);
for ii = 1:20
    thisEvenDex = evenDex(ii);
    thisOddDex = oddDex(ii);
    conipsi_diff(ii) = posStack.Mean(thisOddDex)-posStack.Mean(thisEvenDex);
end

%newLabel = repmat({'Left','Right'},1,10)';

% conipsi_diff is 20x1: [Left1, Right1, Left2, Right2, ... Left10, Right10]
leftVals  = conipsi_diff(1:2:end);
rightVals = conipsi_diff(2:2:end);

% Run paired t-test
[~, p, ~, stats] = ttest(leftVals, rightVals);
%fprintf('Paired t-test: t(%d) = %.3f, p = %.4f\n', stats.df, stats.tstat, p);
% Format the output string
outstr = sprintf('Paired t-test: t(%d) = %.3f, p = %.4f\n', stats.df, stats.tstat, p);
fprintf(outstr)
outfile = fullfile(savedir, 'rawts_emg_pairedttest_results.txt');
writelines(outstr, outfile)

%% also run ANOVA
anovaLabels = split(posStack.Label,'_');
RLgroup = anovaLabels(:,1);
ContraIpsigroup = anovaLabels(:,2);
[p,tbl,stats] = anovan(posStack.Mean, {RLgroup,ContraIpsigroup},'model','interaction');

% multcompare
figure
[c,m,h,gnames] = multcompare(stats,"Dimension",1,'Display','on','CriticalValueType','bonferroni');
tbldom = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=gnames(tbldom.("Group A"));
tbldom.("Group B")=gnames(tbldom.("Group B"));
title('Right vs Left task')
writecell(tbl,[savedir 'rawt_anova_canapi' ],'FileType','spreadsheet')
writetable(tbldom,[savedir 'rawt_mult_d1_canapi' ],'FileType','spreadsheet')
theTable.Properties.VariableNames{1} = 'StructName';
figure
[c,m,h,gnames] = multcompare(stats,"Dimension",2,'Display','on','CriticalValueType','bonferroni');
tbldom = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=gnames(tbldom.("Group A"));
tbldom.("Group B")=gnames(tbldom.("Group B"));
title('Contra vs Ipsi')
writetable(tbldom,[savedir 'rawt_mult_d2_canapi' ],'FileType','spreadsheet')
theTable.Properties.VariableNames{1} = 'StructName';
figure
[c,m,h,gnames] = multcompare(stats,"Dimension",[1 2],'Display','on','CriticalValueType','bonferroni');
tbldom = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=gnames(tbldom.("Group A"));
tbldom.("Group B")=gnames(tbldom.("Group B"));
title('Contra vs Ipsi')
writetable(tbldom,[savedir 'rawt_mult_d12_canapi' ],'FileType','spreadsheet')
theTable.Properties.VariableNames{1} = 'StructName';

%% also run ANOVA on numVoxels

[p,tbl,stats] = anovan(posStack.numVox, {RLgroup,ContraIpsigroup},'model','interaction');

% multcompare
figure
[c,m,h,gnames] = multcompare(stats,"Dimension",1,'Display','on','CriticalValueType','bonferroni');
tbldom = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=gnames(tbldom.("Group A"));
tbldom.("Group B")=gnames(tbldom.("Group B"));
title('Right vs Left task')
writecell(tbl,[savedir 'rawt_anova_canapi_numvox' ],'FileType','spreadsheet')
writetable(tbldom,[savedir 'rawt_mult_d1_canapi_numvox' ],'FileType','spreadsheet')
theTable.Properties.VariableNames{1} = 'StructName';
figure
[c,m,h,gnames] = multcompare(stats,"Dimension",2,'Display','on','CriticalValueType','bonferroni');
tbldom = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=gnames(tbldom.("Group A"));
tbldom.("Group B")=gnames(tbldom.("Group B"));
title('Contra vs Ipsi')
writetable(tbldom,[savedir 'rawt_mult_d2_canapi_numvox' ],'FileType','spreadsheet')
theTable.Properties.VariableNames{1} = 'StructName';
figure
[c,m,h,gnames] = multcompare(stats,"Dimension",[1 2],'Display','on','CriticalValueType','bonferroni');
tbldom = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=gnames(tbldom.("Group A"));
tbldom.("Group B")=gnames(tbldom.("Group B"));
title('Contra vs Ipsi')
writetable(tbldom,[savedir 'rawt_mult_d12_canapi_numvox' ],'FileType','spreadsheet')
theTable.Properties.VariableNames{1} = 'StructName';

%% Build gramm object
clc
close all
figure('Position',[100 100 1000 500]);

dodgeVal = 0.8;

g = gramm( ...
    'x', posStack.Subject, ...
    'y', posStack.Mean, ...
    'color', posStack.Label, ...
    'ymin', posStack.ymin, ...
    'ymax', posStack.ymax);

% Bars + your own SD errorbars
g.geom_bar('width',0.8, 'stacked',false,'dodge',dodgeVal,'LineWidth',0.2) 
%g.geom_interval('geom','errorbar','dodge',0.5,'width',1);   % <- uses ymin/ymax that you defined

% Optional styling
g.set_names('x',[],'y','Mean T','color','Condition');
g.set_title('fMRI T-values','FontSize',16);
g.axe_property('FontSize',16,'ylim',[0 16],'XGrid','on','YGrid','on');
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

filename = ('rawtstatfmriplot');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

%% also want to plot numVals
clc
close all
figure('Position',[100 100 1000 500]);

dodgeVal = 0.8;

g = gramm( ...
    'x', posStack.Subject, ...
    'y', posStack.numVox, ...
    'color', posStack.Label);

% Bars + your own SD errorbars
g.geom_bar('width',0.8, 'stacked',false,'dodge',dodgeVal,'LineWidth',0.2) 
%g.geom_interval('geom','errorbar','dodge',0.5,'width',1);   % <- uses ymin/ymax that you defined

% Optional styling
g.set_names('x',[],'y','Number of Voxels','color','Condition');
g.set_title('fMRI T-values','FontSize',16);
g.axe_property('FontSize',16,'XGrid','on','YGrid','on');
g.set_order_options('x',0,'color',0)
g.set_color_options('map',cmapped)
%g.no_legend
g.draw();


filename = ('rawtstatfmriplot_numVox');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')


%% same for neg
clc
close all
figure('Position',[100 100 1000 500]);

dodgeVal = 0.8;

g = gramm( ...
    'x', negStack.Subject, ...
    'y', negStack.Mean, ...
    'color', negStack.Label, ...
    'ymin', negStack.ymin, ...
    'ymax', negStack.ymax);

% Bars + your own SD errorbars
g.geom_bar('width',0.8, 'stacked',false,'dodge',dodgeVal,'LineWidth',0.2) 
%g.geom_interval('geom','errorbar','dodge',0.5,'width',1);   % <- uses ymin/ymax that you defined

% Optional styling
g.set_names('x',[],'y','Mean T','color','Condition');
%g.set_title('Positive T-values');
g.axe_property('FontSize',12,'ylim',[-10 0],'XGrid','on','YGrid','on');
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

filename = ('rawtstatfmriplot_neg');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')



%% lets copy the cluster weighted script canapi_unilateral_tstats.m and correlate with EMG traces
%
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
emg_1barR = emgData(1,:); % 1 x 10
emg_1barL = emgData(3,:); % 1 x 10

emg_1barR = emg_1barR(:);
emg_1barL = emg_1barL(:);

% need to adapt this here to my table
LcontraDex = 1:4:40;
LipsiDex = 2:4:40;
RcontraDex = 3:4:40;
RipsiDex = 4:4:40;

posStack.Label(LcontraDex)
posStack.Label(LipsiDex)
posStack.Label(RcontraDex)
posStack.Label(RipsiDex)

fmri_1barR_contra = posStack.Mean(RcontraDex); % contralateral
fmri_1barR_ipsi   = posStack.Mean(RipsiDex); % ipsilateral
fmri_1barL_contra = posStack.Mean(LcontraDex);
fmri_1barL_ipsi   = posStack.Mean(LipsiDex);

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
figure('Position',[100 100 1200 600])
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

filename = ('xcorr_vs_raw_tstat');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')








