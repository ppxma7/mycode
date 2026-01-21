close all
clear variables
clc


basedir = '/Volumes/DRS-GBPerm/other/outputs/FS_aseg_stats_prepost_SASHB';
xlsxfile = fullfile(basedir,'aseg_sashb.xlsx');

groupNames = 'sashbprepost';

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/freesurfer_plots/' groupNames '/'];

% --- read Excel metadata ---
meta = readtable(xlsxfile);

% enforce string IDs
meta.ID = string(meta.ID);

% --- list aseg stats ---
files = dir(fullfile(basedir,'aseg_*.stats'));

n = numel(files);

GM  = nan(n,1);
WM  = nan(n,1);
CSF = nan(n,1);
ID  = strings(n,1);

for i = 1:n
    fname = fullfile(basedir,files(i).name);

    tok = regexp(files(i).name,'aseg_(.*)\.stats','tokens','once');
    ID(i) = tok{1};

    [GM(i), WM(i), CSF(i)] = extract_aseg_vols(fname);
end

% --- assemble table ---
asegT = table(ID, GM, WM, CSF);

% --- merge with Excel ---
D = innerjoin(meta, asegT, 'Keys','ID');

% --- normalise by TIV ---
D.GMfrac  = D.GM  ./ D.TIV;
D.WMfrac  = D.WM  ./ D.TIV;
D.CSFfrac = D.CSF ./ D.TIV;

%disp(D(:,{'ID','AGE','GROUP','GMfrac','WMfrac','CSFfrac'}));
disp(D)

% need to plot things now
G = cellstr(num2str(D.GROUP));
G(G=="1") = {'pre-dialysis'};
G(G=="2") = {'post-dialysis'};

gid = cellstr(D.ID);
gid_names = extractAfter(gid,'_');

%%
clear g
close all

%cmap = {'#e31a1c','#fd8d3c','#0570b0','#74a9cf'};
cmap = {'#2b8cbe','#a6bddb','#ece7f2','#74a9cf'};

cmapped = validatecolor(cmap,'multiple');
comesInBlack = ones(4,3).*0.6;

figure('Position',[100 100 600 600])
g = gramm('x',G,'y',D.GMfrac);
g.stat_boxplot2() %'drawoutlier',0);
g.axe_property('YGrid','on','XGrid','on');
g.set_names('y','GMV/TIV','x',[])
g.set_order_options('x',0)
g.set_color_options('map',cmapped)
g.draw()

g.update('y',D.GMfrac)
g.geom_jitter2()
g.set_color_options('map',comesInBlack)
g.draw()

g.update('label',gid_names)
g.geom_label('dodge',10,'Color','k')
g.draw()

filename = 'sashb_gmv';
g.export('file_name', ...
    fullfile(savedir,filename), ...
    'file_type','pdf');


figure('Position',[100 100 600 600])
g = gramm('x',G,'y',D.WMfrac);
g.stat_boxplot2() %'drawoutlier',0);
g.axe_property('YGrid','on','XGrid','on');
g.set_names('y','WMV/TIV','x',[])
g.set_order_options('x',0)
g.set_color_options('map',cmapped)
g.draw()

g.update('y',D.WMfrac)
g.geom_jitter2()
g.set_color_options('map',comesInBlack)
g.draw()

g.update('label',gid_names)
g.geom_label('dodge',10,'Color','k')
g.draw()

filename = 'sashb_wmv';
g.export('file_name', ...
    fullfile(savedir,filename), ...
    'file_type','pdf');

figure('Position',[100 100 600 600])
g = gramm('x',G,'y',D.CSFfrac);
g.stat_boxplot2() %'drawoutlier',0);
g.axe_property('YGrid','on','XGrid','on');
g.set_names('y','CSF/TIV','x',[])
g.set_order_options('x',0)
g.set_color_options('map',cmapped)
g.draw()

g.update('y',D.CSFfrac)
g.geom_jitter2()
g.set_color_options('map',comesInBlack)
g.draw()

g.update('label',gid_names)
g.geom_label('dodge',10,'Color','k')
g.draw()

filename = 'sashb_CSF';
g.export('file_name', ...
    fullfile(savedir,filename), ...
    'file_type','pdf');



figure('Position',[100 100 600 600])
g = gramm('x',G,'y',D.TIV);
g.stat_boxplot2() %'drawoutlier',0);
g.axe_property('YGrid','on','XGrid','on');
g.set_names('y','TIV','x',[])
g.set_order_options('x',0)
g.set_color_options('map',cmapped)
g.draw()

g.update('y',D.TIV)
g.geom_jitter2()
g.set_color_options('map',comesInBlack)
g.draw()

g.update('label',gid_names)
g.geom_label('dodge',10,'Color','k')
g.draw()

filename = 'sashb_TIV';
g.export('file_name', ...
    fullfile(savedir,filename), ...
    'file_type','pdf');













%% functions
function [GM, WM, CSF] = extract_aseg_vols(fname)

fid = fopen(fname,'r');
assert(fid > 0, 'Cannot open %s', fname);

seg = [];
vol = [];

while ~feof(fid)
    line = fgetl(fid);

    if isempty(line) || startsWith(line,'#')
        continue
    end

    % Split on whitespace (robust)
    parts = regexp(strtrim(line),'\s+','split');

    % Expect: Index SegId NVoxels Volume_mm3 StructName
    if numel(parts) < 4
        continue
    end

    seg(end+1) = str2double(parts{2}); %#ok<AGROW>
    vol(end+1) = str2double(parts{4}); %#ok<AGROW>
end

fclose(fid);

% Canonical FreeSurfer aseg labels
GM  = sum(vol(ismember(seg,[3 42])));
WM  = sum(vol(ismember(seg,[2 41])));
CSF = sum(vol(ismember(seg,[4 5 14 15])));
end

%%
function out = ternary(cond,trueVal,falseVal)
if cond
    out = trueVal;
else
    out = falseVal;
end
end