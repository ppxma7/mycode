clear all
close all
clc
close all hidden

savepath = '/Users/ppzma/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/SPMIC User Groups - Imaging for Neuroscience/fMRI_benchmark_phantom_oct27/';

%% classic load
mypath = '/Volumes/odysseus/phantom_classic_7T_271023/classic/fMRI_report_data/';
cd(mypath)

sm_quad_mb2 = 'phantomoct_Sensorimotor_1p25mm_iso_TR2_20231027115835_9.nii';
wh_quad_mb2 = 'phantomoct_WholeHead_rsfMRI_2mm_iso_TR1p5_20231027115835_10.nii';
sm_ball_mb2 = 'phantomoct_Sensorimotor_1p25mm_iso_TR2_20231027115835_17.nii';
wh_ball_mb2 = 'phantomoct_WholeHead_rsfMRI_2mm_iso_TR1p5_20231027115835_18.nii';
sm_ball_mb0 = 'phantomoct_SM_MB0_17slc_1p25mm_iso_TR2_20231027115835_19.nii';
wh_ball_mb0 = 'phantomoct_WH_MB0_25slc_rsfMRI_2mm_iso_TR1p5_20231027115835_20.nii';
sm_quad_mb0 = 'phantomoct_SM_MB0_17slc_1p25mm_iso_TR2_20231027115835_34.nii';
wh_quad_mb0 = 'phantomoct_WH_MB0_25slc_rsfMRI_2mm_iso_TR1p5_20231027115835_35.nii';

sm_quad_mb2_data = MRIread(sm_quad_mb2);
wh_quad_mb2_data = MRIread(wh_quad_mb2);
sm_ball_mb2_data = MRIread(sm_ball_mb2);
wh_ball_mb2_data = MRIread(wh_ball_mb2);
sm_quad_mb0_data = MRIread(sm_quad_mb0);
wh_quad_mb0_data = MRIread(wh_quad_mb0);
sm_ball_mb0_data = MRIread(sm_ball_mb0);
wh_ball_mb0_data = MRIread(wh_ball_mb0);

sm_quad_mb2_data_vol = sm_quad_mb2_data.vol(:,:,:,1:60);
wh_quad_mb2_data_vol = wh_quad_mb2_data.vol(:,:,:,1:60);
sm_ball_mb2_data_vol = sm_ball_mb2_data.vol(:,:,:,1:60);
wh_ball_mb2_data_vol = wh_ball_mb2_data.vol(:,:,:,1:60);
sm_quad_mb0_data_vol = sm_quad_mb0_data.vol(:,:,:,1:60);
wh_quad_mb0_data_vol = wh_quad_mb0_data.vol(:,:,:,1:60);
sm_ball_mb0_data_vol = sm_ball_mb0_data.vol(:,:,:,1:60);
wh_ball_mb0_data_vol = wh_ball_mb0_data.vol(:,:,:,1:60);

thecell = cell(1,8);
thecell{1} = sm_quad_mb2_data_vol;
thecell{2} = wh_quad_mb2_data_vol;
thecell{3} = sm_ball_mb2_data_vol;
thecell{4} = wh_ball_mb2_data_vol;
thecell{5} = sm_quad_mb0_data_vol;
thecell{6} = wh_quad_mb0_data_vol;
thecell{7} = sm_ball_mb0_data_vol;
thecell{8} = wh_ball_mb0_data_vol;

%% mtx load
mypath = '/Volumes/odysseus/phantom_classic_7T_271023/mtx/fMRI_report_data/';
cd(mypath)

sm_quad_mb2 = 'parrec_Sensorimotor_1p25mm_iso_TR2_20231030110948_9.nii';
wh_quad_mb2 = 'parrec_WholeHead_rsfMRI_2mm_iso_TR1p5_20231030110948_10.nii';
sm_ball_mb2 = 'parrec_Sensorimotor_1p25mm_iso_TR2_20231030110948_18.nii';
wh_ball_mb2 = 'parrec_WholeHead_rsfMRI_2mm_iso_TR1p5_20231030110948_19.nii';
sm_quad_mb0 = 'parrec_Sensorimotor_1p25mm_iso_TR2_noMB_20231030110948_11.nii';
wh_quad_mb0 = 'parrec_WholeHead_rsfMRI_2mm_iso_TR1p5_20231030110948_13.nii';
sm_ball_mb0 = 'parrec_Sensorimotor_1p25mm_iso_TR2_noMB_20231030110948_20.nii';


