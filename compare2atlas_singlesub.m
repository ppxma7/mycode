function [  ] = compare2atlas_singlesub(shallisave, verbose)
%compare2atlas - compare patient/subject digit to atlas digit
%
% [ma] feb2019
%
% run loadAtlas_George.m first to get digitatlas as .mat file
%
% try loading and comparing
% THIS IS USED WHEN IN FSAVERAGE SPACE
% See Also loadAtlas_George.m

tic
if nargin<2
    shallisave=1;
    verbose = 1;
elseif nargin < 1
    verbose = [];
end

%load('/Users/ppzma/data/DigitAtlas/fsaveragePhBindDigits/digitAtlas_mean_usingmax.mat')
%load('/Volumes/nemosine/digatlas_oct19_binarised.mat', 'pLD_all', 'pRD_all', 'pLD_FPM', 'pRD_FPM','pLD_MPM','pRD_MPM'); %load the 21 subject atlas
%load('/Users/ppzma/data/digatlas_github.mat', 'pLD_all', 'pRD_all', 'pLD_FPM', 'pRD_FPM','pLD_MPM','pRD_MPM'); %load the 21 subject atlas


userName = char(java.lang.System.getProperty('user.name'));

load(['/Users/' userName '/Documents/MATLAB/digitAtlas/sundries/digatlas_github.mat'], 'pLD_all', 'pRD_all', 'pLD_FPM', 'pRD_FPM','pLD_MPM','pRD_MPM');
%subdir='/Users/ppzma/data/DigitAtlas/patients_digits/';
%subdir = '/Volumes/styx/for_Michael/';
subdir = '/Volumes/arianthe/exp016/231108_share/';




cd(subdir)

%subs = {'s014','s021'};
% subs={'006', '009', '011', '013',...
%     '014', '015', '020',...
%     '023', '024', '028'};

%subs={'021','022','030','032','033'};
subs={'005','006','008','009','011','012','013','014','015','017',...
      '018','020','023','024','028','029','037','041','043','045',...
      '049','050','051','052','054','055','056','059','060','064',...
      '021','022','025','026','030','031','032','033','034','035',...
      '036','038','039','040','042','046','047','057','061','063'};

lenHC = 30;
lenPA = 20;

% so far 25 HC, 20 PA


typicality_patients = {'021','022','025','026','030',...
    '031','032','033','035','038',...
    '039', '040','046', '057', '063'};
typicality_s1_repaired = [0.68 0.94 0.72 0.34 0.96,...
    0.88 0.82 0.87 0.75 0.84,...
    0.12 0.6 0.098 0.53 0.17];
% typicality_s1_healthy = [0.5 0.97 0.83 0.67 0.87 0.89,...
%     0.93 0.89 0.52 0.88 0.61 0.94 0.87 0.48,...
%     0.87];

LD_repaired = contains(typicality_patients,{'021','022','030','033','035','039','046'});
RD_repaired = contains(typicality_patients,{'025','026','031','032','038','040','057','063'});

LD_injured = contains(subs,{'021','022','030','033','034','035','039','046','047','061'});
RD_injured = contains(subs,{'025','026','031','032','036','038','040','042','057','063'});
LD_inj_idx = find(LD_injured);
RD_inj_idx = find(RD_injured);

LD_media = contains(subs,{'021','033','039','046'});
LD_ulnar = contains(subs,{'022','030','047','061'});
LD_both = contains(subs,{'034','035'});
RD_media = contains(subs,{'040'}); 
RD_ulnar = contains(subs,{'025','031','036','042','057'});
RD_both = contains(subs,{'026','032','038'});
LD_media_idx = find(LD_media);
LD_ulnar_idx = find(LD_ulnar);
LD_both_idx = find(LD_both);
RD_media_idx = find(RD_media);
RD_ulnar_idx = find(RD_ulnar);
RD_both_idx = find(RD_both);

% can we group by dominance?
domsub = [2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,1,2,2,2,2,2,2,2,1,2,2,2,2];
RIGHT_dom = (domsub == 2);
LEFT_dom = (domsub == 1);
RIGHT_dom_idx = find(RIGHT_dom);
LEFT_dom_idx = find(LEFT_dom);

% patients only from sub 21-63
days_since_repair = [581 309 1856 1130 817 2292 2523 361 274 876 4248,...
    553 930 955 1379 1514 2731 3967 1242 222];

DSR_idx_LD = LD_injured(lenHC+1:end);
days_since_repair_injured_LD = days_since_repair(DSR_idx_LD);
DSR_idx_RD = RD_injured(lenHC+1:end);
days_since_repair_injured_RD = days_since_repair(DSR_idx_RD);

% median ulnar DSR
DSR_idx_LD_media = LD_media(lenHC+1:end);
days_since_repair_LD_media = days_since_repair(DSR_idx_LD_media);
DSR_idx_RD_media = RD_media(lenHC+1:end);
days_since_repair_RD_media = days_since_repair(DSR_idx_RD_media);

DSR_idx_LD_ulnar = LD_ulnar(lenHC+1:end);
days_since_repair_LD_ulnar = days_since_repair(DSR_idx_LD_ulnar);
DSR_idx_RD_ulnar = RD_ulnar(lenHC+1:end);
days_since_repair_RD_ulnar = days_since_repair(DSR_idx_RD_ulnar);
%subs = {'020'};


% splitROW = 5;
% splitCOL = 8;

%nHC = 1;


%disp('Calculating Dice to the MPM, centend to the FPM and FOM between patient digits and the atlas')


mLD = pLD_MPM;
mRD = pRD_MPM;

mLD_explode = [mLD==1,mLD==2,mLD==3,mLD==4,mLD==5];
mRD_explode = [mRD==1,mRD==2,mRD==3,mRD==4,mRD==5];

diceLD = zeros(5,5,length(subs));
diceRD = zeros(5,5,length(subs));


%%
for iSubject = 1:length(subs)
    
    % THIS DOES THE DICE TO THE MPM ATLAS
    
    %RD_A = MRIread([subdir subs{iSubject} '_' 'RD' '.mgh']);
    LD_A = MRIread([subdir 'sub016_' subs{iSubject} '/resultsSummary/atlas/' subs{iSubject} '_' 'LD' '.mgh']);
    RD_A = MRIread([subdir 'sub016_' subs{iSubject} '/resultsSummary/atlas/' subs{iSubject} '_' 'RD' '.mgh']);

    % if isempty(RD_A), RD_A = zeros(size(pLD_all,1),5); else RD_A = RD_A.vol; end
    
    LD_A = LD_A.vol;
    RD_A = RD_A.vol;

    
    for ii = 1:5
        for jj = 1:5
                       
            diceLD(ii,jj,iSubject) = dice(LD_A(:,ii), mLD_explode(:,jj));
            diceRD(ii,jj,iSubject) = dice(RD_A(:,ii), mRD_explode(:,jj));
        end
    end
    %end


    
    
    
    
    
    
    
    %% now try using figure of merit to the FPM
    % paper - O'Neill, G. https://doi.org/10.1016/j.neuroimage.2016.08.061
    % Penalises both representation and degeneracy
    % spatial correlation(D1, atlasD1) - mean(D1, all other atlas digits)
    %
    % since this is binary, maybe try dice coeff - mean dice coeff of rest
    % instead of corr()

    if unique(LD_A) == [0;1] & unique(RD_A) == [0;1]
        
        % mask
        LD_A_masked = LD_A .* pLD_FPM;
        RD_A_masked = RD_A .* pRD_FPM;
        
        % remake to binary
        LD_A_masked_bin = logical(LD_A_masked);
        RD_A_masked_bin = logical(RD_A_masked);
        
        % centend to FPM
        [mycentL(:,:,iSubject) ] = cenTenDig_singlesub(LD_A_masked_bin, pLD_FPM);
        [mycentR(:,:,iSubject) ] = cenTenDig_singlesub(RD_A_masked_bin, pRD_FPM);
        % centend to MPM
        [mycentLMPM(:,:,iSubject) ] = cenTenDig_singlesub(LD_A_masked_bin, mLD_explode);
        [mycentRMPM(:,:,iSubject) ] = cenTenDig_singlesub(RD_A_masked_bin, mRD_explode);
        
        % error check
        if any(isnan(mycentL(:,:,iSubject)))
            %nanDex = isnan(mycent(:,:,iSubject));
            tmpCent = mycentL(:,:,iSubject);
            tmpCent(isnan(tmpCent))=0;
            mycentL(:,:,iSubject) = tmpCent;
        end

        if any(isnan(mycentR(:,:,iSubject)))
            %nanDex = isnan(mycent(:,:,iSubject));
            tmpCent = mycentR(:,:,iSubject);
            tmpCent(isnan(tmpCent))=0;
            mycentR(:,:,iSubject) = tmpCent;
        end
        
        if any(isnan(mycentLMPM(:,:,iSubject)))
            %nanDexMPM = isnan(mycentMPM(:,:,iSubject));
            tmpCentMPM = mycentLMPM(:,:,iSubject);
            tmpCentMPM(isnan(tmpCentMPM))=0;
            mycentLMPM(:,:,iSubject) = tmpCentMPM;
        end
        if any(isnan(mycentRMPM(:,:,iSubject)))
            %nanDexMPM = isnan(mycentMPM(:,:,iSubject));
            tmpCentMPM = mycentRMPM(:,:,iSubject);
            tmpCentMPM(isnan(tmpCentMPM))=0;
            mycentRMPM(:,:,iSubject) = tmpCentMPM;
        end

        
        
        
    else
        %no masking
        %disp('found a non-binary')
        
        [mycentL(:,:,iSubject)] = cenTenDig_singlesub(LD_A, pLD_FPM);
        [mycentLMPM(:,:,iSubject) ] = cenTenDig_singlesub(LD_A, mLD_explode);

        [mycentR(:,:,iSubject)] = cenTenDig_singlesub(RD_A, pRD_FPM);
        [mycentRMPM(:,:,iSubject) ] = cenTenDig_singlesub(RD_A, mRD_explode);

        %if mycent(:,:,iSubject) =
    end
    
    
    
    
    
