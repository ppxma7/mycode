% plot barcharts for t-stat ROIs from MNI space, SPM12 analysis
% of pain subjects
% 16/2/24 [ma]
%
% 3T Subs

clear all
close all
close all hidden
clc
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/The University of Nottingham/Pain Relief Grant - General/results/tstat_plots/'];
thisFont = 'Helvetica';
myfontsize = 16;
painsubs = {'13676','15435','14359','12778','15874'}; %subs1-7
deezSubs = {'sub01','sub02','sub03','sub04','sub05'}';

thispath = '/Volumes/arianthe/PAIN/mni_first_level_scripts_tgi';
cd(thispath)

mycond = 'warm';

%% what if we try reading CSVs

for iSub = 1:length(deezSubs)
    here =  [thispath '/' deezSubs{iSub}];
    switch mycond
        case 'heatpain'
            thisCSV = [here '/3mm/threshold_hand/thermode_hand.csv'];
        case 'warm'
            thisCSV = [here '/3mm/threshold_hand/warm_hand.csv'];
    end    
    % HANDS

    if exist(thisCSV,'file')
        T = readtable(thisCSV);
        nonans = ~isnan(T.clust_ke);
        for ii = 1:height(T)
            splot = split(T.desc_labels_cort(ii));
            if length(splot)>1
                splot_dex1 = contains(splot{2},'Postcentral');
                splot_dex2 = contains(splot{2},'Precentral');
                splot_dex3 = contains(splot{2},'Middle');
                splot_dex4 = contains(splot{2},'Cingulate');
                splot_dex5 = contains(splot{2},'Insular');
            else
                splot_dex1 = 0;
                splot_dex2 = 0;
                splot_dex3 = 0;
                splot_dex4 = 0;
                splot_dex5 = 0;

            end
            splitted1(ii) = splot_dex1;
            splitted2(ii) = splot_dex2;
            splitted3(ii) = splot_dex3;
            splitted4(ii) = splot_dex4;
            splitted5(ii) = splot_dex5;

        end
        PostCG_find = splitted1';
        PreCG_find = splitted2';
        MFG_find = splitted3';
        ACC_find = splitted4';
        INS_find = splitted5';

        clear spl*

        PostCG_cleaning = logical(nonans.*PostCG_find);
        PreCG_cleaning = logical(nonans.*PreCG_find);
        MFG_cleaning = logical(nonans.*MFG_find);
        ACC_cleaning = logical(nonans.*ACC_find);
        INS_cleaning = logical(nonans.*INS_find);


        clust_1 = T.clust_ke(PostCG_cleaning);
        clust_2 = T.clust_ke(PreCG_cleaning);
        clust_3 = T.clust_ke(MFG_cleaning);
        clust_4 = T.clust_ke(ACC_cleaning);
        clust_5 = T.clust_ke(INS_cleaning);

        idx_1 = find(PostCG_cleaning);
        idx_2 = find(PreCG_cleaning);
        idx_3 = find(MFG_cleaning);
        idx_4 = find(ACC_cleaning);
        idx_5 = find(INS_cleaning);

        [~,I1] = max(clust_1);
        [~,I2] = max(clust_2);
        [~,I3] = max(clust_3);
        [~,I4] = max(clust_4);
        [~,I5] = max(clust_5);

        tloc1 = idx_1(I1);
        tloc2 = idx_2(I2);
        tloc3 = idx_3(I3);
        tloc4 = idx_4(I4);
        tloc5 = idx_5(I5);

        if isempty(tloc1); thisTpeak_postCG(iSub) = NaN; else; thisTpeak_postCG(iSub) = T.peak_T(tloc1); end
        if isempty(tloc2); thisTpeak_preCG(iSub) = NaN; else; thisTpeak_preCG(iSub) = T.peak_T(tloc2); end
        if isempty(tloc3); thisTpeak_MFG(iSub) = NaN; else; thisTpeak_MFG(iSub) = T.peak_T(tloc3); end
        if isempty(tloc4); thisTpeak_ACC(iSub) = NaN; else; thisTpeak_ACC(iSub) = T.peak_T(tloc4); end
        if isempty(tloc5); thisTpeak_INS(iSub) = NaN; else; thisTpeak_INS(iSub) = T.peak_T(tloc5); end


    else
        thisTpeak_postCG(iSub) = NaN;
        thisTpeak_preCG(iSub) = NaN;
        thisTpeak_MFG(iSub) = NaN;
        thisTpeak_ACC(iSub) = NaN;
        thisTpeak_INS(iSub) = NaN;
    end

    clear T

    %% ARMS

    switch mycond
        case 'heatpain'
            thisCSV = [here '/3mm/threshold_arm/thermode_arm.csv'];
        case 'warm'
            thisCSV = [here '/3mm/threshold_arm/warm_arm.csv'];
    end

    if exist(thisCSV,'file')
        T = readtable(thisCSV);
        nonans = ~isnan(T.clust_ke);
        for ii = 1:height(T)
            splot = split(T.desc_labels_cort(ii));
            if length(splot)>1
                splot_dex1 = contains(splot{2},'Postcentral');
                splot_dex2 = contains(splot{2},'Precentral');
                splot_dex3 = contains(splot{2},'Middle');
                splot_dex4 = contains(splot{2},'Cingulate');
                splot_dex5 = contains(splot{2},'Insular');
            else
                splot_dex1 = 0;
                splot_dex2 = 0;
                splot_dex3 = 0;
                splot_dex4 = 0;
                splot_dex5 = 0;

            end
            splitted1(ii) = splot_dex1;
            splitted2(ii) = splot_dex2;
            splitted3(ii) = splot_dex3;
            splitted4(ii) = splot_dex4;
            splitted5(ii) = splot_dex5;

        end
        PostCG_find = splitted1';
        PreCG_find = splitted2';
        MFG_find = splitted3';
        ACC_find = splitted4';
        INS_find = splitted5';

        clear spl*

        PostCG_cleaning = logical(nonans.*PostCG_find);
        PreCG_cleaning = logical(nonans.*PreCG_find);
        MFG_cleaning = logical(nonans.*MFG_find);
        ACC_cleaning = logical(nonans.*ACC_find);
        INS_cleaning = logical(nonans.*INS_find);


        clust_1 = T.clust_ke(PostCG_cleaning);
        clust_2 = T.clust_ke(PreCG_cleaning);
        clust_3 = T.clust_ke(MFG_cleaning);
        clust_4 = T.clust_ke(ACC_cleaning);
        clust_5 = T.clust_ke(INS_cleaning);

        idx_1 = find(PostCG_cleaning);
        idx_2 = find(PreCG_cleaning);
        idx_3 = find(MFG_cleaning);
        idx_4 = find(ACC_cleaning);
        idx_5 = find(INS_cleaning);

        [~,I1] = max(clust_1);
        [~,I2] = max(clust_2);
        [~,I3] = max(clust_3);
        [~,I4] = max(clust_4);
        [~,I5] = max(clust_5);

        tloc1 = idx_1(I1);
        tloc2 = idx_2(I2);
        tloc3 = idx_3(I3);
        tloc4 = idx_4(I4);
        tloc5 = idx_5(I5);

        if isempty(tloc1); thisTpeak_postCG_arm(iSub) = NaN; else; thisTpeak_postCG_arm(iSub) = T.peak_T(tloc1); end
        if isempty(tloc2); thisTpeak_preCG_arm(iSub) = NaN; else; thisTpeak_preCG_arm(iSub) = T.peak_T(tloc2); end
        if isempty(tloc3); thisTpeak_MFG_arm(iSub) = NaN; else; thisTpeak_MFG_arm(iSub) = T.peak_T(tloc3); end
        if isempty(tloc4); thisTpeak_ACC_arm(iSub) = NaN; else; thisTpeak_ACC_arm(iSub) = T.peak_T(tloc4); end
        if isempty(tloc5); thisTpeak_INS_arm(iSub) = NaN; else; thisTpeak_INS_arm(iSub) = T.peak_T(tloc5); end


    else
        thisTpeak_postCG_arm(iSub) = NaN;
        thisTpeak_preCG_arm(iSub) = NaN;
        thisTpeak_MFG_arm(iSub) = NaN;
        thisTpeak_ACC_arm(iSub) = NaN;
        thisTpeak_INS_arm(iSub) = NaN;
    end

    clear T


   

