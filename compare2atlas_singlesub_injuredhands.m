

% run compare2atlas_singlesub.m up to line 343

mapcol = brewermap(128,'*RdBu');

a = 0;
b = 2;
bb = 1;
myempty = zeros(5,5);


% 1 = injured hand
% 2 = non-injured hand
% 3 = median nerve injury
% 4 = ulnar nerve injury
% 5 = median + ulnar nerve injury
for ii = 1:2

    figure('Position',[100 100 1200 600])

    if ii == 1
        mycent_LD_inj = mycentL(:,:,LD_inj_idx);
        mycent_RD_inj = mycentR(:,:,RD_inj_idx);
        mydice_LD_inj = diceLD(:,:,LD_inj_idx);
        mydice_RD_inj = diceRD(:,:,RD_inj_idx);
        mydmct_LD_inj = dmCT_LD(:,:,LD_inj_idx);
        mydmct_RD_inj = dmCT_RD(:,:,RD_inj_idx);
        filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
            'injured');
    elseif ii == 2
        mycent_LD_inj = mycentL(:,:,RD_inj_idx);
        mycent_RD_inj = mycentR(:,:,LD_inj_idx);
        mydice_LD_inj = diceLD(:,:,RD_inj_idx);
        mydice_RD_inj = diceRD(:,:,LD_inj_idx);
        mydmct_LD_inj = dmCT_LD(:,:,RD_inj_idx);
        mydmct_RD_inj = dmCT_RD(:,:,LD_inj_idx);
        filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
            'non-injured');
    elseif ii == 3
        mycent_LD_inj = mycentL(:,:,LD_media_idx);
        mycent_RD_inj = mycentR(:,:,RD_media_idx);
        mydice_LD_inj = diceLD(:,:,LD_media_idx);
        mydice_RD_inj = diceRD(:,:,RD_media_idx);
        mydmct_LD_inj = dmCT_LD(:,:,LD_media_idx);
        mydmct_RD_inj = dmCT_RD(:,:,RD_media_idx);
        filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
            'median-nerve');
    elseif ii == 4
        mycent_LD_inj = mycentL(:,:,RD_media_idx);
        mycent_RD_inj = mycentR(:,:,LD_media_idx);
        mydice_LD_inj = diceLD(:,:,RD_media_idx);
        mydice_RD_inj = diceRD(:,:,LD_media_idx);
        mydmct_LD_inj = dmCT_LD(:,:,RD_media_idx);
        mydmct_RD_inj = dmCT_RD(:,:,LD_media_idx);
        filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
            'noninj_median-nerve');
    elseif ii == 5
        mycent_LD_inj = mycentL(:,:,LD_ulnar_idx);
        mycent_RD_inj = mycentR(:,:,RD_ulnar_idx);
        mydice_LD_inj = diceLD(:,:,LD_ulnar_idx);
        mydice_RD_inj = diceRD(:,:,RD_ulnar_idx);
        mydmct_LD_inj = dmCT_LD(:,:,LD_ulnar_idx);
        mydmct_RD_inj = dmCT_RD(:,:,RD_ulnar_idx);
        filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
            'ulnar-nerve');
    elseif ii == 6
        mycent_LD_inj = mycentL(:,:,RD_ulnar_idx);
        mycent_RD_inj = mycentR(:,:,LD_ulnar_idx);
        mydice_LD_inj = diceLD(:,:,RD_ulnar_idx);
        mydice_RD_inj = diceRD(:,:,LD_ulnar_idx);
        mydmct_LD_inj = dmCT_LD(:,:,RD_ulnar_idx);
        mydmct_RD_inj = dmCT_RD(:,:,LD_ulnar_idx);
        filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
            'noninj_ulnar-nerve');
    elseif ii == 7
        mycent_LD_inj = mycentL(:,:,LD_both_idx);
        mycent_RD_inj = mycentR(:,:,RD_both_idx);
        mydice_LD_inj = diceLD(:,:,LD_both_idx);
        mydice_RD_inj = diceRD(:,:,RD_both_idx);
        mydmct_LD_inj = dmCT_LD(:,:,LD_both_idx);
        mydmct_RD_inj = dmCT_RD(:,:,RD_both_idx);
        filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
            'both-nerve');
    elseif ii == 8
        mycent_LD_inj = mycentL(:,:,RD_both_idx);
        mycent_RD_inj = mycentR(:,:,LD_both_idx);
        mydice_LD_inj = diceLD(:,:,RD_both_idx);
        mydice_RD_inj = diceRD(:,:,LD_both_idx);
        mydmct_LD_inj = dmCT_LD(:,:,RD_both_idx);
        mydmct_RD_inj = dmCT_RD(:,:,LD_both_idx);
        filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
            'noninj-both-nerve');
    elseif ii == 9 %dominance
        mycent_LD_inj = mycentL(:,:,LEFT_dom_idx);
        mycent_RD_inj = mycentR(:,:,RIGHT_dom_idx);
        mydice_LD_inj = diceLD(:,:,LEFT_dom_idx);
        mydice_RD_inj = diceRD(:,:,RIGHT_dom_idx);
        mydmct_LD_inj = dmCT_LD(:,:,LEFT_dom_idx);
        mydmct_RD_inj = dmCT_RD(:,:,RIGHT_dom_idx);
        filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
            'dominance');
    end

    % mean
    mycent_LD_inj_mean = mean(mycent_LD_inj,3);
    mycent_RD_inj_mean = mean(mycent_RD_inj,3);

    mydice_LD_inj_mean = mean(mydice_LD_inj,3);
    mydice_RD_inj_mean = mean(mydice_RD_inj,3);

    mydmct_LD_inj_mean = mean(mydmct_LD_inj,3);
    mydmct_RD_inj_mean = mean(mydmct_RD_inj,3);

    % std
    mycent_LD_inj_std = std(mycent_LD_inj,0,3);
    mycent_RD_inj_std = std(mycent_RD_inj,0,3);

    mydice_LD_inj_std = std(mydice_LD_inj,0,3);
    mydice_RD_inj_std = std(mydice_RD_inj,0,3);

    mydmct_LD_inj_std = std(mydmct_LD_inj,0,3);
    mydmct_RD_inj_std = std(mydmct_RD_inj,0,3);

    % build matrices
    buildMat_cent_inj_LD = [mycent_LD_inj_mean; myempty];
    buildMat_cent_inj_RD = [myempty; mycent_RD_inj_mean];
    Mat_cent_inj = [buildMat_cent_inj_LD,buildMat_cent_inj_RD];

    buildMat_dice_inj_LD = [mydice_LD_inj_mean; myempty];
    buildMat_dice_inj_RD = [myempty; mydice_RD_inj_mean];
    Mat_dice_inj = [buildMat_dice_inj_LD,buildMat_dice_inj_RD];

    buildMat_dmct_inj_LD = [mydmct_LD_inj_mean; myempty];
    buildMat_dmct_inj_RD = [myempty; mydmct_RD_inj_mean];
    Mat_dmct_inj = [buildMat_dmct_inj_LD,buildMat_dmct_inj_RD];
    % std matrices
    buildMat_cent_inj_LD = [mycent_LD_inj_std; myempty];
    buildMat_cent_inj_RD = [myempty; mycent_RD_inj_std];
    Mat_cent_inj_std = [buildMat_cent_inj_LD,buildMat_cent_inj_RD];

    buildMat_dice_inj_LD = [mydice_LD_inj_std; myempty];
    buildMat_dice_inj_RD = [myempty; mydice_RD_inj_std];
    Mat_dice_inj_std = [buildMat_dice_inj_LD,buildMat_dice_inj_RD];

    buildMat_dmct_inj_LD = [mydmct_LD_inj_std; myempty];
    buildMat_dmct_inj_RD = [myempty; mydmct_RD_inj_std];
    Mat_dmct_inj_std = [buildMat_dmct_inj_LD,buildMat_dmct_inj_RD];


    %

    tiledlayout(2,3)
    nexttile
    imagesc(Mat_cent_inj)
    title('CT mean')
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
    imagesc(Mat_dice_inj)
    title('dice mean')
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
    imagesc(Mat_dmct_inj)
    title('dmct mean')
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
    clim([a bb])

    nexttile
    imagesc(Mat_cent_inj_std)
    title('CT std')
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
    imagesc(Mat_dice_inj_std)
    title('dice std')
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
    imagesc(Mat_dmct_inj_std)
    title('dmct std')
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
    clim([a bb])

    mappy = 'plasma';
    ax = nexttile(2);
    colormap(ax,mappy);
    colorbar(ax)
    clim([0 0.5])

    mappy2 = brewermap(64,'*Blues');
    for axi = 3:6
        ax_temp = nexttile(axi);
        colormap(ax_temp,mappy2);
        colorbar(ax_temp)
        clim([0 1])
    end

    

    set(gcf,'color', 'w');

    print(filename,'-dpng')

