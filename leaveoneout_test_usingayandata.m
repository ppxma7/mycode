% leave1out_test

%% try a leave one out procedure using george's cenTend function to make
% sure we are doing the right thing
clear variables

cd '/Users/ppxma7/data/DigitAtlas/fsaveragePhBindDigits'

subjects = {'HB1', 'HB2', 'HB3', 'HB4', 'HB5', '11120', '10301', '00393', '03677', '08966','09621', ...
    '10289', '10320', '10329', '10654', '10875', '11251', '11753', '08740', '04217', '11240'};
tic
for iSubject = 1:length(subjects)
    
    
    
    Files = dir('LD1*');
    for k = 1:length(Files)
        FileNames = Files(k).name;
        if ~isequal(FileNames, ['LD1' '_' subjects{iSubject} '.mgh']) % check if we want to get rid of this file
            theFile = MRIread(FileNames);
            LD1(:,k) = theFile.vol';
        else
            theFileLeftout = MRIread(FileNames); % ok, this matches the subject
            LD_A1 = theFileLeftout.vol'; % keep him for later
            LD1(:,k) = zeros(size(theFile.vol,2),1); % get rid of him for the subset atlas
        end
    end
    leftout = find(all(LD1==0)); % this guy got left out
    
    LD1(:,leftout)=[]; % get rid of it
    %pLD1 = sum(LD1,2)./size(LD1,2);
    pLD1 = sum(LD1,2)./max(sum(LD1,2));
    % now we have the atlas minus one subject, we need to take the column
    % of the person we left out and run cenTend between it and the atlas
    
    Files = dir('LD2*');
    for k = 1:length(Files)
        FileNames = Files(k).name;
        if ~isequal(FileNames, ['LD2' '_' subjects{iSubject} '.mgh'])
            theFile = MRIread(FileNames);
            LD2(:,k) = theFile.vol';
        else
            theFileLeftout = MRIread(FileNames);
            LD_A2 = theFileLeftout.vol';
            
            LD2(:,k) = zeros(size(theFile.vol,2),1);
        end
    end
    leftout = find(all(LD2==0)); % this guy got left out
    LD2(:,leftout)=[]; % get rid of it
    pLD2 = sum(LD2,2)./max(sum(LD2,2));
    
    Files = dir('LD3*');
    for k = 1:length(Files)
        FileNames = Files(k).name;
        if ~isequal(FileNames, ['LD3' '_' subjects{iSubject} '.mgh'])
            theFile = MRIread(FileNames);
            LD3(:,k) = theFile.vol';
        else
            theFileLeftout = MRIread(FileNames);
            LD_A3 = theFileLeftout.vol';
            LD3(:,k) = zeros(size(theFile.vol,2),1);
        end
    end
    leftout = find(all(LD3==0)); % this guy got left out
    LD3(:,leftout)=[]; % get rid of it
    pLD3 = sum(LD3,2)./max(sum(LD3,2));
    
    Files = dir('LD4*');
    for k = 1:length(Files)
        FileNames = Files(k).name;
        if ~isequal(FileNames, ['LD4' '_' subjects{iSubject} '.mgh'])
            theFile = MRIread(FileNames);
            LD4(:,k) = theFile.vol';
        else
            theFileLeftout = MRIread(FileNames);
            LD_A4 = theFileLeftout.vol';
            LD4(:,k) = zeros(size(theFile.vol,2),1);
        end
    end
    leftout = find(all(LD4==0)); % this guy got left out
    LD4(:,leftout)=[]; % get rid of it
    pLD4 = sum(LD4,2)./max(sum(LD4,2));
    
    Files = dir('LD5*');
    for k = 1:length(Files)
        FileNames = Files(k).name;
        if ~isequal(FileNames, ['LD5' '_' subjects{iSubject} '.mgh'])
            theFile = MRIread(FileNames);
            LD5(:,k) = theFile.vol';
        else
            theFileLeftout = MRIread(FileNames);
            LD_A5 = theFileLeftout.vol';
            LD5(:,k) = zeros(size(theFile.vol,2),1);
        end
    end
    leftout = find(all(LD5==0)); % this guy got left out
    LD5(:,leftout)=[]; % get rid of it
    pLD5 = sum(LD5,2)./max(sum(LD5,2));
    
    Files = dir('RD1*');
    for k = 1:length(Files)
        FileNames = Files(k).name;
        if ~isequal(FileNames, ['RD1' '_' subjects{iSubject} '.mgh'])
            theFile = MRIread(FileNames);
            RD1(:,k) = theFile.vol';
        else
            theFileLeftout = MRIread(FileNames);
            RD_A1 = theFileLeftout.vol';
            RD1(:,k) = zeros(size(theFile.vol,2),1);
        end
    end
    leftout = find(all(RD1==0)); % this guy got left out
    RD1(:,leftout)=[]; % get rid of it
    pRD1 = sum(RD1,2)./max(sum(RD1,2));
    
    % now we have the atlas minus one subject, we need to take the column
    % of the person we left out and run cenTend between it and the atlas
    
    Files = dir('RD2*');
    for k = 1:length(Files)
        FileNames = Files(k).name;
        if ~isequal(FileNames, ['RD2' '_' subjects{iSubject} '.mgh'])
            theFile = MRIread(FileNames);
            RD2(:,k) = theFile.vol';
        else
            theFileLeftout = MRIread(FileNames);
            RD_A2 = theFileLeftout.vol';
            RD2(:,k) = zeros(size(theFile.vol,2),1);
        end
    end
    leftout = find(all(RD2==0)); % this guy got left out
    RD2(:,leftout)=[]; % get rid of it
    pRD2 = sum(RD2,2)./max(sum(RD2,2));
    
    Files = dir('RD3*');
    for k = 1:length(Files)
        FileNames = Files(k).name;
        if ~isequal(FileNames, ['RD3' '_' subjects{iSubject} '.mgh'])
            theFile = MRIread(FileNames);
            RD3(:,k) = theFile.vol';
        else
            theFileLeftout = MRIread(FileNames);
            RD_A3 = theFileLeftout.vol';
            RD3(:,k) = zeros(size(theFile.vol,2),1);
        end
    end
    leftout = find(all(RD3==0)); % this guy got left out
    RD3(:,leftout)=[]; % get rid of it
    pRD3 = sum(RD3,2)./max(sum(RD3,2));
    
    Files = dir('RD4*');
    for k = 1:length(Files)
        FileNames = Files(k).name;
        if ~isequal(FileNames, ['RD4' '_' subjects{iSubject} '.mgh'])
            theFile = MRIread(FileNames);
            RD4(:,k) = theFile.vol';
        else
            theFileLeftout = MRIread(FileNames);
            RD_A4 = theFileLeftout.vol';
            RD4(:,k) = zeros(size(theFile.vol,2),1);
        end
    end
    leftout = find(all(RD4==0)); % this guy got left out
    RD4(:,leftout)=[]; % get rid of it
    pRD4 = sum(RD4,2)./max(sum(RD4,2));
    
    Files = dir('RD5*');
    for k = 1:length(Files)
        FileNames = Files(k).name;
        if ~isequal(FileNames, ['RD5' '_' subjects{iSubject} '.mgh'])
            theFile = MRIread(FileNames);
            RD5(:,k) = theFile.vol';
        else
            theFileLeftout = MRIread(FileNames);
            RD_A5 = theFileLeftout.vol';
            RD5(:,k) = zeros(size(theFile.vol,2),1);
        end
    end
    leftout = find(all(RD5==0)); % this guy got left out
    RD5(:,leftout)=[]; % get rid of it
    pRD5 = sum(RD5,2)./max(sum(RD5,2));
    
    
    % stick probs together
    pLD = [pLD1 pLD2 pLD3 pLD4 pLD5];
    pRD = [pRD1 pRD2 pRD3 pRD4 pRD5];
    
    % stick guys left out
    LD_A =[LD_A1 LD_A2 LD_A3 LD_A4 LD_A5];
    RD_A =[RD_A1 RD_A2 RD_A3 RD_A4 RD_A5];
    
    % now send to cenTenDig
    [mycent(:,:,iSubject), mycentR(:,:, iSubject) ] = cenTenDig(LD_A, RD_A, pLD, pRD);
    
    for jj = 1:5
        % try checking FOM on each atlas (21)
      
        % we now need to subtract the centends of D1-D2, D1-D3 etc.
        thisCentend = mycent(jj,:,iSubject);
        thisCentendR = mycentR(jj,:,iSubject);
        thisCentend(jj)=[];
        thisCentendR(jj)=[];
        thisCentend_mean = mean(thisCentend);
        thisCentendR_mean = mean(thisCentendR);
        fomL(jj,iSubject) = mycent(jj,jj) - thisCentend_mean;
        fomR(jj,iSubject) = mycentR(jj,jj) - thisCentendR_mean;
        
    end
    
