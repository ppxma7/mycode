%compare2atlas_PFS
%compare2atlas - compare patient/subject digit to atlas digit
%
% [ma] feb2019
%
% run loadAtlas_George.m first to get digitatlas as .mat file
%
% try loading and comparing
% THIS IS USED WHEN IN FSAVERAGE SPACE
% See Also loadAtlas_George.m
clear variables
close all
close all hidden

userName = char(java.lang.System.getProperty('user.name'));
load(['/Users/' userName '/Documents/MATLAB/digitAtlas/sundries/digatlas_github.mat'], 'pLD_all', 'pRD_all', 'pLD_FPM', 'pRD_FPM','pLD_MPM','pRD_MPM');
%subdir = '/Volumes/ares/nemosine/DigitAtlasv2/patients_digits_2mm/';
savedir = ['/Users/' userName '/The University of Nottingham/Pain Relief Grant - General/PFP_results/digitatlas/'];



%load('/Volumes/ares/nemosine/DigitAtlasv2/digatlas_oct19_binarised.mat', 'pLD_all', 'pRD_all', 'pLD_FPM', 'pRD_FPM','pLD_MPM','pRD_MPM'); %load the 21 subject atlas
%subdir = '/Volumes/ares/PFS/7T/digitatlas/';
subdir = '/Volumes/ares/PFP_visit2_230621/digitatlas_1p5/';



cd(subdir)
subs = {'PFS'};
lenSub = length(subs);

grid = factork(lenSub,1);
%tic
%%
mLD = pLD_MPM;
mRD = pRD_MPM;

mLD_explode = [mLD==1,mLD==2,mLD==3,mLD==4,mLD==5];
mRD_explode = [mRD==1,mRD==2,mRD==3,mRD==4,mRD==5];

diceLD = zeros(5,5);
diceRD = zeros(5,5);


%%
for iSubject = 1:length(subs)

    % THIS DOES THE DICE TO THE MPM ATLAS

    %RD_A = MRIread([subdir subs{iSubject} '_' 'RD' '.mgh']);
    LD_A = MRIread([subdir subs{iSubject} '_LD.mgh']);
    LD_A = LD_A.vol;
    for ii = 1:5
        for jj = 1:5

            diceLD(ii,jj,iSubject) = dice(LD_A(:,ii), mLD_explode(:,jj));

        end    
     end




    %% now try using figure of merit to the FPM
    % paper - O'Neill, G. https://doi.org/10.1016/j.neuroimage.2016.08.061
    % Penalises both representation and degeneracy
    % spatial correlation(D1, atlasD1) - mean(D1, all other atlas digits)
    %
    % since this is binary, maybe try dice coeff - mean dice coeff of rest
    % instead of corr()

    %check if binary
    if unique(LD_A) == [0;1] % & unique(RD_A) == [0;1]

        % mask
        LD_A_masked = LD_A .* pLD_FPM;
        % remake to binary
        LD_A_masked_bin = logical(LD_A_masked);
        % centend to FPM
        [mycentL(:,:,iSubject) ] = cenTenDig_singlesub(LD_A_masked_bin, pLD_FPM);
        [mycentLMPM(:,:,iSubject) ] = cenTenDig_singlesub(LD_A_masked_bin, mLD_explode);

        % error check
        if any(isnan(mycentL(:,:,iSubject)))
            %nanDex = isnan(mycent(:,:,iSubject));
            tmpCent = mycentL(:,:,iSubject);
            tmpCent(isnan(tmpCent))=0;
            mycentL(:,:,iSubject) = tmpCent;
        end

        if any(isnan(mycentLMPM(:,:,iSubject)))
            %nanDexMPM = isnan(mycentMPM(:,:,iSubject));
            tmpCentMPM = mycentLMPM(:,:,iSubject);
            tmpCentMPM(isnan(tmpCentMPM))=0;
            mycentLMPM(:,:,iSubject) = tmpCentMPM;
        end

    else
        %no masking
        %disp('found a non-binary')

        [mycentL(:,:,iSubject)] = cenTenDig_singlesub(LD_A, pLD_FPM);
        [mycentLMPM(:,:,iSubject) ] = cenTenDig_singlesub(LD_A, mLD_explode);

        %if mycent(:,:,iSubject) =
    end
    % get Figure of merit here
    fomL(:,iSubject) = fom_sim(mycentL(:,:,iSubject));
    LD_A_stack(:,:,iSubject) = LD_A;