end

%%






%% subtract above matrices
myempty = zeros(5,5);

filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
    'injurednoninjurediffs');

% subtract above matrices
% INJURED
mycent_LD_inj = mycentL(:,:,LD_inj_idx);
mycent_RD_inj = mycentR(:,:,RD_inj_idx);
mydice_LD_inj = diceLD(:,:,LD_inj_idx);
mydice_RD_inj = diceRD(:,:,RD_inj_idx);
mydmct_LD_inj = dmCT_LD(:,:,LD_inj_idx);
mydmct_RD_inj = dmCT_RD(:,:,RD_inj_idx);

mycent_LD_inj_mean = mean(mycent_LD_inj,3);
mycent_RD_inj_mean = mean(mycent_RD_inj,3);
mydice_LD_inj_mean = mean(mydice_LD_inj,3);
mydice_RD_inj_mean = mean(mydice_RD_inj,3);
mydmct_LD_inj_mean = mean(mydmct_LD_inj,3);
mydmct_RD_inj_mean = mean(mydmct_RD_inj,3);

buildMat_cent_inj_LD = [mycent_LD_inj_mean; myempty];
buildMat_cent_inj_RD = [myempty; mycent_RD_inj_mean];
Mat_cent_inj = [buildMat_cent_inj_LD,buildMat_cent_inj_RD];
buildMat_dice_inj_LD = [mydice_LD_inj_mean; myempty];
buildMat_dice_inj_RD = [myempty; mydice_RD_inj_mean];
Mat_dice_inj = [buildMat_dice_inj_LD,buildMat_dice_inj_RD];
buildMat_dmct_inj_LD = [mydmct_LD_inj_mean; myempty];
buildMat_dmct_inj_RD = [myempty; mydmct_RD_inj_mean];
Mat_dmct_inj = [buildMat_dmct_inj_LD,buildMat_dmct_inj_RD];

% NONINJURED
mycent_LD_noninj = mycentL(:,:,RD_inj_idx);
mycent_RD_noninj = mycentR(:,:,LD_inj_idx);
mydice_LD_noninj = diceLD(:,:,RD_inj_idx);
mydice_RD_noninj = diceRD(:,:,LD_inj_idx);
mydmct_LD_noninj = dmCT_LD(:,:,RD_inj_idx);
mydmct_RD_noninj = dmCT_RD(:,:,LD_inj_idx);

mycent_LD_noninj_mean = mean(mycent_LD_noninj,3);
mycent_RD_noninj_mean = mean(mycent_RD_noninj,3);
mydice_LD_noninj_mean = mean(mydice_LD_noninj,3);
mydice_RD_noninj_mean = mean(mydice_RD_noninj,3);
mydmct_LD_noninj_mean = mean(mydmct_LD_noninj,3);
mydmct_RD_noninj_mean = mean(mydmct_RD_noninj,3);

buildMat_cent_noninj_LD = [mycent_LD_noninj_mean; myempty];
buildMat_cent_noninj_RD = [myempty; mycent_RD_noninj_mean];
Mat_cent_noninj = [buildMat_cent_noninj_LD,buildMat_cent_noninj_RD];
buildMat_dice_noninj_LD = [mydice_LD_noninj_mean; myempty];
buildMat_dice_noninj_RD = [myempty; mydice_RD_noninj_mean];
Mat_dice_noninj = [buildMat_dice_noninj_LD,buildMat_dice_noninj_RD];
buildMat_dmct_noninj_LD = [mydmct_LD_noninj_mean; myempty];
buildMat_dmct_noninj_RD = [myempty; mydmct_RD_noninj_mean];
Mat_dmct_noninj = [buildMat_dmct_noninj_LD,buildMat_dmct_noninj_RD];


A = Mat_cent_inj - Mat_cent_noninj;
B = Mat_dice_inj - Mat_dice_noninj;
C = Mat_dmct_inj - Mat_dmct_noninj;

