clear variables
clc 

dirname = '/Volumes/kratos/MB_artefact_021225/';

files ={
    'MB_artefact_021225_WIPMB2_SENSE2_1p5mmiso_20251202150911_9.nii',...
    'MB_artefact_021225_WIPMB2_SENSE2p5_1p5mmiso_20251202150911_13.nii',...
    'MB_artefact_021225_WIPMB2_SENSE3_1p5mmiso_20251202150911_17.nii',...
    'MB_artefact_021225_WIPMB3_SENSE2_1p5mmiso_20251202150911_21.nii',...
    'MB_artefact_021225_WIPMB3_SENSE2_1p5mmiso_run2_20251202150911_34.nii',...
    'MB_artefact_021225_WIPMB3_SENSE2_1p5mmiso_shift_20251202150911_26.nii',...
    'MB_artefact_021225_WIPMB3_SENSE2_1p5mmiso_shift_run2_20251202150911_38.nii',...
    'MB_artefact_021225_WIPMB3_SENSE2p5_1p5mmiso_20251202150911_30.nii',...
    'MB_artefact_021225_WIPMB3_SENSE3_1p5mmiso_20251202150911_42.nii',...
    'MB_artefact_021225_WIPMB4_SENSE2_1p5mmiso_20251202150911_46.nii',...
    'MB_artefact_021225_WIPMB4_SENSE2p5_1p5mmiso_20251202150911_50.nii',...
    'MB_artefact_021225_WIPMB4_SENSE3_1p5mmiso_20251202150911_54.nii'
    };

filelist = cell2struct(files, {'name'}, 1);

filename = {'2DEPI_1p5mm_retinotopy_44slc_wedgesCCW_24',...

           '2DEPI_1p5mm_retinotopyRL_wedgesCW_25',...

           '2DEPI_1p5mm_retinotopyRL_wedgesCCW_26'

           };

phasename = {'2DEPI_1p5mm_retinotopy_44slc_wedgesCCW_24_ph',...

           '2DEPI_1p5mm_retinotopyRL_wedgesCW_25_ph',...

           '2DEPI_1p5mm_retinotopyRL_wedgesCCW_26_ph'

           };

data_path = [rdrive,'DRS-7TfMRI/retinotopy_MBtest/NIFTI/'];

phase_path = [data_path,'Phase/'];

out_path = [data_path,'NORDIC/'];

ext = '.nii.gz';

%###### NORDIC SETTINGS ######

% ARG.magnitude_only = 1;

ARG.DIROUT = out_path;

ARG.save_gfactor_map = 1;

ARG.make_complex_nii = 1;

ARG.save_add_info = 1;

ARG.temporal_phase = 1;

ARG.phase_filter_width = 10;

ARG.gfactor_patch_overlap = 6;

ARG.save_residual_matlab = 1;

ARG.factor_error = 1; %Threshold scaling (1 is default)

ARG.noise_volume_last = 1;

%     ARG.kernel_size_PCA = [11 11 11];

%#############################

parfor n = 1:length(filename)

   mag_base = filename{n};   

   fn_magn_in = [data_path, mag_base];

   fn_phase_in = [phase_path, phasename{n}, ext];

   fn_out = [mag_base, '_nordic'];

   % Filename/Folder based on arguements

   if ~exist([data_path,'NORDIC/'],'dir')

       mkdir([data_path,'NORDIC/'])

       disp('Creating new folder for Nordic correction')

   end

   % RUNNING the correction

   NIFTI_NORDIC(fn_magn_in,fn_phase_tin,fn_out,ARG)

   %Aligning the output g_factor map

   cmd = ['wsl.exe /home/ppzdm1/fsl/share/fsl/bin/fslcpgeom ', ['/mnt/r/',fn_magn_in(4:end)], ' ', ['/mnt/r/',out_path(4:end)],'gfactor/gfactor_', fn_out, '.nii -d'];

   system(cmd);

end


%% NEED TO FIX THIS



