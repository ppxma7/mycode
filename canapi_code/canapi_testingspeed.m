% =========================================================
% SPM12 Results Export Script
% =========================================================
% Remember to launchSPM
%
% Michael Asghar - March 2026

clc

% --- USER TO SET ---

theSubList = {'canapi_sub13', 'canapi_sub14',...
    'canapi_sub15', 'canapi_sub16'};

for s = 1:numel(theSubList)
    thisSub = theSubList{s};

    for contrast_index = [1, 3] % 1barR and 1barL

        for hemi = ['L','R'] % Left and right mask

            % --- SETTINGS ---
            thispath = ['/Volumes/kratos/CANAPI/' thisSub '/spm_analysis/first_level_waccel/'];
            spm_mat_path = fullfile(thispath,'SPM.mat');
            % 1 is 1barR, 2 is lowR, 3 is 1barL, 4 is lowL
            threshold_type = 'none';      % 'FWE', 'FDR', or 'none'
            p_val = 0.001;
            k_extent = 20;                % cluster extent threshold
            use_atlas = true;

            maskname = ['prepostsmaCG_' hemi '_bin'];

            if contrast_index == 1
                name = ['1barR_' hemi 'mask'];
            elseif contrast_index == 3
                name = ['1barL_' hemi 'mask'];
            else
                error('contrast 1 or 3 please = 1barR or 1barL')
            end

            mymask = ['/Users/ppzma/Documents/spm12/tpm/' maskname '.nii'];  % path to mask file

            % Pre-create the masked image in your CWD
            mask_out = fullfile(thispath, [maskname '_mask_001.nii']);
            spm_imcalc({mymask}, mask_out, 'i1>0.5');  % binarise

            xSPM.Im = {mask_out};
            xSPM.Ex = 0;
            xSPM.pm = [];


            % --- LOAD SPM RESULTS ---
            load(spm_mat_path);

            xSPM.swd      = fileparts(spm_mat_path);
            xSPM.title    = '';
            xSPM.Ic       = contrast_index;
            xSPM.n        = 1;

            xSPM.u        = p_val;
            xSPM.k        = k_extent;

            switch threshold_type
                case 'FWE';  xSPM.thresDesc = 'FWE';
                case 'FDR';  xSPM.thresDesc = 'FDR';
                otherwise;   xSPM.thresDesc = 'none';
            end


            [hReg, xSPM, SPM] = spm_results_ui('Setup', xSPM);

            % --- EXPORT TO CSV ---
            TabDat = spm_list('List', xSPM, hReg);

            % --- CONVERT TabDat to table (equivalent to your import steps) ---
            % TabDat.dat contains the data rows, TabDat.hdr has headers

            headers = TabDat.hdr(1,:);
            headers = matlab.lang.makeValidName(headers);
            headers = matlab.lang.makeUniqueStrings(headers);  % fixes duplicates

            data = TabDat.dat;
            data = cellfun(@(x) round_if_numeric(x), data, 'UniformOutput', false);

            moo = cell2table(data, 'VariableNames', headers);

            exportSPMtable(moo,name)
            spm_glass_quick(xSPM,name)

            % Optional: save to CSV
            %writetable(Moo, 'spm_results.csv');

        end
    end
end

% Helper function (add at bottom of script)
function out = round_if_numeric(x)
if isnumeric(x)
    out = round(x, 3);
else
    out = x;
end
end