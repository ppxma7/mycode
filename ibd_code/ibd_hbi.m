% we need a new script that plots GMV/WMV/CT vs fatigue scores.
subjects = {'001_P01','001_P02','001_P04','001_P05','001_P06','001_P08','001_P12','001_P13',...
    '001_P15','001_P16','001_P17','001_P18','001_P19','001_P20','001_P21','001_P22',...
    '001_P23','001_P24','001_P26','001_P27','001_P28','001_P30','001_P31','001_P32',...
    '001_P33','001_P35','001_P37','001_P40','001_P41','001_P42','001_P43','001_P44',...
    '001_P45','004_P01',...
    'sub-003','sub-005', 'sub-006', 'sub-008','sub-012', 'sub-024', 'sub-038',...
    'sub-011', 'sub-014', 'sub-021', 'sub-025','sub-032','sub-033'};


mycamp2 = [99,99,99; 189,189,189];
mycamp2 = flipud(mycamp2)./256;

mycamp_emptyfill = [37,52,148; 255, 255, 255;44,127,184; 161,218,180; 255,255,204];
mycamp_emptyfill = mycamp_emptyfill./256;



mycamp = [37,52,148; 44,127,184; 65,182,196; 161,218,180; 255,255,204];
mycamp = mycamp./256;

mybla = [44,127,184];
mybla = mybla./256;
% these ibdf scores are only for patients for now.
ddur = [1 2 9 1 2 18 15 3 5 17 9 14 20 1 1 7 1 18 1 9 8 6 2 1 4 8 11 2 10,...
    2 10 2 7 1 17 9 18 4 17 11 40 29 3 8 4 28 13];
hbi = [6 9 6 3 0 6 8 4 3 5 2 8 3 5 3 8 8 2 9 1 0 8 5 1,...
    1 2 1 1 6 6 6 3 1 0 5 4 2 1 1 7 2 0 0 2 0 2 1];

age = [56 18 31 23 35 53 30 20 22 30 44 32 63 20 28 38 67 38 68 25 20 18 41 19,...
    28 25 24 62 32 22 31 24 41 18,...
    31 33 52 26 44 62 58 54 53 23 25 54 26];

x = hbi(:);

x_age = age(:);

ddur_grp1 = [repmat({'Active CD'},34,1); repmat({'Fatigued CD'},7,1); repmat({'Non-Fatigued CD'},6,1)];
ddur_grp2 = [repmat({'Active'},34,1); repmat({'Remission'},7+6,1)];

% stick fat scores together

figure
bb = gramm('x',{'Active n=34';'Remission n=13'},'y',[34;7+6],'color',{'Active';'Remission'});
bb.geom_bar
bb.set_names('x',[],'y',[])
bb.no_legend()
bb.set_color_options('map',mycamp2)
bb.set_order_options('x',0)
bb.set_text_options('Font','Helvetica','base_size',16)
bb.draw()
bb.export('file_name','numcount_hbi', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/hbi/',...
    'file_type','pdf')
[R,P] = corrcoef(x, x_age);
figure
clear g
g = gramm('x',x,'y',x_age);
g.stat_glm
g.set_point_options('markers', {'o'} ,'base_size',10)
g.set_text_options('Font','Helvetica','base_size',16)
g.set_names('x','Disease duration (years)','y','Age (years)')
g.set_order_options('x',0)
g.set_color_options('map',mybla)
g.draw()
g.update();
g.geom_point()
g.draw()



text(-20,1,['r=' num2str(round(R(2),4)) ])
text(-20,0.9,['p=' num2str(round(P(2),4)) ])


g.export('file_name','hbi_vs_age', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/hbi/',...
    'file_type','pdf')


%% CT

%m = gifti('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/march_2021_jg_disease_dur_ct/ddur_ct_poscon.gii');
m = gifti('/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/may_2021_jg_hbi_ct/hbictneg.gii');

%m = gifti('ct_fatigue_cluster_mask.gii'); % this is manually derived cluster mask from SPM
numClusters = max(nonzeros(m.cdata)); % chek how mnay clusters
sizeClusters = histc(m.cdata,1:max(m.cdata)); % size of clusters

clusterMean = zeros(numClusters,length(subjects),1); % make space
mypath = '/Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/surf/';


% takes about a minute for 6 clusters.
tic
for ii = 1:length(subjects)
    
    thicBoy = gifti([mypath 's15.mesh.thickness.resampled.m' subjects{ii} '.gii']); % all thickness 
    
    for jj = 1:numClusters
        clusterMean(jj,ii) = mean(thicBoy.cdata(find(m.cdata==jj))); % condensed! take the mean thick val in that cluster, loop over subs
    end
