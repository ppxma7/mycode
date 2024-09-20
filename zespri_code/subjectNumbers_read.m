clear variables
close all
clc

userName = char(java.lang.System.getProperty('user.name'));

savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Zespri- fMRI - General/analysis/subjectNumbers_results/'];
mypath = savedir;
%cd(mypath)

myFile = [mypath 'subjectNumbers.xlsx'];

myFile = readtable(myFile,'Sheet',2);


modality = 'subjectNumbers';

nSubs = 14;


theTable = myFile;
magN = height(theTable);
ylow = 0; yhigh = 5;


theTable.VitCFastedLogical = strcmp(theTable.VitCFasted, 'Y');
theTable.VitCEndLogical = strcmp(theTable.VitCEnd, 'Y');
theTable.PolyFastedLogical = strcmp(theTable.PolyphenolFasted, 'Y');
theTable.PolyEndLogical = strcmp(theTable.PolyphenolEnd, 'Y');


% grouped_data = groupsummary(theTable, {'SubjectNumber', 'VisitNumber'}, 'sum', 'VitCFastedLogical');
% grouped_data.Properties.VariableNames{'sum_VitCFastedLogical'} = 'CountY';
% subject_groups = findgroups(theTable.SubjectNumber);
% count_Y = splitapply(@sum, theTable.VitCFastedLogical, subject_groups);
% 
% count_table = table(unique(theTable.SubjectNumber), count_Y, ...
%                     'VariableNames', {'SubjectNumber', 'CountY'});



%%
figure
thismap = [215,48,39;...
    253,184,99;...
    26,152,80;
    69,117,180];
thismap = thismap./256;
close all

clear g
figure('Position',[100 100 1400 768])
g(1,1) = gramm('x',theTable.SubjectNumber,'y',theTable.VitCFastedLogical,'color',theTable.VisitNumber);
g(1,1).geom_bar('stacked', 1,'width', 0.7);
g(1,1).set_title('Vit C Fasted')

g(1,2) = gramm('x',theTable.SubjectNumber,'y',theTable.VitCEndLogical,'color',theTable.VisitNumber);
g(1,2).geom_bar('stacked', 1,'width', 0.7);
g(1,2).set_title('Vit C End')

g(2,1) = gramm('x',theTable.SubjectNumber,'y',theTable.PolyFastedLogical,'color',theTable.VisitNumber);
g(2,1).geom_bar('stacked', 1,'width', 0.7);
g(2,1).set_title('Polyphenol Fasted')

g(2,2) = gramm('x',theTable.SubjectNumber,'y',theTable.PolyEndLogical,'color',theTable.VisitNumber);
g(2,2).geom_bar('stacked', 1,'width', 0.7);
g(2,2).set_title('Polyphenol End')

g.set_names('x','Subject','y','Sum','color','Visit')
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',10)
%g.axe_property('XGrid','on','YGrid','on','YLim',[ylow yhigh]); %,'DataAspectRatio',[1 1 0 ])
g.set_order_options('x',0,'color',0)
g.set_color_options('map',thismap)
g.draw()

filename = sprintf(['plot_' modality],'%s');
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')



g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','eps')





