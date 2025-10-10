%
clear variables
close all
clc

% Locate data
%mypath = '/Volumes/arianthe/PAIN/';
mypath = '/Volumes/r15/DRS-TOUCHMAP/ma_ares_backup/PAIN/';
cd(mypath)

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/The University of Nottingham/Pain Relief Grant - General/results/canlab_painsubs/'];

mysubs_7t = {'pain_01_12778_221117','pain_02_15435_221117','pain_03_11251_221129',...
    'pain_04_14359_230110','pain_05_11766_230123','pain_06_15252_230126',...
    'pain_07_15874_230213'};
mysubs_3t = {'tgi_sub_01_13676_221124','tgi_sub_02_15435_221124','tgi_sub_03_14359_221124',...
    'tgi_sub_04_12778_221124','tgi_sub_05_15874_230622'};

nps_timeseries = 0;

addpath(genpath('/Users/ppzma/Documents/MATLAB/CanlabCore/'));
addpath(genpath('/Users/ppzma/Documents/MATLAB/NPS_share/'));


%%
theOrder_7T = {'Pre Hand run1','Pre Hand run2','Pre Arm run1','Pre Arm run2'};

%7T
sub01_7T={'swrparrec_thermode_block1_20221117112738_9_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_block2_20221117112738_10_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_armblock1_20221117112738_15_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_armblock2_20221117112738_16_nordic_clv_toppedupabs.nii',...
    };

sub02_7T={'swrparrec_thermode_block1_20221117143136_9_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_block2_20221117143136_10_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_armblock1_20221117143136_14_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_armblock2_20221117143136_15_nordic_clv_toppedupabs.nii',...
    };

sub03_7T={'swrparrec_thermode_block1_20221129091505_11_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_block2_20221129091505_12_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_armblock1_20221129091505_15_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_armblock2_20221129091505_16_nordic_clv_toppedupabs.nii',...
    };
    
sub04_7T={'swrparrec_thermode_block1_20230110092418_10_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_block2_20230110092418_11_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_armblock1_20230110092418_15_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_armblock2_20230110092418_16_nordic_clv_toppedupabs.nii',...
    };

sub05_7T={'swrpain_05_11766_230123_thermode_block1_20230123094829_10_nordic_clv_toppedupabs.nii',...
    'swrpain_05_11766_230123_thermode_block2_20230123094829_11_nordic_clv_toppedupabs.nii',...
    'swrpain_05_11766_230123_thermode_armblock1_20230123094829_16_nordic_clv_toppedupabs.nii',...
    'swrpain_05_11766_230123_thermode_armblock2_20230123094829_17_nordic_clv_toppedupabs.nii',...
    };

sub06_7T={'swrparrec_thermode_block1_20230126092204_10_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_block2_20230126092204_11_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_armblock1_20230126092204_15_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_armblock2_20230126092204_16_nordic_clv_toppedupabs.nii',...
    };

sub07_7T={'swrparrec_thermode_block1_20230213101502_10_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_block2_20230213101502_11_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_armblock1_20230213101502_15_nordic_clv_toppedupabs.nii',...
    'swrparrec_thermode_armblock1_20230213101502_16_nordic_clv_toppedupabs.nii',...
    };


dataList = {sub01_7T, sub02_7T, sub03_7T, sub04_7T, sub05_7T,sub06_7T, sub07_7T};
%dataList = {sub01_7T};

npsStoreValues = cell(6,2,length(dataList));

% Get timings
heat1 = round([46 73 124 204 255 282]./2);
warm1 = round([20 99 151 177 229]./2);
heat2 = round([20 46 124 177 255]./2);
warm2 = round([73 99 151 204 229 282]./2);

tic
for ii = 1:length(dataList)
    thisGuy = dataList{ii};

    for jj = 1:length(thisGuy)

        if jj<=4; whichCap = 'preCap';else, whichCap = 'postCap'; end

        if jj<=2; jump = 'thermode_hand';
        elseif jj==3||jj==4, jump = 'thermode_arm';
        elseif jj>4, jump = 'thermode_arm';
        end

        thisScan = [mypath mysubs_7t{ii} '/processed_data/' whichCap '/' thisGuy{jj}];
        
        if nps_timeseries
            [nps_values, image_names, data_objects] = apply_nps(thisScan);
        end

        preInput = [mypath 'mni_first_level_scripts/sub0' num2str(ii) '/' whichCap '/' jump '/'];

        inputs={[preInput 'spmT_0001.nii'],[preInput 'spmT_0002.nii']};
        [nps_values_spm, image_names_spm, data_objects_spm] = apply_nps(inputs);

        npsStoreValues(jj,:,ii) = nps_values_spm;
        
        if nps_timeseries
            fig = figure('Position',[100 100 850 400]);
            set(fig, 'PaperPositionMode', 'auto'); % Set PaperPositionMode to auto
            set(fig, 'PaperOrientation', 'landscape'); % Set PaperOrientation to landscape
            plot(nps_values{1},'k','LineWidth',2)

            if isodd(jj)
                xline(heat1,'r','heat')
                xline(warm1,'b','warm')
            elseif iseven(jj)
                xline(heat2,'r','heat')
                xline(warm2,'b','warm')
            end
            title(sprintf('7T: %s / NPS SPMT Heat %.2f / NPS SPMT Warm %.2f',theOrder_7T{jj}, nps_values_spm{1},nps_values_spm{2}))
            legend('Predicted NPS response from TSeries','Location','southoutside','FontSize',11)
            thisFilename = [sprintf('7T_%s',theOrder_7T{jj}) 'sub0' num2str(ii) '.pdf'];
            thisFilenameP = strrep(thisFilename,' ','_');
            print([savedir thisFilenameP], '-dpdf', '-r300','-bestfit');
            close all
        end





    end