end
toc

% cd /Volumes/ares/data/IBD/STRUCTURAL/bias_corrected/CAT_outputs/sept_2020_jg_CT/
% 
% load('CD_HV_mdata.mat');
%regionName = 'lcaudate';

clusterMeanT = transpose(clusterMean);

[R,P] = corr(clusterMeanT, x);

%%
myfig = figure ;
nchips = 256;
surface = 'inflated';
hemi = 'r';


mycamp3 = [255,255,0];
mycamp3 = flipud(mycamp3)./256;
mycamp3 = repmat(mycamp3,256,1);

mycolormap = mycamp3;
subdir = '/Volumes/ares/data/IBD/STRUCTURAL/freesurfer_outputs';

if strcmpi(hemi,'l')
    mycdata = m.cdata(1:163842);
    mycdata = mycdata(:);
    myvertices= m.vertices(1:163842);
    myvertices = myvertices(:);
else
    mycdata = m.cdata(163842:end);
    mycdata = mycdata(:);
    myvertices= m.vertices(163842:end);
    myvertices = myvertices(:);
end



go_paint_freesurfer(mycdata,'fsaverage',hemi,'range',[0.1 max(mycdata)],'colormap',mycolormap,'customcmap',surface',surface,'subjects_dir',subdir,'nchips',nchips);
view(90,0)
file_path = '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/hbi/';
filename = ['hbi_surf_r2'];
file_path_name = [file_path filename];
print(myfig,file_path_name, '-dpng', '-opengl', '-r300');


%%
figure('Position',[100 100 1800 800])
clear g
g(1,1) = gramm('x',x,'y',clusterMeanT(:,1));
g(1,1).stat_glm
g(1,1).set_point_options('markers', {'o'} ,'base_size',10)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_names('x','HBI','y','Right mid temporal gyrus (mm)')
g(1,1).set_order_options('x',0)
g(1,1).set_color_options('map',[0 0 0])

g(1,2) = gramm('x',x,'y',clusterMeanT(:,2));
g(1,2).stat_glm
g(1,2).set_point_options('markers', {'o'} ,'base_size',10)
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_names('x','HBI','y','Left inferior frontal gyrus (mm)')
g(1,2).set_order_options('x',0)
g(1,2).set_color_options('map',[0 0 0])

g(1,3) = gramm('x',x,'y',clusterMeanT(:,3));
g(1,3).stat_glm
g(1,3).set_point_options('markers', {'o'} ,'base_size',10)
g(1,3).set_text_options('Font','Helvetica','base_size',16)
g(1,3).set_names('x','HBI','y','Right mid temporal gyrus (subc) (mm)')
g(1,3).set_order_options('x',0)
g(1,3).set_color_options('map',[0 0 0])

g(2,1) = gramm('x',x,'y',clusterMeanT(:,4));
g(2,1).stat_glm
g(2,1).set_point_options('markers', {'o'} ,'base_size',10)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_names('x','HBI','y','Left frontal pole (mm)')
g(2,1).set_order_options('x',0)
g(2,1).set_color_options('map',[0 0 0])


g.draw()

g(1,1).update('color',ddur_grp2)
g(1,1).geom_point('edgewidth',2)
g(1,1).set_color_options('map',mycamp_emptyfill)
g(1,2).update('color',ddur_grp2)
g(1,2).geom_point('edgewidth',2)
g(1,2).set_color_options('map',mycamp_emptyfill)
g(1,3).update('color',ddur_grp2)
g(1,3).geom_point('edgewidth',2)
g(1,3).set_color_options('map',mycamp_emptyfill)
g(2,1).update('color',ddur_grp2)
g(2,1).geom_point('edgewidth',2)
g(2,1).set_color_options('map',mycamp_emptyfill)

g.draw()


text(-1,13,['r=' num2str(round(R(1),4)) ])
text(-1,12,['p=' num2str(round(P(1),4)) ])
text(45,13,['r=' num2str(round(R(2),4)) ])
text(45,12,['p=' num2str(round(P(2),4)) ])
text(90,13,['r=' num2str(round(R(3),4)) ])
text(90,12,['p=' num2str(round(P(3),4)) ])
text(-1,3,['r=' num2str(round(R(4),4)) ])
text(-1,2,['p=' num2str(round(P(4),4)) ])




g.export('file_name','ct_hbi', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/newResults/hbi/',...
    'file_type','pdf')








