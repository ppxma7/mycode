function[] = ibd_atlas_label(regionName,hemi)
%IBD_ATLAS_LABEL - find mean atlas labels for thickness, in fsaverage
%space, for freesurfer subjects, after running -qcache
% combine code from ibd_ct.m to show cat12 in one script
%
% notes:
% want to write something that assigns an atlas annotation to each vertex
% of the thickness values, in fsaverage space, from a freesurfer/surf
% subject. Then take the mean of this label, to create a standard atlas for
% that sub. Can then plot thickness vs. specific ROI, across a set of
% subjects.
%
% possible names for regionName from DK40atlas include
%     {'bankssts'                }
%     {'caudalanteriorcingulate' }
%     {'caudalmiddlefrontal'     }
%     {'corpuscallosum'          }
%     {'cuneus'                  }
%     {'entorhinal'              }
%     {'fusiform'                }
%     {'inferiorparietal'        }
%     {'inferiortemporal'        }
%     {'isthmuscingulate'        }
%     {'lateraloccipital'        }
%     {'lateralorbitofrontal'    }
%     {'lingual'                 }
%     {'medialorbitofrontal'     }
%     {'middletemporal'          }
%     {'parahippocampal'         }
%     {'paracentral'             }
%     {'parsopercularis'         }
%     {'parsorbitalis'           }
%     {'parstriangularis'        }
%     {'pericalcarine'           }
%     {'postcentral'             }
%     {'posteriorcingulate'      }
%     {'precentral'              }
%     {'precuneus'               }
%     {'rostralanteriorcingulate'}
%     {'rostralmiddlefrontal'    }
%     {'superiorfrontal'         }
%     {'superiorparietal'        }
%     {'superiortemporal'        }
%     {'supramarginal'           }
%     {'frontalpole'             }
%     {'temporalpole'            }
%     {'transversetemporal'      }
%     {'insula'                  }
%
% [ma] april 2020
%
% See Also read_annotation strncmp

%% load subjects
subjects = {'001_H03','001_H07','001_H08','001_H09','001_H11','001_H13','001_H14',...
    '001_H15','001_H16','001_H17','001_H19','001_H23','001_H24','001_H25','001_H27',...
    '001_H28','001_H29','001_H30','BL002','BL003','BL004','BL005','BL006','BL007',...
    'BL008','BL010','BL011','BL012','BL013','BL014','BL015','BL016','BL017','BL018',...
    'sub-004','sub-020','sub-022','sub-026','sub-027','sub-028','sub-031','sub-034',...
    '001_P01','001_P02','001_P04','001_P05','001_P06','001_P08','001_P12','001_P13',...
    '001_P15','001_P16','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22',...
    '001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32',...
    '001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44',...
    '001_P45','004_P01',...
    'sub-021', 'sub-024', 'sub-025', 'sub-033', 'sub-005', 'sub-006', 'sub-008', ...
    'sub-011', 'sub-012', 'sub-014', 'sub-003','sub-032','sub-038'};
numHV = 42;
numCD = 34;
numCDR = 13;
myGroup = [repmat({'HV'},numHV,1); repmat({'CD'},numCD,1); repmat({'CD_r'},numCDR,1)];
myGroup = myGroup(:);

jord_group = {'FCD','HV','FCD','FCD','FCD','NFCD','FCD','NFCD','HV','NFCD','HV','FCD','NFCD',...
    'HV','HV','HV','NFCD','HV','NFCD','HV','FCD'}';
jord_MFI_gen =  [16 5 16 16 19 9 18 9 4 13 10 20 7 12 4 9 8 9 10 9 14]';
jord_MFI_phy = [15 5 12 10 16 5 11 4 6 7  7  19 7 9  5 9 6 8 6 10 15]';
% kill hvs
idx = ~strcmpi('HV',jord_group);
jord_MFI_gen_pa = jord_MFI_gen(idx);
jord_MFI_phy_pa = jord_MFI_phy(idx);

myFatGroup3 = [repmat({'Active CD'},26,1); jord_group(idx)];

%ylims
a = 2;
b = 5;

% these ibdf scores are only for patients for now.
ibdf_fat_scores = [12 9 12 12 13 7 13 15 5 9 13 12 8 13 14 15 11 4 13 14,... 
    15 11 12 4 8 3 13 15 14 13 3 12 0 5 15 0 2 4 10];
