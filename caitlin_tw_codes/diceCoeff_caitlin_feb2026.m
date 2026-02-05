clear variables
close all
clc

subdir = '/Volumes/kratos/caitlin/subset/atlas/';
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName ...
    '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/' ...
    'Caitlin Michael - Sensorimotor - Documents/General/'];

subjects = {'Map01','Map02','Map03'};
nSubj = numel(subjects);
nD = 4;   % D2–D5

% Store Dice matrices: [D x D x subject]
DiceAll = zeros(nD, nD, nSubj);

for ii = 1:nSubj

    %RD_3T_v = zeros([], nD); 
    %RD_7T_v = zeros([], nD);

    for kk = 1:nD
        RD_3T = MRIread([subdir subjects{ii} '/3T/RD' num2str(kk+1) '_fsaverage_bin.mgh']);
        RD_7T = MRIread([subdir subjects{ii} '/7T/RD' num2str(kk+1) '_fsaverage_bin.mgh']);

        RD_3T_v(:,kk) = RD_3T.vol(:);
        RD_7T_v(:,kk) = RD_7T.vol(:);
    end

    % Dice for this subject
    DiceMat = zeros(nD, nD);

    for i = 1:nD
        A = RD_3T_v(:,i) > 0;
        for j = 1:nD
            B = RD_7T_v(:,j) > 0;
            DiceMat(i,j) = dice(A, B);
        end
    end

    % Store + save per subject
    DiceAll(:,:,ii) = DiceMat;
    %save(fullfile(savedir, ['Dice_' subjects{ii} '.mat']), 'DiceMat');


    

    % Plot the matrix
    figure;
    %title(['Dice coefficients: ' subjects{ii} ' (3T vs 7T)']);
    imagesc(DiceMat);
    title(['Dice coefficients: ' subjects{ii} ' (3T vs 7T)']);

    axis square;
    colorbar;
    colormap viridis
    clim([0 1]); % Dice is between 0 and 1

    xticks(1:4); yticks(1:4);
    xticklabels({'D2','D3','D4','D5'});
    yticklabels({'D2','D3','D4','D5'});

    xlabel('7T');
    ylabel('3T');

    print(gcf, '-dpng', fullfile(savedir, ['Dice_' subjects{ii} '.png']), '-r300');


end

%% plot mean
MeanDice = mean(DiceAll, 3);

print(gcf, '-dpng', fullfile(savedir, 'Dice_MEAN.png'), '-r300');

figure;
imagesc(MeanDice);
title(['Mean Dice coefficients (3T vs 7T) n=' num2str(length(subjects))]);

axis square;
colorbar;
colormap viridis
clim([0 1]); % Dice is between 0 and 1

xticks(1:4); yticks(1:4);
xticklabels({'D2','D3','D4','D5'});
yticklabels({'D2','D3','D4','D5'});

xlabel('7T');
ylabel('3T');

print(gcf, '-dpng', fullfile(savedir, 'Dice_MEAN.png'), '-r300');

