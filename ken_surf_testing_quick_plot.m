clear all
close all
clc

subs = '020';

% should be where your subject's digit data are
mypath = '/Users/spmic/data/ken_surf_testing/';
savedir = fullfile(mypath,subs);

hemisphere = 'l';
surface = 'inflated'; 
map = 'viridis';
nchips = 256;
mymin = 0.5;
myalpha = 1;

% set to where your freesurfer dirs are, e.g. 020 in this case
subdir='/Users/spmic/data/subs/';
setenv('SUBJECTS_DIR',subdir);

% print each digit on the native surface one by one
for ii = 1:5
    theFile = MRIread(fullfile(mypath, subs, ['RD' num2str(ii) '_020.mgz']));

    data = theFile.vol(:);

    figure
    go_paint_freesurfer(data,...
        subs,'l','range',...
        [0.1 1], 'cbar','colormap',map)
    print(fullfile(savedir, sprintf('RD_%d_inflated', ii)), '-dpdf', '-r600')


end

