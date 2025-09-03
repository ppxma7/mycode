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

close all
clear g
figure('Position',[100 100 1200 600])
g = gramm('x', subs, 'y', y, 'color', filestack);
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


%% matrix
tfilesflip = [tfiles(1:2,:); tfiles(4,:); tfiles(3,:)];

figure('Position', [100 100 600 200])
imagesc(tfilesflip)
clim([0 12])
colorbar
colormap inferno
xlabel('Participant');
ylabel('Task');
%title('RMS of EMG traces');
h = gcf;
thisFilename = [savedir 'tstat_unilateral_matrix'];
%print(h, '-dpdf', thisFilename, '-fillpage', '-r300');  % -r300 sets the resolution to 300 DPI
print(h, '-dpdf', thisFilename, '-r300');  % -r300 sets the resolution to 300 DPI














