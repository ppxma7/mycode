close all
clear variables
clc


basedir = '/Volumes/DRS-GBPerm/other/outputs/FS_aseg_stats_prepost_SASHB';
xlsxfile = fullfile(basedir,'aseg_sashb.xlsx');

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

%% need to plot things now



%%
















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