%mapcol = brewermap(128,'*RdBu');
mapcol = brewermap(128,'*Spectral');

a = -0.2;
b = 0.2;

figure('Position',[100 100 1200 600])
tiledlayout(1,3)
nexttile
imagesc(A)
title('injured - noninjured cent diff')
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
%clim([-0.2 0.2])

nexttile
imagesc(B)
title('injured - noninjured dice diff')
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
%clim([-0.2 0.2])

nexttile
imagesc(C)
title('injured - noninjured dmct diff')
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
%clim([-0.2 0.2])


set(gcf,'color', 'w');
print(filename,'-dpng')


%% Look at distance from 1 on the diagonals

for ii = 1:size(mycentL,3) %LD
    testcaseL = mycentL(:,:,ii);
    testdiagL = diag(testcaseL);
    testdiagL_mean(ii) = mean(testdiagL-1); % distance from 1. Negative means how much below 1, positive is how much above 1 it is
    % RD
    testcaseR = mycentR(:,:,ii);
    testdiagR = diag(testcaseR);
    testdiagR_mean(ii) = mean(testdiagR-1); % distance from 1. Negative means how much below 1, positive is how much above 1 it is
end





% Look at off diagonals
clear offDiags*
thismap = brewermap(128,'*RdBu');
mapcol = brewermap(128,'*RdBu');

a = 0;
b = 2;
myempty = zeros(5,5);

% cent
for ii = 1:size(mycentL,3)
    testcase = mycentL(:,:,ii);
    col1 = [0; testcase(2:5,1)];
    col2 = [testcase(1,2); 0; testcase(3:5,2)];
    col3 = [testcase(1:2,3); 0; testcase(4:5,3)];
    col4 = [testcase(1:3,4); 0; testcase(5,4)];
    col5 = [testcase(1:4,5); 0];
    offDiags_cent_L(:,:,ii) = [col1 col2 col3 col4 col5];
    soffDiags_cent_L(ii) = sum(offDiags_cent_L(:,:,ii),'all');
end
for ii = 1:size(mycentR,3)
    testcase = mycentR(:,:,ii);
    col1 = [0; testcase(2:5,1)];
    col2 = [testcase(1,2); 0; testcase(3:5,2)];
    col3 = [testcase(1:2,3); 0; testcase(4:5,3)];
    col4 = [testcase(1:3,4); 0; testcase(5,4)];
    col5 = [testcase(1:4,5); 0];
    offDiags_cent_R(:,:,ii) = [col1 col2 col3 col4 col5];
    soffDiags_cent_R(ii) = sum(offDiags_cent_R(:,:,ii),'all');
end
% dice
for ii = 1:size(diceLD,3)
    testcase = diceLD(:,:,ii);
    col1 = [0; testcase(2:5,1)];
    col2 = [testcase(1,2); 0; testcase(3:5,2)];
    col3 = [testcase(1:2,3); 0; testcase(4:5,3)];
    col4 = [testcase(1:3,4); 0; testcase(5,4)];
    col5 = [testcase(1:4,5); 0];
    offDiags_dice_L(:,:,ii) = [col1 col2 col3 col4 col5];
    soffDiags_dice_L(ii) = sum(offDiags_dice_L(:,:,ii),'all');
end
for ii = 1:size(diceRD,3)
    testcase = diceRD(:,:,ii);
    col1 = [0; testcase(2:5,1)];
    col2 = [testcase(1,2); 0; testcase(3:5,2)];
    col3 = [testcase(1:2,3); 0; testcase(4:5,3)];
    col4 = [testcase(1:3,4); 0; testcase(5,4)];
    col5 = [testcase(1:4,5); 0];
    offDiags_dice_R(:,:,ii) = [col1 col2 col3 col4 col5];
    soffDiags_dice_R(ii) = sum(offDiags_dice_R(:,:,ii),'all');
end
% dmct
for ii = 1:size(dmCT_LD,3)
    testcase = dmCT_LD(:,:,ii);
    col1 = [0; testcase(2:5,1)];
    col2 = [testcase(1,2); 0; testcase(3:5,2)];
    col3 = [testcase(1:2,3); 0; testcase(4:5,3)];
    col4 = [testcase(1:3,4); 0; testcase(5,4)];
    col5 = [testcase(1:4,5); 0];
    offDiags_dmct_L(:,:,ii) = [col1 col2 col3 col4 col5];
    soffDiags_dmct_L(ii) = sum(offDiags_dmct_L(:,:,ii),'all');
end
for ii = 1:size(dmCT_RD,3)
    testcase = dmCT_RD(:,:,ii);
    col1 = [0; testcase(2:5,1)];
    col2 = [testcase(1,2); 0; testcase(3:5,2)];
    col3 = [testcase(1:2,3); 0; testcase(4:5,3)];
    col4 = [testcase(1:3,4); 0; testcase(5,4)];
    col5 = [testcase(1:4,5); 0];
    offDiags_dmct_R(:,:,ii) = [col1 col2 col3 col4 col5];
    soffDiags_dmct_R(ii) = sum(offDiags_dmct_R(:,:,ii),'all');
end





%figure('Position',[100 100 1200 600])

%% PLOT

% INJURED
% mycent_LD_inj = soffDiags_cent_L(LD_inj_idx);
% mycent_RD_inj = soffDiags_cent_R(RD_inj_idx);
% mycent_diags_LD_inj = testdiagL_mean(LD_inj_idx); %<-- add in distance from 1 on diags
% mycent_diags_RD_inj = testdiagR_mean(RD_inj_idx); %<-- add in distance from 1 on diags
% mydice_LD_inj = soffDiags_dice_L(LD_inj_idx);
% mydice_RD_inj = soffDiags_dice_R(RD_inj_idx);
% mydmct_LD_inj = soffDiags_dmct_L(LD_inj_idx);
% mydmct_RD_inj = soffDiags_dmct_R(RD_inj_idx);
% 
% % NONINJURED
% mycent_LD_noninj = soffDiags_cent_L(RD_inj_idx);
% mycent_RD_noninj = soffDiags_cent_R(LD_inj_idx);
% mycent_diags_LD_noninj = testdiagL_mean(RD_inj_idx); %<-- add in distance from 1 on diags
% mycent_diags_RD_noninj = testdiagR_mean(LD_inj_idx); %<-- add in distance from 1 on diags
% mydice_LD_noninj = soffDiags_dice_L(RD_inj_idx);
% mydice_RD_noninj = soffDiags_dice_R(LD_inj_idx);
% mydmct_LD_noninj = soffDiags_dmct_L(RD_inj_idx);
% mydmct_RD_noninj = soffDiags_dmct_R(LD_inj_idx);

