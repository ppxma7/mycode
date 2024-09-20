% this is just Jordan's score
subjects = {'sub-003','sub-004','sub-005','sub-006','sub-008','sub-011',...
    'sub-012','sub-014','sub-020','sub-021','sub-022','sub-024','sub-025',...
    'sub-026','sub-027','sub-028','sub-033','sub-031','sub-032','sub-034',...
    'sub-038',};

jord_MFI_gen =  [16 5 16 16 19 9 18 9 4 13 10 20 7 12 4 9 8 9 10 9 14]';
jord_MFI_phy = [15 5 12 10 16 5 11 4 6 7  7  19 7 9  5 9 6 8 6 10 15]';

jord_group = {'FCD','HV','FCD','FCD','FCD','NFCD','FCD','NFCD','HV','NFCD','HV','FCD','NFCD',...
    'HV','HV','HV','NFCD','HV','NFCD','HV','FCD'}';

hads_a = [5 1 6 11 8 3 11 6 1 5 8 5 0 8 2 7 8 7 2 3 3];
hads_d = [8 0 6 7 6 1 7 0 0 3 2 10 2 6 1 5 2 3 2 3 3];
hads_tot = hads_a + hads_d;

moca_tot = [24 29 28 26 27 26 26 27 25 29 28 21 26 24 23 25 29 25 26 25 28 ];
moca_tot = moca_tot(:);

hads_a = hads_a(:);
hads_d = hads_d(:);
hads_tot = hads_tot(:);
hads3 = [hads_a;hads_d;hads_tot];
jordg3 = [jord_group; jord_group; jord_group];

whichHads = [repmat({'HADS_anx'},length(hads_a),1); ...
    repmat({'HADS_dep'},length(hads_a),1);...
    repmat({'HADS_tot'},length(hads_a),1)];
whichMoca = repmat({'MoCA'},length(moca_tot),1);
% gramm HADS
%% 
clear g
figure('Position',[100 100 1600 800])
g(1,1) = gramm('x',jordg3,'y',hads3,'color',whichHads);
g(1,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.3,'notch',false)
g(1,1).set_text_options('Font','Helvetica','base_size',16)
g(1,1).set_title('HADS: Median+IQR')
g(1,1).set_names('x','Group', 'y','HADS','color','Scale')
% mean and std too please 
g(1,2) = gramm('x',jordg3,'y',hads3,'color',whichHads);
g(1,2).stat_summary('type','std','geom',{'bar','black_errorbar'});
g(1,2).set_text_options('Font','Helvetica','base_size',16)
g(1,2).set_title('HADS: Mean+STD')
g(1,2).set_names('x','Group', 'y','HADS','color','Scale')

mymap = [201,148,199]./256;
% now for MoCA
a = 20;
b = 30;
g(2,1) = gramm('x',jord_group,'y',moca_tot,'color',whichMoca);
g(2,1).stat_boxplot('alpha',0,'linewidth',2,'width',0.2,'notch',false)
g(2,1).set_text_options('Font','Helvetica','base_size',16)
g(2,1).set_title('MoCA: Median+IQR')
g(2,1).set_names('x','Group', 'y','MoCA','color','Scale')
g(2,1).axe_property('YLim',[a b])
g(2,1).set_color_options('map',mymap)
g(2,1).set_layout_options('legend',true)
% mean and std too please 
g(2,2) = gramm('x',jord_group,'y',moca_tot,'color',whichMoca);
g(2,2).stat_summary('type','std','geom',{'bar','black_errorbar'},'width',0.2);
g(2,2).set_text_options('Font','Helvetica','base_size',16)
g(2,2).set_title('MoCA: Mean+STD')
g(2,2).set_names('x','Group', 'y','MoCA','color','Scale');
g(2,2).axe_property('YLim',[a b])
g(2,2).set_color_options('map',mymap)
g(2,2).set_layout_options('legend',true)

g.set_order_options('x',{'FCD','NFCD','HV'})
g.axe_property('YGrid','on','MinorGridLineStyle','-')

g.draw()

g(1,1).update('y',hads3);
g(1,1).geom_jitter('alpha',0.5,'dodge',0.6)
g(1,1).set_point_options('markers', {'o'} ,'base_size',15)
g(1,1).set_layout_options('legend',false)


g(2,1).update('y',moca_tot);
g(2,1).geom_jitter('alpha',0.5,'dodge',0.6)
g(2,1).set_point_options('markers', {'o'} ,'base_size',15)
g(2,1).set_layout_options('legend',false)
g.draw()

g.export('file_name','jordan_HADSMoCA_scale', ...
    'export_path',...
    '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/',...
    'file_type','pdf')


%% which to use for covariate?
mypath = '/Users/ppzma/The University of Nottingham/Michael_Sue - IBD - IBD/';
labels = [{'MFIgen'},{'HADSa'},{'HADSd'},{'HADStot'},{'MoCAtot'}];
labels2 = [{'MFIphy'},{'HADSa'},{'HADSd'},{'HADStot'},{'MoCAtot'}];
% use corrcoef as an array instead of loop

GEN = [jord_MFI_gen, hads_a,hads_d,hads_tot,moca_tot];
PHY = [jord_MFI_phy, hads_a,hads_d,hads_tot,moca_tot];

GENt = array2table(GEN,'VariableNames',labels);
PHYt = array2table(PHY,'VariableNames',labels2);

figure('Position',[100 100 1400 600])
subplot(1,2,1)
[r_gen,p_gen] = corrplot(GENt,'testR','on','alpha',0.05);
subplot(1,2,2)
[r_phy,p_phy] = corrplot(PHYt,'testR','on','alpha',0.05);

print([mypath 'MFI_HADS_MoCA_corrplot'],'-dpng')





