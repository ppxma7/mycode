function[myMat]=canapi_custom_regressor()

% look at lines 276 in spm_fMRI_design.m

%mypath='/Volumes/kratos/canapi_sub02_180325/EMG/Export/';
mypath='/Volumes/kratos/canapi_sub10_160725/EEG/Export/';
%mypath='/Volumes/kratos/canapi_sub06_240625/EMG/Export/';

%myfiles = {'1bar_ch1_dsmpled.txt','30prc_ch1_dsmpled.txt','50prc_ch1_dsmpled.txt'};
%myfiles = {'1bar_LL_ch2_dsmpled.txt','30prc_LL_ch2_dsmpled.txt','50prc_LL_ch2_dsmpled.txt','70prc_LL_ch2_dsmpled.txt'}; %left leg
%myfiles = {'1bar_R_force_dsmpled.txt','30prc_R_force_dsmpled.txt','50prc_R_force_dsmpled.txt'}; %right leg
%myfiles = {'1bar_L_force_dsmpled.txt','30prc_L_force_dsmpled.txt','50prc_L_force_dsmpled.txt','70prc_L_force_dsmpled.txt'}; %right leg

%myfiles = {'1bar_LL_rectify_rectify_ch2_dsmpled.txt','30prc_LL_rectify_rectify_ch2_dsmpled.txt','50prc_LL_rectify_rectify_ch2_dsmpled.txt','70prc_LL_rectify_rectify_ch2_dsmpled.txt'};
% myfiles = {'CANAPI01_RL_1BAR_Rectify_rectify_ch2_dsmpled.txt','CANAPI01_RL_15per_Rectify_rectify_ch2_dsmpled.txt',...
%     'CANAPI01_LL_1BAR_Rectify_rectify_ch1_dsmpled.txt','CANAPI01_LL_15per_Rectify_rectify_ch1_dsmpled.txt'};

% myfiles = {'CANAPI_sub02_R_1BAR_Rectify_rectify_ch1_dsmpled.txt','CANAPI_sub02_R_15per_Rectify_rectify_ch1_dsmpled.txt',...
%     'CANAPI_sub02_L_1BAR_Rectify_rectify_ch2_dsmpled.txt','CANAPI_sub02_L_15per_Rectify_rectify_ch2_dsmpled.txt'};

% myfiles = {'CANAPI_sub05_RL_1bar_Rectify_rectify_ch1_dsmpled.txt','CANAPI_sub05_RL_15per_Rectify_rectify_ch1_dsmpled.txt',...
%     'CANAPI_sub05_LL_1bar_r2_Rectify_rectify_ch5_dsmpled.txt','CANAPI_sub05_LL_15per_Rectify_rectify_ch5_dsmpled.txt'};

myfiles = {'CANAPI_sub10_RL_1bar_Rectify.dat','CANAPI_sub10_RL_15per_Rectify.dat',...
    'CANAPI_sub10_LL_1bar_Rectify.dat','CANAPI_sub10_LL_15per_Rectify.dat',...
    };
% myfiles = {'CANAPI_sub05_LL_1bar_r2_Rectify_rectify_ch5_dsmpled.txt','CANAPI_sub05_LL_15per_Rectify_rectify_ch5_dsmpled.txt',...
%     'CANAPI_sub05_RL_1bar_Rectify_rectify_ch1_dsmpled.txt','CANAPI_sub05_RL_15per_Rectify_rectify_ch1_dsmpled.txt'};


% myfiles = {'CANAPI_sub07_RL_1barreal_Rectify_rectify_ch5_dsmpled.txt','CANAPI_sub07_RL_15per_Rectify_rectify_ch1_dsmpled.txt',...
%     'CANAPI_sub07_LL_1bar_Rectify_rectify_ch5_dsmpled.txt','CANAPI_sub07_LL_15per_Rectify_rectify_ch1_dsmpled.txt'};

% 
% myfiles = {'CANAPI_sub09_RL_1bar_Rectify_rectify_ch1_dsmpled.txt','CANAPI_sub09_RL_15per_Rectify_rectify_ch1_dsmpled.txt',...
%     'CANAPI_sub09_LL_1bar_Rectify_rectify_ch1_dsmpled.txt','CANAPI_sub09_LL_15per_Rectify_rectify_ch1_dsmpled.txt'};


% myfiles = {'CANAPI_sub10_RL_1bar_Rectify_rectify_ch5_dsmpled.txt','CANAPI_sub10_RL_15per_Rectify_rectify_ch5_dsmpled.txt',...
%     'CANAPI_sub10_LL_1bar_Rectify_rectify_ch5_dsmpled.txt','CANAPI_sub10_LL_15per_Rectify_rectify_ch5_dsmpled.txt'};


for ii = 1:length(myfiles)

    thisfile = [extractBefore(myfiles{ii},'.') '_rectify_ch1_dsmpled.txt']; % just for accel z axis run thorugh
    %custReg(:,ii) = readtable([mypath myfiles{ii}]);
    custReg(:,ii) = readtable([mypath thisfile]);
end

if length(myfiles) > 3
    myMat = [custReg.Var1 custReg.Var2 custReg.Var3 custReg.Var4];
    %myMat = [custReg.Var1 custReg.Var2 custReg.Var3 custReg.Var4 custReg.Var5 custReg.Var6];
else
    myMat = [custReg.Var1 custReg.Var2 custReg.Var3];
end

end