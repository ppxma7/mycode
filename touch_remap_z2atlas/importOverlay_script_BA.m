%thisSub = '018';
thisSub = '16227_mprage_1mm_freesurfer';

% theseOverlays = {'lh_3ab12_div.nii',...
%     'rh_3ab12_div.nii'};

%theseOverlays = {'lh.BA3a_exvivo.label.volume.nii'};

theseOverlays = {'rh.BA3a_exvivo.label.volume.nii',...
    'rh.BA3b_exvivo.label.volume.nii',...
    'rh.BA1_exvivo.label.volume.nii',...
    'rh.BA2_exvivo.label.volume.nii'};


%thispath = ['/Volumes/arianthe/exp016/freesurfer/' thisSub '/label/'];
thispath = ['/Volumes/ares/subs/' thisSub '/label/'];
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
    params.min_overlay = 0.1;
    %params.max_overlay = 10;
    params.pathname = [pathname filename];
    params.frameList = 1;
    params.useSform = 1;
    params.filename = filename;
    params.interpMethod = 'linear';
    params.nameFrame1 = 'Frame 1';
    importOverlay_copy(v,params)
    clear params
end





