function [  ] = compare2atlas_motor_caitlin(shallisave, verbose)
%compare2atlas - compare patient/subject digit to atlas digit
%
% [ma] feb2019
%
% run loadAtlas_George.m first to get digitatlas as .mat file
%
% try loading and comparing
% THIS IS USED WHEN IN FSAVERAGE SPACE
% See Also loadAtlas_George.m
%
% [ma] july 2019
% converted to motor version - one hand so shorter code

mapcol = viridis;
mapcol2 = plasma;

if nargin<2
    shallisave=1;
    verbose = 1;
elseif nargin < 1
    verbose = [];
end

%load('/Volumes/ares/nemosine/DigitAtlasv2/digatlas_oct19.mat') %load the 21 subject atlas
load('/Volumes/nemosine/digatlas_github.mat');
%%subdir = '/Volumes/ares/nemosine/DigitAtlasv2/patients_motordigits/';
subdir = '/Volumes/nemosine/caitlintest/subject_digits/';

cd(subdir)
%subdir = '/Volumes/data/Research/TOUCHMAP/digitAtlas_2019/digitmap/maps_mni/surf/';
% if nargin==0
%     whichSUB = '03942';
% end

%subjects = {'03942', '03677', '00393', '13287', '13382','13447','13483', '13654','13658', '13695'};
%subjects = {'13695', '13695_pre'};
% subs = {'03942', '03677', '00393', '13287proj','13945','13172',...
%     '13382','13447proj','13493', '13654','13658', '13695', '14001'...
%     '13695_pre', '13493_pre', '13382_pre', '13658_pre','14001_pre', '13654_pre'};
%subs = {'13695', '13695_pre'};
subs = {'Post01','Post02','Post03','Post04','Post05','Post06','Post07','Post08',...
    'Post09','Post10','Post11','Post12','Post13','Post14','Post15','Post18','Post19','Post20',...
    'Post21',...
    'Pre01','Pre02','Pre03','Pre04','Pre05','Pre06','Pre07','Pre08','Pre09','Pre10','Pre11',...
    'Pre12','Pre13','Pre14','Pre15','Pre17','Pre18','Pre19','Pre20','Pre21'};
nPOST = 19;
nPRE = 20;
%nPApre = 6;
%magicAmpu = 7;

disp('MOTOR Calculating Dice to the MPM, centend to the FPM and FOM between patient digits and the atlas')
tic

%% find the MPMs

mRD_all = pRD_all;
subsATLAS = {'HB1', 'HB2', 'HB3', 'HB4', 'HB5', '11120', '10301', '00393', '03677', '08966','09621', ...
    '10289', '10320', '10329', '10654', '06447', '11251', '11753', '08740', '04217', '11240', '13676'};
for iSub = 1:length(subsATLAS)
    [iRow, col] = find(mRD_all(:,:,iSub));
    for iDX = 1:length(iRow)
        [~, I] = max(mRD_all(iRow(iDX),:,iSub)); % get index of max prob
        mRD_all(iRow(iDX),I,iSub) = 1; % set index of max prob to 1
    end
    mRD(:,:,iSub) = mRD_all(:,:,iSub)<1 == 0 ; % get rid of remaining non-1 probs
end


for iSubject = 1:length(subs)
    
    %% THIS DOES THE DICE TO THE MPM ATLAS
    
    RD_A = MRIread([subdir subs{iSubject} '_' 'RD' '.mgh']);
    %LD_A = MRIread([subdir subs{iSubject} '_' 'LD' '.mgh']);

    %if isempty(RD_A), RD_A = zeros(size(pLD_all,1),5); else RD_A = RD_A.vol; end
    RD_A = RD_A.vol;
    %LD_A = LD_A.vol;
    %    % comment this for now
    
    
    % Try calculating dice coeff or George's idea of "figure of Merit"
    % first binarise atlas
    
    %if verbose
    pRD_all(pRD_all>0)=1;
    %pLD_all(pLD_all>0)=1;

        
        for jj = 1:5
            for ii = 1:5
                %myintL = sum(LD_A(:,jj) .* mLD(:,ii) ); %= intersection
                myintR = sum(RD_A(:,jj) .* mRD(:,ii) );
                % DICE COEFF = 2 x intersection of A and B / sum of elements of A and B
                %diceLD(jj,ii, iSubject) = (2 .* myintL) ./ (sum(mLD(:,ii))+sum(LD_A(:,jj)));
                diceRD(jj,ii, iSubject) = (2 .* myintR) ./ (sum(mRD(:,ii))+sum(RD_A(:,jj)));
            end
        end
    
    %% now try using figure of merit to the FPM
    % paper - O'Neill, G. https://doi.org/10.1016/j.neuroimage.2016.08.061
    % Penalises both representation and degeneracy
    % spatial correlation(D1, atlasD1) - mean(D1, all other atlas digits)
    % maybe better to use central tendency values
    pRD_FPM = mean(pRD_all,3);
   
    [mycentR(:,:, iSubject) ] = cenTenDig_motor(RD_A, pRD_FPM);
    
    
    for jj = 1:5
        % we now need to subtract the centends of D1-D2, D1-D3 etc.
        thisCentendR = mycentR(jj,:,iSubject);
        thisCentendR(jj)=[];
        thisCentendR_mean = mean(thisCentendR);
        fomR(jj,iSubject) = mycentR(jj,jj) - thisCentendR_mean;
    end