end
toc

%% 7T
clear data
details = {'thermode_hand','thermode_arm',...
    'thermode_hand','thermode_arm'}';
details_stack = repmat(details,1,length(dataList));
details_stack = details_stack(:);

details_cond = {'Noxious heat','Noxious heat',...
    'Innocuous heat','Innocuous heat'}';
details_cond_stack = repmat(details_cond,1,length(dataList));
details_cond_stack = details_cond_stack(:);

for ii = 1:length(dataList)
    thisSub = npsStoreValues(:,:,ii);

    data(:,ii) = [thisSub{1,1} thisSub{3,1} thisSub{5,1},...
        thisSub{1,2} thisSub{3,2} thisSub{5,2}];

end

data = data(:);

% save as a table for excel
% Flatten subject list
% Repeat each subject name 4 times
subject_col = repmat(mysubs_7t(:), 1, 4)';  % 4 rows per subject
subject_col = subject_col(:);    
% Sanity check
if length(subject_col) ~= length(data)
    error('Mismatch in subject IDs and data length.');
end

% Make table
T = table(subject_col, details_stack, details_cond_stack, data, ...
    'VariableNames', {'Subject', 'Details', 'Condition', 'NPS'});
writetable(T,[savedir 'nps_table_7T_noTGICAP'],'FileType','spreadsheet')



thisFont = 'Helvetica';
myfontsize = 16;
mycmap = [0.8 0.8 0.8];

