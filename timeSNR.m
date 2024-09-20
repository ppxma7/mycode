% script to read csv files output from fMRI_report_app (tSNR_report_app.m)
%
% nov2020 ma

%% MB4

shallisave = 1;
mypaths = {'2020_Q4/MB4_1p5mm_S1p5/QA_report/',...
    };

%% MB3
shallisave = 1;
mypaths = {'2018_Q3/MB3_1p5mm/QA_report_2/',...
    '2018_Q4/MB3_1p5mm/QA_report/',...
    '2019_Q1/MB3_1p5mm/QA_report/',...
    '2019_Q2/MB3_1p5mm/QA_report_1/',...
    '2019_Q2/MB3_1p5mm/QA_report_2/',...
    '2019_Q3/MB3_1p5mm/QA_report_1/',...
    '2019_Q3/MB3_1p5mm/QA_report_2/',...
    '2020_Q4/MB3_1p5mm/QA_report/',...
    '2020_Q4/MB3_1p5mm/QA_report2',...
    };

%% MB1
shallisave = 1;
mypaths = {'2016_Q4/MB1_1p25mm/QA_report_1',...
    '2016_Q4/MB1_1p25mm/QA_report_2',...
    '2017_Q3/MB1_1p5mm/QA_report_1',...
    '2017_Q3/MB1_1p5mm/QA_report_2',...
    '2017_Q4/MB1_1p5mm/QA_report',...
    '2020_Q1/MB1_1p25mm/QA_report',...
    '2020_Q4/MB1_1p25mm_S2p5/QA_report1',...
    '2020_Q4/MB1_1p25mm_S2p5/QA_report2',...
    };

%% MB2
shallisave = 1;
mypaths = {'2016_Q3/MB2_1p5mm/QA_report',...
    '2017_Q1/MB2_1p25mm/QA_report_1',...
    '2017_Q1/MB2_1p25mm/QA_report_2',...
    '2017_Q1/MB2_1p25mm/QA_report_3',...
    '2017_Q1/MB2_1p25mm/QA_report_4',...
    '2017_Q4/MB2_1p5mm/QA_report',...
    '2020_Q1/testing/QA_report',...
    '2020_Q4/MB2_1p25mm_S2/QA_report2',...
    };
% '2020_Q4/MB2_1p25mm_S2/QA_report1',...

%%

% very dirty

