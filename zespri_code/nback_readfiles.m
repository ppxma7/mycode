%% Script to read in n-back tasks results and print out
% how many correct
clear variables
close all
clc

userName = char(java.lang.System.getProperty('user.name'));

savedir = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Zespri- fMRI - General/analysis/nback/'];
mypath = '/Volumes/r15/DRS-7TfMRI/michael/ZESPRI/zespri_nback/';
cd(mypath)

mysubs = {'DM','AH','LZ','AD','TS','SE','ACG','GC','YZ','MH','NM','AF','MirA','RH'};
%mysubs = {'MH'};
myruns = {'run01','run02','run03','run04'};

% load files
myletter_path = ['/Users/' userName '/Documents/MATLAB/nottingham/michael/michael_nback/psychopy_nback_fMRI_final/letter_sequences/'];
myletter = {'all_letters_run01','all_letters_run02','all_letters_run03','all_letters_run04'};

myblock_path = ['/Users/' userName '/Documents/MATLAB/nottingham/michael/michael_nback/psychopy_nback_fMRI_final/block_sequences/'];
myblock = {'run01','run02','run03','run04'};

for iSub = 1:length(mysubs)

    for iRun = 1:length(myruns)

        thisTask = [mypath mysubs{iSub} '_' myruns{iRun} '.txt'];
        thisLetter = [myletter_path myletter{iRun} '.txt'];
        thisBlock = [myblock_path myblock{iRun} '.txt'];

        % grab responses in cell
        fileID_task = fopen(thisTask);
        D = textscan(fileID_task,'%s%s');
        DRT = D{1,2};
        DRTn = str2double(DRT);
        Dbtn = D{1,1};
        fclose(fileID_task);

        %% get reaction times?
        logButton = contains(Dbtn,'btn');
        idxButton = find(logButton);
        idxButtonBefore = idxButton-1;
        buttonPress = DRTn(idxButton);
        waitPress = DRTn(idxButtonBefore);
        reactionTime = buttonPress - waitPress;
        meanReactionTime(iSub,iRun) = mean(reactionTime,1);

        %%

        % in 0,1,2-back consecutive order
        fileID_letter = fopen(thisLetter);
        C = textscan(fileID_letter,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s'); % this is better advised than textread for some reason
        Cs = strcat(C{:});
        % negate any spaces at end
        Cs = {Cs{1,1}(1:15); Cs{2,1}(1:15);Cs{3,1}(1:15); Cs{4,1}(1:15); ...
            Cs{5,1}(1:15); Cs{6,1}(1:15); Cs{7,1}(1:15); Cs{8,1}(1:15); ...
            Cs{9,1}(1:15); Cs{10,1}(1:15); Cs{11,1}(1:15); Cs{12,1}(1:15); ...
            };

        fclose(fileID_letter);

        % this is the order run in the scanner
        fileID_block = fopen(thisBlock);
        R = textscan(fileID_block,'%d');
        R_block = double(R{1,1});
        R_block = R_block+1; % account for 0 counting system

        % get the run order in terms of task
        run_order = [repmat({'0-back'},4,1); repmat({'1-back'},4,1); repmat({'2-back'},4,1)];
        run_order_task = run_order(R_block);

        % first, clean up responses
        Dbtn_clv = Dbtn(2:end-1); % don't need start and end points
        dex = strcmpi(Dbtn_clv,'btn');
        Dbtn_clv(dex) = {'0'}; % set every response to 0
        Dbtn_dub = str2double(Dbtn_clv);

        % remove extraneous responses, .e.g when there is a wait, instruction
        % screen etc
        Dbtn_dub(Dbtn_dub==1) = NaN;
        Dbtn_dub(Dbtn_dub==2) = NaN;
        Dbtn_dub(Dbtn_dub==3) = NaN;
        Dbtn_dub(Dbtn_dub==4) = NaN;
        Dbtn_dub(Dbtn_dub==5) = NaN;
        Dbtn_dub(Dbtn_dub==6) = NaN;

        % remove them
        Dbtn_cleannans = Dbtn_dub(~isnan(Dbtn_dub));
        % find where the responses are. this is tricky, because the btn press is
        % actually in response to the previous index, so we need to account for
        % this
        fdex = find(Dbtn_cleannans==0);

        % can't do simple subtraction. Because if the response is that letter 2 is
        % a target (0-back), then the btn happens at 3, so 3-1 = 2. Fine, but then
        % what about when target is at 7, response is not at 6, but actually at 5,
        % because you've added 2 entries into the vec with your btn.
        cumul = 1;
        for ii = 1:length(fdex)
            fdex_cumul(ii) = fdex(ii)-cumul;
            cumul = cumul+1;
        end

        fdex_cumul = fdex_cumul(:); % correct response positions

        fdex_zeros = zeros(180,1); % 15*12 = 180
        fdex_zeros(fdex_cumul)=1; % now, this is it. all task responses correctly.


        %% Next, we need to make the "perfect" responses so we know what is 100%
        % 0back is easy, just look for target and strcmpi
        for ii = 1:4
            master_zero(:,ii) = strcmpi(transpose(Cs{ii}),{'x'});
        end


        % 1back - harder, could use strcmpi, but i went a different route using
        % regexp

        % bit silly but works
        alphabet = {'aa','bb','cc','dd','ee','ff','gg','hh','ii','jj','kk','ll','mm','nn','oo','pp',...
            'qq','rr','ss','tt','uu','vv','ww','xx','yy','zz'};
        % account for 3 letter consec, would count as 2 targets
        alphabet2 = {'aaa','bbb','ccc','ddd','eee','fff','ggg','hhh','iii','jjj','kkk','lll','mmm','nnn','ooo','ppp',...
            'qqq','rrr','sss','ttt','uuu','vvv','www','xxx','yyy','zzz'};

        ncount = 1;
        for ii = 5:8 %From Cs letters which are in consecutive ordering
            %ncount = 1;
            tmp = Cs{ii};

            [st,en] = regexp(tmp,alphabet);
            st_mat = cell2mat(st);
            en_mat = cell2mat(en);
            %en_mat-st_mat;

            [st2,en2] = regexp(tmp,alphabet2);
            st2_mat = cell2mat(st2);
            en2_mat = cell2mat(en2);
            %en2_mat-st2_mat;

            myemp = zeros(15,1);
            myemp(en_mat)=1;
            myemp(en2_mat)=1; % here are your indices of where 1back targets should be

            master_one(:,ncount) = myemp;
            clear tmp
            ncount = ncount+1;
        end

        % 2back
        % try with strcmpi
        % much easier, just look for a 2len difference pattern

        ncount = 1;
        for tt = 9:12

            tmp = Cs{tt};

            for ii = 1:length(tmp)-2 % vector size issue - otherwise end up with 2 too long (17)
                A(:,ii) = strcmpi(tmp(ii),tmp(ii+2)); % look at letter +2 ahead to see if matches
            end
            A = [0 0 A]; % add zeros at front, as the first possible target has to come at index 3

            master_two(:,ncount) = A;
            clear A
            ncount = ncount+1;

        end


        %%
        %% now combine
        % this is all together
        clc
        % this is in consecutive ordering
        master = [master_zero, master_one, master_two];
        task_master = master(:,R_block); % now in scanner ordering
        task_master_v = task_master(:);
        results = fdex_zeros.*task_master_v; % patient response overlapped with true responses
        results_prc(iSub,iRun) = sum(results)./sum(task_master_v).*100;

        % Each guy is tricky

        % need to split up fdex, but it is in scanner ordering
        fdex_perm = reshape(fdex_zeros,[15 12]);
        eachRunDex0 = find(strcmpi(run_order_task,'0-back')); % so find scanner ordering from here
        fdex_zero = fdex_perm(:,eachRunDex0); % this is all the 0-backs
        task_master_zero = task_master(:,eachRunDex0); % same for the perfect response (task_master is in scanner order so it works here)
        fdex_zero_v = fdex_zero(:);
        task_master_zero_v = task_master_zero(:);
        fzero = fdex_zero_v.*task_master_zero_v; % overlap
        %results0 = sum(fzero)./sum(task_master_zero_v)
        results0(iSub,iRun) = sum(fzero)./sum(task_master_zero_v).*100;

        fdex_perm = reshape(fdex_zeros,[15 12]);
        eachRunDex1 = find(strcmpi(run_order_task,'1-back'));
        fdex_one = fdex_perm(:,eachRunDex1);
        task_master_one = task_master(:,eachRunDex1);
        fdex_one_v = fdex_one(:);
        task_master_one_v = task_master_one(:);
        fone = fdex_one_v.*task_master_one_v;
        %results1 = sum(fone)./sum(task_master_one_v)
        results1(iSub,iRun) = sum(fone)./sum(task_master_one_v).*100;
        
        fdex_perm = reshape(fdex_zeros,[15 12]);
        eachRunDex2 = find(strcmpi(run_order_task,'2-back'));
        fdex_two = fdex_perm(:,eachRunDex2);
        task_master_two = task_master(:,eachRunDex2);
        fdex_two_v = fdex_two(:);
        task_master_two_v = task_master_two(:);
        ftwo = fdex_two_v.*task_master_two_v;
        %results2 = sum(ftwo)./sum(task_master_two_v)
        results2(iSub,iRun) = sum(ftwo)./sum(task_master_two_v).*100;


        clear master*
        


    end
end


%% now plotting


nback_grp = [results0, results1,results2];
nback_tsk = [repmat({'0-back'},14,4), repmat({'1-back'},14,4), repmat({'2-back'},14,4)];
nback_sub = [repmat({'sub1'},1,12); repmat({'sub2'},1,12); repmat({'sub3'},1,12); repmat({'sub4'},1,12); ...
    repmat({'sub5'},1,12); repmat({'sub6'},1,12); repmat({'sub7'},1,12); repmat({'sub8'},1,12); ...
    repmat({'sub9'},1,12); repmat({'sub10'},1,12); repmat({'sub11'},1,12); repmat({'sub12'},1,12); ...
    repmat({'sub13'},1,12); repmat({'sub14'},1,12); ];

GRP = nback_grp(:);
TSK = nback_tsk(:);
SUB = nback_sub(:);

% map
% CT=cbrewer('seq', 'Greys', 14,'pchip');
% CT = abs(CT);
% CT(CT>1)=1;
% 
% a = 0.8;
% b = 0.2;
% c = 0.4;
% d = 0.4;

% ti = 1;
% tf = 10;
% t = linspace(ti,tf,14);
% yinitial = a*exp(-b*x)+c*exp(-d*x);
% close all
% figure('Position',[0 400 600 400])
% plot(t,yinitial,'r*')
% thismap = [yinitial(:) yinitial(:) yinitial(:)];


close all
clear g
figure('Position',[100 100 1000 800])
g = gramm('x',TSK,'y',GRP,'color',SUB);
g.stat_summary('type','std','geom',{'area' 'point'},'dodge',0.2)
g.set_names('x','N-back task','y','% correct','color','Subject')
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',10)
g.axe_property('XGrid','on','YGrid','on','YLim',[0 120]); %,'DataAspectRatio',[1 1 0 ])
g.set_order_options('x',0,'color',0)
%g.set_color_options('map',thismap)
g.draw()


