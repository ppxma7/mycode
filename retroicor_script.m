
close all
clear variables
clc
tic
disp('Starting up RETROICOR...')
retPath = '/Volumes/kratos/SOFYA/12185_004/spl2/';
cd(retPath)
MB = 2;
rinput = [retPath '/12185_004_WIP_fMRI_RS_20220804125939_1001_nordic.nii'];
input_marker = [retPath 'SCANPHYSLOG20220804140114.log'];
[folder, name, ext] = fileparts(input_marker);
markerfile = fullfile(folder, [name '_markers' ext]);
disp(markerfile)

disp('First run add markers')
AddMarkers_fast(input_marker)
pause(3)

disp('Now run retroicor')
retroicor_noquestion(retPath,'y',2,2,2,MB,'y','b','y',rinput,markerfile)
disp('RETROICOR is complete')
toc