end
toc

keyboard


% disp(fomL);
% disp(fomR);

% recompose centend and dice
myempty = zeros(5,5,nPRE+nPOST);
%mycent_z = cat(1,mycent,myempty);
mycentR_z = cat(1,myempty,mycentR);
my2cents = mycentR;
%[mycent_z mycentR_z];


%diceLD_z = cat(1,diceLD,myempty);
diceRD_z = cat(1,myempty,diceRD);
my2dice = diceRD;
%[diceLD_z diceRD_z];

% better labels


if verbose
    %% plot central tendency!
    figure('Position', [100 100 1800 1800])
    tiledlayout(4,5)
    for iSubject = 1:nPOST
        
        nexttile(iSubject)
        %subplot(1,nPOST,iSubject)
        imagesc(my2cents(:,:,iSubject))
        title(['CT ' subs{iSubject}])
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
    end
    set(gcf,'color', 'w');
    
    if shallisave
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/PA2ATLAS', ...
            'centend_HC_motor_caitlin');
        print(filename,'-dpng')
    end

    
    figure('Position', [100 100 1800 1800])
    tiledlayout(4,5)
    for iSubject = 1:nPRE
        nexttile(iSubject)
        imagesc(my2cents(:,:,iSubject+nPOST))
        title(['CT ' subs{iSubject+nPOST}])
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
    end
    set(gcf,'color', 'w');
    
    
    
%     figure('Position', [100 100 2000 400])
%     %for iSubject = nPA:length(subs)
%     for iSubject = 1:nPRE
%         subplot(2,7,iSubject)
%         imagesc(my2cents(:,:,iSubject+nPOST))
%         title(['CT ' subs{iSubject+nPOST}])
%         colormap(mapcol)
%         colorbar
%         xticks(1:5)
%         yticks(1:5)
%         xticklabels({'RD1','RD2','RD3','RD4','RD5'});
%         yticklabels({'RD1','RD2','RD3','RD4','RD5'});
%         xtickangle(45)
%         ytickangle(45)
%         ax = gca;
%         ax.FontSize = 10;
%     end
%     set(gcf,'color', 'w');

    
    if shallisave
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/PA2ATLAS', ...
            'centend_PA_motor_caitlin');
        print(filename,'-dpng')
    end

     
    
    %% plot DICE
   
    figure('Position', [100 100 2000 200])
    for iSubject = 1:nPOST
        subplot(1,nPOST,iSubject)
        imagesc(my2dice(:,:,iSubject))
        title(['Dice ' subs{iSubject}])
        colormap(mapcol2)
        colorbar
        xticks(1:5)
        yticks(1:5)
        xticklabels({'RD1','RD2','RD3','RD4','RD5'});
        yticklabels({'RD1','RD2','RD3','RD4','RD5'});
        xtickangle(45)
        ytickangle(45)
        ax = gca;
        ax.FontSize = 10;
    end
    set(gcf,'color', 'w');
    
    if shallisave
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/PA2ATLAS', ...
            'Dice_HC_motor_caitlin');
        print(filename,'-dpng')
    end

    
    figure('Position', [100 100 2000 400])
    %for iSubject = nPA:length(subs)
    for iSubject = 1:nPRE
        subplot(2,7,iSubject)
        imagesc(my2dice(:,:,iSubject+nPOST))
        title(['Dice ' subs{iSubject+nPOST}])
        colormap(mapcol2)
        colorbar
        xticks(1:5)
        yticks(1:5)
        xticklabels({'RD1','RD2','RD3','RD4','RD5'});
        yticklabels({'RD1','RD2','RD3','RD4','RD5'});
        xtickangle(45)
        ytickangle(45)
        ax = gca;
        ax.FontSize = 10;
    end
    set(gcf,'color', 'w');

    
    if shallisave
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/PA2ATLAS', ...
            'Dice_PA_motor_caitlin');
        print(filename,'-dpng')
    end
    
end

%%

cHC = mean(my2cents(:,:,1:7),3);
cPost = mean(my2cents(:,:,8:14),3);
cPre = mean(my2cents(:,:,15:end),3);