%filename = sprintf(['sue_compare_' sep '_' datafilenames{thisModel} '.pdf'],'%s%s');
filename = 'nback_task_plot';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

%% Here, now can we split things up by kiwi type
% green gold red mtxdrn
nback_green = [nback_grp(:,3) nback_grp(:,7) nback_grp(:,11)]; % easy cause visit 3 was always green
nback_tsk_green = [nback_tsk(:,1) nback_tsk(:,5) nback_tsk(:,9)]; % doesn't matter which we grab
nback_sub_green = [nback_sub(:,1) nback_sub(:,5) nback_sub(:,9)];

nback_mtxdrn = [nback_grp(:,4) nback_grp(:,8) nback_grp(:,12)]; % easy cause visit 4 was always mtxdrn

% complicated for red and gold, because subjects mixed orders
% subject 7-11 did gold(B) first, not red(A)

% flip things around
nback_grp_0back_visit1_2 = [nback_grp(:,1) nback_grp(:,2)];
nback_grp_0back_visit1_2_red = [nback_grp_0back_visit1_2(1:6,1); nback_grp_0back_visit1_2(7:11,2); nback_grp_0back_visit1_2(12:14,1)];
nback_grp_0back_visit1_2_gold = [nback_grp_0back_visit1_2(1:6,2); nback_grp_0back_visit1_2(7:11,1); nback_grp_0back_visit1_2(12:14,2)];