% originally lots of magic nums
% basically older versions of generating the report/how the file is claled
% included text. This is annoying.
% Originaly just cleaved off the end because this is wehere it ususally
% was, but this is bad,
% now is better
% 
% Now we use isletter to make sure there aren't any letters inside.
%
% still dodgy bit is checking there is a row included :(

fudge = struct;

%mymagic = 10;

for ii = 1:length(mypaths)
    
    cd(['/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/archived_qa/tSNR_7T/' mypaths{ii}])
    A = readcell('mean_tSNR_data.csv');
    Av = A(:,1); % grab the values
    %Avc = table2cell(Av); %convert to cell
    Avc = Av;
    if sum(isletter(Avc{1})) > sum(~isletter(Avc{1})) % bad way to check for row
        Avc(1) = [];
    end
    
    AD = zeros(length(Avc),1,1);
    
    
    for jj = 1:length(Avc)
        
        tmpch = string(Avc(jj)); % because we have a cell array
        tmpch = char(tmpch); 
        
        
        %tmpch = char(Avc(jj));
        idx = isletter(tmpch); % isletter checks for letters
        tmpch(idx)=[]; % delete letters
        tmpch_dub = str2double(tmpch);
        AD(jj) = tmpch_dub;
    end
    
    %Avc_str = string(Avc); % new, convert cell 2 string
    %AD = str2double(Avc_str); % switch it up to a double
    
    %if any(isnan(AD)) % sanity check, just in case there are any letters
    %ADcell = cellfun(@(S) S(1:end-mymagic), Avc_str, 'Uniform', 0);
    %AD = str2double(ADcell); % now should catch
    %end
    
    
    
    tmp = mypaths{ii};
    tmp = {tmp};
    mydatestr = cellfun(@(D) D(1:7), tmp, 'Uniform', 0); %for gramm
    ADtext = repmat(mydatestr, length(AD),1);
    
    % stick it in a struct
    fudge(ii).coffee = AD;
    fudge(ii).cream = ADtext;
    clear AD
end


% gramm
myvals = cat(1,fudge.coffee);
mydats = cat(1,fudge.cream);

%% for MB4
% clean up some TR1s data

clear g
close all
figure
g = gramm('x',mydats,'y',myvals);
g.geom_jitter()
g.set_point_options('markers',{'o'},'base_size',10)
g.set_order_options('x',0)
g.axe_property('YLim', [0 100])
g.set_text_options('base_size',16)
g.set_names('x','annual quarter','y', 'mean tSNR per scan')
g.set_title('2D-GRE-EPI, MB4, TR1.5s, 1.5mm')
g.draw()
% do this post hoc to find the handle and edit the edge propeprties of the
% points (default is the reverse)
set(g.results.geom_jitter_handle,'MarkerEdgeColor',g.results.draw_data.color,'MarkerFaceColor','none')

if shallisave == 1
    g.export('file_name', 'MB4_1p5_TR1p5',...
        'export_path','/Users/ppzma/The University of Nottingham/Brain acq analysis - QA/tSNR_7T/',...
        'file_type','pdf')
end

%% for MB3
% clean up some TR1s data
% myvals(1:2) = [];
% mydats(1:2) = [];

clear g
close all
figure
g = gramm('x',mydats,'y',myvals);
g.geom_jitter()
g.set_point_options('markers',{'o'},'base_size',10)
g.set_order_options('x',0)
g.axe_property('YLim', [0 100])
g.set_text_options('base_size',16)
g.set_names('x','annual quarter','y', 'mean tSNR per scan')
g.set_title('2D-GRE-EPI, MB3, TR2s, 1.5mm')
g.draw()
% do this post hoc to find the handle and edit the edge propeprties of the
% points (default is the reverse)
set(g.results.geom_jitter_handle,'MarkerEdgeColor',g.results.draw_data.color,'MarkerFaceColor','none')

if shallisave == 1
    g.export('file_name', 'MB3_1p5_TR2',...
        'export_path','/Users/ppzma/The University of Nottingham/Brain acq analysis - QA/tSNR_7T/',...
        'file_type','pdf')
end


%% for MB1, add grouping of resolutions
ex = extractfield(fudge,'cream');
myRes1 = repmat({'1.25mm'},length(cat(1,ex{1:2})),1);
myRes2 = repmat({'1.50mm'},length(cat(1,ex{3:5})),1);
myRes3 = repmat({'1.25mm'},length(cat(1,ex{6:8})),1);
myRes = [myRes1;myRes2;myRes3];

clear g
close all
figure('Position',[100 100 650 400])
g = gramm('x',mydats,'y',myvals,'color',myRes);
g.geom_jitter()
g.set_point_options('markers',{'o'},'base_size',10)
g.set_order_options('x',0)
g.axe_property('YLim', [0 100])
g.set_text_options('base_size',16)
g.set_names('x','annual quarter','y', 'mean tSNR per scan')
g.set_title('2D-GRE-EPI, MB1, TR2s')
g.draw()
% do this post hoc to find the handle and edit the edge propeprties of the
% points (default is the reverse)
set(g.results.geom_jitter_handle(1),'MarkerEdgeColor',g.results.draw_data(1).color,'MarkerFaceColor','none')
set(g.results.geom_jitter_handle(2),'MarkerEdgeColor',g.results.draw_data(2).color,'MarkerFaceColor','none')

if shallisave == 1
    g.export('file_name', 'MB1_TR2',...
        'export_path','/Users/ppzma/The University of Nottingham/Brain acq analysis - QA/tSNR_7T/',...
        'file_type','pdf')
end

%% for MB2, add grouping of resolutions
myvals = cat(1,fudge.coffee);
mydats = cat(1,fudge.cream);

ex = extractfield(fudge,'cream');
myRes1 = repmat({'1.50mm MB2 '},length(cat(1,ex{1})),1);
myRes2 = repmat({'1.25mm MB2 '},length(cat(1,ex{2:5})),1);
myRes3 = repmat({'1.50mm MB2 '},length(cat(1,ex{6})),1);
myRes4 = repmat({'1.25mm MB2 '},length(cat(1,ex{7:8})),1);
%myRes4 = myRes4(1:5);
myRes = [myRes1;myRes2;myRes3;myRes4];
myRes(43)={'MB1 1.25mm'};
%myRes(49)={'1.50mm'};
myRes(56:57)={'MB1 1.25mm'};
%myRes(57:58) = {'MB1 1.25mm'};
% clean up some MB1 data
% myvals(end-5) = [];
% mydats(end-5) = [];

clear g
close all
figure('Position',[100 100 650 400])
g = gramm('x',mydats,'y',myvals,'color',myRes);
g.geom_jitter()
g.set_point_options('markers',{'o'},'base_size',10)
g.set_order_options('x',0)
g.axe_property('YLim', [0 100])
g.set_text_options('base_size',16)
g.set_names('x','annual quarter','y', 'mean tSNR per scan')
g.set_title('2D-GRE-EPI, MB2, TR2s')
g.draw()
% do this post hoc to find the handle and edit the edge propeprties of the
% points (default is the reverse)
set(g.results.geom_jitter_handle(1),'MarkerEdgeColor',g.results.draw_data(1).color,'MarkerFaceColor','none')
set(g.results.geom_jitter_handle(2),'MarkerEdgeColor',g.results.draw_data(2).color,'MarkerFaceColor','none')
set(g.results.geom_jitter_handle(3),'MarkerEdgeColor',g.results.draw_data(3).color,'MarkerFaceColor','none')

if shallisave == 1
    g.export('file_name', 'MB2_TR2',...
        'export_path','/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging for Neuroscience/archived_qa/tSNR_7T/',...
        'file_type','pdf')
end

hline(mean([myvals(9:38); myvals(44:55)]));






