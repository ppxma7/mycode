function nordic_hpc(fn_magn_in)

addpath(genpath('/gpfs01/home/ppzma/code'))

set(0,'DefaultFigureVisible','off')

if endsWith(fn_magn_in,'.nii.gz')
    [mag_dir, mag_base] = fileparts(fn_magn_in(1:end-3));
    myext = '.nii.gz';
else
    [mag_dir, mag_base] = fileparts(fn_magn_in);
    myext = '.nii';
end

subj_dir  = fileparts(mag_dir);
phase_dir = fullfile(subj_dir,'phase');

fn_phase_in = fullfile(phase_dir,[mag_base '_ph' myext]);
data_path   = mag_dir;
fn_out      = [mag_base '_nordic'];

assert(exist(fn_phase_in,'file')==2, ...
    'Phase file not found: %s', fn_phase_in);

%% ARG settings
ARG.save_gfactor_map = 1;
ARG.noise_volume_last = 1;
ARG.save_add_info = 1;
ARG.temporal_phase = 1;
ARG.phase_filter_width = 10;
ARG.gfactor_patch_overlap = 6;
ARG.save_residual_matlab = 0;


if ARG.noise_volume_last == 0
    ARG.factor_error=1.5;
end

%% Filename/Folder based on arguments
% if ~exist([data_path,'NORDIC/'],'dir')
%     mkdir([data_path,'NORDIC/'])
%     disp('Creating new folder for Nordic correction')
% end
% data_path = [data_path,'NORDIC/'];

nordic_dir = fullfile(data_path,'NORDIC');
if ~exist(nordic_dir,'dir')
    mkdir(nordic_dir)
end
data_path = nordic_dir;



if isfield(ARG,'magnitude_only') && ARG.magnitude_only == 1
    if ~exist([data_path,'Mag_only/'],'dir')
        mkdir([data_path,'Mag_only/'])
        disp('Creating new folder for Nordic correction using only magnitude data')
    end
    data_path = [data_path,'Mag_only/'];
    ARG.DIROUT = data_path;
    fn_out = [fn_out,'_MagOnly'];
end

if isfield(ARG,'noise_volume_last') && ARG.noise_volume_last == 1
    if ~exist([data_path,'Noise_input/'],'dir')
        mkdir([data_path,'Noise_input/'])
        disp('Creating new folder for Nordic correction using noise volume')        
    end
    data_path = [data_path,'Noise_input/'];
    ARG.DIROUT = data_path;
else
    if ~exist([data_path,'/No_noise/'],'dir')
        mkdir([data_path,'/No_noise/'])
        disp('Creating new folder for Nordic correction without using noise volume')        
    end    
    data_path = [data_path,'/No_noise/'];
    ARG.DIROUT = data_path;
    fn_out = [fn_out,'_NoNoise'];
end

%% RUNNING the correction
NIFTI_NORDIC(fn_magn_in,fn_phase_in,fn_out,ARG)

%% NORDIC performance check
orig_img = double(niftiread(fn_magn_in)); %Data input into NORDIC correction    
%Stats to check thermal noise
slice_num = round(size(orig_img,3)/2,0); midvox = round(size(orig_img,1)/3,0);
orig_TC = squeeze(orig_img(midvox,midvox,slice_num,1:end-1)) - mean(orig_img(midvox,midvox,slice_num,1:end-1));
var_map = var(orig_img(:,:,:,1:end-1),0,4);
mean_orig = mean(orig_img(:,:,:,1:end-1),4);
tSNR_map = mean_orig./sqrt(var_map);

%nordic_img = double(niftiread([data_path,fn_out,'.nii'])); %Data output from NORDIC correction
nordic_img = double(niftiread(fullfile(data_path,[fn_out myext])));