nback_grp_1back_visit1_2 = [nback_grp(:,5) nback_grp(:,6)];
nback_grp_1back_visit1_2_red = [nback_grp_1back_visit1_2(1:6,1); nback_grp_1back_visit1_2(7:11,2); nback_grp_1back_visit1_2(12:14,1)];
nback_grp_1back_visit1_2_gold = [nback_grp_1back_visit1_2(1:6,2); nback_grp_1back_visit1_2(7:11,1); nback_grp_1back_visit1_2(12:14,2)];

nback_grp_2back_visit1_2 = [nback_grp(:,9) nback_grp(:,10)];
nback_grp_2back_visit1_2_red = [nback_grp_2back_visit1_2(1:6,1); nback_grp_2back_visit1_2(7:11,2); nback_grp_2back_visit1_2(12:14,1)];
nback_grp_2back_visit1_2_gold = [nback_grp_2back_visit1_2(1:6,2); nback_grp_2back_visit1_2(7:11,1); nback_grp_2back_visit1_2(12:14,2)];

% stick together
nback_gold = [nback_grp_0back_visit1_2_gold nback_grp_1back_visit1_2_gold nback_grp_2back_visit1_2_gold];
nback_red = [nback_grp_0back_visit1_2_red nback_grp_1back_visit1_2_red nback_grp_2back_visit1_2_red];