%     for jj = 1:5
%         % we now need to subtract the centends of D1-D2, D1-D3 etc.
%         thisCentendL = mycentL(jj,:,iSubject);
%         thisCentendR = mycentR(jj,:,iSubject);
%         thisCentendL(jj)=[];
%         thisCentendR(jj)=[];
%         thisCentendL_mean = mean(thisCentendL);
%         thisCentendR_mean = mean(thisCentendR);
%         fomL(jj,iSubject) = mycentL(jj,jj,iSubject) - thisCentendL_mean;
%         fomR(jj,iSubject) = mycentR(jj,jj,iSubject) - thisCentendR_mean;
%         % do fom from dice
% %         thisDiceL = diceLD(jj,:,iSubject);
% %         thisDiceR = diceRD(jj,:,iSubject);
% %         thisDiceL(jj)=[];
% %         thisDiceR(jj)=[];
% %         thisDiceL_mean = mean(thisDiceL);
% %         thisDiceR_mean = mean(thisDiceR);
%     end
    
    fomL(:,iSubject) = fom_sim(mycentL(:,:,iSubject));
    fomR(:,iSubject) = fom_sim(mycentR(:,:,iSubject));


    
    % here we save out the maps in a group, so we can make the FPM and MPMs
    % later.
    LD_A_stack(:,:,iSubject) = LD_A;
    RD_A_stack(:,:,iSubject) = RD_A;
    
end
toc
%save touchmap_LR LD_A_stack RD_A_stack % this is the touchmap digit atlas
%% extra calculations

dmCT_LD = mycentL.*diceLD;
dmCT_RD = mycentR.*diceRD;

keyboard

%% CT
mapcol = brewermap(128,'*RdBu');
a = 0;
b = 2;
myempty = zeros(5,5);
figure('Position',[100 100 1600 1000])
tiledlayout(5,6)
for ii = 1:lenHC%1:length(subs) 
    buildMatL = [mycentL(:,:,ii); myempty];
    buildMatR = [myempty; mycentR(:,:,ii)];
    MatLR = [buildMatL,buildMatR];

    nexttile
    imagesc(MatLR)
    title(['Central Tendency ' sprintf(subs{ii},'%s')])
    colormap(mapcol)
    colorbar
    xticks(1:10)
    yticks(1:10)
    xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
    yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
    xtickangle(45)
    ytickangle(45)
    ax = gca;
    ax.FontSize = 10;
    set(gcf,'color', 'w');
    axis square
    clim([a b])

    clear buildMatL buildMatR MatLR
end
filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
    'HC_CT_z309_ALL');
print(filename,'-dpng')

figure('Position',[100 100 1600 1000])
tiledlayout(4,5)
for ii = 31:50 %:length(subs)
    buildMatL = [mycentL(:,:,ii); myempty];
    buildMatR = [myempty; mycentR(:,:,ii)];
    MatLR = [buildMatL,buildMatR];

    nexttile
    imagesc(MatLR)
    title(['Central Tendency ' sprintf(subs{ii},'%s')])
    colormap(mapcol)
    colorbar
    xticks(1:10)
    yticks(1:10)
    xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
    yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
    xtickangle(45)
    ytickangle(45)
    ax = gca;
    ax.FontSize = 10;
    set(gcf,'color', 'w');
    axis square
    clim([a b])

    clear buildMatL buildMatR MatLR
end
filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
    'PA_CT_z309_ALL');
print(filename,'-dpng')


%% DICE

mapcol = plasma;
a = 0;
b = 0.5;
myempty = zeros(5,5);
figure('Position',[100 100 1600 1000])
tiledlayout(5,6)
for ii = 1:lenHC%1:length(subs) 
    buildMatL = [diceLD(:,:,ii); myempty];
    buildMatR = [myempty; diceRD(:,:,ii)];
    MatLR = [buildMatL,buildMatR];

    nexttile
    imagesc(MatLR)
    title(['Dice Coefficient ' sprintf(subs{ii},'%s')])
    colormap(mapcol)
    colorbar
    xticks(1:10)
    yticks(1:10)
    xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
    yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
    xtickangle(45)
    ytickangle(45)
    ax = gca;
    ax.FontSize = 10;
    set(gcf,'color', 'w');
    axis square
    clim([a b])
    clear buildMatL buildMatR MatLR
end
filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
    'HC_DICE_z309_ALL');
print(filename,'-dpng')

figure('Position',[100 100 1600 1000])
tiledlayout(4,5)
for ii = 31:50%1:length(subs) 
    buildMatL = [diceLD(:,:,ii); myempty];
    buildMatR = [myempty; diceRD(:,:,ii)];
    MatLR = [buildMatL,buildMatR];

    nexttile
    imagesc(MatLR)
    title(['Dice Coefficient ' sprintf(subs{ii},'%s')])
    colormap(mapcol)
    colorbar
    xticks(1:10)
    yticks(1:10)
    xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
    yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
    xtickangle(45)
    ytickangle(45)
    ax = gca;
    ax.FontSize = 10;
    set(gcf,'color', 'w');
    axis square
    clim([a b])
    clear buildMatL buildMatR MatLR
end
filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
    'PA_DICE_z309_ALL');
print(filename,'-dpng')

%% what if we weighted the CT by dice = "dice * central tendency"
%close all
clc
% dmCT_LD = mycentL.*diceLD;
% dmCT_RD = mycentR.*diceRD;

%mapcol = brewermap(128,'*RdBu');
mapcol = brewermap(64,'*Blues');
%mapcol = RdBu;
a = 0;
b = 1;
myempty = zeros(5,5);
figure('Position',[100 100 1600 1000])
tiledlayout(5,6)
for ii = 1:30%1:length(subs) 
    buildMatL = [dmCT_LD(:,:,ii); myempty];
    buildMatR = [myempty; dmCT_RD(:,:,ii)];
    MatLR_dm = [buildMatL,buildMatR];

    nexttile
    imagesc(MatLR_dm)
    title(['Dice*Central Tendency ' sprintf(subs{ii},'%s')])
    colormap(mapcol)
    colorbar
    xticks(1:10)
    yticks(1:10)
    xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
    yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
    xtickangle(45)
    ytickangle(45)
    ax = gca;
    ax.FontSize = 10;
    set(gcf,'color', 'w');
    axis square
    clim([a b])
    clear buildMatL buildMatR MatLR_dm
end
filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
    'HC_dicemultct_z309_ALL');
print(filename,'-dpng')

figure('Position',[100 100 1600 1000])
tiledlayout(4,5)
for ii = 31:50%1:length(subs) 
    buildMatL = [dmCT_LD(:,:,ii); myempty];
    buildMatR = [myempty; dmCT_RD(:,:,ii)];
    MatLR_dm = [buildMatL,buildMatR];

    nexttile
    imagesc(MatLR_dm)
    title(['Dice*Central Tendency ' sprintf(subs{ii},'%s')])
    colormap(mapcol)
    colorbar
    xticks(1:10)
    yticks(1:10)
    xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
    yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
    xtickangle(45)
    ytickangle(45)
    ax = gca;
    ax.FontSize = 10;
    set(gcf,'color', 'w');
    axis square
    clim([a b])
    clear buildMatL buildMatR MatLR_dm
end
filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
    'PA_dicemultct_z309_ALL');
print(filename,'-dpng')

%% means and std
%mapcol = RdBu;
mapcol = brewermap(128,'*RdBu');