% median ulnar
mycent_LD_media = soffDiags_cent_L(LD_media_idx);
mycent_RD_media = soffDiags_cent_R(RD_media_idx);
mycent_diags_LD_media = testdiagL_mean(LD_media_idx); %<-- add in distance from 1 on diags
mycent_diags_RD_media = testdiagR_mean(RD_media_idx); %<-- add in distance from 1 on diags
mydice_LD_media = soffDiags_dice_L(LD_media_idx);
mydice_RD_media = soffDiags_dice_R(RD_media_idx);
mydmct_LD_media = soffDiags_dmct_L(LD_media_idx);
mydmct_RD_media = soffDiags_dmct_R(RD_media_idx);

mycent_LD_ulnar = soffDiags_cent_L(LD_ulnar_idx);
mycent_RD_ulnar = soffDiags_cent_R(RD_ulnar_idx);
mycent_diags_LD_ulnar = testdiagL_mean(LD_ulnar_idx); %<-- add in distance from 1 on diags
mycent_diags_RD_ulnar = testdiagR_mean(RD_ulnar_idx); %<-- add in distance from 1 on diags
mydice_LD_ulnar = soffDiags_dice_L(LD_ulnar_idx);
mydice_RD_ulnar = soffDiags_dice_R(RD_ulnar_idx);
mydmct_LD_ulnar = soffDiags_dmct_L(LD_ulnar_idx);
mydmct_RD_ulnar = soffDiags_dmct_R(RD_ulnar_idx);

mycent_LD_both = soffDiags_cent_L(LD_both_idx);
mycent_RD_both = soffDiags_cent_R(RD_both_idx);
mycent_diags_LD_both = testdiagL_mean(LD_both_idx); %<-- add in distance from 1 on diags
mycent_diags_RD_both = testdiagR_mean(RD_both_idx); %<-- add in distance from 1 on diags
mydice_LD_both = soffDiags_dice_L(LD_both_idx);
mydice_RD_both = soffDiags_dice_R(RD_both_idx);
mydmct_LD_both = soffDiags_dmct_L(LD_both_idx);
mydmct_RD_both = soffDiags_dmct_R(RD_both_idx);

%median ulnar non inj
mycent_LD_media_nj = soffDiags_cent_L(RD_media_idx);
mycent_RD_media_nj = soffDiags_cent_R(LD_media_idx);
mycent_diags_LD_media_nj = testdiagL_mean(RD_media_idx); %<-- add in distance from 1 on diags
mycent_diags_RD_media_nj = testdiagR_mean(LD_media_idx); %<-- add in distance from 1 on diags
mydice_LD_media_nj = soffDiags_dice_L(RD_media_idx);
mydice_RD_media_nj = soffDiags_dice_R(LD_media_idx);
mydmct_LD_media_nj = soffDiags_dmct_L(RD_media_idx);
mydmct_RD_media_nj = soffDiags_dmct_R(LD_media_idx);

mycent_LD_ulnar_nj = soffDiags_cent_L(RD_ulnar_idx);
mycent_RD_ulnar_nj = soffDiags_cent_R(LD_ulnar_idx);
mycent_diags_LD_ulnar_nj = testdiagL_mean(RD_ulnar_idx); %<-- add in distance from 1 on diags
mycent_diags_RD_ulnar_nj = testdiagR_mean(LD_ulnar_idx); %<-- add in distance from 1 on diags
mydice_LD_ulnar_nj = soffDiags_dice_L(RD_ulnar_idx);
mydice_RD_ulnar_nj = soffDiags_dice_R(LD_ulnar_idx);
mydmct_LD_ulnar_nj = soffDiags_dmct_L(RD_ulnar_idx);
mydmct_RD_ulnar_nj = soffDiags_dmct_R(LD_ulnar_idx);

mycent_LD_both_nj = soffDiags_cent_L(RD_both_idx);
mycent_RD_both_nj = soffDiags_cent_R(LD_both_idx);
mycent_diags_LD_both_nj = testdiagL_mean(RD_both_idx); %<-- add in distance from 1 on diags
mycent_diags_RD_both_nj = testdiagR_mean(LD_both_idx); %<-- add in distance from 1 on diags
mydice_LD_both_nj = soffDiags_dice_L(RD_both_idx);
mydice_RD_both_nj = soffDiags_dice_R(LD_both_idx);
mydmct_LD_both_nj = soffDiags_dmct_L(RD_both_idx);
mydmct_RD_both_nj = soffDiags_dmct_R(LD_both_idx);


% vectorise
mycent_diags_hc = [testdiagL_mean(1:lenHC) testdiagR_mean(1:lenHC)]; %<-- add in distance from 1 on diags
mycent_diags_hc = mycent_diags_hc(:);
mycent_hc = [soffDiags_cent_L(1:lenHC) soffDiags_cent_R(1:lenHC)];
mycent_hc = mycent_hc(:);
mydice_hc = [soffDiags_dice_L(1:lenHC) soffDiags_dice_R(1:lenHC)];
mydice_hc = mydice_hc(:);
mydmct_hc = [soffDiags_dmct_L(1:lenHC) soffDiags_dmct_R(1:lenHC)];
mydmct_hc = mydmct_hc(:);
mycent_hc_LR = [repmat({'centL'},lenHC,1); repmat({'centR'},lenHC,1)];
mydice_hc_LR = [repmat({'diceL'},lenHC,1); repmat({'diceR'},lenHC,1)];
mydmct_hc_LR = [repmat({'dmctL'},lenHC,1); repmat({'dmctR'},lenHC,1)];

