% List of open inputs
nrun = 1; % enter the number of runs here
jobfile = {'/Users/ppzma/Documents/MATLAB/mycode/touch_remap_z2atlas/spm_zstat_to_native_mprage_job_custom.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
