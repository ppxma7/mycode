
clear all
close all
clc

mypath = '/Volumes/styx/for_Michael/s021/results/';
cd(mypath)
%magicN = 256*256*256;

a = 112;
b = 112;
c = 58;

magicN = a*b*c;
bigLad = zeros(magicN,5,5);
bigRad = zeros(magicN,5,5);

tic
for ii = 1:5
    for jj = 1:5

        fn_magn_in = [mypath 'runL' num2str(ii) '/rzstat' num2str(jj) '.nii'];
        disp(fn_magn_in)
        Mag = niftiread(fn_magn_in); info = niftiinfo(fn_magn_in);
        Magvec = Mag(:);
        bigLad(:,ii,jj) = Magvec;
        bigLinfo(ii,jj).info = info;

        fn_magn_inR = [mypath 'runR' num2str(ii) '/rzstat' num2str(jj) '.nii'];
        disp(fn_magn_inR)
        MagR = niftiread(fn_magn_inR); infoR = niftiinfo(fn_magn_inR);
        MagvecR = MagR(:);
        bigRad(:,ii,jj) = MagvecR;
        bigRinfo(ii,jj).info = infoR;

    end
end
toc
%%
avgZstat_L = squeeze(mean(bigLad,2));
avgZstat_R = squeeze(mean(bigRad,2));

zstat1_L = reshape(avgZstat_L(:,1),[a b c]);
zstat1_L = single(zstat1_L);
zstat2_L = reshape(avgZstat_L(:,2),[a b c]);
zstat2_L = single(zstat2_L);
zstat3_L = reshape(avgZstat_L(:,3),[a b c]);
zstat3_L = single(zstat3_L);
zstat4_L = reshape(avgZstat_L(:,4),[a b c]);
zstat4_L = single(zstat4_L);
zstat5_L = reshape(avgZstat_L(:,5),[a b c]);
zstat5_L = single(zstat5_L);

zstat1_R = reshape(avgZstat_R(:,1),[a b c]);
zstat1_R = single(zstat1_R);
zstat2_R = reshape(avgZstat_R(:,2),[a b c]);
zstat2_R = single(zstat2_R);
zstat3_R = reshape(avgZstat_R(:,3),[a b c]);
zstat3_R = single(zstat3_R);
zstat4_R = reshape(avgZstat_R(:,4),[a b c]);
zstat4_R = single(zstat4_R);
zstat5_R = reshape(avgZstat_R(:,5),[a b c]);
zstat5_R = single(zstat5_R);

zstat1_L_info = bigLinfo(1,1).info;
%zstat1_L_info.Datatype = 'double';
zstat2_L_info = bigLinfo(1,2).info;
%zstat2_L_info.Datatype = 'double';
zstat3_L_info = bigLinfo(1,3).info;
%zstat3_L_info.Datatype = 'double';
zstat4_L_info = bigLinfo(1,4).info;
%zstat4_L_info.Datatype = 'double';
zstat5_L_info = bigLinfo(1,5).info;
%zstat5_L_info.Datatype = 'double';


zstat1_R_info = bigRinfo(1,1).info;
%zstat1_R_info.Datatype = 'double';
zstat2_R_info = bigRinfo(1,2).info;
%zstat2_R_info.Datatype = 'double';
zstat3_R_info = bigRinfo(1,3).info;
%zstat3_R_info.Datatype = 'double';
zstat4_R_info = bigRinfo(1,4).info;
%zstat4_R_info.Datatype = 'double';
zstat5_R_info = bigRinfo(1,5).info;
%zstat5_R_info.Datatype = 'double';
% 
niftiwrite(zstat1_L,'zstat1_L.nii',zstat1_L_info);
niftiwrite(zstat2_L,'zstat2_L.nii',zstat2_L_info);
niftiwrite(zstat3_L,'zstat3_L.nii',zstat3_L_info);
niftiwrite(zstat4_L,'zstat4_L.nii',zstat4_L_info);
niftiwrite(zstat5_L,'zstat5_L.nii',zstat5_L_info);

niftiwrite(zstat1_R,'zstat1_R.nii',zstat1_R_info);
niftiwrite(zstat2_R,'zstat2_R.nii',zstat2_R_info);
niftiwrite(zstat3_R,'zstat3_R.nii',zstat3_R_info);
niftiwrite(zstat4_R,'zstat4_R.nii',zstat4_R_info);
niftiwrite(zstat5_R,'zstat5_R.nii',zstat5_R_info);












