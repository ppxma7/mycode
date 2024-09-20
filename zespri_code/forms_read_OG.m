clear variables
close all
clc

userName = char(java.lang.System.getProperty('user.name'));

savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Zespri- fMRI - General/analysis/forms_results/'];
mypath = savedir;
%cd(mypath)

myFile = [mypath 'forms_edited.xlsx'];

PANAS = readtable(myFile,'Sheet','PANASkiwi');
MFS = readtable(myFile,'Sheet','MFSI-SFkiwi');
VAS = readtable(myFile,'Sheet','VASkiwi');

modality = 'VAS';

nSubs = 14;

if strcmpi(modality,'PANAS')
    theTable = PANAS;
    magN = height(theTable);
    ylow = 0; yhigh = 5;
elseif strcmpi(modality,'MFS')
    theTable = MFS;
    magN = height(theTable);
    ylow = 0; yhigh = 6;
elseif strcmpi(modality,'VAS')
    theTable = VAS;
    magN = height(theTable);
    ylow = 0; yhigh = 1;
end

%% groupings

kiwi = theTable.Var3;
kiwiGroup = [kiwi; kiwi; kiwi];

disRow = magN.*3;
% Make it so each column is a sub, and combine the 3 timepoints into one
% long column
YData = zeros(disRow,nSubs);
for ii = 1:nSubs
    if ii>9
        YData(:,ii) = [theTable{:,['sub' num2str(ii)]}; theTable{:,['sub' num2str(ii) '_1']}; theTable{:,['sub' num2str(ii) '_2']}];
    else
        YData(:,ii) = [theTable{:,['sub0' num2str(ii)]}; theTable{:,['sub0' num2str(ii) '_1']}; theTable{:,['sub0' num2str(ii) '_2']}];
    end
end

timePoints = [repmat({'Start'},magN,1); repmat({'Mid'},magN,1); repmat({'End'},magN,1)];

desc = theTable.Var1;
descGroup = [desc; desc; desc];

% now vectorise to match number of subs
vYData = YData(:);
vkiwiGroup = repmat(kiwiGroup,nSubs,1);
vtimePoints = repmat(timePoints,nSubs,1);
vdescGroup = repmat(descGroup,nSubs,1);

%% Plot
thismap = [215,48,39;...
    253,184,99;...
    26,152,80;
    69,117,180];
thismap = thismap./256;
close all

clear g
figure('Position',[100 100 1400 768])
g(1,1) = gramm('x',vtimePoints,'y',vYData,'color',vkiwiGroup);
g(1,1).stat_summary('type','std','geom',{'bar','black_errorbar'})

g(2,1) = gramm('x',vdescGroup,'y',vYData,'color',vkiwiGroup);
g(2,1).stat_summary('type','std','geom',{'bar','black_errorbar'})


g.set_names('x','X','y',[modality ' Score'],'color','Visit')
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',10)
g.axe_property('XGrid','on','YGrid','on','YLim',[ylow yhigh]); %,'DataAspectRatio',[1 1 0 ])
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
%%
% figure
% clear g
% g(1,1) = gramm('x',vdescGroup,'y',vYData,'color',vtimePoints);
% g(1,1).stat_summary('type','std','geom',{'bar','black_errorbar'})
% g.set_names('x','X','y',[modality ' Score'],'color','Visit')
% g.set_text_options('Font','Helvetica', 'base_size', 16)
% g.set_point_options('base_size',10)
% g.axe_property('XGrid','on','YGrid','on','YLim',[ylow yhigh]); %,'DataAspectRatio',[1 1 0 ])
% g.set_order_options('x',0,'color',0)
% %g.set_color_options('map',thismap)
% g.draw()

%% stats
%[p,tbl,stats,terms] = anovan(vYData,{vtimePoints,vkiwiGroup,vdescGroup},'model','interaction','varnames',{'Timepoints','Kiwi','Questions'}); %interaction?
[p,tbl,stats,terms] = anovan(vYData,{vtimePoints,vkiwiGroup},'model','interaction','varnames',{'Timepoints','Kiwi'}); %interaction?

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

% figure
% [c,m,h,gnames] = multcompare(stats,"Dimension",[2 3]);
% tbldom = array2table(c,"VariableNames", ...
%     ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
% tbldom.("Group A")=gnames(tbldom.("Group A"));
% tbldom.("Group B")=gnames(tbldom.("Group B"));
% writecell(tbl,sprintf([savedir 'anova' modality],'%s'),'FileType','spreadsheet')
% writetable(tbldom,sprintf([savedir 'mult_d23' modality],'%s'),'FileType','spreadsheet')





