% mycent_inj = [mycent_LD_inj mycent_RD_inj];
% mycent_inj = mycent_inj(:);
% mycent_diags_inj = [mycent_diags_LD_inj mycent_diags_RD_inj];
% mycent_diags_inj = mycent_diags_inj(:);
% mydice_inj = [mydice_LD_inj mydice_RD_inj];
% mydice_inj = mydice_inj(:);
% mydmct_inj = [mydmct_LD_inj mydmct_RD_inj];
% mydmct_inj = mydmct_inj(:);
% mycent_inj_LR = [repmat({'centL'},length(mycent_LD_inj),1); repmat({'centR'},length(mycent_RD_inj),1)];
% mydice_inj_LR = [repmat({'diceL'},length(mydice_LD_inj),1); repmat({'diceR'},length(mydice_RD_inj),1)];
% mydmct_inj_LR = [repmat({'dmctL'},length(mydmct_LD_inj),1); repmat({'dmctR'},length(mydmct_RD_inj),1)];
% 
% 
% mycent_noninj = [mycent_LD_noninj mycent_RD_noninj];
% mycent_noninj = mycent_noninj(:);
% mycent_diags_noninj = [mycent_diags_LD_noninj mycent_diags_RD_noninj];
% mycent_diags_noninj = mycent_diags_noninj(:);
% mydice_noninj = [mydice_LD_noninj mydice_RD_noninj];
% mydice_noninj = mydice_noninj(:);
% mydmct_noninj = [mydmct_LD_noninj mydmct_RD_noninj];
% mydmct_noninj = mydmct_noninj(:);
% mycent_noninj_LR = [repmat({'centL'},length(mycent_LD_noninj),1); repmat({'centR'},length(mycent_RD_noninj),1)];
% mydice_noninj_LR = [repmat({'diceL'},length(mydice_LD_noninj),1); repmat({'diceR'},length(mydice_RD_noninj),1)];
% mydmct_noninj_LR = [repmat({'dmctL'},length(mydmct_LD_noninj),1); repmat({'dmctR'},length(mydmct_RD_noninj),1)];

mycent_media = [mycent_LD_media mycent_RD_media];
mycent_media = mycent_media(:);
mycent_diags_media = [mycent_diags_LD_media mycent_diags_RD_media];
mycent_diags_media = mycent_diags_media(:);
mydice_media = [mydice_LD_media mydice_RD_media];
mydice_media = mydice_media(:);
mydmct_media = [mydmct_LD_media mydmct_RD_media];
mydmct_media = mydmct_media(:);
mycent_media_LR = [repmat({'centL'},length(mycent_LD_media),1); repmat({'centR'},length(mycent_RD_media),1)];
mydice_media_LR = [repmat({'diceL'},length(mydice_LD_media),1); repmat({'diceR'},length(mydice_RD_media),1)];
mydmct_media_LR = [repmat({'dmctL'},length(mydmct_LD_media),1); repmat({'dmctR'},length(mydmct_RD_media),1)];

mycent_ulnar = [mycent_LD_ulnar mycent_RD_ulnar];
mycent_ulnar = mycent_ulnar(:);
mycent_diags_ulnar = [mycent_diags_LD_ulnar mycent_diags_RD_ulnar];
mycent_diags_ulnar = mycent_diags_ulnar(:);
mydice_ulnar = [mydice_LD_ulnar mydice_RD_ulnar];
mydice_ulnar = mydice_ulnar(:);
mydmct_ulnar = [mydmct_LD_ulnar mydmct_RD_ulnar];
mydmct_ulnar = mydmct_ulnar(:);
mycent_ulnar_LR = [repmat({'centL'},length(mycent_LD_ulnar),1); repmat({'centR'},length(mycent_RD_ulnar),1)];
mydice_ulnar_LR = [repmat({'diceL'},length(mydice_LD_ulnar),1); repmat({'diceR'},length(mydice_RD_ulnar),1)];
mydmct_ulnar_LR = [repmat({'dmctL'},length(mydmct_LD_ulnar),1); repmat({'dmctR'},length(mydmct_RD_ulnar),1)];

mycent_both = [mycent_LD_both mycent_RD_both];
mycent_both = mycent_both(:);
mycent_diags_both = [mycent_diags_LD_both mycent_diags_RD_both];
mycent_diags_both = mycent_diags_both(:);
mydice_both = [mydice_LD_both mydice_RD_both];
mydice_both = mydice_both(:);
mydmct_both = [mydmct_LD_both mydmct_RD_both];
mydmct_both = mydmct_both(:);
mycent_both_LR = [repmat({'centL'},length(mycent_LD_both),1); repmat({'centR'},length(mycent_RD_both),1)];
mydice_both_LR = [repmat({'diceL'},length(mydice_LD_both),1); repmat({'diceR'},length(mydice_RD_both),1)];
mydmct_both_LR = [repmat({'dmctL'},length(mydmct_LD_both),1); repmat({'dmctR'},length(mydmct_RD_both),1)];

%noninjured 
mycent_media_nj = [mycent_LD_media_nj mycent_RD_media_nj];
mycent_media_nj = mycent_media_nj(:);
mycent_diags_media_nj = [mycent_diags_LD_media_nj mycent_diags_RD_media_nj];
mycent_diags_media_nj = mycent_diags_media_nj(:);
mydice_media_nj = [mydice_LD_media_nj mydice_RD_media_nj];
mydice_media_nj = mydice_media_nj(:);
mydmct_media_nj = [mydmct_LD_media_nj mydmct_RD_media_nj];
mydmct_media_nj = mydmct_media_nj(:);
mycent_media_LR_nj = [repmat({'centL'},length(mycent_LD_media_nj),1); repmat({'centR'},length(mycent_RD_media_nj),1)];
mydice_media_LR_nj = [repmat({'diceL'},length(mydice_LD_media_nj),1); repmat({'diceR'},length(mydice_RD_media_nj),1)];
mydmct_media_LR_nj = [repmat({'dmctL'},length(mydmct_LD_media_nj),1); repmat({'dmctR'},length(mydmct_RD_media_nj),1)];

mycent_ulnar_nj = [mycent_LD_ulnar_nj mycent_RD_ulnar_nj];
mycent_ulnar_nj = mycent_ulnar_nj(:);
mycent_diags_ulnar_nj = [mycent_diags_LD_ulnar_nj mycent_diags_RD_ulnar_nj];
mycent_diags_ulnar_nj = mycent_diags_ulnar_nj(:);
mydice_ulnar_nj = [mydice_LD_ulnar_nj mydice_RD_ulnar_nj];
mydice_ulnar_nj = mydice_ulnar_nj(:);
mydmct_ulnar_nj = [mydmct_LD_ulnar_nj mydmct_RD_ulnar_nj];
mydmct_ulnar_nj = mydmct_ulnar_nj(:);
mycent_ulnar_LR_nj = [repmat({'centL'},length(mycent_LD_ulnar_nj),1); repmat({'centR'},length(mycent_RD_ulnar_nj),1)];
mydice_ulnar_LR_nj = [repmat({'diceL'},length(mydice_LD_ulnar_nj),1); repmat({'diceR'},length(mydice_RD_ulnar_nj),1)];
mydmct_ulnar_LR_nj = [repmat({'dmctL'},length(mydmct_LD_ulnar_nj),1); repmat({'dmctR'},length(mydmct_RD_ulnar_nj),1)];

