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
%%
% theseOverlays = {'rspmT_0001.nii',...
%     'rspmT_0002.nii',...
%     'rspmT_0003.nii',...
%     'rspmT_0004.nii',...
%     'rspmT_0005.nii',...
%     };


theseOverlays = {'spmT2mprage_0001.nii',...
    'spmT2mprage_0002.nii',...
    'spmT2mprage_0003.nii',...
    'spmT2mprage_0004.nii',...
    'spmT2mprage_0005.nii'
    };

% theseFolders = {'thermode_hand_3t',...
%     'thermode_arm_3t',...
%     'thermode_hand_7t',...
%     'thermode_arm_7t',...
%     'thermode_arm_post_7t',...
%     };

% 
% theseFolders = {
%     'thermode_hand_7t',...
%     'thermode_arm_7t',...
%     'thermode_arm_post_7t',...
%     };

theseFolders = {'thermode_hand_3t',...
    'thermode_arm_3t'
    };


%subject = '10875';
%thispath = '/Volumes/nemosine/subs/';
%thispath = '/Volumes/styx/for_Michael/';
%thispath = '/Volumes/styx/DigitAtlas/FreeSurferDigitAtlas/';
%thispath = ['/Volumes/arianthe/exp016/231108_share/sub016_' thisSub '/resultsSummary/'];


thispath = '/Volumes/arianthe/PAIN/spmimport_redo_allsubs/';
thisSub = 'sub08';


%pathname = [thispath subject '/label/'];
%pathname = thispath;
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
%%
%theseOverlays = {'lh.BA3b_exvivo.label.volume.nii'};
%pathname = [thispath subject '/freesurfer/label/'];

for ii = 1:length(theseFolders)
    for jj = 1:length(theseOverlays)

        v = viewGet([], 'view', 1);

        filename = fullfile(thispath,thisSub,theseFolders{ii},theseOverlays{jj});
        %filename = 'lh.BA6_exvivo.label.volume.nii';
        params.scanlist = 1; % 1 for forward, 2 for reverse
        %params.min_overlay = 3.09;
        params.min_overlay = 2;
        params.max_overlay = 10;
        params.min_clip = 2.3;
        %params.colormap = viridis(256);
        params.max_clip = 10;
        params.pathname = filename;
        params.frameList = 1;
        params.useSform = 1;
        params.filename = [theseFolders{ii} '_' theseOverlays{jj}];
        params.interpMethod = 'linear';
        params.nameFrame1 = 'Frame 1';
        importOverlay_copy(v,params)
        clear params
    end
end





