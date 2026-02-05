function []=makeDigitROIs_BD_caitlin(path,n)

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
if nargin==0
    path = '/Volumes/nemosine/caitlin_data/atlas/';
    n = 64; %64 96
elseif nargin==1
    n = 80;
end

numDigs = 4;

%cd(path)

subs = {'7T/'};
for ii = 1:length(subs)
    
    cd([path subs{ii}]);
    
    disp(['Working through subject ' subs{ii}])
    
    [thismask]=niftiread('ROI.nii');
    [HdrMask]=niftiinfo('ROI.nii');
    %[CO hdr2]=cbiReadNifti('co_LD.nii');
    [CO]=niftiread('co.nii');
    [PH]=niftiread('ph.nii');
    
    % PH = double(PH);
    
    HdrCO = niftiinfo('co.nii');
    HdrPH = niftiinfo('ph.nii');
    
    %n=80;
    
    mySize = size(CO);
    
    CO = CO(:);
    PH = PH(:);
    thismask = thismask(:);
    %thismask = logical(thismask);
    
    %thismask = ~isnan(thismask);
    thismask = logical(thismask);
    
    
    
    P=coherenceToP(CO,n);
    pValThresh = coherenceToP(0.5,n);
    Pdata = P;
    %pValThresh = 0.05;
    index = Pdata<pValThresh;
    index_masked = logical(thismask.*index);
    %index_masked = logical(index); % don't mask
    
    PH(not(index_masked))=nan;
    CO(not(index_masked))=nan; % comment this this if you want to keep all CO
    
    
    PH = reshape(PH,mySize);
    CO = reshape(CO,mySize);
    
    
    niftiwrite(PH,'ph_masked', HdrPH);
    niftiwrite(CO,'co_masked', HdrCO);
    
    D5_idx=PH>(2*pi/numDigs)*(numDigs-1);
    D5=zeros(size(PH));
    D5(D5_idx)=1;
    D5 = logical(D5);
    D5 = single(D5);
    HdrMask.Datatype = 'single';
    HdrMask.MultiplicativeScaling = 1;
    HdrMask.raw.scl_slope = 1;
    niftiwrite(D5,'RD5',HdrMask);
    PH(D5_idx)=nan;
    
    D4_idx=PH>(2*pi/numDigs)*(numDigs-2);
    D4=zeros(size(PH));
    D4(D4_idx)=1;
    D4 = logical(D4);
    D4 = single(D4);
    niftiwrite(D4,'RD4',HdrMask);
    PH(D4_idx)=nan;
    
    
    D3_idx=PH>(2*pi/numDigs)*(numDigs-3);
    D3=zeros(size(PH));
    D3(D3_idx)=1;
    D3 = logical(D3);
    D3 = single(D3);
    niftiwrite(D3,'RD3',HdrMask);
    PH(D3_idx)=nan;
    
    %D2_idx=PH>(2*pi/numDigs)*(numDigs-4);
    D2_idx=isfinite(PH);
    D2=zeros(size(PH));
    D2(D2_idx)=1;
    D2 = logical(D2);
    D2 = single(D2);
    niftiwrite(D2,'RD2',HdrMask);
    PH(D2_idx)=nan;