end
%toc
%save touchmap_LR LD_A_stack RD_A_stack % this is the touchmap digit atlas
%% extra calculations

dmCT_LD = mycentL.*diceLD;
%%
%keyboard
disp('Got this far')
mapcol = brewermap(128,'*RdBu');
a = 0;
b = 2;
myempty = zeros(5,5);
%figure('Position',[100 100 800 400])
figure
tiledlayout(grid(1),grid(2))
for ii = 1:lenSub%1:length(subs)
    buildMatL = [mycentL(:,:,ii); myempty];
    buildMatR = [myempty; myempty];
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
filename = [savedir 'ct'];
print(filename,'-dpng')
%% dice
mapcol = plasma;
a = 0;
b = 0.5;
myempty = zeros(5,5);
figure%('Position',[100 100 1600 1000])
tiledlayout(grid(1),grid(2))
for ii = 1:lenSub%1:length(subs)
    buildMatL = [diceLD(:,:,ii); myempty];
    buildMatR = [myempty; myempty];
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
filename = [savedir 'dice'];
print(filename,'-dpng')

%% dmct
mapcol = brewermap(64,'*Blues');
%mapcol = RdBu;
a = 0;
b = 1;
myempty = zeros(5,5);
figure%('Position',[100 100 1600 1000])
tiledlayout(grid(1),grid(2))
for ii = 1:lenSub
    buildMatL = [dmCT_LD(:,:,ii); myempty];
    buildMatR = [myempty; myempty];
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
filename = [savedir 'dmct'];
print(filename,'-dpng')

%% FOM
mylim = [-1 2];
theFom = fomL(:);
grpsubs = repmat({'PFS'},5,1);
digs = {'D1','D2','D3','D4','D5'};
digss = repmat(digs(:),length(theFom)./5,1);
figure %('Position',[100 100 1400 500])
clear g
g(1,1) = gramm('x',digss,'y',theFom,'color',grpsubs);
g(1,1).geom_jitter('dodge',0.8)
%g(1,1).stat_boxplot('width', 0.5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
%g(1,1).stat_summary('geom',{'bar','black_errorbar'});
g(1,1).set_title('LD')
g(1,1).no_legend()
g.set_order_options('color',0)


% g(1,1).update('x',digss,'y',theFom);
% g(1,1).geom_jitter('dodge',0.8)

g.set_names('x',[],'y', 'Figure of merit')
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',8)
g.axe_property('YLim',[mylim(1) mylim(2)])
g.set_order_options('color',0)
g.draw
filename = 'fom';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')


%% stats
% [p,tbl,stats,terms] = anovan(theFom,{digss},'model','linear','varnames',{'digits'}); %interaction?
% writecell(tbl,[savedir 'anova_fomL_digs'],'FileType','spreadsheet')

[P, ANOVATAB, STATS] = anova1(theFom,digss);
writecell(ANOVATAB,[savedir 'anova_fomL_digs'],'FileType','spreadsheet')

figure
[cc1,m,hh,gnames] = multcompare(STATS);

% [cc1,m,hh,gnames] = multcompare(stats,"Dimension",[1]);

% tbldom = array2table(cc1,"VariableNames", ...
%     ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
% tbldom.("Group A")=gnames(tbldom.("Group A"));
% tbldom.("Group B")=gnames(tbldom.("Group B"));
% writetable(tbldom,[savedir 'mult_anova_fomL_digs'],'FileType','spreadsheet')
% 