ibdf_fat_scores = ibdf_fat_scores(:);
fat_subs = {'001_P13','001_P15','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22',...
    '001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32',...
    '001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44',...
    '001_P45','004_P01',...
    'sub-003','sub-005', 'sub-006', 'sub-008','sub-011', 'sub-012', 'sub-014',...
    'sub-021', 'sub-024', 'sub-025', 'sub-033','sub-032','sub-038'};
myFatGroup = [repmat({'Gita CD'},26,1); repmat({'Jordan CD'},13,1)];



for ii = 1:length(subjects)
    for jj = 1:length(fat_subs)
        tmp = strcmpi(subjects{ii},fat_subs{jj});
        if tmp == 1
            thisIdx(ii) = tmp;
        end
    end
end
thisIdx = thisIdx(:);
% grab index of which patients have fat scores


if nargin == 0
    hemi = 'l';
    regionName = 'precentral';
elseif nargin == 1
    hemi = 'l';
end

%% FREESURFER
% get labels from fsaverage first
cd /Applications/freesurfer/subjects/fsaverage/label/
if strcmpi(hemi,'l')
    % here, read the fsaverage label
    [vertices, label, ctab] = read_annotation('lh.aparc.annot');
else
    [vertices, label, ctab] = read_annotation('rh.aparc.annot');
end
%stgctab = strmatch(atlasName,char(ctab.struct_names)); % original, but
%advised not to use strmatch()

% do a strcmpi, to find where in ctab our region is
stgctab = find(strncmp(regionName,ctab.struct_names,length(regionName)));
% The code in the 5th column is
stgcode = ctab.table(stgctab,5);
% these are the indices in fsaverage that correspond to atlasName
indstg = find(label==stgcode); 
% actually more useful to get logicals
indstg_log = label==stgcode;
nstg = length(indstg); % optional get no of vertices that correspond to regionName

%% go to data
cd /Volumes/ares/data/IBD/STRUCTURAL/freesurfer_outputs/
mRegion = zeros(length(subjects),1); %make space

tic
for ii = 1:length(subjects)
    if strcmpi(hemi,'l')
        tmp = MRIread(['m' subjects{ii} '.freesurfer/surf/lh.thickness.fwhm15.fsaverage.mgh']);
    else
        tmp = MRIread(['m' subjects{ii} '.freesurfer/surf/rh.thickness.fwhm15.fsaverage.mgh']);
    end
    thisThic = tmp.vol(:);
    thisRegion = nonzeros(thisThic.*indstg_log);
    mRegion(ii) = mean(thisRegion); % Get mean of these vertices based on DK40 atlas labeling
end
toc

%% Freesurfer ct groups 
% plot in gramm()
clear g
figure('Position', [100 100 1200 600])
g(1,1) = gramm('x',myGroup,'y',mRegion);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'notch',false)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_title(['FS6 ' hemi '_' regionName ' Median+IQR'])

% mean and std too please 
g(1,2) = gramm('x',myGroup,'y',mRegion);
g(1,2).stat_summary('type','std','geom',{'area','black_errorbar'});
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_title(['FS6 ' hemi '_' regionName ' Mean+STD'])
g.set_names('x','Group', 'y','Cortical thickness mm^2')
g.axe_property('YLim',[a b])

g.draw()
g(1,1).update('y',mRegion);
g(1,1).geom_jitter('alpha',0.5)
g(1,1).set_point_options('markers', {'o'} ,'base_size',15)
g.draw()
g.export('file_name',[hemi regionName '_fs6_ibd'], ...
    'export_path',...
    '/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/',...
    'file_type','pdf')



%% Freesurfer CT vs fatigue IBDF
% plot fatigue scores now
fatThicF = mRegion(thisIdx); % add this to mak
figure
clear d
d = gramm('x',ibdf_fat_scores,'y',fatThicF);
d.geom_point
d.set_point_options('markers', {'o'} ,'base_size',15)
d.set_text_options('Font','Helvetica','base_size',16)
d.set_names('x','IBDF scale', 'y','Cortical thickness (mm^2)','color','Group')
d.set_title(['FS6 ' hemi regionName])
d.axe_property('YLim',[a b])
d.draw()

d.update('y',fatThicF)
d.stat_glm('geom','area','disp_fit',false)
d.set_layout_options('legend',false)
d.draw()

