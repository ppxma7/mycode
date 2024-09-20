% Look at tSNR drops again
%
% February 2023 ma
%
% 7T
%
%
shallisave = 1;
mypaths_prenordic = {'/Volumes/nemosine/260821_prf_14359/nordic/magnitude/',...
    '/Volumes/nemosine/210922_prf3/magnitude/',...
    '/Volumes/nemosine/210924_prf4/magnitude/',...
    '/Volumes/nemosine/211004_prf6/magnitude/',...
    '/Volumes/nemosine/211011_prf7/magnitude/',...
    '/Volumes/nemosine/211129_prf8/magnitude/',...
    '/Volumes/nemosine/211203_prf9/magnitude/',...
    '/Volumes/nemosine/211207_prf10/magnitude/',...
    '/Volumes/nemosine/211215_prf11/magnitude/',...
    '/Volumes/hermes/pain_01_12778_221117/magnitude/',...
    '/Volumes/hermes/pain_02_15435_221117/magnitude/',...
    '/Volumes/hermes/pain_03_11251_221129/magnitude/',...
    '/Volumes/hermes/pain_04_14359_230110/magnitude/',...
    '/Volumes/hermes/pain_05_11766_230123/magnitude/',...
    '/Volumes/hermes/pain_06_15252_230126/magnitude/',...
    '/Volumes/hermes/230117_prf12/magnitude/',...
    };

mypaths_postnordic = {'/Volumes/nemosine/260821_prf_14359/topup/',...
    '/Volumes/nemosine/210922_prf3/topup/',...
    '/Volumes/nemosine/210924_prf4/topup/',...
    '/Volumes/nemosine/211004_prf6/topup/',...
    '/Volumes/nemosine/211011_prf7/topup/',...
    '/Volumes/nemosine/211129_prf8/topup/',...
    '/Volumes/nemosine/211203_prf9/topup/',...
    '/Volumes/nemosine/211207_prf10/topup/',...
    '/Volumes/nemosine/211215_prf11/topup/',...
    '/Volumes/hermes/pain_01_12778_221117/topup/',...
    '/Volumes/hermes/pain_02_15435_221117/topup/',...
    '/Volumes/hermes/pain_03_11251_221129/topup/',...
    '/Volumes/hermes/pain_04_14359_230110/topup/',...
    '/Volumes/hermes/pain_05_11766_230123/topup/',...
    '/Volumes/hermes/pain_06_15252_230126/topup/',...
    '/Volumes/hermes/230117_prf12/topup/',...
    };
% 
% mydates = {'2022_Nov','2022_Nov','2022_Nov','2023_Jan','2023_Jan','2023_Jan',...
%     '2021_Aug','2021_Sep','2021_Sep','2021_Oct','2021_Oct','2021_Nov',...
%     '2021_Dec','2021_Dec','2021_Dec','2023_Jan'};

mydates = {'2021_Aug','2021_Sep','2021_Sep','2021_Oct','2021_Oct','2021_Nov',...
    '2021_Dec','2021_Dec','2021_Dec',...
    '2022_Nov','2022_Nov','2022_Nov','2023_Jan','2023_Jan','2023_Jan',...
    '2023_Jan'};


mydates = mydates';
%%

fudge = struct;

for ii = 1:length(mypaths_prenordic)
    
    %cd(['/Users/ppzma/The University of Nottingham/Brain acq analysis - QA/tSNR_7T/' mypaths{ii}])
    A = readcell([mypaths_prenordic{ii} 'mean_tSNR_data.csv']);
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
    
    tmp = mypaths_prenordic{ii};
    tmp = {tmp};
    mydatestr = cellfun(@(D) D(10:17), tmp, 'Uniform', 0); %for gramm
    %ADtext = repmat(mydatestr, length(AD),1);
    
    % stick it in a struct
    fudge(ii).coffee = AD;
    fudge(ii).cream = repmat(mydates(ii),1,length(AD));
    clear AD
end


% gramm
myvals = cat(1,fudge.coffee);
mydats = cat(2,fudge.cream);
mydats = mydats(:);

%% now everything is in order... we can begin.


% mydates_reordered = {'2021_Aug','2021_Sep','2021_Sep','2021_Oct','2021_Oct','2021_Nov',...
%     '2021_Dec','2021_Dec','2021_Dec',...
%     '2022_Nov','2022_Nov','2022_Nov','2023_Jan','2023_Jan','2023_Jan',...
%     '2023_Jan'};
% 
% mydates = {'2022_Nov','2022_Nov','2022_Nov','2023_Jan','2023_Jan','2023_Jan',...
%     '2021_Aug','2021_Sep','2021_Sep','2021_Oct','2021_Oct','2021_Nov',...
%     '2021_Dec','2021_Dec','2021_Dec','2023_Jan'};

%mydates_sorted = sort(mydats);

clear g
close all
figure 
g = gramm('x',mydats,'y',myvals);
g.geom_jitter()
g.set_point_options('markers',{'o'},'base_size',10)
g.set_order_options('x',0)
g.axe_property('YLim', [0 100])
g.set_text_options('base_size',16)
g.set_names('x','date','y', 'mean tSNR per scan')
g.set_title('2D-GRE-EPI, MB2, TR2s, 1.25mm')
g.draw()
% do this post hoc to find the handle and edit the edge propeprties of the
% points (default is the reverse)
set(g.results.geom_jitter_handle,'MarkerEdgeColor',g.results.draw_data.color,'MarkerFaceColor','none')

if shallisave == 1
    g.export('file_name', 'pre_MB2_1p25_TR2',...
        'export_path','/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging For Neuroscience/tSNR_jan2023_7T/',...
        'file_type','pdf')
end


%% post nordic
clc


fudge = struct;

for ii = 1:length(mypaths_postnordic)
    
    %cd(['/Users/ppzma/The University of Nottingham/Brain acq analysis - QA/tSNR_7T/' mypaths{ii}])
    A = readcell([mypaths_postnordic{ii} 'mean_tSNR_data.csv']);
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
    
    tmp = mypaths_postnordic{ii};
    tmp = {tmp};
    mydatestr = cellfun(@(D) D(10:17), tmp, 'Uniform', 0); %for gramm
    %ADtext = repmat(mydatestr, length(AD),1);
    
    % stick it in a struct
    fudge(ii).coffee = AD;
    fudge(ii).cream = repmat(mydates(ii),1,length(AD));
    clear AD
end


% gramm
myvals = cat(1,fudge.coffee);
mydats = cat(2,fudge.cream);
mydats = mydats(:);



clear g
close all
figure 
g = gramm('x',mydats,'y',myvals);
g.geom_jitter()
g.set_point_options('markers',{'o'},'base_size',10)
g.set_order_options('x',0)
g.axe_property('YLim', [0 100])
g.set_text_options('base_size',16)
g.set_names('x','date','y', 'mean tSNR per scan')
g.set_title('2D-GRE-EPI, MB2, TR2s, 1.25mm')
g.draw()
% do this post hoc to find the handle and edit the edge propeprties of the
% points (default is the reverse)
set(g.results.geom_jitter_handle,'MarkerEdgeColor',g.results.draw_data.color,'MarkerFaceColor','none')

if shallisave == 1
    g.export('file_name', 'post_MB2_1p25_TR2',...
        'export_path','/Users/ppzma/The University of Nottingham/SPMIC User Groups - Imaging For Neuroscience/tSNR_jan2023_7T/',...
        'file_type','pdf')
end





