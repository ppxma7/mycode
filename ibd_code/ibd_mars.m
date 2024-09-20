% reshape data from cat12 for graphpad prism

cd /Volumes/arianthe/BROAD_data/Michael/STRUCTURAL/bias_corrected/CAT_outputs/mwp2_gitaonly_fatigue/

load('marsbar_rLinGy.mat','SPM');

myStats = SPM.marsY.Y;

mySubs = {'001_P15','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22',...
    '001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32',...
    '001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44',...
    '001_P45','004_P01'}';


finalMat = [mySubs num2cell(myStats)];
writecell(finalMat,'wmv_rLinGy','FileType','text');

