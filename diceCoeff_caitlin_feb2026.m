

subdir = '/Volumes/nemosine/caitlin_data/atlas/';
userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/caitlin/'];

sub3T = {'3T'};
sub7T = {'7T'};

for ii = 1:length(sub3T)

    for kk = 1:4

        RD_3T = MRIread([subdir sub3T{ii} '/' 'RD' num2str(kk+1) '_fsaverage.mgh']);
        RD_7T = MRIread([subdir sub7T{ii} '/' 'RD' num2str(kk+1) '_fsaverage.mgh']);

        RD_3T_v(:,kk) = RD_3T.vol(:);
        RD_7T_v(:,kk) = RD_7T.vol(:);

        disp('loaded')
        
    end

end



%%

% Preallocate Dice matrix
DiceMat = zeros(4,4);

for i = 1:4   % columns in 3T (D2–D5)
    A = RD_3T_v(:,i) > 0;   % convert to binary mask
    
    for j = 1:4   % columns in 7T (D2–D5)
        B = RD_7T_v(:,j) > 0; % convert to binary mask
        
        % Use MATLAB's built-in dice
        DiceMat(i,j) = dice(A, B);
    end
end

% Plot the matrix
figure;
imagesc(DiceMat);
axis square;
colorbar;
colormap viridis
clim([0 1]); % Dice is between 0 and 1

xticks(1:4); yticks(1:4);
xticklabels({'D2','D3','D4','D5'});
yticklabels({'D2','D3','D4','D5'});

xlabel('7T');
ylabel('3T');
title('Dice coefficients (RD, fsaverage)');

thisFilename = fullfile(savedir, 'dice_plot');
h = gcf;
print(h, '-dpdf', thisFilename, '-r600');
