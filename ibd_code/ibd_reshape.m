% reshape data from cat12 for graphpad prism


%cd /Volumes/arianthe/BROAD_data/Michael/STRUCTURAL/bias_corrected/CAT_outputs/label/

cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/label/
% 
% subjects = {'001_H03','001_H07','001_H08','001_H09','001_H11','001_H13','001_H14',...
%     '001_H15','001_H16','001_H17','001_H19','001_H23','001_H24','001_H25','001_H27',...
%     '001_H28','001_H29','001_H30','BL002','BL003','BL004','BL005','BL006','BL007',...
%     'BL008','BL010','BL011','BL012','BL013','BL014','BL015','BL016','BL017','BL018',...
%     '001_P01','001_P02','001_P04','001_P05','001_P06','001_P08','001_P12','001_P13',...
%     '001_P15','001_P16','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22',...
%     '001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32',...
%     '001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44',...
%     '001_P45','004_P01'};

subjects = {'msub-003', 'msub-004', 'msub-005', 'msub-006', 'msub-008', 'msub-011', 'msub-012', ...
    'msub-014', 'msub-021', 'msub-024', 'msub-025', 'msub-033'};


for ii = 1:length(subjects)
    
    %load(['catROIs_m' subjects{ii} '.mat'],'S');  % surface file
    load(['catROIs_' subjects{ii} '.mat'],'S');            % volume file
                                                  
    %keyboard
    
    mySub(:,ii) = S.aparc_DK40.data.thickness(:); 
    %mySub(:,ii) = S.hammers.data.Vgm(:);
    %mySub(:,ii) = S.hammers.data.Vwm(:);
end



finalMat = [S.aparc_DK40.names num2cell(mySub)];
%finalMat = [S.hammers.names num2cell(mySub)];

writecell(finalMat,'ct_jordan_dk40','FileType','text');


%%

%subjects = {'001_H03','001_H07','001_H08','001_H09','001_H11','001_H13','001_H14','001_H15','001_H16','001_H17','001_H19','001_H23','001_H24','001_H25','001_H27','001_H28','001_H29','001_H30','BL002','BL003','BL004','BL005','BL006','BL007','BL008','BL010','BL011','BL012','BL013','BL014','BL015','BL016','BL017','BL018','001_P01','001_P02','001_P04','001_P05','001_P06','001_P08','001_P12','001_P13','001_P15','001_P16','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22','001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32','001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44','001_P45','004_P01'};




