

fs_path = '/Volumes/DRS-Touchmap/ma_ares_backup/TOUCH_REMAP/exp016/freesurfer/';
zs_path = '/Volumes/DRS-Touchmap/ma_ares_backup/TOUCH_REMAP/exp016/231108_share/';
% List of subject IDs
% subject_ids = {'005', '006', '008', '009', '011', '012', '013', '014', ...
%                '015', '017', '018', '020', '021', '022', '023', '024', ...
%                '025', '026', '028', '029', '030', '031', '032', ...
%                '033', '034', '035', '036', '037', '038', '039', '040', ...
%                '041', '042', '043', '045', '046', '047', '049', '050', ...
%                '051', '052', '054', '055', '056', '057', '059', '060', ...
%                '061', '063', '064'};

subject_ids = {'025','031','035','038','039','040','046','057','060','063'};

%subject_ids = {'005','006'};

for ii = 1:length(subject_ids)


    matlabbatch{ii}.spm.spatial.coreg.estwrite.ref = {sprintf('%s%s/surfRelax/%s_mprage_pp.nii,1', fs_path, subject_ids{ii}, subject_ids{ii})};
    matlabbatch{ii}.spm.spatial.coreg.estwrite.source = {sprintf('%ssub016_%s/resultsSummary/%s_aveRightHand_Cope1zstat_2highres.nii,1', zs_path, subject_ids{ii}, subject_ids{ii})};
    matlabbatch{ii}.spm.spatial.coreg.estwrite.other = {
        sprintf('%ssub016_%s/resultsSummary/%s_aveRightHand_Cope2zstat_2highres.nii,1', zs_path, subject_ids{ii}, subject_ids{ii})
        sprintf('%ssub016_%s/resultsSummary/%s_aveRightHand_Cope3zstat_2highres.nii,1', zs_path, subject_ids{ii}, subject_ids{ii})
        sprintf('%ssub016_%s/resultsSummary/%s_aveRightHand_Cope4zstat_2highres.nii,1', zs_path, subject_ids{ii}, subject_ids{ii})
        sprintf('%ssub016_%s/resultsSummary/%s_aveRightHand_Cope5zstat_2highres.nii,1', zs_path, subject_ids{ii}, subject_ids{ii})
        };

    matlabbatch{ii}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{ii}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{ii}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{ii}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{ii}.spm.spatial.coreg.estwrite.roptions.interp = 4;
    matlabbatch{ii}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{ii}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{ii}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';

end


