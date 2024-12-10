%% importOverlay_script.m

%thisSub = '018';
% Speed up import overlay loading from nifti, e.g. from a Freesurfer label
% Use in combination with convert2label.sh
%
%
% Michael Asghar 9/8/23
%
%
% theseOverlays = {'lh.BA3a_exvivo.label.volume.nii',...
%     'lh.BA3b_exvivo.label.volume.nii','lh.BA1_exvivo.label.volume.nii',...
%     'lh.BA2_exvivo.label.volume.nii','lh.BA4a_exvivo.label.volume.nii',...
%     'lh.BA4p_exvivo.label.volume.nii','lh.BA6_exvivo.label.volume.nii'};

% theseOverlays = {'lh.BA3a_exvivo.label.volume.nii',...
%     'lh.BA3b_exvivo.label.volume.nii','lh.BA1_exvivo.label.volume.nii',...
%     'lh.BA2_exvivo.label.volume.nii'};


% theseOverlays = {'lh.BA4a_exvivo.label.volume.nii',...
%     'lh.BA4p_exvivo.label.volume.nii','lh.BA6_exvivo.label.volume.nii'};
% 
% theseOverlays = {'lh.BA3a_exvivo.label.volume.nii',...
%     'lh.BA3b_exvivo.label.volume.nii','lh.BA1_exvivo.label.volume.nii',...
%     'lh.BA2_exvivo.label.volume.nii'};


% 
% theseOverlays = {'zstat1_R.nii','zstat2_R.nii','zstat3_R.nii','zstat4_R.nii','zstat5_R.nii',...
%     'zstat1_L.nii','zstat2_L.nii','zstat3_L.nii','zstat4_L.nii','zstat5_L.nii'};
% 
% theseOverlays = {'WTA_idx_freesurfer_right_WM_Flat_158_95_185_Rad60.nii',...
%     'WTA_max_freesurfer_right_WM_Flat_158_95_185_Rad60.nii'};


% theseOverlays = {'WTA_idx_freesurfer_left_WM_Flat_89_98_177_Rad65.nii',...
%     'WTA_max_freesurfer_left_WM_Flat_89_98_177_Rad65.nii'};


% theseOverlays = {[thisSub '_aveRightHand_Cope1zstat_2highres.nii'],...
%     [thisSub '_aveRightHand_Cope2zstat_2highres.nii'],...
%     [thisSub '_aveRightHand_Cope3zstat_2highres.nii'],...
%     [thisSub '_aveRightHand_Cope4zstat_2highres.nii'],...
%     [thisSub '_aveRightHand_Cope5zstat_2highres.nii'],...
%     [thisSub '_aveLeftHand_Cope1zstat_2highres.nii'],...
%     [thisSub '_aveLeftHand_Cope2zstat_2highres.nii'],...
%     [thisSub '_aveLeftHand_Cope3zstat_2highres.nii'],...
%     [thisSub '_aveLeftHand_Cope4zstat_2highres.nii'],...
%     [thisSub '_aveLeftHand_Cope5zstat_2highres.nii']};

theseOverlays = {'mrtoolsspmT_0002.nii',...
    'mrtoolsspmT_0003.nii',...
    'mrtoolsspmT_0004.nii',...
    'mrtoolsspmT_0006.nii',...
    'mrtoolsspmT_0007.nii',...
    'mrtoolsspmT_0008.nii',...
    'mrtoolsspmT_0009.nii',...
    'mrtoolsspmT_0010.nii',...
    };

%subject = '10875';
%thispath = '/Volumes/nemosine/subs/';
%thispath = '/Volumes/styx/for_Michael/';
%thispath = '/Volumes/styx/DigitAtlas/FreeSurferDigitAtlas/';
%thispath = ['/Volumes/arianthe/exp016/231108_share/sub016_' thisSub '/resultsSummary/'];


thispath = '/Volumes/ares/PFS/spm_conversions/cttouch_redo/';


%pathname = [thispath subject '/label/'];
pathname = thispath;
%pathname = [thispath subject '/ROIs/'];
%pathname = [thispath];% '/Volumes/nemosine/subs/13658/label/';

% for ii = 1:length(theseOverlays)
%     v = viewGet([], 'view', 1);
%     filename = theseOverlays{ii};
%     %filename = 'lh.BA6_exvivo.label.volume.nii';
%     params.scanlist = 1; % 1 for forward, 2 for reverse
%     %params.min_overlay = 0.1;
%     params.colormap = digits(5);
%     params.pathname = [pathname filename];
%     params.frameList = 1;
%     params.useSform = 1;
%     params.filename = filename;
%     params.interpMethod = 'linear';
%     params.nameFrame1 = 'Frame 1';
%     importOverlay(v,params)
%     clear params
% end

%theseOverlays = {'lh.BA3b_exvivo.label.volume.nii'};
%pathname = [thispath subject '/freesurfer/label/'];

for ii = 1:length(theseOverlays)
    v = viewGet([], 'view', 1);
    filename = theseOverlays{ii};
    %filename = 'lh.BA6_exvivo.label.volume.nii';
    params.scanlist = 1; % 1 for forward, 2 for reverse
    %params.min_overlay = 3.09;
    params.min_overlay = 2;
    params.max_overlay = 10;
    params.pathname = [pathname filename];
    params.frameList = 1;
    params.useSform = 1;
    params.filename = filename;
    params.interpMethod = 'linear';
    params.nameFrame1 = 'Frame 1';
    importOverlay_copy(v,params)
    clear params
end