a = 0;
b = 2;
myempty = zeros(5,5);
figure('Position',[100 100 1600 600])

% mean cent LD
myHCsL = mycentL(:,:,1:lenHC);
myPAsL = mycentL(:,:,lenHC+1:end);
myHCsL_mean = mean(myHCsL,3);
myPAsL_mean = mean(myPAsL,3);
myHCsL_std = std(myHCsL,0,3);
myPAsL_std = std(myPAsL,0,3);
% mean cent RD
myHCsR = mycentR(:,:,1:lenHC);
myPAsR = mycentR(:,:,lenHC+1:end);
myHCsR_mean = mean(myHCsR,3);
myPAsR_mean = mean(myPAsR,3);
myHCsR_std = std(myHCsR,0,3);
myPAsR_std = std(myPAsR,0,3);
% mean dice*cent LD
myHCsL_dm = dmCT_LD(:,:,1:lenHC);
myPAsL_dm = dmCT_LD(:,:,lenHC+1:end);
myHCsL_dm_mean = mean(myHCsL_dm,3);
myPAsL_dm_mean = mean(myPAsL_dm,3);
myHCsL_dm_std = std(myHCsL_dm,0,3);
myPAsL_dm_std = std(myPAsL_dm,0,3);
% mean dice*cent RD
myHCsR_dm = dmCT_RD(:,:,1:lenHC);
myPAsR_dm = dmCT_RD(:,:,lenHC+1:end);
myHCsR_dm_mean = mean(myHCsR_dm,3);
myPAsR_dm_mean = mean(myPAsR_dm,3);
myHCsR_dm_std = std(myHCsR_dm,0,3);
myPAsR_dm_std = std(myPAsR_dm,0,3);
% mean dice LD
myHCsL_dice = diceLD(:,:,1:lenHC);
myPAsL_dice = diceLD(:,:,lenHC+1:end);
myHCsL_dice_mean = mean(myHCsL_dice,3);
myPAsL_dice_mean = mean(myPAsL_dice,3);
myHCsL_dice_std = std(myHCsL_dice,0,3);
myPAsL_dice_std = std(myPAsL_dice,0,3);
% mean dice RD
myHCsR_dice = diceRD(:,:,1:lenHC);
myPAsR_dice = diceRD(:,:,lenHC+1:end);
myHCsR_dice_mean = mean(myHCsR_dice,3);
myPAsR_dice_mean = mean(myPAsR_dice,3);
myHCsR_dice_std = std(myHCsR_dice,0,3);
myPAsR_dice_std = std(myPAsR_dice,0,3);

% build matrices
buildMatLhc = [myHCsL_mean; myempty];
buildMatRhc = [myempty; myHCsR_mean];
MatLRhc = [buildMatLhc,buildMatRhc];

buildMatLpa = [myPAsL_mean; myempty];
buildMatRpa = [myempty; myPAsR_mean];
MatLRpa = [buildMatLpa,buildMatRpa];

buildMatLhc_dm = [myHCsL_dm_mean; myempty];
buildMatRhc_dm = [myempty; myHCsR_dm_mean];
MatLRhc_dm = [buildMatLhc_dm,buildMatRhc_dm];

buildMatLpa_dm = [myPAsL_dm_mean; myempty];
buildMatRpa_dm = [myempty; myPAsR_dm_mean];
MatLRpa_dm = [buildMatLpa_dm,buildMatRpa_dm];

buildMatLhc_dice = [myHCsL_dice_mean; myempty];
buildMatRhc_dice = [myempty; myHCsR_dm_mean];
MatLRhc_dice = [buildMatLhc_dice,buildMatRhc_dice];

buildMatLpa_dice = [myPAsL_dice_mean; myempty];
buildMatRpa_dice = [myempty; myPAsR_dice_mean];
MatLRpa_dice = [buildMatLpa_dice,buildMatRpa_dice];

% build matrices std
buildMatLhc_std = [myHCsL_std; myempty];
buildMatRhc_std = [myempty; myHCsR_std];
MatLRhc_std = [buildMatLhc_std,buildMatRhc_std];

buildMatLpa_std = [myPAsL_std; myempty];
buildMatRpa_std = [myempty; myPAsR_std];
MatLRpa_std = [buildMatLpa_std,buildMatRpa_std];

buildMatLhc_dm_std = [myHCsL_dm_std; myempty];
buildMatRhc_dm_std = [myempty; myHCsR_dm_std];
MatLRhc_dm_std = [buildMatLhc_dm_std,buildMatRhc_dm_std];

buildMatLpa_dm_std = [myPAsL_dm_std; myempty];
buildMatRpa_dm_std = [myempty; myPAsR_dm_std];
MatLRpa_dm_std = [buildMatLpa_dm_std,buildMatRpa_dm_std];

buildMatLhc_dice_std = [myHCsL_dice_std; myempty];
buildMatRhc_dice_std = [myempty; myHCsR_dm_std];
MatLRhc_dice_std = [buildMatLhc_dice_std,buildMatRhc_dice_std];

buildMatLpa_dice_std = [myPAsL_dice_std; myempty];
buildMatRpa_dice_std = [myempty; myPAsR_dice_std];
MatLRpa_dice_std = [buildMatLpa_dice_std,buildMatRpa_dice_std];



tiledlayout(2,6)
nexttile
imagesc(MatLRhc)
title('CT mean HC')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])
nexttile
imagesc(MatLRpa)
title('CT mean PA')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])
nexttile
imagesc(MatLRhc_dice)
title('dice mean HC')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([0 0.5])
nexttile
imagesc(MatLRpa_dice)
title('dice mean PA')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([0 0.5])
nexttile
imagesc(MatLRhc_dm)
title('dice*CT mean HC')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a 1])
nexttile
imagesc(MatLRpa_dm)
title('dice*CT mean PA')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a 1])

nexttile
imagesc(MatLRhc_std)
title('CT std HC')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])
nexttile
imagesc(MatLRpa_std)
title('CT std PA')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])
nexttile
imagesc(MatLRhc_dice_std)
title('dice std HC')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])
nexttile
imagesc(MatLRpa_dice_std)
title('dice std PA')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])
nexttile
imagesc(MatLRhc_dm_std)
title('dice*CT std HC')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a 1])
nexttile
imagesc(MatLRpa_dm_std)
title('dice*CT std PA')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a 1])

%mappy = brewermap(64,'plasma');
mappy = 'plasma';

ax = nexttile(3);
colormap(ax,mappy);
colorbar(ax)
clim([0 0.5])

ax2 = nexttile(4);
colormap(ax2,mappy);
colorbar(ax2)
clim([0 0.5])

mappy2 = brewermap(64,'*Blues');

for axi = 5:12
    ax_temp = nexttile(axi);
    colormap(ax_temp,mappy2);
    colorbar(ax_temp)
    clim([0 1])
end

set(gcf,'color', 'w');

filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
    'group_means_ct_dice_dmct');
print(filename,'-dpng')


%% Investigate CT and different summaries other than FOM
% how often is a diagonal < 1?

thisthresh = 1;

thisempty = zeros(5,5,size(mycentL,3));
for ii = 1:size(mycentL,3)
    testcase = mycentL(:,:,ii);
    testdiag = diag(testcase);
    testdex = testdiag>thisthresh;
    thisempty(1,1,ii) = testdex(1);
    thisempty(2,2,ii) = testdex(2);
    thisempty(3,3,ii) = testdex(3);
    thisempty(4,4,ii) = testdex(4);
    thisempty(5,5,ii) = testdex(5);
end

sumempty_HCL = sum(thisempty(:,:,1:lenHC),3);
sumempty_PAL = sum(thisempty(:,:,lenHC+1:end),3);

thisempty = zeros(5,5,size(mycentR,3));
for ii = 1:size(mycentR,3)
    testcase = mycentR(:,:,ii);
    testdiag = diag(testcase);
    testdex = testdiag>thisthresh;
    thisempty(1,1,ii) = testdex(1);
    thisempty(2,2,ii) = testdex(2);
    thisempty(3,3,ii) = testdex(3);
    thisempty(4,4,ii) = testdex(4);
    thisempty(5,5,ii) = testdex(5);
end

sumempty_HCR = sum(thisempty(:,:,1:lenHC),3);
sumempty_PAR = sum(thisempty(:,:,lenHC+1:end),3);

myempty = zeros(5,5);
buildMatLhc_D = [sumempty_HCL; myempty];
buildMatRhc_D = [myempty; sumempty_HCR];
MatLRhc_D = [buildMatLhc_D,buildMatRhc_D];

buildMatLpa_D = [sumempty_PAL; myempty];
buildMatRpa_D = [myempty; sumempty_PAR];
MatLRpa_D = [buildMatLpa_D,buildMatRpa_D];

