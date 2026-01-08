% mypath='/Volumes/nemosine/SAN/SASHB/outputs';
% subjects={'16905_004','16905_005','17880001','17880002'};
close all
clear variables
clc

suffix='CHAIN';
%mypath='/Volumes/nemosine/SAN/AFIRM/afirm_new_outs/';

mypath='/Volumes/DRS-GBPerm/other/outputs/';

subjects={'1688-002C', '15234-003B', '16469-002A','16498-002A',...
'16500-002B', '16501-002b','16521-001b','16523_002b','16602-002B',...
'16707-002A','16708-03A','16797-002C','16798-002A','16821-002A',...
'16835-002A','16885-002A','16994-002A','16999-002B','17057-002C',...
'17058-002A','17059-002a','17311-002b'};

%,'16998-002'};

% subjects={'16905_004','16905_005','17880001','17880002','156862_004', '156862_005',...
%     'SASHB_5_1', 'SASHB_5_2', 'SASHB_6_1', 'SASHB_6_2', 'SASHB_7_2'}

%,'SASHB_7_2'};

subjects={'CHN001_V6_C','CHN002_V6_C', 'CHN003_V6_C','CHN005_v6_redo_C',...
    'CHN006_V6_C', 'CHN007_V6_C', 'CHN008_V6_DTI_C', 'CHN009_V6_C',...
    'CHN010_V6_2_DTI_C','CHN012','CHN013_v6_classic','CHN014_V6_DTI_C',...
    'CHN015_V6_DTI_C','CHN019_V6_C'};



% legacy fixed vars
puncate=14; %puncate is less than this number %14
focal=900; %focal is less than this number but greater than puncate  %900
large=10000; %large is less than this number but greater than focal  %2000

tic
for ii = 1:length(subjects)
    disp(['Running subject ' subjects{ii}])
    thismask = fullfile(subjects{ii},'analysis/anatMRI/T2/preproc/lesions/final_mask.nii.gz');
    % Load the mask for the current subject
    maskData = niftiread(fullfile(mypath, thismask));
    maskDataInfo = niftiinfo(fullfile(mypath, thismask));

    vox = maskDataInfo.PixelDimensions(1)*maskDataInfo.PixelDimensions(2)*maskDataInfo.PixelDimensions(3);
    
    CC = bwconncomp(maskData);
    numPixels = cellfun(@numel,CC.PixelIdxList);

    % Define categories
    categories.total      = numPixels;
    categories.punctate = numPixels(numPixels < puncate);
    categories.focal    = numPixels(numPixels > puncate & numPixels < focal);
    categories.large    = numPixels(numPixels > focal   & numPixels < large);
    categories.XL       = numPixels(numPixels > large);

    % Initialise stats struct for subject f
    stats(ii).categories = struct();

    % Loop through each category
    fn = fieldnames(categories);
    for jj = 1:numel(fn)
        vals = categories.(fn{jj});
        stats(ii).categories.(fn{jj}) = struct( ...
            'num',   numel(vals), ...
            'mean',  mean(vals), ...
            'stdev', std(vals), ...
            'sum',   sum(vals) ...
            );
    end

    % Add WMH metrics
    stats(ii).wmh = struct( ...
        'count', sum(maskData, 'all'), ...
        'vol',   sum(maskData, 'all') * vox ...
        );

end
toc

%%
% Helper to extract values from nested struct fields across all subjects
getval = @(f1,f2,f3) arrayfun(@(s) s.(f1).(f2).(f3), stats)';

% Extract metrics from stats into column vectors
numclusters   = getval('categories','total','num');
meanclus      = getval('categories','total','mean');
stdevclus     = getval('categories','total','stdev');

numpunctate   = getval('categories','punctate','num');
meanpunctate  = getval('categories','punctate','mean');
stdevpunctate = getval('categories','punctate','stdev');
sumpunctate   = getval('categories','punctate','sum');

numfocal      = getval('categories','focal','num');
meanfocal     = getval('categories','focal','mean');
stdevfocal    = getval('categories','focal','stdev');
sumfocal      = getval('categories','focal','sum');

numlarge      = getval('categories','large','num');
meanlarge     = getval('categories','large','mean');
stdevlarge    = getval('categories','large','stdev');
sumlarge      = getval('categories','large','sum');

numXL         = getval('categories','XL','num');
meanXL        = getval('categories','XL','mean');
stdevXL       = getval('categories','XL','stdev');
sumXL         = getval('categories','XL','sum');

wmhcount      = arrayfun(@(s) s.wmh.count, stats)';
wmhvol        = arrayfun(@(s) s.wmh.vol, stats)';

% Build the table
wmhtable = table(subjects', wmhcount, wmhvol, ...
    numclusters, meanclus, stdevclus, ...
    numpunctate, meanpunctate, stdevpunctate, sumpunctate, ...
    numfocal, meanfocal, stdevfocal, sumfocal, ...
    numlarge, meanlarge, stdevlarge, sumlarge, ...
    numXL, meanXL, stdevXL, sumXL);

% Save to CSV
writetable(wmhtable, fullfile(mypath,['t2lesiontable_' suffix '.csv']));
