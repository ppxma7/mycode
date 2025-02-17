% List of open inputs
nrun = 1; % enter the number of runs here
jobfile = {'/Volumes/arianthe/PAIN/spmimport_redo_allsubs/quickreg_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
