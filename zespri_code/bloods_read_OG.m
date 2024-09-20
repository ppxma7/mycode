clear variables
close all
clc

userName = char(java.lang.System.getProperty('user.name'));

savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Zespri- fMRI - General/blood_results/'];
mypath = savedir;
%cd(mypath)

myFile = [mypath 'VITC-circulated.xlsx'];

modality = 'VITC';

theTable = readtable(myFile,'Sheet','condensed');

%% rearrange


numRows = height(theTable);
numMeans = floor(numRows / 3);
meanValues = zeros(numMeans, 1);

% Loop through the rows in steps of 3
for ii = 1:numMeans
    startIndex = (ii-1) * 3 + 1;
    endIndex = startIndex + 2;
    % Calculate the mean of the current group of 3 rows
    meanValues(ii) = mean(theTable.value(startIndex:endIndex));
end

% normalize by subject
meanValuesZ = normalize(meanValues);


regime = repmat({'fasted','100min'},1,4)';
regimeStack = repmat(regime,4,1);

sub = [repmat({'Sub01'},8,1); repmat({'Sub04'},8,1);...
    repmat({'Sub13'},8,1); repmat({'Sub14'},8,1)];

visit = repmat({'Red','Red','Gold','Gold','Green','Green','Mtxdrn','Mtxdrn'},1,1)';
visitStack = repmat(visit,4,1);

%% print

mean(meanValues(contains(regimeStack,'fasted')))
std(meanValues(contains(regimeStack,'fasted')))
mean(meanValues(contains(regimeStack,'100min')))
std(meanValues(contains(regimeStack,'100min')))

%% plot
ylow = 0; yhigh = 2;
zylow = -2.4; zyhigh = 2.4;

thismap = [215,48,39;...
    253,184,99;...
    26,152,80;
    69,117,180];
thismap = thismap./256;

thismap2 = [189,189,189;...
    99,99,99];
thismap2 = thismap2./256;

close all

clear g
figure('Position',[100 100 1400 768])
g(1,1) = gramm('x',regimeStack,'y',meanValuesZ,'color',visitStack);
%g(1,1).stat_summary('type','std','geom',{'bar','black_errorbar'})
%g(1,1).stat_boxplot2('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
g(1,1).stat_boxplot()
g(1,1).set_names('x',[],'y',[modality ' Z Score'],'color','Visit')
g(1,1).axe_property('XGrid','on','YGrid','on','YLim',[zylow zyhigh]); %,'DataAspectRatio',[1 1 0 ])
g(1,1).set_color_options('map',thismap)

g(1,2) = gramm('x',sub,'y',meanValues,'color',visitStack);
g(1,2).stat_summary('type','std','geom',{'bar','black_errorbar'})
g(1,2).set_names('x',[],'y',[modality ' Raw Score'],'color','Visit')
g(1,2).axe_property('XGrid','on','YGrid','on','YLim',[ylow yhigh]); %,'DataAspectRatio',[1 1 0 ])
g(1,2).set_color_options('map',thismap)

g(2,1) = gramm('x',visitStack,'y',meanValuesZ,'color',regimeStack);
%g(2,1).stat_summary('type','std','geom',{'bar','black_errorbar'})
%g(2,1).stat_boxplot2('width', 0.5, 'dodge', 5, 'alpha', 0, 'linewidth', 2, 'drawoutlier',0)
g(2,1).stat_boxplot()
g(2,1).set_names('x',[],'y',[modality ' Z Score'],'color','Visit')
g(2,1).axe_property('XGrid','on','YGrid','on','YLim',[zylow zyhigh]);
g(2,1).set_color_options('map',thismap2)

g(2,2) = gramm('x',sub,'y',meanValues,'color',regimeStack);
g(2,2).stat_summary('type','std','geom',{'bar','black_errorbar'})
g(2,2).set_names('x',[],'y',[modality ' Raw Score'],'color','Visit')
g(2,2).axe_property('XGrid','on','YGrid','on','YLim',[ylow yhigh]);
g(2,2).set_color_options('map',thismap2)

%g.set_names('x','X','y',[modality ' Score'],'color','Visit')
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',10)
%g.axe_property('XGrid','on','YGrid','on','YLim',[ylow yhigh]); %,'DataAspectRatio',[1 1 0 ])
g.set_order_options('x',0,'color',0)
%g.set_color_options('map',thismap)


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

%% stats
[p,tbl,stats,terms] = anovan(meanValuesZ,{visitStack,regimeStack},'model','interaction','varnames',{'Kiwi','Regime'}); %interaction?

figure
[c,m,h,gnames] = multcompare(stats,"Dimension",1);
tbldom = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=gnames(tbldom.("Group A"));
tbldom.("Group B")=gnames(tbldom.("Group B"));
writecell(tbl,sprintf([savedir 'anova' modality],'%s'),'FileType','spreadsheet')
writetable(tbldom,sprintf([savedir 'mult_d1' modality],'%s'),'FileType','spreadsheet')

figure
[c,m,h,gnames] = multcompare(stats,"Dimension",2);
tbldom = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=gnames(tbldom.("Group A"));
tbldom.("Group B")=gnames(tbldom.("Group B"));
writetable(tbldom,sprintf([savedir 'mult_d2' modality],'%s'),'FileType','spreadsheet')

figure
[c,m,h,gnames] = multcompare(stats,"Dimension",[1 2]);
tbldom = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=gnames(tbldom.("Group A"));
tbldom.("Group B")=gnames(tbldom.("Group B"));
writetable(tbldom,sprintf([savedir 'mult_d12' modality],'%s'),'FileType','spreadsheet')