mycent_both_nj = [mycent_LD_both_nj mycent_RD_both_nj];
mycent_both_nj = mycent_both_nj(:);
mycent_diags_both_nj = [mycent_diags_LD_both_nj mycent_diags_RD_both_nj];
mycent_diags_both_nj = mycent_diags_both_nj(:);
mydice_both_nj = [mydice_LD_both_nj mydice_RD_both_nj];
mydice_both_nj = mydice_both_nj(:);
mydmct_both_nj = [mydmct_LD_both_nj mydmct_RD_both_nj];
mydmct_both_nj = mydmct_both_nj(:);
mycent_both_LR_nj = [repmat({'centL'},length(mycent_LD_both_nj),1); repmat({'centR'},length(mycent_RD_both_nj),1)];
mydice_both_LR_nj = [repmat({'diceL'},length(mydice_LD_both_nj),1); repmat({'diceR'},length(mydice_RD_both_nj),1)];
mydmct_both_LR_nj = [repmat({'dmctL'},length(mydmct_LD_both_nj),1); repmat({'dmctR'},length(mydmct_RD_both_nj),1)];

% plot sum of off diagonals
% ideally expect a tail off from the diagonal, but higher values will
% imply that there is more peripheral overlap with the atlas


gCENT = [mycent_hc; mycent_media; mycent_media_nj; mycent_ulnar; mycent_ulnar_nj; mycent_both; mycent_both_nj];
gCENT_group = [repmat({'Healthy'},length(mycent_hc_LR),1); ...
    repmat({'Median-injured'},    length(mycent_media_LR),1); ...
    repmat({'Median-non-injured'},length(mycent_media_LR_nj),1); ...
    repmat({'Ulnar-injured'},     length(mycent_ulnar_LR),1); ...
    repmat({'Ulnar-non-injured'}, length(mycent_ulnar_LR_nj),1); ...
    repmat({'Both-injured'},      length(mycent_both_LR),1);...
    repmat({'Both-non-injured'},  length(mycent_both_LR_nj),1)];
gCENT_hand = [repmat({'LD'},lenHC,1); ...
    repmat({'RD'},lenHC,1); ...
    repmat({'LD'},length(mycent_LD_media),1); ...
    repmat({'RD'},length(mycent_RD_media),1); ...
    repmat({'LD'},length(mycent_LD_media_nj),1); ...
    repmat({'RD'},length(mycent_RD_media_nj),1); ...
    repmat({'LD'},length(mycent_LD_ulnar),1); ...
    repmat({'RD'},length(mycent_RD_ulnar),1); ...
    repmat({'LD'},length(mycent_LD_ulnar_nj),1); ...
    repmat({'RD'},length(mycent_RD_ulnar_nj),1); ...
    repmat({'LD'},length(mycent_LD_both),1); ...
    repmat({'RD'},length(mycent_RD_both),1); ...
    repmat({'LD'},length(mycent_LD_both_nj),1); ...
    repmat({'RD'},length(mycent_RD_both_nj),1)];   


gCENT_diags = [mycent_diags_hc; mycent_diags_media; mycent_diags_media_nj;...
    mycent_diags_ulnar; mycent_diags_ulnar_nj; mycent_diags_both; mycent_diags_both_nj];
gCENT_diags_group = gCENT_group;
gCENT_diags_hand = gCENT_hand;

gDICE = [mydice_hc; mydice_media; mydice_media_nj; mydice_ulnar; mydice_ulnar_nj;...
    mydice_both; mydice_both_nj];
gDICE_group = gCENT_group;
gDICE_hand = gCENT_hand;

gDMCT = [mydmct_hc; mydmct_media; mydmct_media_nj; mydmct_ulnar; mydmct_ulnar_nj;...
    mydmct_both; mydmct_both_nj];
gDMCT_group = gCENT_group;
gDMCT_hand = gCENT_hand;

close all
figure('Position',[100 100 1200 1000])
clear g
g(1,1) = gramm('x',gCENT_group,'y',gCENT,'color',gCENT_hand);
g(1,1).geom_jitter
g(1,1).stat_boxplot2('width', 0.5, 'dodge', 0.8, 'alpha', 0.5, 'linewidth', 1, 'drawoutlier',0)
g(1,1).set_title('central tendency')
%g(1,1).axe_property('YLim',[0 20])

g(1,2) = gramm('x',gDICE_group,'y',gDICE,'color',gDICE_hand);
g(1,2).geom_jitter
g(1,2).stat_boxplot2('width', 0.5, 'dodge', 0.8, 'alpha', 0.5, 'linewidth', 1, 'drawoutlier',0)
g(1,2).set_title('dice')
g(1,2).axe_property('YLim',[0 5])

g(2,1) = gramm('x',gDMCT_group,'y',gDMCT,'color',gDMCT_hand);
g(2,1).geom_jitter
g(2,1).stat_boxplot2('width', 0.5, 'dodge', 0.8, 'alpha', 0.5, 'linewidth', 1, 'drawoutlier',0)
g(2,1).set_title('dmct')
g(2,1).axe_property('YLim',[0 5])

g(2,2) = gramm('x',gCENT_diags_group,'y',gCENT_diags,'color',gCENT_diags_hand);
g(2,2).geom_jitter
g(2,2).stat_boxplot2('width', 0.5, 'dodge', 0.8, 'alpha', 0.5, 'linewidth', 1, 'drawoutlier',0)
g(2,2).set_title('CT: diagonals')
%g(1,4).axe_property('YLim',[-0.5 1.5])


g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_order_options('x',0)
g.set_point_options('base_size',12)
g.axe_property('XGrid','on','YGrid','on')
g.set_names('x','Group','y', 'Sum of Off diagonals')
g(2,2).set_names('y', 'Distance from 1 on diagonal')

g.draw()
filename = 'offdiagsumplot';
g.export('file_name',filename, ...
    'export_path',...
    ['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'],...
    'file_type','pdf')