GRP_green = nback_green(:);
GRP_mtxdrn = nback_mtxdrn(:);
GRP_gold = nback_gold(:);
GRP_red = nback_red(:);
TSK_split = nback_tsk_green(:);
SUB_split = nback_sub_green(:);

% now plot again
close all
clear g
figure('Position',[100 100 1000 800])
g(1,1) = gramm('x',TSK_split,'y',GRP_red,'color',SUB_split);
g(1,1).stat_summary('type','std','geom',{'area' 'point'},'dodge',0.2)
g(1,1).set_title('Red')
g(1,2) = gramm('x',TSK_split,'y',GRP_gold,'color',SUB_split);
g(1,2).stat_summary('type','std','geom',{'area' 'point'},'dodge',0.2)
g(1,2).set_title('Gold')
g(2,1) = gramm('x',TSK_split,'y',GRP_green,'color',SUB_split);
g(2,1).stat_summary('type','std','geom',{'area' 'point'},'dodge',0.2)
g(2,1).set_title('Green')
g(2,2) = gramm('x',TSK_split,'y',GRP_mtxdrn,'color',SUB_split);
g(2,2).stat_summary('type','std','geom',{'area' 'point'},'dodge',0.2)
g(2,2).set_title('MTXDRN')

g.set_names('x','N-back task','y','% correct','color','Subject')
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',10)
g.axe_property('XGrid','on','YGrid','on','YLim',[0 120]); %,'DataAspectRatio',[1 1 0 ])
g.set_order_options('x',0,'color',0)
%g.set_color_options('map',thismap)
g.draw()


%filename = sprintf(['sue_compare_' sep '_' datafilenames{thisModel} '.pdf'],'%s%s');
filename = 'nback_task_plot_kiwigrouped';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','eps')


%% Now stats
nSubjects = 14;
nConditions = 4; % Green, Mtxdrn, Gold, Red
nTasks = 3; % 0back, 1back, 2back
% rearrange for Anova
% Let's redo these things just to reset 
nback_data = [nback_green nback_mtxdrn nback_gold nback_red];
nback_task = [nback_tsk_green nback_tsk_green nback_tsk_green nback_tsk_green];
nback_kiwi = [repmat({'Green'},nSubjects,nTasks) repmat({'Mtxdrn'},nSubjects,nTasks)...
    repmat({'Gold'},nSubjects,nTasks) repmat({'Red'},nSubjects,nTasks)];