end
clc

%% Now organise and plot
%% organising
mycmap = [0.8 0.8 0.8];
% do post CG first
PostCG = [thisTpeak_postCG thisTpeak_postCG_arm ]';
PreCG = [thisTpeak_preCG thisTpeak_preCG_arm ]';
ACC = [thisTpeak_ACC thisTpeak_ACC_arm ]';
MFG = [thisTpeak_MFG thisTpeak_MFG_arm ]';
INS = [thisTpeak_INS thisTpeak_INS_arm ]';


ALL_subs = repmat(deezSubs,2,1);
ALL_cond = [repmat({'hand'},length(deezSubs),1); repmat({'arm'},length(deezSubs),1)];

clear g
close all
figure('Position',[100 100 1024 768])

g(1,1) = gramm('x',ALL_cond,'y',PostCG);
g(1,1).stat_summary('type','std','geom',{'bar','black_errorbar'})
g(1,1).set_title('PostCG')
g(1,2) = gramm('x',ALL_cond,'y',PreCG);
g(1,2).stat_summary('type','std','geom',{'bar','black_errorbar'})
g(1,2).set_title('PreCG')
g(1,3) = gramm('x',ALL_cond,'y',ACC);
g(1,3).stat_summary('type','std','geom',{'bar','black_errorbar'})
g(1,3).set_title('ACC')
g(2,1) = gramm('x',ALL_cond,'y',MFG);
g(2,1).stat_summary('type','std','geom',{'bar','black_errorbar'})
g(2,1).set_title('MFG')
g(2,2) = gramm('x',ALL_cond,'y',INS);
g(2,2).stat_summary('type','std','geom',{'bar','black_errorbar'})
g(2,2).set_title('Insula')

g.set_text_options('font', thisFont, 'base_size', myfontsize)
g.set_names('x','Condition', 'y', 'T stat (uncorr)')
g.axe_property('YLim',[0 15],'PlotBoxAspectRatio',[1 1 1],'XGrid','on','YGrid','on');
g.set_order_options('x',0,'color',0)
g.set_color_options('map',mycmap)
g.draw()

g(1,1).update('color',ALL_subs)
g(1,1).geom_jitter
g(1,2).update('color',ALL_subs)
g(1,2).geom_jitter
g(1,3).update('color',ALL_subs)
g(1,3).geom_jitter
g(2,1).update('color',ALL_subs)
g(2,1).geom_jitter
g(2,2).update('color',ALL_subs)
g(2,2).geom_jitter

g.set_point_options('base_size',10)
g.set_order_options('x',0,'color',0)
g.set_color_options('map','lch')
g.draw

switch mycond
    case 'heatpain'
        filename = 'BAR_ALL_t_stats_heatpain_3t';
    case 'warm'
        filename = 'BAR_ALL_t_stats_warm_3t';
end


g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')
