%% can we correlate something to the time from repair????

DSR_LR = [days_since_repair_injured_LD days_since_repair_injured_RD];



DSR_LR_hand = [repmat({'LD'},length(mycent_LD_inj),1);...
    repmat({'RD'},length(mycent_RD_inj),1)];


clear g
figure('Position',[100 100 1000 800])
g(1,1) = gramm('x',DSR_LR,'y',mycent_inj,'color',DSR_LR_hand);
g(1,1).geom_point()
g(1,1).set_names('x','Days since repair','y','sum of off diagonals CT Injured')
g(1,1).axe_property('YLim',[0 20])
g(1,2) = gramm('x',DSR_LR,'y',mydmct_inj,'color',DSR_LR_hand);
g(1,2).geom_point()
g(1,2).set_names('x','Days since repair','y','sum of off diagonals DICE Injured')
g(1,2).axe_property('YLim',[0 5])
g(2,1) = gramm('x',DSR_LR,'y',mydice_inj,'color',DSR_LR_hand);
g(2,1).geom_point()
g(2,1).set_names('x','Days since repair','y','sum of off diagonals DMCT Injured')
g(2,1).axe_property('YLim',[0 5])
g(2,2) = gramm('x',DSR_LR,'y',mycent_diags_inj,'color',DSR_LR_hand);
g(2,2).geom_point()
g(2,2).set_names('x','Days since repair','y','distance from 1 diagonals CT Injured')
g(2,2).axe_property('YLim',[-0.5 1.5])

g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',12)
g.axe_property('XGrid','on','YGrid','on')
g.draw()
filename = 'days_since_repair_injured';
g.export('file_name',filename, ...
    'export_path',...
    ['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'],...
    'file_type','pdf')


%% Can we plot histogram of DSR vs ulnar or median injury
DSR_LR = [days_since_repair_LD_media days_since_repair_RD_media];
DSR_LR_hand = [repmat({'LD'},length(mycent_LD_media),1);...
    repmat({'RD'},length(mycent_RD_media),1)];
clear g
figure('Position',[100 100 1000 800])
g(1,1) = gramm('x',DSR_LR,'y',mycent_media,'color',DSR_LR_hand);
g(1,1).geom_point()
g(1,1).set_names('x','Days since repair','y','sum of off diagonals CT Median')
g(1,1).axe_property('YLim',[0 20])
g(1,2) = gramm('x',DSR_LR,'y',mydmct_media,'color',DSR_LR_hand);
g(1,2).geom_point()
g(1,2).set_names('x','Days since repair','y','sum of off diagonals DICE Median')
g(1,2).axe_property('YLim',[0 5])
g(2,1) = gramm('x',DSR_LR,'y',mydice_media,'color',DSR_LR_hand);
g(2,1).geom_point()
g(2,1).set_names('x','Days since repair','y','sum of off diagonals DMCT Median')
g(2,1).axe_property('YLim',[0 5])
g(2,2) = gramm('x',DSR_LR,'y',mycent_diags_media,'color',DSR_LR_hand);
g(2,2).geom_point()
g(2,2).set_names('x','Days since repair','y','distance from 1 diagonals CT Median')
g(2,2).axe_property('YLim',[-0.5 1.5])

g.axe_property('XLim',[0 4000])

g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',12)
g.axe_property('XGrid','on','YGrid','on')
g.draw()
filename = 'days_since_repair_media';
g.export('file_name',filename, ...
    'export_path',...
    ['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'],...
    'file_type','pdf')

DSR_LR = [days_since_repair_LD_ulnar days_since_repair_RD_ulnar];
DSR_LR_hand = [repmat({'LD'},length(mycent_LD_ulnar),1);...
    repmat({'RD'},length(mycent_RD_ulnar),1)];
clear g
figure('Position',[100 100 1000 800])
g(1,1) = gramm('x',DSR_LR,'y',mycent_ulnar,'color',DSR_LR_hand);
g(1,1).geom_point()
g(1,1).set_names('x','Days since repair','y','sum of off diagonals CT Ulnar')
g(1,1).axe_property('YLim',[0 20])
g(1,2) = gramm('x',DSR_LR,'y',mydmct_ulnar,'color',DSR_LR_hand);
g(1,2).geom_point()
g(1,2).set_names('x','Days since repair','y','sum of off diagonals DICE Ulnar')
g(1,2).axe_property('YLim',[0 5])
g(2,1) = gramm('x',DSR_LR,'y',mydice_ulnar,'color',DSR_LR_hand);
g(2,1).geom_point()
g(2,1).set_names('x','Days since repair','y','sum of off diagonals DMCT Ulnar')
g(2,1).axe_property('YLim',[0 5])
g(2,2) = gramm('x',DSR_LR,'y',mycent_diags_ulnar,'color',DSR_LR_hand);
g(2,2).geom_point()
g(2,2).set_names('x','Days since repair','y','distance from 1 diagonals CT Ulnar')
g(2,2).axe_property('YLim',[-0.5 1.5])
g.axe_property('XLim',[0 4000])

g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',12)
g.axe_property('XGrid','on','YGrid','on')
g.draw()
filename = 'days_since_repair_ulnar';
g.export('file_name',filename, ...
    'export_path',...
    ['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'],...
    'file_type','pdf')
%%