d.update('color',myFatGroup3)
d.geom_point
d.draw()

[Rgita,PgitaR]=corrcoef(ibdf_fat_scores(1:25),fatThicF(1:25));
[Rjord,PjordR]=corrcoef(ibdf_fat_scores(26:end),fatThicF(26:end));

[RMFIBDF,PMFIBDF]=corrcoef(ibdf_fat_scores,fatThicF);
TF = table('Size',[3 2],'VariableType',{'double','double'},'VariableNames',{'R','P-val'},'RowNames',{'Gita','Jordan','Both'});
TF(1,1) = {Rgita(2)};
TF(1,2) = {Rjord(2)};
TF(2,1) = {PgitaR(2)};
TF(2,2) = {PjordR(2)};
TF(3,1) = {RMFIBDF(2)};
TF(3,2) = {PMFIBDF(2)};
writetable(TF,['/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/' hemi regionName '_FS6_table_fatigue_scores.csv'],'FileType','text','WriteRowNames',1)
clear TF_MFI


%
% fprintf('\n\n Gita r: %.3f',Rgita(2))
% fprintf('\n Gita p: %.3f',PgitaR(2))
% fprintf('\n Jord r: %.3f',Rjord(2))
% fprintf('\n Jord p: %.3f',PjordR(2))

% TF = table('Size',[2 2],'VariableType',{'double','double'},'RowNames',{'R','P-val'},'VariableNames',{'Gita','Jordan'});
% TF(1,1) = {Rgita(2)};
% TF(1,2) = {Rjord(2)};
% TF(2,1) = {PgitaR(2)};
% TF(2,2) = {PjordR(2)};

% writetable(TF,['/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/' hemi regionName '_FS6_table_fatigue_scores.csv'],'FileType','text','WriteRowNames',1)
%
d.export('file_name',[hemi regionName '_fs6_ibd_fatigue'], ...
    'export_path',...
    '/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/',...
    'file_type','pdf')




%% %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
% and now CAT12 
cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/label/

regionNameC = [hemi regionName];
%mystr = 'lcaudalmiddlefrontal';
%mystr = 'lcaudalmiddlefrontal';
% first thickness values from CAT12
mRegionC = zeros(length(subjects),1);
for ii = 1:length(subjects)
    load(['catROIs_m' subjects{ii} '.mat'],'S');
    myidx = find(strcmpi(S.aparc_DK40.names,regionNameC));
    mRegionC(ii) = S.aparc_DK40.data.thickness(myidx);
end

%% cat12 ct groups

clear h
figure('Position', [100 100 1200 600])
h(1,1) = gramm('x',myGroup,'y',mRegionC);
h(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'notch',false)
h(1,1).set_text_options('Font','Helvetica','base_size',16)
h(1,1).set_title(['CAT12 ' regionNameC ' Median+IQR'])
h(1,2) = gramm('x',myGroup,'y',mRegionC);
h(1,2).stat_summary('type','std','geom',{'area','black_errorbar'});
h(1,2).set_text_options('Font','Helvetica','base_size',16)
h(1,2).set_title(['CAT12 ' regionNameC ' Mean+STD'])
h.set_names('x','Group', 'y','Cortical thickness mm^2')
h.axe_property('YLim',[a b])
h.draw()

h(1,1).update('y',mRegionC);
h(1,1).geom_jitter('alpha',0.5)
h(1,1).set_point_options('markers', {'o'} ,'base_size',15)
h.draw()
h.export('file_name',[regionNameC '_cat12_ibd'], ...
    'export_path',...
    '/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/',...
    'file_type','pdf')

%% now cat12 fatigue
fatThic = mRegionC(thisIdx); % unnecessray?


figure
clear f
f = gramm('x',ibdf_fat_scores,'y',fatThic);
f.geom_point
f.set_point_options('markers', {'o'} ,'base_size',15)
f.set_text_options('Font','Helvetica','base_size',16)
f.set_names('x','IBDF scale', 'y','Cortical thickness (mm^2)','color','Group')
f.set_title(['CAT12 ' regionNameC])
f.axe_property('YLim',[a b])
f.draw()
f.update('y',fatThic)
f.stat_glm('geom','area','disp_fit',false)
f.set_layout_options('legend',false)
f.draw()
f.update('color',myFatGroup3)
f.geom_point
f.draw()