figure('Position',[100 100 800 600])
g = gramm('x',details_cond_stack,'y',data);
%g.stat_summary('type','std','geom',{'bar','black_errorbar'})
g.stat_boxplot2('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
g.set_text_options('font', thisFont, 'base_size', myfontsize)
g.set_names('x','Stimulation', 'y', 'Condition')
g.axe_property('YLim',[-15 30],'XGrid','on','YGrid','on');
g.set_order_options('x',0,'color',0)
g.set_color_options('map',mycmap)
g.set_title('7T NPS Scalar values')
g.draw()
g.update('color',details_stack)
g.geom_jitter2
g.set_point_options('base_size',10)
g.set_order_options('x',0,'color',0)
g.set_color_options('map','lch')
g.no_legend
g.draw()

% add this fudgey bit to include values from Jo PFP
g.update('x',{'Noxious heat'; 'Innocuous heat'},'y',[3.71; 500])
g.geom_jitter2('edgewidth',2)
g.set_point_options('base_size',12)
g.set_color_options('map',[1 1 0])
g.draw
% 
g.update('x',{'Noxious heat'; 'Innocuous heat'},'y',[500; -2.03])
g.geom_jitter2('edgewidth',2)
g.set_point_options('base_size',12)
g.set_color_options('map',[1 1 0])
g.draw

% 
filename = '7T_NPS_vals_noTGICAP';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')


%% STats

[P, ANOVATAB, STATS] = anova1(data,details_cond_stack);

[COMPARISON,MEANS,H,GNAMES] = multcompare(STATS);
tbldom = array2table(COMPARISON,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=GNAMES(tbldom.("Group A"));
tbldom.("Group B")=GNAMES(tbldom.("Group B"));
writetable(tbldom,[savedir 'mult_anova_7T_noTGICAP'],'FileType','spreadsheet')
% 




%% 3T
theOrder_3T = {'Hand run1','Hand run2','Arm run1','Arm run2'};

%3T
sub0X_3T={'swrtgi_sub_01_13676_221124_WIPThermode-fMRI1_20221124113203_3_nordic_clv_toppedupabs.nii',...
    'swrtgi_sub_01_13676_221124_WIPThermode-fMRI1_20221124113203_4_nordic_clv_toppedupabs.nii',...
    'swrtgi_sub_01_13676_221124_WIPThermode-fMRI1_20221124113203_5_nordic_clv_toppedupabs.nii',...
    'swrtgi_sub_01_13676_221124_WIPThermode-fMRI1_20221124113203_6_nordic_clv_toppedupabs.nii',...
    };

sub02_3T={'swrtgi_sub_02_15435_221124_WIPThermode-fMRI1_20221124124607_2_nordic_clv_toppedupabs.nii',...
    'swrtgi_sub_02_15435_221124_WIPThermode-fMRI1_20221124124607_3_nordic_clv_toppedupabs.nii',...
    'swrtgi_sub_02_15435_221124_WIPThermode-fMRI1_20221124124607_4_nordic_clv_toppedupabs.nii',...
    'swrtgi_sub_02_15435_221124_WIPThermode-fMRI1_20221124124607_5_nordic_clv_toppedupabs.nii',...
    };


sub04_3T={'swrtgi_sub_03_14359_221124_WIPThermode-fMRI1_20221124135439_2_nordic_clv_toppedupabs.nii',...
    'swrtgi_sub_03_14359_221124_WIPThermode-fMRI1_20221124135439_3_nordic_clv_toppedupabs.nii',...
    'swrtgi_sub_03_14359_221124_WIPThermode-fMRI1_20221124135439_4_nordic_clv_toppedupabs.nii',...
    'swrtgi_sub_03_14359_221124_WIPThermode-fMRI1_20221124135439_5_nordic_clv_toppedupabs.nii',...
    };

sub01_3T={'swrtgi_sub_04_12778_221124_WIPThermode-fMRI1_20221124145248_8_nordic_clv_toppedupabs.nii',...
    'swrtgi_sub_04_12778_221124_WIPThermode-fMRI1_20221124145248_9_nordic_clv_toppedupabs.nii',...
    'swrtgi_sub_04_12778_221124_WIPThermode-fMRI1_20221124145248_10_nordic_clv_toppedupabs.nii',...
    'swrtgi_sub_04_12778_221124_WIPThermode-fMRI1_20221124145248_11_nordic_clv_toppedupabs.nii',...
    };

sub07_3T={'swrtherm1_nordic_clv_toppedupabs.nii',...
    'swrtherm2_nordic_clv_toppedupabs.nii',...
    'swrtherm3_nordic_clv_toppedupabs.nii',...
    'swrtherm4_nordic_clv_toppedupabs.nii',...
    };

dataList = {sub0X_3T, sub02_3T, sub04_3T, sub01_3T, sub07_3T};
%dataList = {sub0X_3T};
npsStoreValues_3T = cell(6,3,length(dataList));

% Get timings
heat1 = [46 73 124 204 255 282];
warm1 = [20 99 151 177 229];
heat2 = [20 46 124 177 255];
warm2 = [73 99 151 204 229 282];
tgi_heat = [0 28 56 112 168 196 252 280];
tgi_cold = [137 224];
tgi_warm = 84;


tic
for ii = 1:length(dataList)
    thisGuy = dataList{ii};

    for jj = 1:length(thisGuy)

        %if jj<=4; whichCap = 'thermode';else, whichCap = 'grill'; end

        if jj<=2; jump = 'threshold_hand';
        elseif jj==3||jj==4, jump = 'threshold_arm';
        elseif jj==5, jump = 'qst_hand';
        elseif jj==6, jump = 'qst_arm';
        end

        thisScan = [mypath mysubs_3t{ii} '/processed_data/' thisGuy{jj}];
        
        if nps_timeseries
            [nps_values, image_names, data_objects] = apply_nps(thisScan);
        end
        preInput = [mypath 'mni_first_level_scripts_tgi/sub0' num2str(ii) '/3mm/' jump '/'];

        % account for TGI has 3 conditions
        if jj>=5 
            inputs={[preInput 'spmT_0001.nii'],[preInput 'spmT_0002.nii'],[preInput 'spmT_0003.nii']};
        else
            inputs={[preInput 'spmT_0001.nii'],[preInput 'spmT_0002.nii']};
        end

        % check file exists
        if logical(exist([preInput 'spmT_0001.nii'],'file'))
            [nps_values_spm, image_names_spm, data_objects_spm] = apply_nps(inputs);
            
            if length(nps_values_spm)==2
                npsStoreValues_3T(jj,1:2,ii) = nps_values_spm;
            else
                npsStoreValues_3T(jj,1:3,ii) = nps_values_spm;
            end
        else
            if length(nps_values_spm)==2
                npsStoreValues_3T(jj,1:2,ii) = nps_values_spm;
            else
                npsStoreValues_3T(jj,1:3,ii) = nps_values_spm;
            end
        end
        %[nps_values_spm, image_names_spm, data_objects_spm] = apply_nps(inputs);

        %npsStoreValues_3T(jj,:,ii) = nps_values_spm;
        if nps_timeseries
            fig = figure('Position',[100 100 850 400]);
            set(fig, 'PaperPositionMode', 'auto'); % Set PaperPositionMode to auto
            set(fig, 'PaperOrientation', 'landscape'); % Set PaperOrientation to landscape
            plot(nps_values{1},'k','LineWidth',2)

            if jj<=4 && isodd(jj)
                xline(heat1,'r','heat')
                xline(warm1,'b','warm')
            elseif jj<=4 && iseven(jj)
                xline(heat2,'r','heat')
                xline(warm2,'b','warm')
            elseif jj>4
                xline(tgi_heat,'r','tgi')
                xline(tgi_cold,'b','cold')
                xline(tgi_warm,'g','warm')
            end

            title(sprintf('3T: %s / NPS SPMT Heat %.2f / NPS SPMT Warm %.2f',theOrder_3T{jj}, nps_values_spm{1},nps_values_spm{2}))
            legend('Predicted NPS response from TSeries','Location','southoutside','FontSize',11)
            thisFilename = [sprintf('3T_%s',theOrder_3T{jj}) 'sub0' num2str(ii) '.pdf'];
            thisFilenameP = strrep(thisFilename,' ','_');
            print([savedir thisFilenameP], '-dpdf', '-r300','-bestfit');

            close all
        end




    end
end
toc

%% Now we want plot everybody's NPS scalar values
% 3T
clear data
details = {'thermode_hand','thermode_arm',...
    'thermode_hand','thermode_arm',...
    }';
details_stack = repmat(details,1,length(dataList));
details_stack = details_stack(:);
% 
% details_cond = {'heat','heat',...
%     'warm','warm',...
%     }';

details_cond = {'Noxious heat','Noxious heat',...
    'Innocuous heat','Innocuous heat'}';
details_cond_stack = repmat(details_cond,1,length(dataList));
details_cond_stack = details_cond_stack(:);

for ii = 1:length(dataList)
    thisSub = npsStoreValues_3T(:,:,ii);

    data(:,ii) = [thisSub{1,1} thisSub{3,1},...
        thisSub{1,2} thisSub{3,2},...
        ];

end

data = data(:);

% save as a table for excel
% Flatten subject list
% Repeat each subject name 4 times
subject_col = repmat(mysubs_3t(:), 1, 4)';  % 4 rows per subject
subject_col = subject_col(:);    
% Sanity check
if length(subject_col) ~= length(data)
    error('Mismatch in subject IDs and data length.');
end

% Make table
T = table(subject_col, details_stack, details_cond_stack, data, ...
    'VariableNames', {'Subject', 'Details', 'Condition', 'NPS'});
writetable(T,[savedir 'nps_table_3T_noTGICAP'],'FileType','spreadsheet')


thisFont = 'Helvetica';
myfontsize = 16;
mycmap = [0.8 0.8 0.8];

figure('Position',[100 100 800 600])
g = gramm('x',details_cond_stack,'y',data);
%g.stat_summary('type','std','geom',{'bar','black_errorbar'})
g.stat_boxplot2('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
g.set_text_options('font', thisFont, 'base_size', myfontsize)
g.set_names('x','Stimulation', 'y', 'Condition')
g.axe_property('YLim',[-50 140],'XGrid','on','YGrid','on');
g.set_order_options('x',0,'color',0)
g.set_color_options('map',mycmap)
g.set_title('3T NPS Scalar values')
g.draw()
g.update('color',details_stack)
g.geom_jitter2
g.set_point_options('base_size',10)
g.set_order_options('x',0,'color',0)
g.set_color_options('map','lch')
g.no_legend
g.draw()


% %add this fudgey bit to include values from Jo PFP
g.update('x',{'Noxious heat';'Innocuous heat'},'y',[46.29; 500])
g.geom_jitter2('edgewidth',2)
g.set_point_options('base_size',12)
g.set_color_options('map',[1 1 0])
g.draw
% 
g.update('x',{'Noxious heat';'Innocuous heat'},'y',[500; 14.07])
g.geom_jitter2('edgewidth',2)
g.set_point_options('base_size',12)
g.set_color_options('map',[1 1 0])
g.draw


filename = '3T_NPS_vals_noTGICAP';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

%% STats

[P, ANOVATAB, STATS] = anova1(data,details_cond_stack);

[COMPARISON,MEANS,H,GNAMES] = multcompare(STATS);
tbldom = array2table(COMPARISON,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=GNAMES(tbldom.("Group A"));
tbldom.("Group B")=GNAMES(tbldom.("Group B"));
writetable(tbldom,[savedir 'mult_anova_3T_noTGICAP'],'FileType','spreadsheet')






