%
% for ii = 1:2
%
%     figure('Position',[100 100 1200 600])
% 
%     if ii == 1
% 
%         % INJURED
%         mycent_LD_inj = offDiags_cent_L(:,:,LD_inj_idx);
%         mycent_RD_inj = offDiags_cent_R(:,:,RD_inj_idx);
% 
%         mydice_LD_inj = offDiags_dice_L(:,:,LD_inj_idx);
%         mydice_RD_inj = offDiags_dice_R(:,:,RD_inj_idx);
% 
%         mydmct_LD_inj = offDiags_dmct_L(:,:,LD_inj_idx);
%         mydmct_RD_inj = offDiags_dmct_R(:,:,RD_inj_idx);
% 
%         filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
%             'injured_offdiags');
% 
% 
%     elseif ii == 2
%         % NONINJURED
%         mycent_LD_inj = offDiags_cent_L(:,:,RD_inj_idx);
%         mycent_RD_inj = offDiags_cent_R(:,:,LD_inj_idx);
% 
%         mydice_LD_inj = offDiags_dice_L(:,:,RD_inj_idx);
%         mydice_RD_inj = offDiags_dice_R(:,:,LD_inj_idx);
% 
%         mydmct_LD_inj = offDiags_dmct_L(:,:,RD_inj_idx);
%         mydmct_RD_inj = offDiags_dmct_R(:,:,LD_inj_idx);
% 
%         filename = fullfile(['/Users/' userName '/The University of Nottingham/Touch ReMap - General/results/'], ...
%             'noninjured_offdiags');
% 
% 
%     end
% 
% 
% 
% 
%     % mean
%     mycent_LD_inj_mean = mean(mycent_LD_inj,3);
%     mycent_RD_inj_mean = mean(mycent_RD_inj,3);
% 
%     mydice_LD_inj_mean = mean(mydice_LD_inj,3);
%     mydice_RD_inj_mean = mean(mydice_RD_inj,3);
% 
%     mydmct_LD_inj_mean = mean(mydmct_LD_inj,3);
%     mydmct_RD_inj_mean = mean(mydmct_RD_inj,3);
% 
%     % std
%     mycent_LD_inj_std = std(mycent_LD_inj,0,3);
%     mycent_RD_inj_std = std(mycent_RD_inj,0,3);
% 
%     mydice_LD_inj_std = std(mydice_LD_inj,0,3);
%     mydice_RD_inj_std = std(mydice_RD_inj,0,3);
% 
%     mydmct_LD_inj_std = std(mydmct_LD_inj,0,3);
%     mydmct_RD_inj_std = std(mydmct_RD_inj,0,3);
% 
%     % build matrices
%     buildMat_cent_inj_LD = [mycent_LD_inj_mean; myempty];
%     buildMat_cent_inj_RD = [myempty; mycent_RD_inj_mean];
%     Mat_cent_inj = [buildMat_cent_inj_LD,buildMat_cent_inj_RD];
% 
%     buildMat_dice_inj_LD = [mydice_LD_inj_mean; myempty];
%     buildMat_dice_inj_RD = [myempty; mydice_RD_inj_mean];
%     Mat_dice_inj = [buildMat_dice_inj_LD,buildMat_dice_inj_RD];
% 
%     buildMat_dmct_inj_LD = [mydmct_LD_inj_mean; myempty];
%     buildMat_dmct_inj_RD = [myempty; mydmct_RD_inj_mean];
%     Mat_dmct_inj = [buildMat_dmct_inj_LD,buildMat_dmct_inj_RD];
%     % std matrices
%     buildMat_cent_inj_LD = [mycent_LD_inj_std; myempty];
%     buildMat_cent_inj_RD = [myempty; mycent_RD_inj_std];
%     Mat_cent_inj_std = [buildMat_cent_inj_LD,buildMat_cent_inj_RD];
% 
%     buildMat_dice_inj_LD = [mydice_LD_inj_std; myempty];
%     buildMat_dice_inj_RD = [myempty; mydice_RD_inj_std];
%     Mat_dice_inj_std = [buildMat_dice_inj_LD,buildMat_dice_inj_RD];
% 
%     buildMat_dmct_inj_LD = [mydmct_LD_inj_std; myempty];
%     buildMat_dmct_inj_RD = [myempty; mydmct_RD_inj_std];
%     Mat_dmct_inj_std = [buildMat_dmct_inj_LD,buildMat_dmct_inj_RD];
% 
%     tiledlayout(2,3)
%     nexttile
%     imagesc(Mat_cent_inj)
%     title('CT mean')
%     colormap(mapcol)
%     colorbar
%     xticks(1:10)
%     yticks(1:10)
%     xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
%     yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
%     xtickangle(45)
%     ytickangle(45)
%     ax = gca;
%     ax.FontSize = 10;
%     set(gcf,'color', 'w');
%     axis square
%     clim([a b])
%     nexttile
%     imagesc(Mat_dice_inj)
%     title('dice mean')
%     colormap(mapcol)
%     colorbar
%     xticks(1:10)
%     yticks(1:10)
%     xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
%     yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
%     xtickangle(45)
%     ytickangle(45)
%     ax = gca;
%     ax.FontSize = 10;
%     set(gcf,'color', 'w');
%     axis square
%     clim([a b])
%     nexttile
%     imagesc(Mat_dmct_inj)
%     title('dmct mean')
%     colormap(mapcol)
%     colorbar
%     xticks(1:10)
%     yticks(1:10)
%     xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
%     yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
%     xtickangle(45)
%     ytickangle(45)
%     ax = gca;
%     ax.FontSize = 10;
%     set(gcf,'color', 'w');
%     axis square
%     clim([a b])
% 
%     nexttile
%     imagesc(Mat_cent_inj_std)
%     title('CT std')
%     colormap(mapcol)
%     colorbar
%     xticks(1:10)
%     yticks(1:10)
%     xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
%     yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
%     xtickangle(45)
%     ytickangle(45)
%     ax = gca;
%     ax.FontSize = 10;
%     set(gcf,'color', 'w');
%     axis square
%     clim([a b])
%     nexttile
%     imagesc(Mat_dice_inj_std)
%     title('dice std')
%     colormap(mapcol)
%     colorbar
%     xticks(1:10)
%     yticks(1:10)
%     xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
%     yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
%     xtickangle(45)
%     ytickangle(45)
%     ax = gca;
%     ax.FontSize = 10;
%     set(gcf,'color', 'w');
%     axis square
%     clim([a b])
%     nexttile
%     imagesc(Mat_dmct_inj_std)
%     title('dmct std')
%     colormap(mapcol)
%     colorbar
%     xticks(1:10)
%     yticks(1:10)
%     xticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
%     yticklabels({'LD1','LD2','LD3','LD4','LD5','RD1','RD2','RD3','RD4','RD5'});
%     xtickangle(45)
%     ytickangle(45)
%     ax = gca;
%     ax.FontSize = 10;
%     set(gcf,'color', 'w');
%     axis square
%     clim([a b])
% 
%     mappy = 'plasma';
%     ax = nexttile(2);
%     colormap(ax,mappy);
%     colorbar(ax)
%     clim([0 0.5])
% 
%     mappy2 = brewermap(64,'*Blues');
%     for axi = 4:6
%         ax_temp = nexttile(axi);
%         colormap(ax_temp,mappy2);
%         colorbar(ax_temp)
%         clim([0 1])
%     end
% 
%     set(gcf,'color', 'w');
% 
%     print(filename,'-dpng')
% 
% 
% end