% [Rgita,PgitaR]=corrcoef(ibdf_fat_scores(1:25),fatThic(1:25));
% [Rjord,PjordR]=corrcoef(ibdf_fat_scores(26:end),fatThic(26:end));
%
% fprintf('\n\n Gita r: %.3f',Rgita(2))
% fprintf('\n Gita p: %.3f',PgitaR(2))
% fprintf('\n Jord r: %.3f',Rjord(2))
% fprintf('\n Jord p: %.3f',PjordR(2))


[Rgita,PgitaR]=corrcoef(ibdf_fat_scores(1:25),fatThic(1:25));
[Rjord,PjordR]=corrcoef(ibdf_fat_scores(26:end),fatThic(26:end));
[RMFIBDF,PMFIBDF]=corrcoef(ibdf_fat_scores,fatThic);
TF = table('Size',[3 2],'VariableType',{'double','double'},'VariableNames',{'R','P-val'},'RowNames',{'Gita','Jordan','Both'});
TF(1,1) = {Rgita(2)};
TF(1,2) = {Rjord(2)};
TF(2,1) = {PgitaR(2)};
TF(2,2) = {PjordR(2)};
TF(3,1) = {RMFIBDF(2)};
TF(3,2) = {PMFIBDF(2)};
writetable(TF,['/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/' hemi regionName '_CAT12_table_fatigue_scores.csv'],'FileType','text','WriteRowNames',1)
clear TF_MFI


% T = table('Size',[2 2],'VariableType',{'double','double'},'RowNames',{'R','P-val'},'VariableNames',{'Gita','Jordan'});
% T(1,1) = {Rgita(2)};
% T(1,2) = {Rjord(2)};
% T(2,1) = {PgitaR(2)};
% T(2,2) = {PjordR(2)};

writetable(TF,['/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/' regionNameC '_CAT12_table_fatigue_scores.csv'],'FileType','text','WriteRowNames',1)
f.export('file_name',[regionNameC '_cat12_ibd_fatigue'], ...
    'export_path',...
    '/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/',...
    'file_type','pdf')



%% try plotting just patients vs fatigue score

% sort from lowest to highest scores, and get index in subjects

BS = ibdf_fat_scores(:);
[B, I] = sort(BS);
fat_subs_sorted = fat_subs(I);

figure
clear p
p = gramm('x',fat_subs_sorted,'y',B);
p.geom_point
p.set_point_options('markers', {'o'} ,'base_size',15)
p.set_text_options('Font','Helvetica','base_size',16)
p.set_names('x','Subjects', 'y','IBDF scale','color','Group')
p.axe_property('XTickLabel',[])
%p.set_title(['CAT12 ' regionNameC])
%p.axe_property('YLim',[a b])
p.draw()
p.update('y',B)
p.stat_glm('geom','area','disp_fit',false)
p.set_layout_options('legend',false)
p.draw()

p.export('file_name','fatigue_all_subs', ...
    'export_path',...
    '/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/',...
    'file_type','pdf')





%% convert gita's fatigue score to MFI using correlation

% this is the conversion equation, derived from corelating MFI to IBDF in
% ibd_fatigue.m
m = 0.70884;
c = 7.6819;
m2 = 0.69797;
c2 = 4.5396;
gita_CD = [12 9 12 12 13 7 13 15 5 9 13 12 8 13 14 15 11 4 13 14,15 11 12 4 8 3];
gita_CD_general = round((m*gita_CD)+c);
gita_CD_physical = round((m2*gita_CD)+c2);
% jord_MFI_gen =  [16 5 16 16 19 9 18 9 4 13 10 20 7 12 4 9 8 9 10 9 14]';
% jord_MFI_phy = [15 5 12 10 16 5 11 4 6 7  7  19 7 9  5 9 6 8 6 10 15]';
% 
% jord_group = {'FCD','HV','FCD','FCD','FCD','NFCD','FCD','NFCD','HV','NFCD','HV','FCD','NFCD',...
%     'HV','HV','HV','NFCD','HV','NFCD','HV','FCD'}';
% 
% 
% % kill hvs
% idx = ~strcmpi('HV',jord_group);
% jord_MFI_gen_pa = jord_MFI_gen(idx);
% jord_MFI_phy_pa = jord_MFI_phy(idx);
% 
% myFatGroup3 = [repmat({'Active CD'},25,1); jord_group(idx)];