sm_quad_mb2_data = MRIread(sm_quad_mb2);
wh_quad_mb2_data = MRIread(wh_quad_mb2);
sm_ball_mb2_data = MRIread(sm_ball_mb2);
wh_ball_mb2_data = MRIread(wh_ball_mb2);
sm_quad_mb0_data = MRIread(sm_quad_mb0);
wh_quad_mb0_data = MRIread(wh_quad_mb0);
sm_ball_mb0_data = MRIread(sm_ball_mb0);

sm_quad_mb2_data_vol = sm_quad_mb2_data.vol(:,:,:,1:60);
wh_quad_mb2_data_vol = wh_quad_mb2_data.vol(:,:,:,1:60);
sm_ball_mb2_data_vol = sm_ball_mb2_data.vol(:,:,:,1:60);
wh_ball_mb2_data_vol = wh_ball_mb2_data.vol(:,:,:,1:60);
sm_quad_mb0_data_vol = sm_quad_mb0_data.vol(:,:,:,1:60);
wh_quad_mb0_data_vol = wh_quad_mb0_data.vol(:,:,:,1:60);
sm_ball_mb0_data_vol = sm_ball_mb0_data.vol(:,:,:,1:60);

thecell_mtx = cell(1,7);
thecell_mtx{1} = sm_quad_mb2_data_vol;
thecell_mtx{2} = wh_quad_mb2_data_vol;
thecell_mtx{3} = sm_ball_mb2_data_vol;
thecell_mtx{4} = wh_ball_mb2_data_vol;
thecell_mtx{5} = sm_quad_mb0_data_vol;
thecell_mtx{6} = wh_quad_mb0_data_vol;
thecell_mtx{7} = sm_ball_mb0_data_vol;


