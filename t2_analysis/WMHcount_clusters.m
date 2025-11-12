%% White matter hyperintensity mask quatifying
clear 

%VOXEL SIZE - EDIT if scan acquisition changed
vox = 1*1*1; %mm

%cluster group size maximum values
puncate=14; %puncate is less than this number %14
focal=900; %focal is less than this number but greater than puncate  %900
large=10000; %large is less than this number but greater than focal  %2000
%XL is greater than large number

%cluster size bands (expect XL) are taken from Wei Wen et al, https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6870596/#:~:text=WMHs%20in%20the%20deep%20white,diameter%20greater%20than%2012%20mm.


%change to change name of csv output file if needed
wmhcsvname = 'white_matter_hyperintensities_vols.csv'; 

[wFileName,wpath] = uigetfile({'*.nii.gz'},'Select white matter hyperintensity masks', 'MultiSelect','on'); 
cd(wpath)
wFileName = cellstr(wFileName);
for f=1:length(wFileName)
    clear wmhmask CC numPixels
    wmhmask = niftiread(wFileName{f});
    wmhniftiinfo = niftiinfo(wFileName{f});
    CC = bwconncomp(wmhmask);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    clusnumpuncate = numPixels(numPixels<puncate);
    clusnumfocal = numPixels(numPixels>puncate&numPixels<focal);
    clusnumlarge = numPixels(numPixels>focal&numPixels<large);
    clusnumXL = numPixels(numPixels>large);
    numclusters(f) = length(numPixels);
    meanclus(f) = mean(numPixels);
    stdevclus(f) = std(numPixels);
    numpuncate(f) = length(clusnumpuncate);
    meanpunctate(f) = mean(clusnumpuncate);
    stdevpunctate(f) = std(clusnumpuncate);
    sumpuncate(f) = sum(clusnumpuncate);
    numfocal(f) = length(clusnumfocal);
    meanfocal(f) = mean(clusnumfocal);
    stdevfocal(f) = std(clusnumfocal);
    sumfocal(f) = sum(clusnumfocal);
    numlarge(f) = length(clusnumlarge);
    meanlarge(f) = mean(clusnumlarge);
    stdevlarge(f) = std(clusnumlarge);
    sumlarge(f) = sum(clusnumlarge);
    numXL(f) = length(clusnumXL);
    meanXL(f) = mean(clusnumXL);
    stdevXL(f) = std(clusnumXL);
    sumXL(f) = sum(clusnumXL);
%     sorted = sort(numPixels, 'descend');
%     top3 = sorted(1:3);
    wmhcount(f) = sum(wmhmask, 'all');
    wmhvol(f) = wmhcount(f)*vox; 
end

wFileName = wFileName';
wmhcount = wmhcount';
wmhvol = wmhvol';
numclusters = numclusters';
meanclus = meanclus';
stdevclus = stdevclus';
numpuncate = numpuncate';
meanpunctate = meanpunctate';
stdevpunctate =stdevpunctate';
sumpuncate = sumpuncate';
numfocal = numfocal';
meanfocal = meanfocal';
stdevfocal =stdevfocal';
sumfocal = sumfocal';
numlarge = numlarge';
meanlarge= meanlarge';
stdevlarge =stdevlarge';
sumlarge = sumlarge';
numXL= numXL';
meanXL = meanXL';
stdevXL = stdevXL';
sumXL= sumXL';

wmhtable = table(wFileName, wmhcount, wmhvol,numclusters, meanclus, stdevclus, numpuncate, meanpunctate, stdevpunctate,sumpuncate,numfocal, meanfocal,stdevfocal,sumfocal,numlarge,meanlarge,stdevlarge,sumlarge,numXL,meanXL,stdevXL,sumXL);

writetable(wmhtable, wmhcsvname);