MFI_scores_g = [gita_CD_general(:); jord_MFI_gen_pa(:)];
MFI_scores_p = [gita_CD_physical(:); jord_MFI_phy_pa(:)];

% MFI_scores = [MFI_scores_g; MFI_scores_p];
% myFatGroup_MFI = [myFatGroup; myFatGroup];
% fatThicF_MFI = [fatThicF;fatThicF];
% fatThic_MFI = [fatThic;fatThic];

% now do thickness vs fatigue, using the MFI scores, both for physical and
% general, both FReesurfer and Cat
%
% fat_subs should be in the right order from the top
% FREESURFER vs FATIGUE
figure('Position',[100 100 1200 800])
clear gr
gr(1,1) = gramm('x',MFI_scores_g,'y',fatThicF);
gr(1,1).geom_point
gr(1,1).set_point_options('markers', {'o'} ,'base_size',15)
gr(1,1).set_text_options('Font','Helvetica','base_size',16)
gr(1,1).set_names('x','MFI general scale', 'y','Cortical thickness (mm^2)','color','Group')
gr(1,1).set_title(['FS6 ' hemi regionName])
gr(1,1).axe_property('YLim',[a b])

gr(1,2) = gramm('x',MFI_scores_g,'y',fatThic);
gr(1,2).geom_point
gr(1,2).set_point_options('markers', {'o'} ,'base_size',15)
gr(1,2).set_text_options('Font','Helvetica','base_size',16)
gr(1,2).set_names('x','MFI general scale', 'y','Cortical thickness (mm^2)','color','Group')
gr(1,2).set_title(['CAT12 ' hemi regionName])
gr(1,2).axe_property('YLim',[a b])

gr(2,1) = gramm('x',MFI_scores_p,'y',fatThicF);
gr(2,1).geom_point
gr(2,1).set_point_options('markers', {'o'} ,'base_size',15)
gr(2,1).set_text_options('Font','Helvetica','base_size',16)
gr(2,1).set_names('x','MFI physical scale', 'y','Cortical thickness (mm^2)','color','Group')
gr(2,1).set_title(['FS6 ' hemi regionName])
gr(2,1).axe_property('YLim',[a b])

gr(2,2) = gramm('x',MFI_scores_p,'y',fatThic);
gr(2,2).geom_point
gr(2,2).set_point_options('markers', {'o'} ,'base_size',15)
gr(2,2).set_text_options('Font','Helvetica','base_size',16)
gr(2,2).set_names('x','MFI physical scale', 'y','Cortical thickness (mm^2)','color','Group')
gr(2,2).set_title(['CAT12 ' hemi regionName])
gr(2,2).axe_property('YLim',[a b])

gr.draw()

gr(1,1).update('y',fatThicF)
gr(1,1).stat_glm('geom','area','disp_fit',false)
gr(1,1).set_layout_options('legend',false)

gr(1,2).update('y',fatThic)
gr(1,2).stat_glm('geom','area','disp_fit',false)
gr(1,2).set_layout_options('legend',false)

gr(2,1).update('y',fatThicF)
gr(2,1).stat_glm('geom','area','disp_fit',false)
gr(2,1).set_layout_options('legend',false)

gr(2,2).update('y',fatThic)
gr(2,2).stat_glm('geom','area','disp_fit',false)
gr(2,2).set_layout_options('legend',false)


gr.draw()
gr(1,1).update('color',myFatGroup3)
gr(1,1).geom_point
%gr(1,1).stat_glm('geom','area','disp_fit',false)
%gr(1,1).set_layout_options('legend',false)

gr(1,2).update('color',myFatGroup3)
gr(1,2).geom_point
% gr(1,2).stat_glm('geom','area','disp_fit',false)
% gr(1,2).set_layout_options('legend',false)

gr(2,1).update('color',myFatGroup3)
gr(2,1).geom_point
% gr(2,1).stat_glm('geom','area','disp_fit',false)
% gr(2,1).set_layout_options('legend',false)

gr(2,2).update('color',myFatGroup3)
gr(2,2).geom_point
% gr(2,2).stat_glm('geom','area','disp_fit',false)
% gr(2,2).set_layout_options('legend',false)
gr.draw()

gr.export('file_name',[hemi regionName '_ibd_fatigue_MFI_both'], ...
    'export_path',...
    '/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/',...
    'file_type','pdf')


