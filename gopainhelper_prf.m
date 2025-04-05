% paint digits for pRF subjects
% to investigate unfolding blurring problem
clear variables
close all
clc
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/The University of Nottingham/Pain Relief Grant - General/results/allsubs_maps_again/'];

%%
%subs = {'260821_prf_14359'};
%subs = {'15874_prf13', '210922_prf3','211004_prf6','211011_prf7','211207_prf10','211215_prf11','260821_prf_14359'};

%subs = {'260821_prf_14359', '211011_prf7'};

subs = {'260821_prf_14359'};

mypath = '/Volumes/arianthe/prf_smoothed_1p5mm/';
cd(mypath)
hemisphere = 'l';
surface = 'inflated'; % or sphere!
%subject = {'14359', '11251'};
%subject = {'15874','12778_psir_1mm','15435_psir_1mm','11251','15252_psir_1mm','11766','14359'};
subject = {'14359'};
map = 'hsv';
nchips = 256;
mymin = 0.5;
myalpha = 1;

subdir='/Volumes/ares/subs/';
setenv('SUBJECTS_DIR',subdir);

for ii = 1:length(subs)
    theFile = MRIread([mypath subs{ii} '/visualisation/digitmap_ph_masked.mgh']);
    theMask = MRIread([mypath subs{ii} '/visualisation/BA3a.mgh']);
    LD = theFile.vol(:);
    LD_mask = theMask.vol(:);

    handarea = LD;
    maskarea = LD_mask;
    figure
    go_paint_freesurfer(handarea,...
        subject{ii},'l','range',...
        [0.1 max(handarea)], 'cbar','colormap','hsv')
    print([savedir subs{ii} '_digitmap_ph'],'-dpdf','-r600')



    figure
    go_paint_freesurfer(maskarea,...
        subject{ii},'l','range',...
        [0.1 0.9], 'cbar','colormap','gray')
    print([savedir subs{ii} '_mask'],'-dpdf','-r600')




end

%% for pain data
% to investigate unfolding blurring problem
clear variables
close all
clc
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/The University of Nottingham/Pain Relief Grant - General/results/3t/'];

subs = {'tgi_sub_05_15874_230622'};
mypath = '/Volumes/arianthe/PAIN/';
cd(mypath)
hemisphere = 'l';
surface = 'inflated'; % or sphere!
%subject = {'14359', '11251'};
subject = {'15874'};
map = 'hsv';
nchips = 256;
mymin = 0.5;
myalpha = 1;

subdir='/Volumes/arianthe/freesurfer/';
setenv('SUBJECTS_DIR',subdir);

for ii = 1:length(subs)
    theFile1 = MRIread([mypath subs{ii} '/processed_data_mrtools/visualisation/hand.mgh']);
    %theFile2 = MRIread([mypath subs{ii} '/processed_data_mrtools/visualisation/hand_pos.mgh']);
    %theFile3 = MRIread([mypath subs{ii} '/processed_data_mrtools/visualisation/hand_neg.mgh']);
    theFile4 = MRIread([mypath subs{ii} '/processed_data_mrtools/visualisation/arm.mgh']);
    %theFile5 = MRIread([mypath subs{ii} '/processed_data_mrtools/visualisation/arm_pos.mgh']);
    %theFile6 = MRIread([mypath subs{ii} '/processed_data_mrtools/visualisation/arm_neg.mgh']);
    %theFile7 = MRIread([mypath subs{ii} '/processed_data_mrtools/visualisation/armpost.mgh']);
    %theFile8 = MRIread([mypath subs{ii} '/processed_data_mrtools/visualisation/armpost_pos.mgh']);
    %theFile9 = MRIread([mypath subs{ii} '/processed_data_mrtools/visualisation/armpost_neg.mgh']);

    theMask =  MRIread([mypath subs{ii} '/processed_data_mrtools/visualisation/BA3a.mgh']);

    LD1 = theFile1.vol(:);
    %LD2 = theFile2.vol(:);
    %LD3 = theFile3.vol(:);
    LD4 = theFile4.vol(:);
    %LD5 = theFile5.vol(:);
    %LD6 = theFile6.vol(:);
    %LD7 = theFile7.vol(:);
    %LD8 = theFile8.vol(:);
    %LD9 = theFile9.vol(:);

    LD_mask = theMask.vol(:);
    maskarea = LD_mask;

    %handarea = LD;

    upperThresh = 10;

    figure
    go_paint_freesurfer(LD1,...
        subject{ii},'l','range',...
        [3.08 upperThresh], 'cbar','colormap','hot')
    print([savedir subs{ii} '_heat_hand'],'-dpdf','-r600')


%     figure
%     go_paint_freesurfer(LD2,...
%         subject{ii},'l','range',...
%         [3.08 upperThresh], 'cbar','colormap','hot')
%     print([savedir subs{ii} '_heat_hand_pos'],'-dpdf','-r600')
% 
%     figure
%     go_paint_freesurfer(LD3,...
%         subject{ii},'l','range',...
%         [3.08 upperThresh], 'cbar','colormap','hot')
%     print([savedir subs{ii} '_heat_hand_neg'],'-dpdf','-r600')
% 
    figure
    go_paint_freesurfer(LD4,...
        subject{ii},'l','range',...
        [3.08 upperThresh], 'cbar','colormap','hot')
    print([savedir subs{ii} '_heat_arm'],'-dpdf','-r600')


%     figure
%     go_paint_freesurfer(LD5,...
%         subject{ii},'l','range',...
%         [3.08 upperThresh], 'cbar','colormap','hot')
%     print([savedir subs{ii} '_heat_arm_pos'],'-dpdf','-r600')
% 
%     figure
%     go_paint_freesurfer(LD6,...
%         subject{ii},'l','range',...
%         [3.08 upperThresh], 'cbar','colormap','hot')
%     print([savedir subs{ii} '_heat_arm_neg'],'-dpdf','-r600')

%     figure
%     go_paint_freesurfer(LD7,...
%         subject{ii},'l','range',...
%         [3.08 upperThresh], 'cbar','colormap','hot')
%     print([savedir subs{ii} '_heat_armpost'],'-dpdf','-r600')
% 
% 
%     figure
%     go_paint_freesurfer(LD8,...
%         subject{ii},'l','range',...
%         [3.08 upperThresh], 'cbar','colormap','hot')
%     print([savedir subs{ii} '_heat_armpost_pos'],'-dpdf','-r600')
% 
%     figure
%     go_paint_freesurfer(LD9,...
%         subject{ii},'l','range',...
%         [3.08 upperThresh], 'cbar','colormap','hot')
%     print([savedir subs{ii} '_heat_armpost_neg'],'-dpdf','-r600')


    figure
    go_paint_freesurfer(maskarea,...
        subject{ii},'l','range',...
        [0.1 0.9], 'cbar','colormap','gray')
    print([savedir subs{ii} '_mask'],'-dpdf','-r600')

end