%     
%     D1_idx=isfinite(PH);
%     D1=zeros(size(PH));
%     D1(D1_idx)=1;
%     D1 = logical(D1);
%     D1 = single(D1);
%     niftiwrite(D1,'RD1',HdrMask);
    
    disp('Done!')
    
    return
    
    %path = [ path subs{ii} '/'];
    
    % if ~strcmp(subs{ii},'13447')
    %     %For right digits (left hemisphere)
    %     % this is the ROI mask
    %     %[mask hdr]=cbiReadNifti( 'RD_somato_EPI.img'); %RD_somato
    %     [mask hdr]=cbiReadNifti( 'RD_motor.img'); %RD_somato
    %
    %     [CO hdr2]=cbiReadNifti( 'co_RD.img');
    %     %n=80; % this is number of timepoints
    %
    %     P=coherenceToP(CO,n);
    %     %Pdata = fdrAdjustment(P);% FDR adjustment % UNCOMMENT THIS FOR FDR CORR
    %     Pdata = P;
    %
    %     index=Pdata<0.0034;
    %     %index=Pdata<1;
    %     %index = CO>0.3;
    %     mask(not(index))=0; %threshold at p<0.05
    %
    %     %Now considered voxels only within the combine mask
    %     index=mask>0;
    %
    %     % for resting state, save out the coherence for now...
    %     cbiWriteNifti('index_RD.img',index,hdr) % this is the binarised coherence map, set at p=0.05, which is ~co=0.3
    %
    %     [PH hdr3]=cbiReadNifti('ph_RD.img');
    %     PH(not(index))=nan;
    %     CO(not(index))=nan; % comment this this if you want to keep all CO
    %
    %     %cbiWriteNifti('co_RD_masked_oxf.hdr', CO, hdr);
    %     % %cbiWriteNifti('ph_RD_masked_oxf.hdr', PH, hdr);
    %
    %     cbiWriteNifti('ph_RD_masked.hdr',PH, hdr); % this is the phase values
    %     cbiWriteNifti('co_RD_masked.hdr',CO, hdr); % this is coherence values
    %
    %     D5_idx=PH>2*pi/5*4;
    %     D5=zeros(size(PH));
    %     %D5(D5_idx) = PH(D5_idx); % to keep weights!
    %     D5(D5_idx)=1; % to make binary!
    %     cbiWriteNifti('RD5.hdr',D5,hdr);
    %     PH(D5_idx)=nan;
    %
    %     D4_idx=PH>2*pi/5*3;
    %     D4=zeros(size(PH));
    %     %D4(D4_idx) = PH(D4_idx); % to keep weights!
    %     D4(D4_idx)=1;
    %     cbiWriteNifti('RD4.hdr',D4,hdr);
    %     PH(D4_idx)=nan;
    %
    %
    %     D3_idx=PH>2*pi/5*2;
    %     D3=zeros(size(PH));
    %     %D3(D3_idx) = PH(D3_idx); % to keep weights!
    %     D3(D3_idx)=1;
    %     cbiWriteNifti('RD3.hdr',D3,hdr);
    %     PH(D3_idx)=nan;
    %
    %     D2_idx=PH>2*pi/5;
    %     D2=zeros(size(PH));
    %     %D2(D2_idx) = PH(D2_idx); % to keep weights!
    %     D2(D2_idx)=1;
    %     cbiWriteNifti('RD2.hdr',D2,hdr);
    %     PH(D2_idx)=nan;
    %
    %     D1_idx=isfinite(PH);
    %     %D1(D1_idx) = PH(D1_idx); % to keep weights!
    %     D1=zeros(size(PH));
    %     D1(D1_idx)=1;
    %     cbiWriteNifti('RD1.hdr',D1,hdr);
    %
    %     %return
    %     %keyboard
    % end
    
    %return
    %% For left digits (right hemisphere)
    [thismask]=niftiread( 'LD_somato.nii');
    [HdrMask]=niftiinfo( 'LD_somato.nii');
    %[CO hdr2]=cbiReadNifti('co_LD.nii');
    [CO]=niftiread('co_LD.nii');
    [PH]=niftiread('phase_LD.nii');
    
    % PH = double(PH);
    
    HdrCO = niftiinfo('co_LD.nii');
    HdrPH = niftiinfo('phase_LD.nii');
    
    %n=80;
    
    mySize = size(CO);
    
    CO = CO(:);
    PH = PH(:);
    thismask = thismask(:);
    thismask = logical(thismask);
    
    
    
    P=coherenceToP(CO,n);
    pValThresh = coherenceToP(0.3,n);
    Pdata = P;
    index = Pdata<pValThresh;
    index_masked = logical(thismask.*index);
    
    PH(not(index_masked))=nan;
    CO(not(index_masked))=nan; % comment this this if you want to keep all CO
    
    
    PH = reshape(PH,mySize);
    CO = reshape(CO,mySize);
    
    
    niftiwrite(PH,'ph_LD_masked', HdrPH);
    niftiwrite(CO,'co_LD_masked', HdrCO);
    
    D5_idx=PH>2*pi/5*4;
    D5=zeros(size(PH));
    D5(D5_idx)=1;
    D5 = logical(D5);
    D5 = single(D5);
    HdrMask.Datatype = 'single';
    HdrMask.MultiplicativeScaling = 1;
    HdrMask.raw.scl_slope = 1;
    niftiwrite(D5,'LD5',HdrMask);
    PH(D5_idx)=nan;
    
    D4_idx=PH>2*pi/5*3;
    D4=zeros(size(PH));
    D4(D4_idx)=1;
    D4 = logical(D4);
    D4 = single(D4);
    niftiwrite(D4,'LD4',HdrMask);
    PH(D4_idx)=nan;
    
    
    D3_idx=PH>2*pi/5*2;
    D3=zeros(size(PH));
    D3(D3_idx)=1;
    D3 = logical(D3);
    D3 = single(D3);
    niftiwrite(D3,'LD3',HdrMask);
    PH(D3_idx)=nan;
    
    D2_idx=PH>2*pi/5;
    D2=zeros(size(PH));
    D2(D2_idx)=1;
    D2 = logical(D2);
    D2 = single(D2);
    niftiwrite(D2,'LD2',HdrMask);
    PH(D2_idx)=nan;
    
    D1_idx=isfinite(PH);
    D1=zeros(size(PH));
    D1(D1_idx)=1;
    D1 = logical(D1);
    D1 = single(D1);
    niftiwrite(D1,'LD1',HdrMask);
    
    disp('Done!')
    
    %% return
    
end


end