thismap =  spectral(30);
figure('Position',[100 100 1000 400])
tiledlayout(1,2)
nexttile
imagesc(MatLRhc_D)
colormap(thismap)
colorbar
clim([0 size(myHCsL,3)])
for jj = 1:10
    text(jj,jj,num2str(MatLRhc_D(jj,jj)))
end
title(['HC diagonals > ', num2str(thisthresh)])
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10; 
set(gcf,'color', 'w');
axis square

nexttile
imagesc(MatLRpa_D)
colormap(thismap)
colorbar
clim([0 size(myPAsL,3)])
for jj = 1:10
    text(jj,jj,num2str(MatLRpa_D(jj,jj)))
end
title(['PA diagonals > ', num2str(thisthresh)])
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square


a = ['cutoff_' num2str(thisthresh) '_diags'];
acl = [strrep(a,'.',''),'.png'];

filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
    acl);
print(filename,'-dpng')

%% What about off diagonals?
thismap = brewermap(128,'*RdBu');

for ii = 1:size(mycentL,3)
    testcase = mycentL(:,:,ii);
    col1 = [0; testcase(2:5,1)];
    col2 = [testcase(1,2); 0; testcase(3:5,2)];
    col3 = [testcase(1:2,3); 0; testcase(4:5,3)];
    col4 = [testcase(1:3,4); 0; testcase(5,4)];
    col5 = [testcase(1:4,5); 0];
    offDiagsL(:,:,ii) = [col1 col2 col3 col4 col5];
    soffDiagsL(ii) = sum(offDiagsL(:,:,ii),'all');
end
offDiags_HCL = mean(offDiagsL(:,:,1:lenHC),3);
offDiags_PAL = mean(offDiagsL(:,:,lenHC+1:end),3);

for ii = 1:size(mycentR,3)
    testcase = mycentR(:,:,ii);
    col1 = [0; testcase(2:5,1)];
    col2 = [testcase(1,2); 0; testcase(3:5,2)];
    col3 = [testcase(1:2,3); 0; testcase(4:5,3)];
    col4 = [testcase(1:3,4); 0; testcase(5,4)];
    col5 = [testcase(1:4,5); 0];
    offDiagsR(:,:,ii) = [col1 col2 col3 col4 col5];
    soffDiagsR(ii) = sum(offDiagsR(:,:,ii),'all');
end
offDiags_HCR = mean(offDiagsR(:,:,1:15),3);
offDiags_PAR = mean(offDiagsR(:,:,16:end),3);

myempty = zeros(5,5);
buildMatLhc_OD = [offDiags_HCL; myempty];
buildMatRhc_OD = [myempty; offDiags_HCR];
MatLRhc_OD = [buildMatLhc_OD,buildMatRhc_OD];

buildMatLpa_OD = [offDiags_PAL; myempty];
buildMatRpa_OD = [myempty; offDiags_PAR];
MatLRpa_OD = [buildMatLpa_OD,buildMatRpa_OD];

bb = 2;
figure
tiledlayout(1,2)
nexttile
imagesc(MatLRhc_OD)
colormap(thismap)
colorbar
clim([0 bb])
title('HC off diagonals mean')
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square

nexttile
imagesc(MatLRpa_OD)
colormap(thismap)
colorbar
clim([0 bb])
title('PA off diagonals mean')
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square


filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
    [sprintf(subs{1},'%s') '_offdiags']);
print(filename,'-dpng')

%% can we compare to the atlas?

newpath = ['/Users/' userName '/Documents/MATLAB/digitAtlas/sundries/'];
cd(newpath);
load('lv_surf_useful.mat');
mycentL_mean = mean(LD_central_tendency,3);
mycentR_mean = mean(RD_central_tendency,3);
mycentL_std = std(LD_central_tendency,0,3);
mycentR_std = std(RD_central_tendency,0,3);

buildMatL_atlas = [mycentL_mean; myempty];
buildMatR_atlas = [myempty; mycentR_mean];
MatLR_atlas = [buildMatL_atlas,buildMatR_atlas];

buildMatL_atlas = [mycentL_std; myempty];
buildMatR_atlas = [myempty; mycentR_std];
MatLR_atlas_std = [buildMatL_atlas,buildMatR_atlas];
% myHCsL_mean = mean(myHCsL,3);
% myPAsL_mean = mean(myPAsL,3);
% myHCsR = mycentR(:,:,1:15);
% myPAsR = mycentR(:,:,16:end);


Mat_hc_diff = MatLR_atlas - MatLRhc;
Mat_pa_diff = MatLR_atlas - MatLRpa;
Mat_hc_pa_diff = MatLRhc - MatLRpa;

group_minus_hc_std = Mat_hc_pa_diff - MatLRhc_std;
group_minus_pa_std = Mat_hc_pa_diff - MatLRpa_std;

hc_minus_atlas_std = Mat_hc_diff - MatLR_atlas_std;
pa_minus_atlas_std = Mat_pa_diff - MatLR_atlas_std;
%% compare diffs to std
thismap = brewermap(128,'*Spectral');
aa = -1;
bb = 1;
figure('Position',[100 100 1200 800])
tiledlayout(2,2)
nexttile;
imagesc(group_minus_hc_std)
colormap(thismap)
colorbar
clim([aa bb])
ax = gca;
ax.FontSize = 10;
axis square
title('group diff minus hc std')
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)

nexttile;
imagesc(group_minus_pa_std)
colormap(thismap)
colorbar
clim([aa bb])
ax = gca;
ax.FontSize = 10;
axis square
title('group diff minus pa std')
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)

nexttile;
imagesc(hc_minus_atlas_std)
colormap(thismap)
colorbar
clim([aa bb])
ax = gca;
ax.FontSize = 10;
axis square
title('hc minus atlas std')
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)

nexttile;
imagesc(pa_minus_atlas_std)
colormap(thismap)
colorbar
clim([aa bb])
ax = gca;
ax.FontSize = 10;
axis square
title('pa minus atlas std')
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)

filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
    'minus_stds');
print(filename,'-dpng')

%% plot the means and differences

thismap = brewermap(128,'*RdBu');

%thismap = RdBu;
bb = 2;
figure('Position',[100 100 1200 800])
tiledlayout(3,3)
nexttile;
imagesc(MatLR_atlas)
colormap(thismap)
colorbar
clim([0 bb])
ax = gca;
ax.FontSize = 10;
axis square
title('ATLAS LVO CT')
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)

nexttile
imagesc(MatLRhc)
colormap(thismap)
colorbar
clim([0 bb])
ax = gca;
ax.FontSize = 10;
axis square
title('Healthy CT')
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)

%mappy = brewermap(64,'*Spectral');
nexttile
imagesc(Mat_hc_diff)
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
axis square
title('Diff = ATLAS CT - Healthy CT')

nexttile;
imagesc(MatLR_atlas)
colormap(thismap)
colorbar
clim([0 bb])
ax = gca;
ax.FontSize = 10;
axis square
title('ATLAS LVO CT')
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)

nexttile
imagesc(MatLRpa)
colormap(thismap)
colorbar
clim([0 bb])
ax = gca;
ax.FontSize = 10;
axis square
title('Patient CT')
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)

%mappy = brewermap(64,'*Spectral');
nexttile
imagesc(Mat_pa_diff)
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax2 = gca;
ax2.FontSize = 10;
axis square
title('Diff = ATLAS CT - Patient CT')

nexttile;
imagesc(MatLRhc)
colormap(thismap)
colorbar
clim([0 bb])
ax = gca;
ax.FontSize = 10;
axis square
title('Healthy CT')
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)

nexttile
imagesc(MatLRpa)
colormap(thismap)
colorbar
clim([0 bb])
ax = gca;
ax.FontSize = 10;
axis square
title('Patient CT')
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)

mappy = brewermap(64,'*Spectral');
nexttile
imagesc(Mat_hc_pa_diff)
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax2 = gca;
ax2.FontSize = 10;
axis square
title('Diff = Healthy CT - Patient CT')




ax = nexttile(3);
colormap(ax,mappy);
colorbar(ax)
clim([-1 1])

ax2 = nexttile(6);
colormap(ax2,mappy);
colorbar(ax2)
clim([-1 1])
ax3 = nexttile(9);
colormap(ax3,mappy);
colorbar(ax3)
clim([-1 1])
set(gcf,'color', 'w');

filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
    [sprintf(subs{1},'%s') '_CT_diff_map']);
print(filename,'-dpng')



%% FOM

theFom = [fomL(:); fomR(:)];

