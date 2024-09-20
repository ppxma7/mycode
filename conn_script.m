nsub=1;       % subject number
ncondition=1; % condition number
nroi=34;       % source/seed number
nanalysis=1;  % analysis number

global CONN_x;
filepath=CONN_x.folders.preprocessing;
filepathresults=fullfile(CONN_x.folders.firstlevel,CONN_x.Analyses(nanalysis).name);
filename=fullfile(filepath,['DATA_Subject',num2str(nsub,'%03d'),'_Condition',num2str(ncondition,'%03d'),'.mat']);
Y=conn_vol(filename);
DOF=max(0,Y.size.Nt*(min(1/(2*CONN_x.Setup.RT),CONN_x.Preproc.filter(2))-max(0,CONN_x.Preproc.filter(1)))*(2*CONN_x.Setup.RT)+1);
filename=fullfile(filepathresults,['BETA_Subject00',num2str(nsub),'_Condition',num2str(ncondition,'%03d'),'_Source',num2str(nroi,'%03d'),'.nii']);
a=spm_vol(filename);
Z=spm_read_vols(a);          % fisher-transformed correlation values
z=Z*max(0,sqrt(DOF-3));    % z-scores
p=spm_Ncdf(z);                  % p-values from normal distribution
p=2*min(p,1-p);                 % note: two-sided tests (remove this line for one-sided tests; i.e. only positive correlations)
P=p;
P(:)=conn_fdr(p(:));            % FDR-corrected p-values
a.fname=fullfile(filepathresults,['p_Subject',num2str(nsub),'_Condition',num2str(ncondition,'%03d'),'_Source',num2str(nroi,'%03d'),'.nii']);
spm_write_vol(a,p);
a.fname=fullfile(filepathresults,['pFDR_Subject',num2str(nsub),'_Condition',num2str(ncondition,'%03d'),'_Source',num2str(nroi,'%03d'),'.nii']);
spm_write_vol(a,P);

a.fname=fullfile(filepathresults,['T_Subject',num2str(nsub),'_Condition',num2str(ncondition,'%03d'),'_Source',num2str(nroi,'%03d'),'.nii']);
a.descrip='SPM{T_[1e6]}';
spm_write_vol(a,spm_invTcdf(max(eps,min(1-eps,1-p)),1e6)  );