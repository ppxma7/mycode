subdir='/Volumes/nemosine/subs/';
setenv('SUBJECTS_DIR',subdir);

hemisphere = 'r';
surface = 'inflated'; % or sphere!
subject = 'fsaverage';



mypath = '/Volumes/ares/PFS/7T/digitatlas/';

map = 'hsv';
nchips = 256;
%mysub = {'00393'};
mymin = 0.2;
mysub = {'PFS'};

myalpha = 1;


for iSub = 1:length(mysub)
    cd([mypath mysub{iSub}])
    fnameRD = 'ph_LD_masked_fsaverage.mgh';
    fnameRDco = 'co_LD_masked_fsaverage.mgh';
    overlay = MRIread(fnameRD);
    mytmp = overlay.vol;
    % mask?
    mytmp = mytmp(:);
    coidx = 0.4;
    coverlay = MRIread(fnameRDco);
    coverlay_vec = coverlay.vol;
    coverlay_vec = coverlay_vec(:);
    coverlay_vec_thresh = coverlay_vec>coidx;
    
    mytmp = mytmp .* coverlay_vec_thresh; % threshold phase by coherence
    
    for ii = 1:5
        %    fnameL = ['PCorrelation_index_RD' sprintf('%d',iDigit) '.mgh'];
        %fnameL = ['PCorrelation_index_RD.mgh'];
        fnameDig = ['LD' num2str(ii) '_fsaverage.mgh'];
        overlayDig = MRIread(fnameDig);
        mytmpDig = overlayDig.vol;
        mytmpDig = mytmpDig(:);
        
        thisDigit = mytmpDig .* mytmp;
        
        %         fnameL = ['RD' sprintf('%d',iDigit) '_' mysub{iSub} '.mgh'];
        %         %fnameR = ['LD' sprintf('%d',iDigit) '_' mysub{iSub} '.mgh'];
        %         %[overlayR] = MRIread(fnameR);
        %         overlay = MRIread(fnameL);
        
        %mytmp(:,iDigit) = overlay.vol;
        %         mytmp(:) = overlay.vol;
        
        % mask?
        %         mytmp = mytmp(:);
        %         mytmp = mytmp .* pRD_FPM(:,iDigit);
        %         mytmp = logical(mytmp);
        %
        figure
        go_paint_freesurfer(thisDigit,'fsaverage','r','range',[mymin max(thisDigit)], 'cbar','colormap','hsv')
    end
end

%%
subdir='/Volumes/nemosine/subs';
setenv('SUBJECTS_DIR',subdir);
mymin = 0.2;
hemisphere = 'l';
surface = 'inflated'; % or sphere!
%subject = 'fsaverage';

mysub = {'12778_psir_1mm'};

% vol2surf_cmd = 'mri_vol2surf --hemi lh --mov corr_masked_postL --regheader ${subject}/Anatomy/pre01freesurfer --projfrac-avg  0.1 1 0.1 --surf-fwhm 1 --out ${MOUNT}/${subject}/motortopy/ph_RD_masked.mgh --surf white --out_type mgh';
% unix(vol2surf_cmd);

tmpdata = corr_masked_postL(:);

for ii = 1:length(mysub)
    go_paint_freesurfer(tmpdata,mysub{ii},'l','range',[0 1], 'cbar','colormap','inferno','warp')
    
end



%%


hemisphere = 'l';
surface = 'inflated'; % or sphere!
subject = 'fsaverage';
mypath = '/Volumes/hermes/pain_04_14359_230110/processed_data_mrtools/overlays_export/';
cd(mypath)
map = 'inferno';
nchips = 256;
mymin = 2;
mysub = {'14359'};
myalpha = 0.8;
subdir='/Volumes/nemosine/subs';
setenv('SUBJECTS_DIR',subdir);

data_meta = MRIread([mypath 'concat_thermodearm.mgh']);
%data_meta = MRIread([mypath 'concat_thermodearmpost.mgh']);
%data_meta = MRIread([mypath 'concat_thermodehand.mgh']);
data = data_meta.vol;

% need the {ii} because otherwise fopen doesn't like the cell array, so
% need to send it the contents

for ii = 1:length(mysub)
    go_paint_freesurfer(data,mysub{ii},'l','range',[mymin 6], 'cbar','colormap',map,'alpha',myalpha,'warp')
end

mypath2 = '/Users/ppzma/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Pain Relief Grant - General/';
cd(mypath2)

%fig1 = [mypath2 mysub{ii} '_thermodehand.png'];
fig1 = [mypath2 mysub{ii} '_thermodearm.png'];
saveas(gcf,fig1)
%bloop{2,n} = corr_fig2;
%tmpdata = corr_masked_postL(:);

%for ii = 1:length(mysub)
%go_paint_freesurfer(data,mysub{ii},'l','range',[0 1], 'cbar','colormap',map,'warp')

%end








