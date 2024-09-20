function DigitMask=makeDigitROIs_BD_nodigs(path,n)

if nargin==0
    mypath = '/Volumes/arianthe/prf_smoothed_1p5mm/';
    n = 120;
elseif nargin==1
    error('look at script')
end

cd(mypath)
%subs = {'211011_prf7/'};
subs = {'15874_prf13/', '210922_prf3/','211004_prf6/','211011_prf7/','211207_prf10/','211215_prf11/','260821_prf_14359/'};
for ii = 1:length(subs)

    cd([mypath subs{ii} 'visualisation/']);
    disp(['Working through subject ' subs{ii}])

    %[myROI]=niftiread('BA3A.nii'); 
    [CO]=niftiread('digitmap_co.nii');
    [PH]=niftiread('digitmap_ph.nii');

    HdrCO = niftiinfo('digitmap_co.nii');
    HdrPH = niftiinfo('digitmap_ph.nii');
    %HdrROI = niftiinfo('BA3A.nii');

    % mask = mask.vol(:);
    % CO = CO.vol(:);
    % PH = PH.vol(:);

    P=coherenceToP(CO,n);
    %Pdata = fdrAdjustment(P);% FDR adjustment % UNCOMMENT THIS FOR FDR CORR
    Pdata = P;

    pValThresh = coherenceToP(0.3,n);
    index = Pdata<pValThresh;

    %index=Pdata<0.0034;
    %index=Pdata<0.05;
    %index=Pdata<1;
    %index = CO>0.3;
    %mask(not(index))=0; %threshold at p<0.05

    %Now considered voxels only within the combine mask
    %index=mask>0;

  
    PH(not(index))=nan;
    CO(not(index))=nan; % comment this this if you want to keep all CO

    niftiwrite(CO,'digitmap_co_masked',HdrCO)
    niftiwrite(PH,'digitmap_ph_masked',HdrPH)
    %niftiwrite(myROI,'BA3A_masked',HdrROI)
    % cbiWriteNifti('ph_RD_masked.hdr',PH, hdr); % this is the phase values
    % cbiWriteNifti('co_RD_masked.hdr',CO, hdr); % this is coherence values

end


end