nback_sub = [repmat({'sub1'},1,12); repmat({'sub2'},1,12); repmat({'sub3'},1,12); repmat({'sub4'},1,12); ...
    repmat({'sub5'},1,12); repmat({'sub6'},1,12); repmat({'sub7'},1,12); repmat({'sub8'},1,12); ...
    repmat({'sub9'},1,12); repmat({'sub10'},1,12); repmat({'sub11'},1,12); repmat({'sub12'},1,12); ...
    repmat({'sub13'},1,12); repmat({'sub14'},1,12); ];


% Define factors 'kiwi' and 'task'
% anova_kiwi = kron(1:4, ones(1, size(nback_data, 2)/4));
% anova_task = repmat(1:3, 1, size(nback_data, 2)/3);


y = nback_data(:);
g1 = nback_task(:);
g2 = nback_kiwi(:);
[P,T,stats,TERMS] = anovan(y,{g1 g2},"Model","full", ...
    "Varnames",["Task","Kiwi"]);

filename = [savedir 'nback_anova_results_anova.csv'];
writecell(T, filename);

[results,~,~,gnames] = multcompare(stats,"Dimension",[2]);
tbl = array2table(results,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbl.("Group A")=gnames(tbl.("Group A"));
tbl.("Group B")=gnames(tbl.("Group B"));

%filename = [savedir 'nback_anova_results_multcompare_task.csv'];
filename = [savedir 'nback_anova_results_multcompare_kiwi.csv'];

% Write the results table to a CSV file
writetable(tbl, filename);





%% try anova
% This is one factor, so the task, ignoring the kiwi factor
[P,ANOVATAB,STATS] = anova1(GRP,TSK);
[COMPARISON,MEANS,H,GNAMES] = multcompare(STATS);

% Create a table to display significant differences
results_table = array2table(COMPARISON, ...
    'VariableNames', {'Group1', 'Group2', 'LowerCI', 'UpperCI', 'pValue', 'RejectNull'});

% Add group names to the table
results_table.Group1 = GNAMES(results_table.Group1);
results_table.Group2 = GNAMES(results_table.Group2);

% Define the file name for CSV export
filename = [savedir 'nback_anova_results.csv'];

% Write the results table to a CSV file
writetable(results_table, filename);

%% Can we look at the anova for each day?
% 
% nback_grp_day1 = [nback_grp(:,1) nback_grp(:,5) nback_grp(:,9)];
% nback_sub_day = [nback_sub(:,1) nback_sub(:,5) nback_sub(:,9)];
% nback_tsk_day = [nback_tsk(:,1) nback_tsk(:,5) nback_tsk(:,9)];
% nback_grp_day2 = [nback_grp(:,2) nback_grp(:,6) nback_grp(:,10)];
% nback_grp_day3 = [nback_grp(:,3) nback_grp(:,7) nback_grp(:,11)];
% nback_grp_day4 = [nback_grp(:,4) nback_grp(:,8) nback_grp(:,12)];
% 
% GRP_day1 = nback_grp_day1(:);
% SUB_day = nback_sub_day(:);
% TSK_day = nback_tsk_day(:);
% GRP_day2 = nback_grp_day2(:);
% GRP_day3 = nback_grp_day3(:);
% GRP_day4 = nback_grp_day4(:);
% 
% [P,ANOVATAB,STATS1] = anova1(GRP_day1,TSK_day);
% [P,ANOVATAB,STATS2] = anova1(GRP_day2,TSK_day);
% [P,ANOVATAB,STATS3] = anova1(GRP_day3,TSK_day);
% [P,ANOVATAB,STATS4] = anova1(GRP_day4,TSK_day);
% 
% [COMPARISON1,MEANS,H,GNAMES] = multcompare(STATS1);
% [COMPARISON2,MEANS,H,GNAMES] = multcompare(STATS2);
% [COMPARISON3,MEANS,H,GNAMES] = multcompare(STATS3);
% [COMPARISON4,MEANS,H,GNAMES] = multcompare(STATS4);
% 
% results_table1 = array2table(COMPARISON1, ...
%     'VariableNames', {'Group1', 'Group2', 'LowerCI', 'UpperCI', 'pValue', 'RejectNull'});
% results_table1.Group1 = GNAMES(results_table1.Group1);
% results_table1.Group2 = GNAMES(results_table1.Group2);
% results_table2 = array2table(COMPARISON2, ...
%     'VariableNames', {'Group1', 'Group2', 'LowerCI', 'UpperCI', 'pValue', 'RejectNull'});
% results_table2.Group1 = GNAMES(results_table2.Group1);
% results_table2.Group2 = GNAMES(results_table2.Group2);
% results_table3 = array2table(COMPARISON3, ...
%     'VariableNames', {'Group1', 'Group2', 'LowerCI', 'UpperCI', 'pValue', 'RejectNull'});
% results_table3.Group1 = GNAMES(results_table3.Group1);
% results_table3.Group2 = GNAMES(results_table3.Group2);
% results_table4 = array2table(COMPARISON4, ...
%     'VariableNames', {'Group1', 'Group2', 'LowerCI', 'UpperCI', 'pValue', 'RejectNull'});
% results_table4.Group1 = GNAMES(results_table4.Group1);
% results_table4.Group2 = GNAMES(results_table4.Group2);
% 
% 
% filename1 = [savedir 'nback_anova_results_day1.csv'];
% filename2 = [savedir 'nback_anova_results_day2.csv'];
% filename3 = [savedir 'nback_anova_results_day3.csv'];
% filename4 = [savedir 'nback_anova_results_day4.csv'];
% 
% writetable(results_table1, filename1);
% writetable(results_table2, filename2);
% writetable(results_table3, filename3);
% writetable(results_table4, filename4);


%% plot reaction times

rarRT = meanReactionTime;

% swap gold and red rememebr
rarRT(7:11,1) = meanReactionTime(7:11,2);
rarRT(7:11,2) = meanReactionTime(7:11,1);

newsubs = {'sub01','sub02','sub03','sub04','sub05','sub06','sub07',...
    'sub08','sub09','sub10','sub11','sub12','sub13','sub14'};

theSubjects =  [newsubs(:); newsubs(:); newsubs(:); newsubs(:)];
theRTs = rarRT(:);
theVisits = [repmat({'Red'},14,1); repmat({'Gold'},14,1); repmat({'Green'},14,1); repmat({'MTXDRN'},14,1)];

nanDEX = ~isnan(theRTs);

theSubjects = theSubjects(nanDEX);
theRTs = theRTs(nanDEX);
theVisits = theVisits(nanDEX);

% now plot again
close all
clear g
%
% figure('Position',[100 100 1000 800])
figure
g = gramm('x',theVisits,'y',theRTs);
g.stat_summary('type','std','geom',{'area' 'point'},'dodge',0.2)

g.draw()

g.update('y',theRTs,'color',theSubjects)
g.geom_jitter()

g.set_names('x','Visit','y','Reaction times (s)','color','Subject')
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',10)
%g.axe_property('XGrid','on','YGrid','on','YLim',[0 120]); %,'DataAspectRatio',[1 1 0 ])
g.set_order_options('x',0,'color',0)


g.draw()
filename = 'reactionTimes';
g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','pdf')

g.export('file_name',filename, ...
    'export_path',...
    savedir,...
    'file_type','eps')
%%
[P,ANOVATAB,STATS] = anova1(theRTs,theVisits);
[COMPARISON,MEANS,H,GNAMES] = multcompare(STATS);

% Create a table to display significant differences
results_table = array2table(COMPARISON, ...
    'VariableNames', {'Group1', 'Group2', 'LowerCI', 'UpperCI', 'pValue', 'RejectNull'});

% Add group names to the table
results_table.Group1 = GNAMES(results_table.Group1);
results_table.Group2 = GNAMES(results_table.Group2);

% Define the file name for CSV export
filename = [savedir 'reactiontimes_anova_results.csv'];

% Write the results table to a CSV file
writetable(results_table, filename);