for nn = 1:length(filelist)
    
    [~,~,ext] = fileparts(files{nn});
    if strcmpi(ext,'.gz')
        cleaveMe = 7; 
        cleaveMePh = 7; 
        myext = '.nii.gz';
    else 
        cleaveMe = 4; 
        cleaveMePh = 4; 
        myext = '.nii';
    end
    
    %magicDE = 19;
    %cleaveMePh = magicDE;

    mag_base = filelist(nn).name(1:end-cleaveMe);
    phase_base = filelist(nn).name(1:end-cleaveMePh);
    data_path = [dirname, '/magnitude/'];
    phase_path = [dirname, '/phase/'];
    fn_magn_in = [data_path, mag_base, myext];
    fn_phase_in = [phase_path, phase_base, '_ph' myext];
    %fn_phase_in = [phase_path, phase_base, '_phase_echo0' num2str(nn) '.nii'];
    fn_out = [mag_base, '_nordic'];
    ARG.save_gfactor_map = 1;
    ARG.noise_volume_last = 1;
    ARG.save_add_info = 1;
    
    ARG.temporal_phase=1;
    ARG.phase_filter_width=10;
    ARG.gfactor_patch_overlap=6;
    ARG.save_residual_matlab=0;

    %ARG.measured_noise = sqrt(2)./2;
    %ARG.kernel_size_PCA = [];
    %ARG.kernel_size_PCA = [11 11 11]; % 11 11 4 % this is a fudge factor for my data ask DAN
    diffNoise = 0;

    if ARG.noise_volume_last == 0
        ARG.factor_error=1.5;
    end

    if ARG.noise_volume_last == 1
        disp('checking histogram binning of noise volume...')
        b = load_untouch_nii(fn_magn_in);
        bs = single(b.img);
        bs_noise = bs(:,:,:,end); %grab last dynamic
        bs_noise_vec = bs_noise(:);
        unique_values = length(unique(bs_noise_vec));
        figure, histogram(bs_noise_vec,100)
        title(sprintf('Unique values: %d',unique_values))
        fprintf('\nThere are %d unique values, still gonna run NORDIC, but just be careful...\n',unique_values)
        %saveas(gcf,[data_path,fn_out,'_noise_hist.png'])
    end




    % A) If you have a noise scan, then noise_volume_last = 1, diffNoise = 0
    % B) If you don't have a noise scan, then noise_volume_last = 1, diffNoise
    % = 1
    % C) If you don't have a noise scan, and don't want to create one from
    % diffs, then noise_volume_last = 0, diffNoise = 0.
    % If you set noise_volume_last = 0, diffNoise = 1, then this will
    % achieve the same result as C) 
   

    %% Noise checks
    % Mag = niftiread(fn_magn_in); info = niftiinfo(fn_magn_in);
    % Mag_diff_ns = Mag(:,:,:,6) - Mag(:,:,:,7);
    % Phase = single(niftiread(fn_phase_in)); info_ph = niftiinfo(fn_phase_in);
    % Ph_ns = Phase(:,:,:,6) - Phase(:,:,:,7);
    % phase_range = max(Phase(:));
    % II_diff_ns = single(Mag_diff_ns) .* exp(1i*((single(Ph_ns)+1)-(phase_range+1)/2)/(phase_range+1)*2*pi);
    % II = single(Mag) .* exp(1i*((single(Phase)+1)-(phase_range+1)/2)/(phase_range+1)*2*pi);
    % II_ns = II(:,:,:,end);
    % 
    % figure; subplot(2,2,1); imagesc(abs(Mag_diff_ns(:,:,5))); title('Mag. abs. diff. noise'); subplot(2,2,2); imagesc(Mag(:,:,5,end)); title('Mag. noise');
    % hist_data = real(II_diff_ns(:)); hist_data = hist_data(hist_data~=0);
    % subplot(2,2,3); nbins = 100; histfit(hist_data,nbins); xlabel('Pixel value'); ylabel('Count'); title({'Complex data diff. noise (Real)'})
    % hist_data = real(II_ns(:)); hist_data = hist_data(hist_data~=0);
    % subplot(2,2,4); nbins = 100; histfit(hist_data,nbins); xlabel('Pixel value'); ylabel('Count'); title({'Complex data noise (Real)'})

    %% Difference for noise volume
    if diffNoise == 1
        if ~exist([dirname,filelist(nn).name,'_diffNoise.nii.gz'],'file')
            disp('Creating noise volume using the difference between 2 consecutive dynamics')
            Mag = niftiread(fn_magn_in); info = niftiinfo(fn_magn_in);
            %Mag_ns = Mag(:,:,:,6) - Mag(:,:,:,7);
            endMag = size(Mag,ndims(Mag));
            penultMag = endMag-1;
            
            Mag_ns = Mag(:,:,:,penultMag) - Mag(:,:,:,endMag);
            Phase = single(niftiread(fn_phase_in)); info_ph = niftiinfo(fn_phase_in);
            Ph_ns = abs(Phase(:,:,:,penultMag) - Phase(:,:,:,endMag));
            phase_range = max(Phase(:));
            II_ns = single(Mag_ns) .* exp(1i*((single(Ph_ns)+1)-(phase_range+1)/2)/(phase_range+1)*2*pi);

            figure; subplot(1,3,1); imagesc(abs(Mag_ns(:,:,2))); title('Mag. diff. noise');
            subplot(1,3,2); imagesc(Ph_ns(:,:,2)); title('Phase diff. noise');        
            hist_data = real(II_ns(:)); hist_data = hist_data(hist_data~=0); 
            subplot(1,3,3); nbins = 100; histfit(hist_data,nbins); xlabel('Pixel value'); ylabel('Count'); title({'Complex data noise (Real)' ''})
            lim = prctile(hist_data,99.7); xlim([-lim, lim]);
            Mag_wns = cat(4,Mag,abs(Mag_ns));
            Ph_wns = cat(4,Phase,abs(Ph_ns));
            out_info = info; out_info.raw.dim(5) = out_info.raw.dim(5) + 1;
            out_info.ImageSize(4) = out_info.ImageSize(4) + 1;

            
            out_info_ph = info_ph; out_info_ph.raw.dim(5) = out_info_ph.raw.dim(5) + 1;
            out_info_ph.ImageSize(4) = out_info_ph.ImageSize(4) + 1;
            out_info_ph.Datatype = 'single';

            niftiwrite((Mag_wns),[data_path, mag_base, '_diffNoise.nii'],out_info,'Compressed',true);
            niftiwrite((Ph_wns),[phase_path, phase_base, 'ph_diffNoise.nii'],out_info_ph, 'Compressed',true);
        end
        disp('Using scan with noise volume created using the difference between 2 consecutive dynamics')
        fn_magn_in = [data_path, mag_base, '_diffNoise.nii.gz'];
        fn_phase_in = [phase_path, phase_base, 'ph_diffNoise.nii.gz'];
        fn_out = [mag_base, '_diffNoise_nordic'];
    end

    %% Filename/Folder based on arguments
    if ~exist([data_path,'NORDIC/'],'dir')
        mkdir([data_path,'NORDIC/'])
        disp('Creating new folder for Nordic correction')
    end
    data_path = [data_path,'NORDIC/'];

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
    
    nordic_img = double(niftiread([data_path,fn_out,'.nii'])); %Data output from NORDIC correction
    nordic_TC = squeeze(nordic_img(midvox,midvox,slice_num,1:end-1)) - mean(nordic_img(midvox,midvox,slice_num,1:end-1));
    nordic_var_map = var(nordic_img(:,:,:,1:end-1),0,4);
    mean_nordic = mean(nordic_img(:,:,:,1:end-1),4);
    nordic_tSNR_map = mean_nordic./sqrt(nordic_var_map);
    nordic_tSNR_map(nordic_tSNR_map==Inf) = NaN;
    nordic_diff = abs(nordic_img(:,:,:,3) - nordic_img(:,:,:,4));
    %nordic_diff = abs(nordic_img(:,:,:,6) - nordic_img(:,:,:,7));


    %% Plotting stats and maps
    figure('Position',[ 50 50 1100 650])
    [ax, axpos] = tight_subplot(2,3,0.01,0.05,0.2);
    %Temporal mean
    axes(ax(1)); imshow(mean_orig(:,:,slice_num)); colormap(ax(1), 'gray'); cmax = round(max(mean_orig(:)),0); caxis([0 cmax]); title('Mean image'); ylab = ylabel('Pre NORDIC'); set(ylab, 'Units', 'Normalized', 'Position', [-0.01, 0.5, 0]); 
    axes(ax(4)); imshow(mean_nordic(:,:,slice_num)); colormap(ax(4), 'gray'); caxis([0 cmax]); ylab = ylabel('Post NORDIC'); set(ylab, 'Units', 'Normalized', 'Position', [-0.01, 0.5, 0]); cb = colorbar('AxisLocation','in','Location','North','Color','black','Box', 'off','Position',[axpos{1}(1)+0.01, axpos{1}(2)-0.025, axpos{1}(3)-0.02, 0.05]); %cb.Ruler.Exponent = 3;
    %Temporal variance maps
    axes(ax(2)); imshow(var_map(:,:,slice_num)); colormap(ax(2), 'hot'); cmax = round(median(var_map(:))*10,0); caxis([0 cmax]); title('Variance Map');
    axes(ax(5)); imshow(nordic_var_map(:,:,slice_num)); colormap(ax(5), 'hot'); caxis([0 cmax]); cb = colorbar('AxisLocation','in','Location','North','Color','black','Box', 'off','Position',[axpos{2}(1)+0.01, axpos{2}(2)-0.025, axpos{2}(3)-0.02, 0.05]); %cb.Ruler.Exponent = 2;
    %tSNR maps
    axes(ax(3)); imshow(tSNR_map(:,:,slice_num)); colormap(ax(3), 'hot'); cmax = round(max(tSNR_map(:)),0); caxis([0 cmax]); title('tSNR Map');
    axes(ax(6)); imshow(nordic_tSNR_map(:,:,slice_num)); colormap(ax(6), 'hot'); caxis([0 cmax]); cb = colorbar('AxisLocation','in','Location','North','Color','black','Box', 'off','Position',[axpos{3}(1)+0.01, axpos{3}(2)-0.025, axpos{3}(3)-0.02, 0.05]); %cb.Ruler.Exponent = 1;
    saveas(gcf,[data_path,fn_out,'_statmaps.png'])
    %% tSNR Histograms and timecourse
    [values, edges] = histcounts(tSNR_map); %, 'Normalization', 'probability'
    centers = (edges(1:end-1)+edges(2:end))/2;
    figure('Position',[100 100 1700 600])
    % [ax2, axpos2] = tight_subplot(2,3,0.01,0.05,0.1);
    subplot(3,2,[1,3,5])
    imshow(nordic_diff(:,:,slice_num)); colormap gray; cmax = round(median(mean_orig(:)),0); caxis([0 cmax]); title('Difference Dynamics post NORDIC')
    colorbar

    subplot(3,2,2)
    area(centers, values, 'EdgeColor', [31 135 49]./250,'FaceColor', [31 135 49]./250, 'FaceAlpha', 0.5);
    [values, edges] = histcounts(nordic_tSNR_map); 
    ylabel('Count'); xlabel('tSNR'); xlim([0 50]); legend('Pre NORDIC');

    centers = (edges(1:end-1)+edges(2:end))/2;
    subplot(3,2,4)
    area(centers, values, 'EdgeColor', [155, 66, 245]./250,'FaceColor', [155, 66, 245]./250, 'FaceAlpha', 0.5); 
    ylabel('Count'); xlabel('tSNR'); xlim([0 50]); legend('Post NORDIC');

    subplot(3,2,6)
    plot(orig_TC,'m'); hold on; plot(nordic_TC,'c'); legend('Pre NORDIC', 'Post NORDIC','Location','best')
    ylabel('Signal'); xlabel('Dynamic'); ylim([min(orig_TC)*1.2, max(orig_TC)*1.2])
    saveas(gcf,[data_path,fn_out,'_tSNR_hist.png'])
%    close all;
end