digs = {'D1','D2','D3','D4','D5'};
digss = repmat(digs(:),length(theFom)./5,1);
% groupss = [repmat({'HC'},length(fomL).*5./3,1); repmat({'BTX'},length(fomL).*5./3,1); repmat({'NoBTX'},length(fomL).*5./3,1);...
%     repmat({'HC'},length(fomL).*5./3,1); repmat({'BTX'},length(fomL).*5./3,1); repmat({'NoBTX'},length(fomL).*5./3,1)];
theDom = [repmat({'LD'},length(fomL(:)),1); repmat({'RD'},length(fomR(:)),1)];

group = [repmat({'HC'},5*lenHC,1);  repmat({'PA'},5*lenPA,1)];
bothGroup = [group; group];

% means
theFom_meanAcrossDigs = [mean(fomL,1) mean(fomR,1)];
theFom_meanAcrossDigs = theFom_meanAcrossDigs(:);
pre_group_meanAcrossDigs = [repmat({'HC'},lenHC,1);  repmat({'PA'},lenPA,1)];
group_meanAcrossDigs = [pre_group_meanAcrossDigs; pre_group_meanAcrossDigs];
theDom_meanAcrossDigs = [repmat({'LD'},length(mean(fomL,1)),1); repmat({'RD'},length(mean(fomR,1)),1)];
subs_mean = [subs subs];

% compare wit typicality

fomL_mean = mean(fomL,1);
fomR_mean = mean(fomR,1);

pa_fomL = fomL_mean(16:30);
pa_fomR = fomR_mean(16:30);

pa_fomL_repaired = pa_fomL(LD_repaired);
pa_fomR_repaired = pa_fomR(RD_repaired);

pa_typ_L_repaired = typicality_s1_repaired(LD_repaired);
pa_typ_R_repaired = typicality_s1_repaired(RD_repaired);


% Afom = [pa_fomL_repaired pa_fomR_repaired];
% Atyp = [pa_typ_L_repaired pa_typ_R_repaired];

% figure, scatter(pa_fomL_repaired,pa_typ_L_repaired);
% figure, scatter(pa_fomR_repaired,pa_typ_R_repaired);

[Rl,Pl] = corrcoef(pa_fomL_repaired, pa_typ_L_repaired);
[Rr,Pr] = corrcoef(pa_fomR_repaired, pa_typ_R_repaired);

figure('Position',[100 100 800 400])
clear g
g(1,1) = gramm('x',pa_typ_L_repaired,'y',pa_fomL_repaired);
g(1,1).geom_point
g(1,1).stat_glm('geom','line','disp_fit',true)
g(1,1).set_title('LD')
g(1,2) = gramm('x',pa_typ_R_repaired,'y',pa_fomR_repaired);
g(1,2).geom_point
g(1,2).stat_glm('geom','line','disp_fit',true)
g(1,2).set_title('RD')
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',12)
g.axe_property('XLim',[0 1],'YLim',[0 1])
g.axe_property('XGrid','on','YGrid','on')
g.set_names('x','Typicality S1 repaired','y', 'Figure of merit S1 repaired')
g.draw()
filename = 'correlateplots';
g.export('file_name',filename, ...
    'export_path',...
    ['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'],...
    'file_type','pdf')



