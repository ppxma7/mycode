function []=makeDigitROIs_BD_caitlin()

% Create individual digit ROIS by dividing phase map into 5 bins
% Digit 1: [0, 2*pi/5]
% Digit 2: [2*pi/5, 4*pi/5*]
% Digit 3: [4*pi/5, 6*pi/5*]
% Digit 4: [6*pi/5, 8*pi/5*]
% Digit 5: [8*pi/5, 2*pi]
%         by: sanchez-panchuelo, used some bits from project's students (Boreham)
%       date: 2017-Jan
%inputs:      - path: path whith locations of files (DigitMask_LD, co_LD and ph_LD)
%             - n= number of volumes in the analysis (needed to convert coherence to P
%    outputs: maps for each digit (D1, ... ,D5)
%
%path = '/data/projects/DigitAtlas/sub1/';
%
% nov2018 [ma] edited with my paths
%
%if nargin==0




% elseif nargin==1
%     n = 80;
% end

numDigs = 4;

%cd(path)

mypath = '/Volumes/kratos/caitlin/subset/atlas/';
%n = 96; %64 96

subs = {'Map01','Map02','Map03'};

modality = {'7T'};
if strcmpi(modality,'3T')
    n = 96;
elseif strcmpi(modality,'7T')
    n = 64;
end


for ii = 1:length(subs)

    %cd([path subs{ii}]);

    thispath = fullfile(mypath,subs{ii},modality);
    thispath = char(thispath);


    disp(['Working through subject ' subs{ii}])

    [thismask]=niftiread(fullfile(thispath,'cothr.nii'));
    [HdrMask]=niftiinfo(fullfile(thispath,'cothr.nii'));
    %[CO hdr2]=cbiReadNifti('co_LD.nii');
    [CO]=niftiread(fullfile(thispath,'co.nii'));
    [PH]=niftiread(fullfile(thispath,'ph.nii'));

    % PH = double(PH);

    HdrCO = niftiinfo(fullfile(thispath,'co.nii'));
    HdrPH = niftiinfo(fullfile(thispath,'ph.nii'));

    %n=80;

    mySize = size(CO);

    CO = CO(:);
    PH = PH(:);
    thismask = thismask(:);
    %thismask = logical(thismask);

    %thismask = ~isnan(thismask);
    thismask = logical(thismask);



    P=coherenceToP(CO,n);
    pValThresh = coherenceToP(0.4,n);
    Pdata = P;
    %pValThresh = 0.05;
    index = Pdata<pValThresh;
    index_masked = logical(thismask.*index);
    %index_masked = logical(index); % don't mask

    PH(not(index_masked))=nan;
    CO(not(index_masked))=nan; % comment this this if you want to keep all CO


    PH = reshape(PH,mySize);
    CO = reshape(CO,mySize);


    niftiwrite(PH,fullfile(thispath,'ph_masked'), HdrPH);
    niftiwrite(CO,fullfile(thispath,'co_masked'), HdrCO);

    D5_idx=PH>(2*pi/numDigs)*(numDigs-1);
    D5=zeros(size(PH));
    D5(D5_idx)=1;
    D5 = logical(D5);
    D5 = single(D5);
    HdrMask.Datatype = 'single';
    HdrMask.MultiplicativeScaling = 1;
    HdrMask.raw.scl_slope = 1;
    niftiwrite(D5,fullfile(thispath,'RD5'),HdrMask);
    PH(D5_idx)=nan;

    D4_idx=PH>(2*pi/numDigs)*(numDigs-2);
    D4=zeros(size(PH));
    D4(D4_idx)=1;
    D4 = logical(D4);
    D4 = single(D4);
    niftiwrite(D4,fullfile(thispath,'RD4'),HdrMask);
    PH(D4_idx)=nan;


    D3_idx=PH>(2*pi/numDigs)*(numDigs-3);
    D3=zeros(size(PH));
    D3(D3_idx)=1;
    D3 = logical(D3);
    D3 = single(D3);
    niftiwrite(D3,fullfile(thispath,'RD3'),HdrMask);
    PH(D3_idx)=nan;

    %D2_idx=PH>(2*pi/numDigs)*(numDigs-4);
    D2_idx=isfinite(PH);
    D2=zeros(size(PH));
    D2(D2_idx)=1;
    D2 = logical(D2);
    D2 = single(D2);
    niftiwrite(D2,fullfile(thispath,'RD2'),HdrMask);
    PH(D2_idx)=nan;
    %
    %     D1_idx=isfinite(PH);
    %     D1=zeros(size(PH));
    %     D1(D1_idx)=1;
    %     D1 = logical(D1);
    %     D1 = single(D1);
    %     niftiwrite(D1,'RD1',HdrMask);

    disp('Done!')


end


end

