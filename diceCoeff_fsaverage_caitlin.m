% try doing dice of patients in fsaverage space




subdir = '/Volumes/nemosine/caitlintest/subject_digits/';

%cd(subdir)


subs={'Pre01' 'Pre02' 'Pre03' 'Pre04' 'Pre05' 'Pre06' 'Pre07' 'Pre08' 'Pre09' 'Pre10' 'Pre11' 'Pre12' 'Pre13' 'Pre14' 'Pre15'...
    'Pre17' 'Pre18' 'Pre19' 'Pre20' 'Pre21' 'Post01' 'Post02' 'Post03' 'Post04' 'Post05' 'Post06' 'Post07' 'Post08' 'Post09' 'Post10'...
    'Post11' 'Post12' 'Post13' 'Post14' 'Post15' 'Post18' 'Post19' 'Post20' 'Post21'};
%PreM1subs={};
%PreVtxsubs={};
%PostM1subs={};
%PostVtxsubs={};
%subs = {'13695', '13695_pre'};
nPre = 20;
nPost = 19;

%disp('Calculating Dice to the MPM, centend to the FPM and FOM between patient digits and the atlas')
%tic
for iSubject = 1:length(subs)
    
    RD_A = MRIread([subdir subs{iSubject} '_' 'RD' '.mgh']);
    %LD_A = MRIread([subdir subs{iSubject} '_' 'LD' '.mgh']);
    %RD_A = MRIread([subjects{iSubject} '_' 'RD' '.mgh']);
    %LD_A = MRIread([subjects{iSubject} '_' 'LD' '.mgh']);
    %if isempty(RD_A), RD_A = zeros(size(LD_A.vol,1),5); else RD_A = RD_A.vol; end
    RD_A = RD_A.vol;
    %LD_A = LD_A.vol;
    
    %eachSubL(:,:,iSubject) = LD_A;
    eachSubR(:,:,iSubject) = RD_A;
   
end

%%
%Pre PreVtx PreM1 PostVtx PostM1
PreAll = eachSubR(:,:,1:20);
PreAllmean = mean(PreAll,3);
PostAll = eachSubR(:,:,21:39);
PostAllmean = mean(PostAll,3);

PreVtx = eachSubR(:,:,[5:7,10,14,16:17,19:20]); %PreVtx subjects: 5:7, 10, 14, 16:17, 19:20
PreVtxmean = mean(PreVtx,3);
PostVtx = eachSubR(:,:,[25:27,30,34,36,38:39]); %PostVtx subjects: 25:27, 30, 34, 36, 38:39 
PostVtxmean = mean(PostVtx,3);

PreM1 = eachSubR(:,:,[1:4,8:9,11:13,15,18]);  %PreM1 subjects: 1:4, 8:9, 11:13, 15, 18
PreM1mean = mean(PreM1,3);
PostM1 = eachSubR(:,:,[21:24,28:29,31:33,35,37]); %PostM1 subjects: 21:24, 28:29, 31:33, 35, 37
PostM1mean = mean(PostM1,3);

% logical these because after mean not binary
% but hten we're just doing an overlap in fsaverage spae

PreAllmean = logical(PreAllmean);
PostAllmean = logical(PostAllmean);
PreVtxmean = logical(PreVtxmean);
PostVtxmean = logical(PostVtxmean);
PreM1mean = logical(PreM1mean);
PostM1mean = logical(PostM1mean);

% so for BTX R vs NoBTX R

for ii = 1:5
    for jj = 1:5
        PostVtxvPostM1(jj,ii) = dice(PostVtxmean(:,jj),PostM1mean(:,ii));
        PreVtxvPreM1(jj,ii) = dice(PreVtxmean(:,jj),PreM1mean(:,ii));
        
        PreAllvPostAll(jj,ii) = dice(PreAllmean(:,jj),PostAllmean(:,ii));
        
        PreM1vPostM1(jj,ii) = dice(PreM1mean(:,jj),PostM1mean(:,ii));
        PreVtxvPostVtx(jj,ii) = dice(PreVtxmean(:,jj),PostVtxmean(:,ii));
        
        
        %BTXvBTX_LR(jj,ii) = dice(BTXLmean(:,jj),BTXRmean(:,ii));
        %NoBTXvNoBTX_LR(jj,ii) = dice(NoBTXLmean(:,jj),NoBTXRmean(:,ii));
        %HCvBTX_R(jj,ii) = dice(PostAllmean(:,jj),PostVtxmean(:,ii));
        %HCvNoBTX_L(jj,ii) = dice(PreAllmean(:,jj),PreM1mean(:,ii));
        %HCvNoBTX_R(jj,ii) = dice(PostAllmean(:,jj),PostM1mean(:,ii));

    end
end
a = 0;
b = 1;

figure('Position',[100 100 600 800])
tiledlayout(3,2)
nexttile
imagesc(PreVtxvPreM1)
xlabel('PreVtx')
ylabel('PreM1')
title('PreVtx vs PreM1')
colormap(jet)
colorbar
caxis([a b])
xticks(1:5)
yticks(1:5)
yticklabels({'D1','D2','D3','D4','D5'});
xticklabels({'D1','D2','D3','D4','D5'});
axis square

nexttile
imagesc(PostVtxvPostM1)
xlabel('PostVtx')
ylabel('PostM1')
title('PostVtx vs PostM1')
colormap(jet)
colorbar
caxis([a b])
xticks(1:5)
yticks(1:5)
yticklabels({'D1','D2','D3','D4','D5'});
xticklabels({'D1','D2','D3','D4','D5'});
axis square

nexttile
imagesc(PreAllvPostAll)
xlabel('PreAll')
ylabel('PostAll')
title('PreAll vs PostAll')
colormap(jet)
colorbar
caxis([a b])
xticks(1:5)
yticks(1:5)
yticklabels({'D1','D2','D3','D4','D5'});
xticklabels({'D1','D2','D3','D4','D5'});
axis square

nexttile
imagesc(PreM1vPostM1)
xlabel('PreM1')
ylabel('PostM1')
title('PreM1 vs PostM1')
colormap(jet)
colorbar
caxis([a b])
xticks(1:5)
yticks(1:5)
yticklabels({'D1','D2','D3','D4','D5'});
xticklabels({'D1','D2','D3','D4','D5'});
axis square

nexttile
imagesc(PreVtxvPostVtx)
xlabel('PreVtx')
ylabel('PostVtx')
title('PreVtx vs PostVtx')
colormap(jet)
colorbar
caxis([a b])
xticks(1:5)
yticks(1:5)
yticklabels({'D1','D2','D3','D4','D5'});
xticklabels({'D1','D2','D3','D4','D5'});
axis square
% 
% filename = fullfile('/Users/caitlinsmith/freesurfer/subjects/-mapping/subject_digits/Dice/', ...
%     'dice_fsaveragespace');
% 
% print(filename,'-dpng')








