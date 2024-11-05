function[myMat]=canapi_custom_regressor()

mypath='/Volumes/hermes/canapi_full_run_111024/EMG/Export/';

%myfiles = {'1bar_ch1_dsmpled.txt','30prc_ch1_dsmpled.txt','50prc_ch1_dsmpled.txt'};
%myfiles = {'1bar_LL_ch2_dsmpled.txt','30prc_LL_ch2_dsmpled.txt','50prc_LL_ch2_dsmpled.txt','70prc_LL_ch2_dsmpled.txt'}; %left leg
%myfiles = {'1bar_R_force_dsmpled.txt','30prc_R_force_dsmpled.txt','50prc_R_force_dsmpled.txt'}; %right leg
%myfiles = {'1bar_L_force_dsmpled.txt','30prc_L_force_dsmpled.txt','50prc_L_force_dsmpled.txt','70prc_L_force_dsmpled.txt'}; %right leg

myfiles = {'1bar_LL_rectify_rectify_ch2_dsmpled.txt','30prc_LL_rectify_rectify_ch2_dsmpled.txt','50prc_LL_rectify_rectify_ch2_dsmpled.txt','70prc_LL_rectify_rectify_ch2_dsmpled.txt'};
%myfiles = {'1bar_rectify_rectify_ch1_dsmpled.txt','30prc_rectify_rectify_ch1_dsmpled.txt','50prc_rectify_rectify_ch1_dsmpled.txt'};

for ii = 1:length(myfiles)
    custReg(:,ii) = readtable([mypath myfiles{ii}]);
end

if length(myfiles) > 3
    myMat = [custReg.Var1 custReg.Var2 custReg.Var3 custReg.Var4];
else
    myMat = [custReg.Var1 custReg.Var2 custReg.Var3];
end

end