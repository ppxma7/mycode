% try painting caitlin's digits
subdir='/Applications/freesurfer/subjects/';
setenv('SUBJECTS_DIR',subdir);

hemisphere = 'r';
surface = 'inflated'; % or sphere!
subject = 'fsaverage';

%mypath = '/Volumes/nemosine/caitlintest/subject_digits/';
mypath = '/Volumes/ares/PFS/7T/digitatlas/';

map = 'hsv';
nchips = 256;
mymin = 0.5;
% mysub = {'Post01','Post02','Post03','Post04','Post05','Post06','Post07','Post08',...
%     'Post09','Post10','Post11','Post12','Post13','Post14','Post15','Post18','Post19','Post20',...
%     'Post21',...
%     'Pre01','Pre02','Pre03','Pre04','Pre05','Pre06','Pre07','Pre08','Pre09','Pre10','Pre11',...
%     'Pre12','Pre13','Pre14','Pre15','Pre17','Pre18','Pre19','Pre20','Pre21'};

mysub = {'PFS'};

myalpha = 1;

cd(mypath)
whichDigit = 1;

for iSub = 1:length(mysub)
    %cd([mypath mysub{iSub} '_RD'])
    fnameRD = [mysub{iSub} '_LD.mgh'];
    %fnameRDco = 'co_RD_masked_fsaverage.mgh';
    overlay = MRIread(fnameRD);
    
    %keyboard
    
    
    mytmp = overlay.vol;
    %tiledlayout(4,5)
    
    figure
    thisDigit = mytmp(:,whichDigit);
    %D4 = mytmp(:,4);
    go_paint_freesurfer(thisDigit,'fsaverage','l','range',[mymin max(thisDigit)])
    
    
%     for ii = 1:5
%         figure
%         %nexttile
%         thisDigit = mytmp(:,ii);
%         %D4 = mytmp(:,4);
%         go_paint_freesurfer(thisDigit,'fsaverage','l','range',[mymin max(thisDigit)])
%         
%     end
    
    
    
    % mask?
%     mytmp = mytmp(:);
%     coidx = 0.4;
%     coverlay = MRIread(fnameRDco);
%     coverlay_vec = coverlay.vol;
%     coverlay_vec = coverlay_vec(:);
%     coverlay_vec_thresh = coverlay_vec>coidx;
    
    %mytmp = mytmp .* coverlay_vec_thresh; % threshold phase by coherence
    
%     for ii = 1:5
%         %    fnameL = ['PCorrelation_index_RD' sprintf('%d',iDigit) '.mgh'];
%         %fnameL = ['PCorrelation_index_RD.mgh'];
%         fnameDig = ['RD' num2str(ii) '_fsaverage.mgh'];
%         overlayDig = MRIread(fnameDig);
%         mytmpDig = overlayDig.vol;
%         mytmpDig = mytmpDig(:);
%         
%         thisDigit = mytmpDig .* mytmp;
%         
%         %         fnameL = ['RD' sprintf('%d',iDigit) '_' mysub{iSub} '.mgh'];
%         %         %fnameR = ['LD' sprintf('%d',iDigit) '_' mysub{iSub} '.mgh'];
%         %         %[overlayR] = MRIread(fnameR);
%         %         overlay = MRIread(fnameL);
%         
%         %mytmp(:,iDigit) = overlay.vol;
%         %         mytmp(:) = overlay.vol;
%         
%         % mask?
%         %         mytmp = mytmp(:);
%         %         mytmp = mytmp .* pRD_FPM(:,iDigit);
%         %         mytmp = logical(mytmp);
%         %
%         figure
%         go_paint_freesurfer(thisDigit,'fsaverage','l','range',[mymin max(thisDigit)], 'cbar','colormap','hsv')
%     end
end

