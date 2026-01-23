%% Load in chain dti data and plot means
thisType = 'MD';
root = ['/Volumes/DRS-CHAIN-Study/dti_data/dti_' thisType '/'];

savedgroup = 'chain_dti';

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/' savedgroup '/'];


files = dir(root);
fileTable = struct2table(files);
fileNames = fileTable.name;
niftiFileNames = fileNames(contains(fileNames,'.nii.gz'));

fprintf('Found %d files\n',length(niftiFileNames))

idx6 = contains(niftiFileNames, 'V6', 'IgnoreCase', true);
idx13 = contains(niftiFileNames, 'V13', 'IgnoreCase', true);
idx20 = contains(niftiFileNames, 'V20', 'IgnoreCase', true);
idx33 = contains(niftiFileNames, 'V33', 'IgnoreCase', true);

filenames_v6 = niftiFileNames(idx6);
filenames_v13 = niftiFileNames(idx13);
filenames_v20 = niftiFileNames(idx20);
filenames_v33 = niftiFileNames(idx33);

fullList = cat(1,filenames_v6,filenames_v13,filenames_v20,filenames_v33);

groupList = [repmat({'v6'},length(filenames_v6),1); ...
    repmat({'v13'},length(filenames_v13),1); ...
    repmat({'v20'},length(filenames_v20),1); ...
    repmat({'v33'},length(filenames_v33),1)];

vm = zeros(length(fullList),1);
for ii = 1:length(fullList)

    thisFile = fullfile(root, fullList{ii});
    thisFileContents = niftiread(thisFile);
    fprintf('Getting nonzero mean of %s\n',fullList{ii})
    v = thisFileContents(:);
    vm(ii) = mean(nonzeros(v));
end

% get labels
idList = cellfun(@(x) x(1:6), fullList, 'UniformOutput', false);

%% just plot these out for now
clear g
close all
cmap = {'#2b8cbe','#a6bddb','#ece7f2','#74a9cf'};
cmapped = validatecolor(cmap,'multiple');
comesInBlack = ones(4,3).*0.6;

figure('Position',[100 100 1000 600])
g = gramm('x',groupList,'y',vm);
g.stat_boxplot2('drawoutlier',0);
g.set_names('x','Group','y',['Mean ' thisType]);
%g.set_names('x','ROI','y','Mean T1','color','Group');
%g.set_point_options('base_size',1)
%g.axe_property('XTickLabelRotation',45,'YLim',[0 1],'YGrid','on','XGrid','on');
g.axe_property('XTickLabelRotation',45,'YGrid','on','XGrid','on') %,'YLim',[0.2 0.4]);
g.set_order_options('x',0)
g.set_color_options('map',cmapped)
g.draw();

g.update('y',vm)
g.geom_jitter2()
g.set_color_options('map',comesInBlack)
g.draw()

% g.update('label',idList)
% g.geom_label('dodge',10,'Color','k')
% g.draw()

g.export('file_name', ...
    fullfile(savedir,thisType), ...
    'file_type','pdf');