[RgitaMFI,PgitaRMFI]=corrcoef(MFI_scores_g(1:25),fatThicF(1:25));
[RjordMFI,PjordRMFI]=corrcoef(MFI_scores_g(26:end),fatThicF(26:end));
[RMFI,PMFI]=corrcoef(MFI_scores_g,fatThicF);
TF_MFI = table('Size',[3 2],'VariableType',{'double','double'},'VariableNames',{'R','P-val'},'RowNames',{'Gita','Jordan','Both'});
TF_MFI(1,1) = {RgitaMFI(2)};
TF_MFI(2,1) = {RjordMFI(2)};
TF_MFI(1,2) = {PgitaRMFI(2)};
TF_MFI(2,2) = {PjordRMFI(2)};
TF_MFI(3,1) = {RMFI(2)};
TF_MFI(3,2) = {PMFI(2)};
writetable(TF_MFI,['/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/' hemi regionName '_FS6_table_fatigue_scores_MFIgen.csv'],'FileType','text','WriteRowNames',1)
clear TF_MFI

[RgitaMFI,PgitaRMFI]=corrcoef(MFI_scores_p(1:25),fatThicF(1:25));
[RjordMFI,PjordRMFI]=corrcoef(MFI_scores_p(26:end),fatThicF(26:end));
[RMFI,PMFI]=corrcoef(MFI_scores_p,fatThicF);
TF_MFI = table('Size',[3 2],'VariableType',{'double','double'},'VariableNames',{'R','P-val'},'RowNames',{'Gita','Jordan','Both'});
TF_MFI(1,1) = {RgitaMFI(2)};
TF_MFI(2,1) = {RjordMFI(2)};
TF_MFI(1,2) = {PgitaRMFI(2)};
TF_MFI(2,2) = {PjordRMFI(2)};
TF_MFI(3,1) = {RMFI(2)};
TF_MFI(3,2) = {PMFI(2)};
writetable(TF_MFI,['/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/' hemi regionName '_FS6_table_fatigue_scores_MFIphy.csv'],'FileType','text','WriteRowNames',1)
clear TF_MFI

[RgitaMFI,PgitaRMFI]=corrcoef(MFI_scores_g(1:25),fatThic(1:25));
[RjordMFI,PjordRMFI]=corrcoef(MFI_scores_g(26:end),fatThic(26:end));
[RMFI,PMFI]=corrcoef(MFI_scores_g,fatThic);
TF_MFI = table('Size',[3 2],'VariableType',{'double','double'},'VariableNames',{'R','P-val'},'RowNames',{'Gita','Jordan','Both'});
TF_MFI(1,1) = {RgitaMFI(2)};
TF_MFI(2,1) = {RjordMFI(2)};
TF_MFI(1,2) = {PgitaRMFI(2)};
TF_MFI(2,2) = {PjordRMFI(2)};
TF_MFI(3,1) = {RMFI(2)};
TF_MFI(3,2) = {PMFI(2)};
writetable(TF_MFI,['/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/' hemi regionName '_CAT_table_fatigue_scores_MFIgen.csv'],'FileType','text','WriteRowNames',1)
clear TF_MFI

[RgitaMFI,PgitaRMFI]=corrcoef(MFI_scores_p(1:25),fatThic(1:25));
[RjordMFI,PjordRMFI]=corrcoef(MFI_scores_p(26:end),fatThic(26:end));
[RMFI,PMFI]=corrcoef(MFI_scores_p,fatThic);
TF_MFI = table('Size',[3 2],'VariableType',{'double','double'},'VariableNames',{'R','P-val'},'RowNames',{'Gita','Jordan','Both'});
TF_MFI(1,1) = {RgitaMFI(2)};
TF_MFI(2,1) = {RjordMFI(2)};
TF_MFI(1,2) = {PgitaRMFI(2)};
TF_MFI(2,2) = {PjordRMFI(2)};
TF_MFI(3,1) = {RMFI(2)};
TF_MFI(3,2) = {PMFI(2)};
writetable(TF_MFI,['/Users/ppzma/Google Drive/PhD/latex/affinity/3T_IBD/' hemi regionName '_CAT_table_fatigue_scores_MFIphy.csv'],'FileType','text','WriteRowNames',1)
clear TF_MFI





end