end
toc





figure('Position', [100 100 1700 500]);
for iSubject = 1:length(subjects)
    subplot(3,7,iSubject)
    imagesc(mycent(:,:,iSubject))
    title([subjects{iSubject} '_' ' LD'])
    colormap(jet)
    colorbar
    xlabel('Atlas')
    ylabel('Subject digit')
end


figure('Position', [100 100 1700 500]);
for iSubject = 1:length(subjects)
    subplot(3,7,iSubject)
    imagesc(mycentR(:,:,iSubject))
    title([subjects{iSubject} '_' ' RD'])
    colormap(jet)
    colorbar
    xlabel('Atlas')
    ylabel('Subject digit')
end

% plot means!

figure
subplot(1,2,1)
imagesc(mean(mycent,3))
title('LD mean')
colormap(jet)
colorbar
subplot(1,2,2)
imagesc(mean(mycentR,3))
title('RD means')
colormap(jet)
colorbar

% try plotting FOM!
mydim = size(fomL,1) .* size(fomL,2);
subjects_stacked = repmat(subjects,5,1);
whichDig = repmat({'D1', 'D2', 'D3', 'D4', 'D5'}', size(fomL,2), 1);

figure('Position', [100, 100, 1200, 900])
g(1,1) = gramm('x', whichDig, 'y', reshape(fomL,mydim,1), 'color', subjects_stacked(:));
g(1,1).geom_jitter('alpha',0.8)
g(1,1).set_title('Left digits')
g(1,1).set_names('x', 'Digit', 'y', 'FIGURE OF MERIT ', 'color', 'Subjects')
g(1,1).set_text_options('font', 'Menlo', 'base_size', 16)
g(1,1).set_point_options('markers', {'o'} ,'base_size',15)
g(1,1).no_legend()
g(1,1).axe_property('YLim', [-2 2])

g(1,2) = gramm('x', whichDig, 'y', reshape(fomR,mydim,1), 'color', subjects_stacked(:));
g(1,2).set_title('Right digits')
g(1,2).geom_jitter('alpha',0.8)
g(1,2).set_names('x', 'Digit', 'y', 'FIGURE OF MERIT ', 'color', 'Subjects')
g(1,2).set_text_options('font', 'Menlo', 'base_size', 16)
g(1,2).set_point_options('markers', {'o'} ,'base_size',15)
g(1,2).axe_property('YLim', [-2 2])
g.draw()

keyboard
% try raincloud plotting!
[cb] = cbrewer('qual', 'Set3', 12, 'pchip');
cl(1,:) = cb(4,:);
cl(2,:) = cb(1,:);

fom_stackL = reshape(fomL,mydim,1);
fom_stackR = reshape(fomR,mydim,1);
fom_STACK = [fom_stackL; fom_stackR];
which_HAND = [repmat({'RD'},size(fom_stackL,1),1); repmat({'LD'}, size(fom_stackR,1),1)];


fomD1 = fomL(1,:)';
fomD2 = fomL(2,:)';
fomD3 = fomL(3,:)';
fomD4 = fomL(4,:)';
fomD5 = fomL(5,:)';
fomD1r = fomR(1,:)';
fomD2r = fomR(2,:)';
fomD3r = fomR(3,:)';
fomD4r = fomR(4,:)';
fomD5r = fomR(5,:)';

digit1 = repmat({'D1'},size(fomD1,1),1);
digit2 = repmat({'D2'},size(fomD1,1),1);
digit3 = repmat({'D3'},size(fomD1,1),1);
digit4 = repmat({'D4'},size(fomD1,1),1);
digit5 = repmat({'D5'},size(fomD1,1),1);

myrow = 2;
mycol = 2;
myalpha = 0.5;
myboxdodge = [0.2 0.4 0.6 0.8 1];
mydotdodge = [0.2 0.4 0.6 0.8 1];

figure('Position', [100 100 1200 800])
subplot(myrow,mycol,[1,2])
h1 = raincloud_plot('x', fom_stackL, 'box_on',1, 'color', cb(1,:), 'alpha', myalpha, 'box_dodge',1', 'box_dodge_amount',myboxdodge(1), 'dot_dodge_amount', mydotdodge(1));
h2 = raincloud_plot('x', fom_stackR, 'box_on',1, 'color', cb(4,:), 'alpha', myalpha, 'box_dodge',1', 'box_dodge_amount',myboxdodge(2), 'dot_dodge_amount', mydotdodge(2));
title('LD+RD')
legend([h1{1} h2{1}], {'LD', 'RD'});
set(gca, 'YLim', [-0.5 1]);
xlabel('FOM')

subplot(myrow,mycol,3)
g1 = raincloud_plot('x', fomD1, 'box_on',1, 'color', cb(1,:), 'alpha', myalpha, 'box_dodge',1', 'box_dodge_amount',myboxdodge(1), 'dot_dodge_amount', mydotdodge(1));
g2 = raincloud_plot('x', fomD2, 'box_on',1, 'color', cb(2,:), 'alpha', myalpha, 'box_dodge',1', 'box_dodge_amount',myboxdodge(2), 'dot_dodge_amount', mydotdodge(2));
g3 = raincloud_plot('x', fomD3, 'box_on',1, 'color', cb(3,:), 'alpha', myalpha, 'box_dodge',1', 'box_dodge_amount',myboxdodge(3), 'dot_dodge_amount', mydotdodge(3));
g4 = raincloud_plot('x', fomD4, 'box_on',1, 'color', cb(4,:), 'alpha', myalpha, 'box_dodge',1', 'box_dodge_amount',myboxdodge(4), 'dot_dodge_amount', mydotdodge(4));
g5 = raincloud_plot('x', fomD5, 'box_on',1, 'color', cb(5,:), 'alpha', myalpha, 'box_dodge',1', 'box_dodge_amount',myboxdodge(5), 'dot_dodge_amount', mydotdodge(5));
title('LD')
set(gca, 'YLim', [-1.5 2.5]);
legend([g1{1} g2{1} g3{1} g4{1} g5{1}], {'D1', 'D2', 'D3', 'D4', 'D5'});
xlabel('FOM')

subplot(myrow,mycol,4)
g11 = raincloud_plot('x', fomD1r, 'box_on',1, 'color', cb(1,:), 'alpha', myalpha, 'box_dodge',1', 'box_dodge_amount',myboxdodge(1), 'dot_dodge_amount', mydotdodge(1));
g22 = raincloud_plot('x', fomD2r, 'box_on',1, 'color', cb(2,:), 'alpha', myalpha, 'box_dodge',1', 'box_dodge_amount',myboxdodge(2), 'dot_dodge_amount', mydotdodge(2));
g33 = raincloud_plot('x', fomD3r, 'box_on',1, 'color', cb(3,:), 'alpha', myalpha, 'box_dodge',1', 'box_dodge_amount',myboxdodge(3), 'dot_dodge_amount', mydotdodge(3));
g44 = raincloud_plot('x', fomD4r, 'box_on',1, 'color', cb(4,:), 'alpha', myalpha, 'box_dodge',1', 'box_dodge_amount',myboxdodge(4), 'dot_dodge_amount', mydotdodge(4));
g55 = raincloud_plot('x', fomD5r, 'box_on',1, 'color', cb(5,:), 'alpha', myalpha, 'box_dodge',1', 'box_dodge_amount',myboxdodge(5), 'dot_dodge_amount', mydotdodge(5));
title('RD')
set(gca, 'YLim', [-1.5 2.5]);
legend([g11{1} g22{1} g33{1} g44{1} g55{1}], {'D1', 'D2', 'D3', 'D4', 'D5'});
xlabel('FOM')








