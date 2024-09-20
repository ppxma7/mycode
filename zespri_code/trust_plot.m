% This is a script to plot the values from the TRUST csv files
% Data acquired from the ZESPRI study in May 2023
% There are 4 conditions: Red, Gold, Green, MTX, and 2 TRUST scans per
% subject
% Need to be careful, because, some subjects did Red first, rather than
% Gold, so A and B are swapped.
% 
% See Also trustcode.m 
%
% Michael Asghar May 2024
close all
clear variables
clc
thisCSV='/Volumes/hermes/zespri_tasks/trust/trust_subject_data_firstpass_corrected.csv';
csvFile=readtable(thisCSV);

userName = char(java.lang.System.getProperty('user.name'));
savedir = ['/Users/' userName '/The University of Nottingham/Zespri- fMRI - General/analysis/trust/'];


% here is the key output from trustcode.m
Yv_values = csvFile.Yv___;
stdR2 = csvFile.StdErrorR2;

nRepeats = 8;
nRepeats_sessions = 56;

% group by subjects
mySubs=[repmat({'sub1'},nRepeats,1),repmat({'sub2'},nRepeats,1),...
    repmat({'sub3'},nRepeats,1),repmat({'sub4'},nRepeats,1),...
    repmat({'sub5'},nRepeats,1),repmat({'sub6'},nRepeats,1),...
    repmat({'sub7'},nRepeats,1),repmat({'sub8'},nRepeats,1),...
    repmat({'sub9'},nRepeats,1),repmat({'sub10'},nRepeats,1),...
    repmat({'sub11'},nRepeats,1),repmat({'sub12'},nRepeats,1),...
    repmat({'sub13'},nRepeats,1),repmat({'sub14'},nRepeats,1)];
mySubs=mySubs(:);

% group by sessions
mySessions=repmat({'session1','session2'},1,nRepeats_sessions);
mySessions=mySessions(:);

% Subjects 7-11 had Gold first
kiwi1 = {'Red','Red','Gold','Gold','Green','Green','MTX','MTX'}';
kiwi2 = {'Gold','Gold','Red','Red','Green','Green','MTX','MTX'}';
kiwiGroup = [repmat(kiwi1,6,1); repmat(kiwi2,5,1); repmat(kiwi1,3,1)];

%% okay now plot
close all
figure('Position',[100 100 800 600])
%figure
% Convert to table for easier handling
data = table(mySessions', mySubs', kiwiGroup', Yv_values', ...
             'VariableNames', {'Session', 'Subject', 'KiwiType', 'Values'});

clear g
thisFont='Helvetica';
myfontsize=14;
g = gramm('x', data.KiwiType, 'y', data.Values, 'color', data.KiwiType);
g.stat_boxplot('width',2,'alpha', 0,'linewidth', 2, 'drawoutlier',0)
g.set_text_options('font', thisFont, 'base_size', myfontsize)
g.set_names('x','Condition', 'y', 'Yv TRUST')
g.set_order_options('x',0,'color',0)
g.draw()

g.update('y',data.Values,'color',data.Subject)
g.geom_jitter
g.set_point_options('base_size',8)
g.draw()
filename = 'trust_yv_subject';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

figure('Position',[100 100 800 600])
clear g
thisFont='Helvetica';
myfontsize=14;
g = gramm('x', data.KiwiType, 'y', data.Values, 'color', data.KiwiType);
g.stat_boxplot('width',2,'alpha', 0,'linewidth', 2, 'drawoutlier',0)
g.set_text_options('font', thisFont, 'base_size', myfontsize)
g.set_names('x','Condition', 'y', 'Yv TRUST')
g.set_order_options('x',0,'color',0)
g.draw()

g.update('y',data.Values,'color',data.Session)
g.geom_jitter
g.set_point_options('base_size',8)
g.draw()
filename = 'trust_yv_session_corrected';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

%% Anova now


[P, ANOVATAB, STATS] = anova1(data.Values,data.KiwiType);

[COMPARISON,MEANS,H,GNAMES] = multcompare(STATS);
tbldom = array2table(COMPARISON,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbldom.("Group A")=GNAMES(tbldom.("Group A"));
tbldom.("Group B")=GNAMES(tbldom.("Group B"));
writetable(tbldom,[savedir 'mult_anova_trust'],'FileType','spreadsheet')




%% also compare Yv with error

figure
g = gramm('x',stdR2,'y',Yv_values,'color',mySubs);
g.geom_point()
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',10)
g.axe_property('XGrid','on','YGrid','on')
g.set_names('x', 'Standard Error in R2', 'y', 'Yv')
%g.set_title('Correlation to atlas CT')
%g.set_order_options('x',0)]
%g.set_color_options('map','brewer2');
g.draw()
filename = 'trust_yv_vs_r2_std_corrected';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')



























