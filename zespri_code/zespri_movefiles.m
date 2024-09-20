clear all
close all
clc
close all hidden


toppath = '/Volumes/ares/ZESPRI/data/';
movepath = '/Volumes/ares/ZESPRI/spm_analysis/';
thisSubs = 11:14;
thisSessions = {'A','B','C','D'};
%thisSessions = {'C'};

for ii = 1:length(thisSubs)
    for jj = 1:length(thisSessions)
        
        disp(sprintf(['Now running zespri_' num2str(thisSubs(ii)) thisSessions{jj}],'%d%s\n'));
        thispath = [toppath 'zespri_' num2str(thisSubs(ii)) thisSessions{jj} '/'];
        
% 
%       cd([thispath '/nback/Topup/'])
%       filename = dir('*_toppedupabs*');
        filename = dir([thispath '/nback/Topup/*_toppedupabs*']);
        if isempty(filename)
            filename = dir([thispath '/nback/Topup/*N-BACK*clv*']);
            copyfile([filename.folder '/' filename.name],[movepath 'session_' thisSessions{jj} '/nback/nback_' num2str(thisSubs(ii)) thisSessions{jj} '.nii.gz']);
        else
            copyfile([filename.folder '/' filename.name],[movepath 'session_' thisSessions{jj} '/nback/nback_' num2str(thisSubs(ii)) thisSessions{jj} '.nii.gz']);
        end
        %cd([thispath '/rs/Topup/'])
        %filename_rs1 = dir('*3_ws*_toppedupabs*');
        filename_rs1 = dir([thispath '/rs/Topup/*3_ws*_toppedupabs*']);

        if isempty(filename_rs1)
            filename_rs1 = dir([thispath '/rs/RETROicor/*RSfMRI*3_ws_map_RCR*']);

            copyfile([filename_rs1.folder '/' filename_rs1.name],[movepath 'session_' thisSessions{jj} '/rs/rs1_' num2str(thisSubs(ii)) thisSessions{jj} '.nii.gz']);
        else
            copyfile([filename_rs1.folder '/' filename_rs1.name],[movepath 'session_' thisSessions{jj} '/rs/rs1_' num2str(thisSubs(ii)) thisSessions{jj} '.nii.gz']);
        end

        %cd([thispath '/rs/Topup/'])
        %filename_rs2 = dir('*4_ws*_toppedupabs*');
        filename_rs2 = dir([thispath '/rs/Topup/*4_ws*_toppedupabs*']);
        if isempty(filename_rs2)
            filename_rs2 = dir([thispath '/rs/RETROicor/*RSfMRI*4_ws_map_RCR*']);

            if isempty(filename_rs2)
                disp('no second RS fMRI run...')

            else
                copyfile([filename_rs2.folder '/' filename_rs2.name],[movepath 'session_' thisSessions{jj} '/rs/rs2_' num2str(thisSubs(ii)) thisSessions{jj} '.nii.gz']);
            end
        else

            copyfile([filename_rs2.folder '/' filename_rs2.name],[movepath 'session_' thisSessions{jj} '/rs/rs2_' num2str(thisSubs(ii)) thisSessions{jj} '.nii.gz']);
        end

        if strcmpi(thisSessions{jj},'D')
            %cd([thispath '/brand/Topup/'])
            %filename_br1 = dir('*14_ws*_toppedupabs*');
            filename_br1 = dir([thispath '/brand/Topup/*14_ws*_toppedupabs*']);
            copyfile([filename_br1.folder '/' filename_br1.name],[movepath 'session_' thisSessions{jj} '/brand/brand1_' num2str(thisSubs(ii)) thisSessions{jj} '.nii.gz']);

            %cd([thispath '/brand/Topup/'])
            %filename_br2 = dir('*15_ws*_toppedupabs*');
            filename_br2 = dir([thispath '/brand/Topup/*15_ws*_toppedupabs*']);
            copyfile([filename_br2.folder '/' filename_br2.name],[movepath 'session_' thisSessions{jj} '/brand/brand2_' num2str(thisSubs(ii)) thisSessions{jj} '.nii.gz']);


        end




    end
end














