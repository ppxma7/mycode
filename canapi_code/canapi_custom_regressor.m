function[myMat]=canapi_custom_regressor()

mypath='/Volumes/hermes/canapi_051224/emg/Export/';

%myfiles = {'1bar_ch1_dsmpled.txt','30prc_ch1_dsmpled.txt','50prc_ch1_dsmpled.txt'};
%myfiles = {'1bar_LL_ch2_dsmpled.txt','30prc_LL_ch2_dsmpled.txt','50prc_LL_ch2_dsmpled.txt','70prc_LL_ch2_dsmpled.txt'}; %left leg
%myfiles = {'1bar_R_force_dsmpled.txt','30prc_R_force_dsmpled.txt','50prc_R_force_dsmpled.txt'}; %right leg
%myfiles = {'1bar_L_force_dsmpled.txt','30prc_L_force_dsmpled.txt','50prc_L_force_dsmpled.txt','70prc_L_force_dsmpled.txt'}; %right leg

%myfiles = {'1bar_LL_rectify_rectify_ch2_dsmpled.txt','30prc_LL_rectify_rectify_ch2_dsmpled.txt','50prc_LL_rectify_rectify_ch2_dsmpled.txt','70prc_LL_rectify_rectify_ch2_dsmpled.txt'};
myfiles = {'CANAPI_1bar_Rectify_rectify_ch1_dsmpled.txt','CANAPI_30per_Rectify_rectify_ch1_dsmpled.txt','CANAPI_50per_Rectify_rectify_ch1_dsmpled.txt',...
    'CANAPI_1bar_t2_Rectify_rectify_ch1_dsmpled.txt','CANAPI_30per_t2_Rectify_rectify_ch1_dsmpled.txt','CANAPI_50per_t2_Rectify_rectify_ch1_dsmpled.txt'};

for ii = 1:length(myfiles)
    custReg(:,ii) = readtable([mypath myfiles{ii}]);
end

if length(myfiles) > 3
    %myMat = [custReg.Var1 custReg.Var2 custReg.Var3 custReg.Var4];
    myMat = [custReg.Var1 custReg.Var2 custReg.Var3 custReg.Var4 custReg.Var5 custReg.Var6];
else
    myMat = [custReg.Var1 custReg.Var2 custReg.Var3];
end

end