%%
%classic
thecell_out = cell(1,8);
for ii = 1:8

    im_data = thecell{ii};
    nX = size(im_data,1);
    nY = size(im_data,2);
    nS = size(im_data,3);
    nV = 60;
    reshaped_data = reshape(im_data,nX*nY*nS,nV);
    reshaped_data = double(reshaped_data);
    X1 =[1:nV].';X2 = X1.^2;
    X = [ones(size(X1)),X1,X2]; %Design matrix
    P = (X'*X)\X'; % Proj. matrix (also pinv(X))
    betas = P*(double(reshaped_data).');
    detrended_data = (reshaped_data.' - X(:,2:3)*betas(2:3,:)).';
    im_data = reshape(detrended_data,nX,nY,nS,nV);

    thecell_out{ii} = im_data;

end

% mtx
thecell_out_mtx = cell(1,7);
for ii = 1:7

    im_data = thecell_mtx{ii};
    nX = size(im_data,1);
    nY = size(im_data,2);
    nS = size(im_data,3);
    nV = 60;
    reshaped_data = reshape(im_data,nX*nY*nS,nV);
    reshaped_data = double(reshaped_data);
    X1 =[1:nV].';X2 = X1.^2;
    X = [ones(size(X1)),X1,X2]; %Design matrix
    P = (X'*X)\X'; % Proj. matrix (also pinv(X))
    betas = P*(double(reshaped_data).');
    detrended_data = (reshaped_data.' - X(:,2:3)*betas(2:3,:)).';
    im_data = reshape(detrended_data,nX,nY,nS,nV);

    thecell_out_mtx{ii} = im_data;

end


%% plot TS and compare



for ii = 1:7

    classicScan = thecell_out{ii};
    %classicScan = fliplr(classicScan);
    mtxScan = thecell_out_mtx{ii};

    imgScale_classic = 50000;
    imgScale_mtx = 50000;

    tsnrData_classic=mean(classicScan,4)./std(classicScan,0,4);
    tsnrData_mtx=mean(mtxScan,4)./std(mtxScan,0,4);


    nX = size(classicScan,1);
    nY = size(classicScan,2);
    nS = size(classicScan,3);
    nV = size(classicScan,4);

    patchsize = [20 20];
    xpos = round(nX./2)+12; %-20
    ypos = round(nY./2)-32; %+10
    xpatch = xpos+patchsize(1);
    ypatch = ypos+patchsize(2);
    thisSlice = round(size(classicScan,3).*(2./3));
    quickCrop = [xpos,xpatch,ypos,ypatch,thisSlice];

    mypatch_classic = classicScan(quickCrop(1):quickCrop(2),quickCrop(3):quickCrop(4),quickCrop(5),:);
    mypatch_multix = mtxScan(quickCrop(1):quickCrop(2),quickCrop(3):quickCrop(4),quickCrop(5),:);

    squatch_classic = squeeze(mypatch_classic);
    squatch_mtx = squeeze(mypatch_multix);

    patch_tSNR_classic = mean(squatch_classic,3)./std(squatch_classic,0,3);
    patch_tSNR_mean_classic = mean(patch_tSNR_classic(:));

    patch_tSNR_mtx = mean(squatch_mtx,3)./std(squatch_mtx,0,3);
    patch_tSNR_mean_mtx = mean(patch_tSNR_mtx(:));


    bloop = figure('Position',[100 100 1300 600]);
    tiledlayout(2,4)
    nexttile
    %imagesc(classicScan(:,:,quickCrop(5)))
    imagesc(tsnrData_classic(:,:,quickCrop(5)))
    title(sprintf('tSNR, slice %d',quickCrop(5)))
    %clim([0 imgScale_classic])
    clim([0 500])
    hold on
    rectangle('Position',[quickCrop(3),quickCrop(1),patchsize],...
        'LineWidth',2,'LineStyle','--')
    colormap inferno
    colorbar
    nexttile
    imagesc(patch_tSNR_classic)
    title(sprintf('patch tSNR = %d',round(patch_tSNR_mean_classic)))
    colormap inferno
    colorbar
    clim([0 500])
    nexttile
    %imagesc(mtxScan(:,:,quickCrop(5)))
    imagesc(tsnrData_mtx(:,:,quickCrop(5)))
    title(sprintf('tSNR, slice %d',quickCrop(5)))
    %clim([0 imgScale_mtx])
    clim([0 500])
    hold on
    rectangle('Position',[quickCrop(3),quickCrop(1),patchsize],...
        'LineWidth',2,'LineStyle','--')
    colormap inferno
    colorbar
    nexttile
    imagesc(patch_tSNR_mtx)
    title(sprintf('patch tSNR = %d',round(patch_tSNR_mean_mtx)))
    colormap inferno
    colorbar
    clim([0 500])

    %


    squatch_rows_classic = mean(squatch_classic,1);
    squatch_rowscols_classic = mean(squatch_rows_classic,2);
    squatch_t_classic = squeeze(squatch_rowscols_classic);
    std_sq_classic = std(squatch_classic);
    std_sq_rows_classic = mean(std_sq_classic);
    std_sq_rows_sq_classic = squeeze(std_sq_rows_classic);
    %a_cls = squatch_t_classic-mean(squatch_t_classic);
    %b_cls = std_sq_rows_sq_classic-mean(std_sq_rows_sq_classic);

    squatch_rows_mtx = mean(squatch_mtx,1);
    squatch_rowscols_mtx = mean(squatch_rows_mtx,2);
    squatch_t_mtx = squeeze(squatch_rowscols_mtx);
    std_sq_mtx = std(squatch_mtx);
    std_sq_rows_mtx = mean(std_sq_mtx);
    std_sq_rows_sq_mtx = squeeze(std_sq_rows_mtx);
    %a_mtx = squatch_t_mtx-mean(squatch_t_mtx);
    %b_mtx = std_sq_rows_sq_mtx-mean(std_sq_rows_sq_mtx);




    facor = mean(squatch_t_mtx)./mean(squatch_t_classic);
    facor_std = mean(std_sq_rows_mtx)./mean(std_sq_rows_classic);
    location = 'northeast';
    %bloopy = figure;
    %tiledlayout(2,2)
    nexttile([1 2])
    plot(squatch_t_classic.*facor,'LineWidth',2)
    hold on
    plot(squatch_t_mtx,'LineWidth',2)
    legend('Mean classic','Mean mtx','FontSize',9,'Location',location)
    nexttile([1 2])
    plot(std_sq_rows_sq_classic.*facor_std,'LineWidth',2)
    hold on
    plot(std_sq_rows_sq_mtx,'LineWidth',2)
    legend('Std classic','Std mtx','FontSize',9,'Location',location)
    print(bloop, sprintf([savepath 'comparison_signal_std_scan_%d.png'],ii),'-dpng');

end




