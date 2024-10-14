function[myMat]=canapi_custom_regressor_right_leg()

mypath='/Volumes/hermes/canapi_full_run_111024/EMG/Export/';

myfiles = {'1bar_ch1_dsmpled.txt','30prc_ch1_dsmpled.txt','50prc_ch1_dsmpled.txt'};

for ii = 1:length(myfiles)
    custReg(:,ii) = readtable([mypath myfiles{ii}]);
end

myMat = [custReg.Var1 custReg.Var2 custReg.Var3];

end