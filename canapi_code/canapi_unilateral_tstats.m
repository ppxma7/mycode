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

        mypath=['/Volumes/kratos/' dataset{iSub} '/spm_analysis/first_level/'];
        
        thisFile = fullfile(mypath,myfiles{ii});

        thisFile_contents = readtable(thisFile);

        % take max of peak T
        tfiles(ii,iSub) = max(thisFile_contents.peak_T);

        % Optional - compute the cluster-size weighted mean T
        Tvals = thisFile_contents.peak_T;
        KEvals = thisFile_contents.clust_ke;
        validIdx = ~isnan(Tvals) & ~isnan(KEvals);
        weightedTs(ii,iSub) = sum(Tvals(validIdx) .* KEvals(validIdx)) / sum(KEvals(validIdx));



    end
end
toc
% now plot?

y = weightedTs(:);
%y = tfiles;
%yflip = [y(1:2,:); y(4,:); y(3,:)]; % bug, because L_L comes before 
%yflip = yflip(:);

%myfiles_flip = {'1barR_Lmask.csv','1barR_Rmask.csv','1barL_Rmask.csv','1barL_Lmask.csv'};


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



close all
clear g
figure('Position',[100 100 1200 600])
g = gramm('x', subs, 'y', y, 'color', legendLabels);
%g.geom_jitter2('dodge', 0);  % adds subject dots
%g.geom_point()
g.stat_summary('geom', {'bar'}, 'dodge', 0.6);  % mean over subjects
g.set_names('x','Participant','y','T Stat','color','Task');
%g.set_title('Max T stat per task');
g.set_title('Cluster-size weighted average T-score per task');

g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',12)
g.set_color_options("map",cmapped)
g.set_order_options("color",0)

g.axe_property('YLim', [0 30]);
g.draw();
filename = ('tstat_unilateral_weighted');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')


%% also plot separately
weightedTs_R = weightedTs(1:2,:);
weightedTs_L = weightedTs(3:4,:);
yR = weightedTs_R(:);
yL = weightedTs_L(:);
subs = repmat({'sub01','sub02','sub03','sub04','sub05','sub06','sub07','sub08','sub09','sub10'},2,1);
subs = subs(:);
filestackR = repmat(myfiles(1:2),length(dataset),1);
filestackL = repmat(myfiles(3:4),length(dataset),1);
filestackR = filestackR';
filestackL = filestackL';
filestackR = filestackR(:);
filestackL = filestackL(:);

legendLabelsR = filestackR; % start with same names
legendLabelsR(strcmpi(filestackR, '1barR_Lmask.csv')) = {'1barR_contralateral'};
legendLabelsR(strcmpi(filestackR, '1barR_Rmask.csv')) = {'1barR_ipsilateral'};
legendLabelsL = filestackL; % start with same names
legendLabelsL(strcmpi(filestackL, '1barL_Lmask.csv')) = {'1barL_ipsilateral'};
legendLabelsL(strcmpi(filestackL, '1barL_Rmask.csv')) = {'1barL_contralateral'};


close all
clear g
figure('Position',[100 100 1200 600])
g = gramm('x', subs, 'y', yR, 'color', legendLabelsR);
%g.geom_jitter2('dodge', 0);  % adds subject dots
%g.geom_point()
g.stat_summary('geom', {'bar'}, 'dodge', 0.6);  % mean over subjects
g.set_names('x','Participant','y','T Stat','color','Task');
%g.set_title('Max T stat per task');
g.set_title('Cluster-size weighted average T-score per task');

g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',12)
g.set_color_options("map",cmapped)
g.set_order_options("color",0)

g.axe_property('YLim', [0 30]);
g.draw();
filename = ('tstat_unilateral_weighted_R');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

close all
clear g
figure('Position',[100 100 1200 600])
g = gramm('x', subs, 'y', yL, 'color', legendLabelsL);
%g.geom_jitter2('dodge', 0);  % adds subject dots
%g.geom_point()
g.stat_summary('geom', {'bar'}, 'dodge', 0.6);  % mean over subjects
g.set_names('x','Participant','y','T Stat','color','Task');
%g.set_title('Max T stat per task');
g.set_title('Cluster-size weighted average T-score per task');

g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',12)
g.set_color_options("map",cmapped(3:4,:))
g.set_order_options("color",0)

g.axe_property('YLim', [0 30]);
g.draw();
filename = ('tstat_unilateral_weighted_L');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')



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

filename = ('xcorr_vs_tstat');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')




%% matrix
%tfilesflip = [tfiles(1:2,:); tfiles(4,:); tfiles(3,:)];

figure('Position', [100 100 600 200])
imagesc(tfiles)
%clim([0 12])
colorbar
colormap inferno
xlabel('Participant');
ylabel('Task');
%title('RMS of EMG traces');
h = gcf;
thisFilename = [savedir 'tstat_unilateral_matrix'];
%print(h, '-dpdf', thisFilename, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI
print(h, '-dpdf', thisFilename, '-r300');  % -r300 sets the resolution to 300 DPI