figure('Position',[100 100 800 700])
clear g
g = gramm('x',bothGroup,'y',theFom);
g.stat_boxplot2('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
%g.draw
%g.update('y',theFom,'color',digss)
%g.update('x',bothGroup,'y',theFom,'color',digss);
%g.geom_jitter('dodge',0.5)
g.set_names('x',[],'y', 'Figure of merit')
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',12)
% g.axe_property('XGrid','on','YGrid','on')
% g.axe_property('YLim',[mylim(1) mylim(2)])
g.draw
g.update('y',theFom,'color',digss)
g.geom_jitter('dodge',0.5)
g.draw()
filename = 'fom_kv_z309_all';
g.export('file_name',filename, ...
    'export_path',...
    ['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'],...
    'file_type','pdf')

figure('Position',[100 100 800 700])
clear g
g = gramm('x',group_meanAcrossDigs,'y',theFom_meanAcrossDigs);
g.stat_boxplot2('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
%g.draw
%g.update('y',theFom,'color',digss)
%g.update('x',bothGroup,'y',theFom,'color',digss);
%g.geom_jitter('dodge',0.5)
g.set_names('x',[],'y', 'Figure of merit')
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',12)
% g.axe_property('XGrid','on','YGrid','on')
%g.axe_property('YLim',[0 1])
g.draw
g.update('y',theFom_meanAcrossDigs,'color',theDom_meanAcrossDigs)
g.geom_jitter('dodge',0.5)
g.draw()
g.update('label',subs_mean)
g.geom_label();
g.draw()

filename = 'fom_kv_z309_all_mean';

g.export('file_name',filename, ...
    'export_path',...
    ['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'],...
    'file_type','pdf')


%% what if we try something individual

allsubs = repmat(subs,5,2);
allfom = [fomL fomR];
digs = transpose({'D1','D2','D3','D4','D5'});
alldigs = repmat(digs,1,length(allfom));
handL = transpose({'LD','LD','LD','LD','LD'});
handR = transpose({'RD','RD','RD','RD','RD'});
hands = [repmat(handL,1,length(fomL)) repmat(handR,1,length(fomR))];  
allsubs = allsubs(:);
allfom = allfom(:);
alldigs = alldigs(:);
allhands = hands(:);

close all
figure('Position',[100 100 1800 400])
clear g
g = gramm('x',allsubs,'y',allfom);
g.stat_boxplot2('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
g.set_names('x',[],'y', 'Figure of merit')
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',8)
g.draw()
g.update('y',allfom,'color',allhands)
g.geom_jitter('dodge',0.5)
g.draw()
filename = 'fom_allsubsdigsf';
g.export('file_name',filename, ...
    'export_path',...
    ['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'],...
    'file_type','pdf')


keyboard

%%

% 
% 
% nexttile
% imagesc(mycentL(:,:,ii))
% title(['CT LD ' sprintf(subs{ii},'%s')])
% colormap(mapcol)
% colorbar
% xticks(1:5)
% yticks(1:5)
% xticklabels({'LD1','LD2','LD3','LD4','LD5'});
% yticklabels({'LD1','LD2','LD3','LD4','LD5'});
% xtickangle(45)
% ytickangle(45)
% ax = gca;
% ax.FontSize = 10;
% set(gcf,'color', 'w');
% axis square
% clim([a b])
% 
% nexttile
% imagesc(mycentR(:,:,1))
% title(['CT RD ' sprintf(subs{1},'%s')])
% colormap(mapcol)
% colorbar
% xticks(1:5)
% yticks(1:5)
% xticklabels({'RD1','RD2','RD3','RD4','RD5'});
% yticklabels({'RD1','RD2','RD3','RD4','RD5'});
% xtickangle(45)
% ytickangle(45)
% ax = gca;
% ax.FontSize = 10;
% set(gcf,'color', 'w');
% axis square
% clim([a b])

% filename = fullfile('/Users/spmic/The University of Nottingham/Somatosensory - General/results/', ...
%     [sprintf(subs{1},'%s') '_CT']);
% filename = fullfile('/Users/ppzma/The University of Nottingham/Touch ReMap - General/results/', ...
%     [sprintf(subs{1},'%s') '_CT_z309_HV']);
% print(filename,'-dpng')


mapcol = inferno;
a = 0;
b = 0.4;
c = 1;
%figure('Position', [100 100 1000 1000])
figure
tiledlayout(1,2)
nexttile
imagesc(diceLD(:,:,1))
title(['DICE LD ' sprintf(subs{1},'%s')])
colormap(mapcol)
colorbar
xticks(1:5)
yticks(1:5)
xticklabels({'LD1','LD2','LD3','LD4','LD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])

nexttile
imagesc(diceRD(:,:,1))
title(['DICE RD ' sprintf(subs{1},'%s')])
colormap(mapcol)
colorbar
xticks(1:5)
yticks(1:5)
xticklabels({'RD1','RD2','RD3','RD4','RD5'});
yticklabels({'RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])

% filename = fullfile('/Users/spmic/The University of Nottingham/Somatosensory - General/results/', ...
%     [sprintf(subs{1},'%s') '_DICE']);

filename = fullfile('/Users/ppzma/The University of Nottingham/Touch ReMap - General/results/', ...
    [sprintf(subs{1},'%s') '_DICE_z309']);


print(filename,'-dpng')

%% quick FOM
theFom = [fomL(:); fomR(:)];
digs = {'D1','D2','D3','D4','D5'};
digss = repmat(digs(:),length(theFom)./5,1);
% groupss = [repmat({'HC'},length(fomL).*5./3,1); repmat({'BTX'},length(fomL).*5./3,1); repmat({'NoBTX'},length(fomL).*5./3,1);...
%     repmat({'HC'},length(fomL).*5./3,1); repmat({'BTX'},length(fomL).*5./3,1); repmat({'NoBTX'},length(fomL).*5./3,1)];
theDom = [repmat({'LD'},length(fomL),1); repmat({'RD'},length(fomL),1)];
figure
clear g
g = gramm('x',digss,'y',theFom);
g.stat_boxplot('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
g.draw
%g.update('y',theFom,'color',digss)
g.update('x',digss,'y',theFom,'color',theDom);
g.geom_jitter('dodge',0.5)
g.set_names('x',[],'y', 'Figure of merit')
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',12)
% g.axe_property('XGrid','on','YGrid','on')
% g.axe_property('YLim',[mylim(1) mylim(2)])
g.draw
filename = 'fom_kv_z309';
% g.export('file_name',filename, ...
%     'export_path',...
%     '/Users/spmic/The University of Nottingham/Somatosensory - General/results/',...
%     'file_type','pdf')

g.export('file_name',filename, ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Touch ReMap - General/results/',...
    'file_type','pdf')


keyboard

%%
% 
% nexttile
% imagesc(mycent(:,:,2))
% title('CT s021 LD')
% colormap(mapcol)
% colorbar
% xticks(1:5)
% yticks(1:5)
% xticklabels({'LD1','LD2','LD3','LD4','LD5'});
% yticklabels({'LD1','LD2','LD3','LD4','LD5'});
% xtickangle(45)
% ytickangle(45)
% ax = gca;
% ax.FontSize = 10;
% set(gcf,'color', 'w');
% axis square
% clim([a b])

% filename = fullfile('/Users/ppzma/The University of Nottingham/Touch ReMap - General/results/', ...
%     'centend_s014_s021');
% print(filename,'-dpng')

mapcol = inferno;
a = 0;
b = 0.5;

%figure('Position', [100 100 1000 1000])
figure
tiledlayout(1,2)
nexttile
imagesc(diceLD(:,:,1))
title('dice s014 LD')
colormap(mapcol)
colorbar
xticks(1:5)
yticks(1:5)
xticklabels({'LD1','LD2','LD3','LD4','LD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])
nexttile
imagesc(diceLD(:,:,2))
title('dice s021 LD')
colormap(mapcol)
colorbar
xticks(1:5)
yticks(1:5)
xticklabels({'LD1','LD2','LD3','LD4','LD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])

filename = fullfile('/Users/ppzma/The University of Nottingham/Touch ReMap - General/results/', ...
    'dice_s014_s021');
print(filename,'-dpng')




return


%% extra bit 
% look at means and STD of the central tendency

meanHCL = mean(mycent(:,:,1:nHC),3);
meanHCR = mean(mycentR(:,:,1:nHC),3);
meanBTXL = mean(mycent(:,:,nHC+1:nPA),3);
meanBTXR = mean(mycentR(:,:,nHC+1:nPA),3);
meanNoBTXL = mean(mycent(:,:,nPA:nPA+nPApre),3);
meanNoBTXR = mean(mycentR(:,:,nPA:nPA+nPApre),3);

stdHCL = std(mycent(:,:,1:nHC),0,3);
stdHCR = std(mycentR(:,:,1:nHC),0,3);
stdBTXL = std(mycent(:,:,nHC+1:nPA),0,3);
stdBTXR = std(mycentR(:,:,nHC+1:nPA),0,3);
stdNoBTXL = std(mycent(:,:,nPA:nPA+nPApre),0,3);
stdNoBTXR = std(mycentR(:,:,nPA:nPA+nPApre),0,3);
% 
% meanHCL_fom = mean(fomL(:,1:nHC),2);
% meanHCR_fom = mean(fomR(:,1:nHC),2);
% meanBTXL_fom = mean(fomL(:,nHC+1:nPA),2);
% meanBTXR_fom = mean(fomR(:,nHC+1:nPA),2);
% meanNoBTXL_fom = mean(fomL(:,nPA:nPA+nPApre),2);
% meanNoBTXR_fom = mean(fomR(:,nPA:nPA+nPApre),2);
% 
% stdHCL_fom = std(fomL(:,1:nHC),0,2);
% stdHCR_fom = std(fomR(:,1:nHC),0,2);
% stdBTXL_fom = std(fomL(:,nHC+1:nPA),0,2);
% stdBTXR_fom = std(fomR(:,nHC+1:nPA),0,2);
% stdNoBTXL_fom = std(fomL(:,nPA:nPA+nPApre),0,2);
% stdNoBTXR_fom = std(fomR(:,nPA:nPA+nPApre),0,2);

theFom = [fomL(:); fomR(:)];
digs = {'D1','D2','D3','D4','D5'};
% theFom = [meanHCL_fom; meanBTXL_fom; meanNoBTXL_fom;...
%     meanHCR_fom; meanBTXR_fom; meanNoBTXR_fom];
digss = repmat(digs(:),length(theFom)./5,1);
groupss = [repmat({'HC'},length(fomL).*5./3,1); repmat({'BTX'},length(fomL).*5./3,1); repmat({'NoBTX'},length(fomL).*5./3,1);...
    repmat({'HC'},length(fomL).*5./3,1); repmat({'BTX'},length(fomL).*5./3,1); repmat({'NoBTX'},length(fomL).*5./3,1)];
theDom = [repmat({'LD'},length(fomL).*5,1); repmat({'RD'},length(fomL).*5,1)];
figure
clear g
g = gramm('x',groupss,'y',theFom);
g.stat_boxplot('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
g.draw
g.update('y',theFom,'color',digss)
g.geom_jitter('dodge',0.5)
g.set_names('x',[],'y', 'Figure of merit')
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',12)
% g.axe_property('XGrid','on','YGrid','on')
% g.axe_property('YLim',[mylim(1) mylim(2)])
g.draw
filename = 'FOM_patients2atlas_box_digs';
g.export('file_name',filename, ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/',...
    'file_type','pdf')

myempty = zeros(5,5);
meanHC = [meanHCL, myempty; myempty, meanHCR];
stdHC = [stdHCL, myempty; myempty, stdHCR];
meanBTX = [meanBTXL, myempty; myempty, meanBTXR];
stdBTX = [stdBTXL, myempty; myempty, stdBTXR];
meanNoBTX = [meanNoBTXL, myempty; myempty, meanNoBTXR];
stdNoBTX = [stdNoBTXL, myempty; myempty, stdNoBTXR];


mapcol = viridis;
a = 0;
b = 1.5;
c = 1;
figure('Position', [100 100 1000 1000])
tiledlayout(3,2)
nexttile
imagesc(meanHC)
title('CT MEAN HC')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])
nexttile
imagesc(stdHC)
title('CT STD HC')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a c])
nexttile
imagesc(meanBTX)
title('CT MEAN BTX')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])
nexttile
imagesc(stdBTX)
title('CT STD BTX')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a c])
nexttile
imagesc(meanNoBTX)
title('CT MEAN NoBTX')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a b])
nexttile
imagesc(stdNoBTX)
title('CT STD NoBTX')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
clim([a c])
filename = fullfile('/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/', ...
    'centend_all');
print(filename,'-dpng')








%%


return


%% THE FOLLOWING IS FOR MORE SUBJECTS
%keyboard
disp('Got this far')


% disp(fomL);
% disp(fomR);

% recompose centend and dice
myempty = zeros(5,5,nPA+nHC);
mycent_z = cat(1,mycent,myempty);
mycentR_z = cat(1,myempty,mycentR);
my2cents = [mycent_z mycentR_z];

mycent_zMPM = cat(1,mycentMPM,myempty);
mycentR_zMPM = cat(1,myempty,mycentRMPM);
my2centsMPM = [mycent_zMPM mycentR_zMPM];


diceLD_z = cat(1,diceLD,myempty);
diceRD_z = cat(1,myempty,diceRD);
my2dice = [diceLD_z diceRD_z];

% better labels
mapcol = viridis;
mapcol2 = inferno;

mylow = 0;
myhigh = 1.5;
myhighm = 1.5;
myhigh2 = 0.5;
%myhigh2 = 1;
if verbose
    %% plot central tendency!
    figure('Position', [100 100 2000 200])
    for iSubject = 1:nHC
        subplot(1,nHC,iSubject)
        imagesc(my2cents(:,:,iSubject))
        title(['CT ' subs{iSubject}])
        colormap(mapcol)
        colorbar
        xticks(1:10)
        yticks(1:10)
        xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
        yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
        xtickangle(45)
        ytickangle(45)
        ax = gca;
        ax.FontSize = 10;
        axis square
        caxis([mylow myhigh])
    end
    set(gcf,'color', 'w');
    
    if shallisave
        filename = fullfile('/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/', ...
            'centendhc');
        print(filename,'-dpng')
    end
    
    
    figure('Position', [100 100 2000 400])
    %for iSubject = nPA:length(subs)
    for iSubject = 1:nPA
        subplot(2,7,iSubject)
        imagesc(my2cents(:,:,iSubject+nHC))
        title(['CT ' subs{iSubject+nHC}])
        colormap(mapcol)
        colorbar
        xticks(1:10)
        yticks(1:10)
        xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
        yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
        xtickangle(45)
        ytickangle(45)
        ax = gca;
        ax.FontSize = 10;
        axis square
        caxis([mylow myhigh])
    end
    set(gcf,'color', 'w');
    
    
    if shallisave
        filename = fullfile('/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/', ...
            'centendPA');
        print(filename,'-dpng')
    end
    
    %% CENTEND TO MPM
    figure('Position', [100 100 2000 200])
    for iSubject = 1:nHC
        subplot(1,nHC,iSubject)
        imagesc(my2centsMPM(:,:,iSubject))
        title(['MPMCT ' subs{iSubject}])
        colormap(mapcol)
        colorbar
        xticks(1:10)
        yticks(1:10)
        xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
        yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
        xtickangle(45)
        ytickangle(45)
        ax = gca;
        ax.FontSize = 10;
        axis square
        caxis([mylow myhighm])
    end
    set(gcf,'color', 'w');
    
    if shallisave
        filename = fullfile('/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/', ...
            'centendhcMPM');
        print(filename,'-dpng')
    end
    
    
    figure('Position', [100 100 2000 400])
    %for iSubject = nPA:length(subs)
    for iSubject = 1:nPA
        subplot(2,7,iSubject)
        imagesc(my2centsMPM(:,:,iSubject+nHC))
        title(['MPMCT ' subs{iSubject+nHC}])
        colormap(mapcol)
        colorbar
        xticks(1:10)
        yticks(1:10)
        xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
        yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
        xtickangle(45)
        ytickangle(45)
        ax = gca;
        ax.FontSize = 10;
        axis square
        caxis([mylow myhighm])
    end
    set(gcf,'color', 'w');
    
    
    if shallisave
        filename = fullfile('/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/', ...
            'centendPAMPM');
        print(filename,'-dpng')
    end
    
    
    
    %% plot DICE
    
    figure('Position', [100 100 2000 200])
    for iSubject = 1:nHC
        subplot(1,nHC,iSubject)
        imagesc(my2dice(:,:,iSubject))
        title(['Dice ' subs{iSubject}])
        colormap(mapcol2)
        colorbar
        xticks(1:10)
        yticks(1:10)
        xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
        yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
        xtickangle(45)
        ytickangle(45)
        ax = gca;
        ax.FontSize = 10;
        axis square
        caxis([mylow myhigh2])
    end
    set(gcf,'color', 'w');
    
    if shallisave
        filename = fullfile('/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/', ...
            'DiceHC');
        print(filename,'-dpng')
    end
    
    
    figure('Position', [100 100 2000 400])
    %for iSubject = nPA:length(subs)
    for iSubject = 1:nPA
        subplot(2,7,iSubject)
        imagesc(my2dice(:,:,iSubject+nHC))
        title(['Dice ' subs{iSubject+nHC}])
        colormap(mapcol2)
        colorbar
        xticks(1:10)
        yticks(1:10)
        xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
        yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
        xtickangle(45)
        ytickangle(45)
        ax = gca;
        ax.FontSize = 10;
        axis square
        caxis([mylow myhigh2])
    end
    set(gcf,'color', 'w');
    
    
    if shallisave
        filename = fullfile('/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/', ...
            'DicePA');
        print(filename,'-dpng')
    end
    
    
    
    
    
end

%% try split by group

cHC = mean(my2cents(:,:,1:7),3);
cPost = mean(my2cents(:,:,8:14),3);
cPre = mean(my2cents(:,:,15:end),3);

dHC = mean(my2dice(:,:,1:7),3);
dPost = mean(my2dice(:,:,8:14),3);
dPre = mean(my2dice(:,:,15:end),3);

mapcol = viridis;
a = 0;
b = 1.5;
%c = 0.35;
figure('Position', [100 100 1000 400])
subplot(1,3,1)
imagesc(cHC)
title('CT HC')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
caxis([a b])

subplot(1,3,2)
imagesc(cPost)
title('CT Post')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
caxis([a b])

subplot(1,3,3)
imagesc(cPre)
title('CT Pre')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
caxis([a b])

if shallisave
    filename = fullfile('/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/', ...
        'CTmean');
    print(filename,'-dpng')
end

%% MPM

cHC = mean(my2centsMPM(:,:,1:7),3);
cPost = mean(my2centsMPM(:,:,8:14),3);
cPre = mean(my2centsMPM(:,:,15:end),3);

mapcol = viridis;
a = 0;
b = 1.5;
c = 0.35;
figure('Position', [100 100 1000 400])
subplot(1,3,1)
imagesc(cHC)
title('CT HC')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
caxis([a b])

subplot(1,3,2)
imagesc(cPost)
title('CT Post')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
caxis([a b])

subplot(1,3,3)
imagesc(cPre)
title('CT Pre')
colormap(mapcol)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
caxis([a b])

if shallisave
    filename = fullfile('/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/', ...
        'CTmeanMPM');
    print(filename,'-dpng')
end


%% dice mean
figure('Position', [100 100 1000 400])
subplot(1,3,1)
imagesc(dHC)
mapcol2 = inferno;
title('dice HC')
colormap(mapcol2)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
caxis([a c])

subplot(1,3,2)
imagesc(dPost)
title('dice Post')
colormap(mapcol2)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
caxis([a c])

subplot(1,3,3)
imagesc(dPre)
title('dice Pre')
colormap(mapcol2)
colorbar
xticks(1:10)
yticks(1:10)
xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
xtickangle(45)
ytickangle(45)
ax = gca;
ax.FontSize = 10;
set(gcf,'color', 'w');
axis square
caxis([a c])

if shallisave
    filename = fullfile('/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/', ...
        'dice_mean');
    print(filename,'-dpng')
end


%% graph to compare FOM

% group by dominance
% uncomment this for hc and post patients
whichDom1 = [repmat({'Dominant'},5,1); repmat({'Non-Dominant'},5,1); repmat({'Dominant'},25,1)];
whichDom2 = [repmat({'Non-Dominant'},5,1); repmat({'Dominant'},5,1); repmat({'Non-Dominant'},25,1)];
whichPA_dominance = [whichDom2; whichDom1];

% uncomment this for pre patients
% whichDom1 = repmat({'Dominant'},5,1);
% whichDom2 = repmat({'Non-Dominant'},5,1);
% whichPA_dominance = [whichDom1; whichDom2];

% 7 HCs so far
whichDom3 = [repmat({'Dominant'},15,1); repmat({'Non-Dominant'},5,1); repmat({'Dominant'},5,1); repmat({'Non-Dominant'},5,1);repmat({'Dominant'},5,1) ];
whichDom4 = [repmat({'Non-Dominant'},15,1); repmat({'Dominant'},5,1); repmat({'Non-Dominant'},5,1); repmat({'Dominant'},5,1); repmat({'Non-Dominant'},5,1)];
whichHC_dominance = [whichDom4; whichDom3];

% whichDom3 = repmat({'Dominant'},5,1);
% whichDom4 = repmat({'Non-Dominant'},5,1);
% whichHC_dominance = [whichDom3; whichDom4];

% split by patient group
FOM_HC = [fomL(:,1:nHC) fomR(:,1:nHC)];
% FOM_PA = [fomL(:,nPA+1:end) fomR(:,nPA+1:end)]; % dodgy fix for comparing pre and post
FOM_PA = [fomL(:,nHC+1:end-nPApre) fomR(:,nHC+1:end-nPApre)];
FOM_PApre = [fomL(:,end-nPApre+1:end) fomR(:,end-nPApre+1:end)];




%FOM = [FOM_HC(:); FOM_PA(:)];
whichDig = repmat({'D1', 'D2', 'D3', 'D4', 'D5'}', size(FOM_HC,2), 1);
whichDigp = repmat({'D1', 'D2', 'D3', 'D4', 'D5'}', size(FOM_PA,2), 1);
whichDigpre = repmat({'D1', 'D2', 'D3', 'D4', 'D5'}', size(FOM_PApre,2), 1);

id = find(FOM_PA==0);
FOM_PA = FOM_PA(:);
FOM_PA(id)=[];
whichDigp(id)=[];
whichPA_dominance(id)=[];
%FOM = [fomL(:); fomR(:)];
%theDOM = [whichNDom; whichDom];
%id = find(FOM==0);
%FOM(id)=[];
%theDOM(id)=[]; % remove amputee
%whichDIG = [whichDig; whichDig];
%whichDIG(id)=[];



whichPApre_dominance = [repmat({'Non-Dominant'},30,1); repmat({'Dominant'},30,1)];

% need to split patients and controls though
if exist('g','var'); clear g; end
figure('Position', [100, 100, 1400,600])
g(1,1)=gramm('x', whichHC_dominance, 'y', FOM_HC(:), 'color', whichDig);
g(1,1).geom_jitter('alpha',0.8)
%g(1,1).stat_boxplot()%'notch','true')
g(1,1).set_title('HC')
g(1,1).set_names('x', 'Group', 'y', 'FIGURE OF MERIT ', 'color', 'Digit')
g(1,1).set_text_options('font', 'Menlo', 'base_size', 16)
g(1,1).set_point_options('markers', {'o'} ,'base_size',15)
g(1,1).axe_property('YLim', [-1 1])

g(1,2)=gramm('x', whichPA_dominance, 'y', FOM_PA, 'color', whichDigp);
g(1,2).geom_jitter('alpha',0.8)
%g(1,2).stat_boxplot()%'notch','true')
g(1,2).set_title('PA post')
g(1,2).set_names('x', 'Group', 'y', 'FIGURE OF MERIT ', 'color', 'Digit')
g(1,2).set_text_options('font', 'Menlo', 'base_size', 16)
g(1,2).set_point_options('markers', {'o'} ,'base_size',15)
g(1,2).axe_property('YLim', [-1 1])


g(1,3)=gramm('x', whichPApre_dominance, 'y', FOM_PApre(:), 'color', whichDigpre);
g(1,3).geom_jitter('alpha',0.8)
%g(1,3).stat_boxplot()%'notch','true')
g(1,3).set_title('PA pre')
g(1,3).set_names('x', 'Group', 'y', 'FIGURE OF MERIT ', 'color', 'Digit')
g(1,3).set_text_options('font', 'Menlo', 'base_size', 16)
g(1,3).set_point_options('markers', {'o'} ,'base_size',15)
g(1,3).axe_property('YLim', [-1 1])

g.draw()

if shallisave
    %     g.export('file_name','FOM_patients2atlas_box', ...
    %         'export_path','/Users/ppzma/Google Drive/PhD/latex/affinity/PA2ATLAS_2mm' ,'file_type','pdf')
    %
    filename = 'FOM_patients2atlas_box';
    g.export('file_name',filename, ...
        'export_path',...
        '/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/',...
        'file_type','pdf')
    
    
    
end



%% here, try linking the FOM between post and pre

% first grab dominance indices
tmp = zeros(numel(whichHC_dominance),1);
for ii = 1:numel(whichHC_dominance)
    if strcmpi('Dominant',whichHC_dominance(ii))
        tmp(ii) = 1;
    elseif strcmpi('Non-Dominant',whichHC_dominance(ii))
        tmp(ii) = 2;
    end
end
idxHC = tmp;

tmp = zeros(numel(whichPA_dominance),1);
for ii = 1:numel(whichPA_dominance)
    if strcmpi('Dominant',whichPA_dominance(ii))
        tmp(ii) = 1;
    elseif strcmpi('Non-Dominant',whichPA_dominance(ii))
        tmp(ii) = 2;
    end
end
idxPA = tmp;


tmp = zeros(numel(whichPApre_dominance),1);
for ii = 1:numel(whichPApre_dominance)
    if strcmpi('Dominant',whichPApre_dominance(ii))
        tmp(ii) = 1;
    elseif strcmpi('Non-Dominant',whichPApre_dominance(ii))
        tmp(ii) = 2;
    end
end
idxPAP = tmp;

FOM_HC = FOM_HC(:);
FOM_PAP = FOM_PApre(:);

% now split by dominance
FOM_HC_dom = FOM_HC(idxHC==1);
FOM_PA_dom = FOM_PA(idxPA==1);
FOM_PAP_dom = FOM_PAP(idxPAP==1);
FOM_HC_ndom = FOM_HC(idxHC==2);
FOM_PA_ndom = FOM_PA(idxPA==2);
FOM_PAP_ndom = FOM_PAP(idxPAP==2);

% now stack by dominance for gramm
FOM_dom = [FOM_HC_dom; FOM_PA_dom; FOM_PAP_dom];
FOM_ndom = [FOM_HC_ndom; FOM_PA_ndom; FOM_PAP_ndom];

% grouping var by patient group
domgroup = [repmat({'Healthy Controls'},[size(FOM_HC_dom),1]); repmat({'Patients post'},[size(FOM_PA_dom),1]); repmat({'Patients pre'},[size(FOM_PAP_dom),1]) ];
ndomgroup = [repmat({'Healthy Controls'},[size(FOM_HC_ndom),1]); repmat({'Patients post'},[size(FOM_PA_ndom),1]); repmat({'Patients pre'},[size(FOM_PAP_ndom),1]) ];

% need to calculate median manually - you'll see why in a sec
median_domgroup = [repmat(median(FOM_HC_dom),[size(FOM_HC_dom),1]); repmat(median(FOM_PA_dom),[size(FOM_PA_dom),1]); repmat(median(FOM_PAP_dom),[size(FOM_PAP_dom),1]) ];
median_ndomgroup = [repmat(median(FOM_HC_ndom),[size(FOM_HC_ndom),1]); repmat(median(FOM_PA_ndom),[size(FOM_PA_ndom),1]); repmat(median(FOM_PAP_ndom),[size(FOM_PAP_ndom),1]) ];

%color by digits
mydigcolor = repmat({'D1','D2','D3','D4','D5'},1,length(FOM_dom)./5);
mydigcolor2 = repmat({'D1','D2','D3','D4','D5'},1,length(FOM_ndom)./5);

mydigcolor = mydigcolor(:);
mydigcolor2 = mydigcolor2(:);

% now plot
if exist('g','var'); clear g; end
figure('Position', [100, 100, 1400,1000])
g(1,1) = gramm('x', domgroup, 'y', FOM_dom);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'drawoutlier',0,'width',0.5)
g(1,1).set_title('Figure of merit (central tendency): Dominant')
g(1,1).set_names('x', 'Group', 'y', 'FIGURE OF MERIT ')
g(1,1).set_text_options('font', 'Menlo', 'base_size', 12)
g(2,1) = gramm('x', ndomgroup, 'y', FOM_ndom);
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'drawoutlier',0,'width',0.5)
g(2,1).set_title('Figure of merit (central tendency): Non-Dominant')
g(2,1).set_names('x', 'Group', 'y', 'FIGURE OF MERIT ')
g(2,1).set_text_options('font', 'Menlo', 'base_size', 12)
g.draw()

% g(1,1).update('y',FOM_dom);
% g(1,1).geom_jitter('alpha',0.8,'width',0.3);
% g(1,1).set_point_options('markers',{'o'}, 'base_size',12);
% g(2,1).update('y',FOM_ndom);
% g(2,1).geom_jitter('alpha',0.8,'width',0.3);
% g(2,1).set_point_options('markers',{'o'}, 'base_size',12);
% g.draw()

%colour by digits
mycmapX = digits(5);

%g(1,1).update('color', whichDig);
g(1,1).update('color',mydigcolor);
g(1,1).geom_jitter('alpha',0.8,'width',0.3);
g(1,1).set_point_options('markers',{'o'}, 'base_size',12);
g(1,1).set_color_options('map', mycmapX);
g(2,1).update('color',mydigcolor2);
g(2,1).geom_jitter('alpha',0.8,'width',0.3);
g(2,1).set_point_options('markers',{'o'}, 'base_size',12);
g(2,1).set_color_options('map', mycmapX);
g.draw()


% g(1,1).update('y',median_domgroup);
% g(1,1).geom_line();
% g(1,1).no_legend()
% g(2,1).update('y',median_ndomgroup);
% g(2,1).geom_line();
% g(2,1).no_legend()
% g.draw()


if shallisave
    %     g.export('file_name','FOM_patients2atlas_box', ...
    %         'export_path','/Users/ppzma/Google Drive/PhD/latex/affinity/PA2ATLAS_2mm' ,'file_type','pdf')
    %
    %
    filename = 'FOM_patients2atlas_box2';
    g.export('file_name',filename, ...
        'export_path',...
        '/Users/ppzma/The University of Nottingham/Michael_Sue - Touchmap - Touchmap/results/',...
        'file_type','pdf')
    
    
end

% Anova

[P,ANOVATAB,STATS] = anova1(FOM_dom,domgroup)
COMPARISON = multcompare(STATS)
[P2,ANOVATAB2,STATS2] = anova1(FOM_ndom,ndomgroup)
COMPARISON2 = multcompare(STATS2)

%% try corr
% xHC = 7;
% xPost = 6;
% xPre = 6;
return
fom2dom(FOM_HC_dom, FOM_PA_dom, FOM_PAP_dom,FOM_HC_ndom, FOM_PA_ndom, FOM_PAP_ndom, mycent, mycentR);







end