dHC = mean(my2dice(:,:,1:7),3);
dPost = mean(my2dice(:,:,8:14),3);
dPre = mean(my2dice(:,:,15:end),3);

mapcol = viridis;
a = 0;
b = 1.5;
c = 0.4;
figure('Position', [100 100 1000 400])
subplot(1,3,1)
imagesc(cHC)
title('CT HC')
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
caxis([a b])

subplot(1,3,2)
imagesc(cPost)
title('CT Post')
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
caxis([a b])
    
subplot(1,3,3)
imagesc(cPre)
title('CT Pre')
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
caxis([a b])

if shallisave
    filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/PA2ATLAS', ...
        'CT_mean_motor_caitlin');
    print(filename,'-dpng')
end

figure('Position', [100 100 1000 400])
subplot(1,3,1)
imagesc(dHC)
mapcol2 = inferno;
title('dice HC')
colormap(mapcol2)
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
caxis([a c])

subplot(1,3,2)
imagesc(dPost)
title('dice Post')
colormap(mapcol2)
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
caxis([a c])
    
subplot(1,3,3)
imagesc(dPre)
title('dice Pre')
colormap(mapcol2)
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
caxis([a c])

if shallisave
    filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/PA2ATLAS', ...
        'Dice_mean_motor_caitlin');
    print(filename,'-dpng')
end

%% graph to compare FOM
% split by patient group

FOM_nPOST = fomR(:,1:nPOST);
FOM_nPRE = fomR(:,nPOST+1:end);
%FOM_PApre = fomR(:,end-nPApre+1:end);


whichDig = repmat({'D1', 'D2', 'D3', 'D4', 'D5'}', size(FOM_nPOST,2), 1);
whichDigp = repmat({'D1', 'D2', 'D3', 'D4', 'D5'}', size(FOM_nPRE,2), 1);
%whichDigpre = repmat({'D1', 'D2', 'D3', 'D4', 'D5'}', size(FOM_PApre,2), 1);

FOM_nPOST = FOM_nPOST(:);
FOM_nPRE = FOM_nPRE(:);
%FOM_PApre = FOM_PApre(:);

bigFOM = [FOM_nPOST; FOM_nPRE];
bigCol = [whichDig; whichDigp ];
whichgroup = [repmat({'HC'},size(FOM_nPOST,1),1); repmat({'PA'},size(FOM_nPRE,1),1)];


% need to split patients and controls though
if exist('g','var'); clear g; end

%figure('Position', [100, 100, 1400,600])
figure
g(1,1)=gramm('x', whichgroup, 'y', bigFOM, 'color', bigCol);
g(1,1).geom_jitter('alpha',0.8)
%g(1,1).stat_boxplot()%'notch','true')
g(1,1).set_title('Motortopy2atlas')
g(1,1).set_names('x', 'Group', 'y', 'FIGURE OF MERIT ', 'color', 'Digit')
g(1,1).set_text_options('font', 'Menlo', 'base_size', 16)
g(1,1).set_point_options('markers', {'o'} ,'base_size',15)
g(1,1).axe_property('YLim', [-1 1])
g.draw

if shallisave
    g.export('file_name','FOM_patients2atlas_box_motor_caitlin', ...
        'export_path','/Users/ppzma/Google Drive/PhD/latex/affinity/PA2ATLAS' ,'file_type','pdf')
end


%% here, try linking the FOM between post and pre

mymedian = [repmat(median(FOM_nPOST),[size(FOM_nPOST),1]); repmat(median(FOM_nPRE),[size(FOM_nPRE),1]) ];
% now plot
if exist('g','var'); clear g; end
%figure('Position', [100, 100, 1400,1000])
figure
g(1,1) = gramm('x', whichgroup, 'y', bigFOM);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'drawoutlier',0,'width',0.5)
g(1,1).set_title('Figure of merit (central tendency): Dominant')
g(1,1).set_names('x', 'Group', 'y', 'FIGURE OF MERIT ')
g(1,1).set_text_options('font', 'Menlo', 'base_size', 12)
g.draw()

%colour by digits
mycmapX = digits(5);

%g(1,1).update('color', whichDig);
g(1,1).update('color',bigCol);
g(1,1).geom_jitter('alpha',0.8,'width',0.3);
g(1,1).set_point_options('markers',{'o'}, 'base_size',12);
g(1,1).set_color_options('map', mycmapX);
g.draw()


g(1,1).update('y',mymedian);
g(1,1).geom_line();
g(1,1).no_legend()
g.draw()


if shallisave
    g.export('file_name','FOM_patients2atlas_box_motor_caitlin', ...
        'export_path','/Users/ppzma/Google Drive/PhD/latex/affinity/PA2ATLAS' ,'file_type','pdf')
end



end

