%------------ FreeSurfer -----------------------------%
setenv('FREESURFER_HOME','/Applications/freesurfer');
fshome = getenv('FREESURFER_HOME');
fsmatlab = sprintf('%s/matlab',fshome);
if (exist(fsmatlab) == 7)
    path(path,fsmatlab);
end

clear fshome fsmatlab;
%-----------------------------------------------------%

%------------ FreeSurfer FAST ------------------------%
setenv('FSFAST_HOME','/Applications/freesurfer/fsfast');
fsfasthome = getenv('FSFAST_HOME');
fsfasttoolbox = sprintf('%s/toolbox',fsfasthome);
if (exist(fsfasttoolbox) == 7)
    path(path,fsfasttoolbox);
end
clear fsfasthome fsfasttoolbox;
%-----------------------------------------------------%


%% BASH->Matlab translation
FREESURFER_HOME='/Applications/freesurfer';

if exist(FREESURFER_HOME,'dir')
     % SUBJECTS_DIR='/data/freesurfer/subjects/';
     %SUBJECTS_DIR='/Users/ppxma7/data/subjects';
     SUBJECTS_DIR='/Volumes/TOUCHMAP/ma/subjects';
     MINC_BIN_DIR=[FREESURFER_HOME '/mni/bin'];
     MINC_LIB_DIR=[FREESURFER_HOME '/mni/lib'];
     MNI_INSTALL_DIR=[FREESURFER_HOME '/mni'];
     % export SUBJECTS_DIR MINC_BIN_DIR  MINC_LIB_DIR MNI_INSTALL_DIR
     setenv('SUBJECTS_DIR',SUBJECTS_DIR);
     setenv('MINC_BIN_DIR',MINC_BIN_DIR);   
     setenv('MINC_LIB_DIR',MINC_LIB_DIR);
     setenv('MNI_INSTALL_DIR',MNI_INSTALL_DIR);
     setenv('PATH', [getenv('PATH') ':' MINC_BIN_DIR ':' MINC_LIB_DIR ':' MNI_INSTALL_DIR ':/Applications/freesurfer/bin'])
 
    % # reset FSL output type to NIFTI_PAIR, so our tools work w/ default file format.
     %setenv('FSLOUTPUTTYPE','NIFTI_PAIR');  
     setenv('FSLOUTPUTTYPE','NIFTI_GZ');  
 
     system(['source ' FREESURFER_HOME '/SetUpFreeSurfer.sh >/dev/null']);

     disp('Freesurfer initialized')
end

%% fsl
fsl_path = '/usr/local/fsl';
setenv('FSLDIR', fsl_path);
%setenv('FSLOUTPUTTYPE', 'NIFTI_PAIR');
curpath = getenv('PATH');
setenv('PATH', sprintf('%s:%s',fullfile(fsl_path, 'bin'), curpath));

fsldir = getenv('FSLDIR');
fsldirmpath = sprintf('%s/etc/matlab',fsldir);
path(path, fsldirmpath);
setenv('PATH', [getenv('PATH') ':/usr/local/fsl/bin']);

%%
% Change default axes fonts.
set(0,'DefaultAxesFontName', 'Helvetica') % or whatever font you fancy
set(0,'DefaultAxesFontSize', 16)
 
% Change default text fonts.
set(0,'DefaultTextFontname', 'Helvetica')
set(0,'DefaultTextFontSize', 16)

%% spm12
% if exist('launchSPM','file')
%     launchSPM
% else
%     disp('Whoops! looking for launchSPM.m check your spm12 installation!')
% end
% 

%%
mountPoint = '/Users/ppzma/Documents/MATLAB/';
otherMountPoint = '/Users/ppzma/data';
addpath(genpath(mountPoint));
addpath(genpath(otherMountPoint));

%spm_rmpath
%rmpath /Users/ppama3/MATLAB/spm12

%rmpath('/Users/ppzma/Documents/MATLAB/Somato_Stimulation/');

rmpath('/Users/ppzma/Documents/MATLAB/mrTools_custom');

rmpath(genpath('CanlabCore'))
rmpath(genpath('NPS_share'))



addpath /Applications/freesurfer/matlab/

% cool stuff (-_- )    (=^.^=)
% c = clock;
% morning = c(4)>=0 & c(4)<12;
% afternoon = c(4)>=12 & c(4)<18;
% evening = c(4)>=18 & c(4)<=23;
% 
% if true(morning)
%     timeofday = 'Morning';
% elseif true(afternoon)
%     timeofday = 'Afternoon';
% elseif true(evening)
%     timeofday = 'Evening';
%     fprintf('\nWHAT THE HELL ARE YOU STILL DOING HERE?');
% else
%     timeofday = 'day';
% end
% 
% d = date;
% fprintf('\nIt is the %s\n', d)
% 
% 
% t = weekday(datestr(now));
% 
% if t == 1
%     fprintf('\nIT''S SUNDAY %s MICHAEL. GO HOME\n\n', timeofday)
% elseif t == 7
%     fprintf('\nIT''S SATURDAY %s MICHAEL. GO HOME\n\n', timeofday)
% elseif t == 2 && strcmp(timeofday,'MORNING')
%     fprintf('\nMONDAY %s''S ARE FOR COFFEE AND CONTEMPLATION.\n\n', timeofday)
% elseif t ~= 1||7
%     fprintf('\nGood %s Michael\n\n', timeofday)
% end
% 
% %fprintf('Hi Dad :)\n\n')
% 
% if c([2 3]) == [11 10]
% disp('Happy Birthday!')
% elseif c([2 3]) == [12 25]
% disp('Merry Christmas!')
% end

% pause(1)
%clc
clear variables 
close all

mrSetPref('niftiFileExtension','.nii');

% bank = {'ONE ROW AT A TIME, ONE COLUMN AT A TIME, ONE MATRIX AT A TIME'};
% quote = bank(randperm(numel(bank),1));
% x = 1:7;
% x = x(randperm(numel(x),1));
% if x == 1
%     disp(quote);
% end


%fprintf('\nGOOD %s MICHAEL\n\n', timeofday)
%disp(['Good ' num2str(timeofday) ', Michael'])




% FSL Setup
setenv( 'FSLDIR', '/usr/local/fsl' );
setenv('FSLOUTPUTTYPE', 'NIFTI_GZ');
fsldir = getenv('FSLDIR');
fsldirmpath = sprintf('%s/etc/matlab',fsldir);
path(path, fsldirmpath);
clear fsldir fsldirmpath;