nordic_TC = squeeze(nordic_img(midvox,midvox,slice_num,1:end-1)) - mean(nordic_img(midvox,midvox,slice_num,1:end-1));
nordic_var_map = var(nordic_img(:,:,:,1:end-1),0,4);
mean_nordic = mean(nordic_img(:,:,:,1:end-1),4);
nordic_tSNR_map = mean_nordic./sqrt(nordic_var_map);
nordic_tSNR_map(nordic_tSNR_map==Inf) = NaN;
nordic_diff = abs(nordic_img(:,:,:,3) - nordic_img(:,:,:,4));
%nordic_diff = abs(nordic_img(:,:,:,6) - nordic_img(:,:,:,7));


%% Plotting stats and maps 
figure('Position',[50 50 1100 650])

t = tiledlayout(2,3, ...
    'TileSpacing','compact', ...
    'Padding','compact');

%% ----- Temporal mean -----
nexttile
imshow(mean_orig(:,:,slice_num),[])
colormap gray
cmax = prctile(mean_orig(:),99);
clim([0 cmax])
title('Mean image')
ylabel('Pre NORDIC')

nexttile(4)
imshow(mean_nordic(:,:,slice_num),[])
colormap gray
clim([0 cmax])
ylabel('Post NORDIC')
cb = colorbar;
cb.Location = 'northoutside';

%% ----- Variance maps -----
nexttile
imshow(var_map(:,:,slice_num),[])
colormap hot
cmax = prctile(var_map(:),99);
clim([0 cmax])
title('Variance Map')

nexttile(5)
imshow(nordic_var_map(:,:,slice_num),[])
colormap hot
clim([0 cmax])
cb = colorbar;
cb.Location = 'northoutside';

%% ----- tSNR maps -----
nexttile
imshow(tSNR_map(:,:,slice_num),[])
colormap hot
cmax = prctile(tSNR_map(:),99);
clim([0 cmax])
title('tSNR Map')

nexttile(6)
imshow(nordic_tSNR_map(:,:,slice_num),[])
colormap hot
clim([0 cmax])
cb = colorbar;
cb.Location = 'northoutside';

saveas(gcf,[data_path,fn_out,'_statmaps.png'])

%% tSNR Histograms and timecourse
figure('Position',[100 100 1700 600])

t = tiledlayout(3,2, ...
    'TileSpacing','compact', ...
    'Padding','compact');

%% ----- Difference dynamics (large tile) -----
nexttile([3 1])
imshow(nordic_diff(:,:,slice_num),[])
colormap gray
cmax = prctile(mean_orig(:),99);
clim([0 cmax])
title('Difference Dynamics post NORDIC')
colorbar

%% ----- Pre-NORDIC histogram -----
nexttile
[vals_pre, edges] = histcounts(tSNR_map);
centers = (edges(1:end-1) + edges(2:end)) / 2;
area(centers, vals_pre, ...
    'EdgeColor',[31 135 49]./255, ...
    'FaceColor',[31 135 49]./255, ...
    'FaceAlpha',0.5);
ylabel('Count')
xlabel('tSNR')
xlim([0 50])
title('Pre NORDIC')

%% ----- Post-NORDIC histogram -----
nexttile
[vals_post, edges] = histcounts(nordic_tSNR_map);
centers = (edges(1:end-1) + edges(2:end)) / 2;
area(centers, vals_post, ...
    'EdgeColor',[155 66 245]./255, ...
    'FaceColor',[155 66 245]./255, ...
    'FaceAlpha',0.5);
ylabel('Count')
xlabel('tSNR')
xlim([0 50])
title('Post NORDIC')

%% ----- Time courses -----
nexttile
plot(orig_TC,'m','LineWidth',1); hold on
plot(nordic_TC,'c','LineWidth',1)
legend('Pre NORDIC','Post NORDIC','Location','best')
ylabel('Signal')
xlabel('Dynamic')
ylim([min(orig_TC)*1.2, max(orig_TC)*1.2])

saveas(gcf,[data_path,fn_out,'_tSNR_hist.png'])

