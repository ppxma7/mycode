close all; 
clear variables;
clc; 

%diceCoeff - Find Dice Coefficient between digit ROIs
%
% calculates dice coefficient (kolasinski 2016 et al.) between patch space ROIs
% in pre and post-treatment FHD patients, from their TW digits.
%
% You will have exported co/ph/roi overlays
% see also makeDigitROIs_BD.m compare2atlas.m loadAtlas.m
%
% THIS IS USED FOR WHEN IN PATCH SPACE
% [ma] November 2018

shallisave = [];
two = 0;

subdir = '/Volumes/research/TOUCHMAP/ma/DigitAtlasv2/';
cd(subdir)


subs = {'03942', '00393', '03677', '13287','13945','00791', '13172',...
    '13382', '13493', '13654','13658', '13695', '14001'...
    '13382_pre', '13493_pre', '13654_pre', '13658_pre', '13695_pre','14001_pre'};

subs = {'13172'}

nHC = 7;
nPA = 12;
%% motor to motor HC

disp('Calculating motor to motor correspondence...')
tic
for ii = 1:nHC
    
    if ~strcmpi(subs{ii},'00791') % no motor for this sub
        
        if two == 1
            cd([subdir subs{ii} '/2mm/patchSpace/orig_mot/'])
        else
            cd([subdir 'HC/' subs{ii} '_motor/patchSpace'])
        end
        % phase difference here
        
        if strcmpi(subs{ii},'13287')
            kk = {'L'};
            
        else
            kk = {'R'};
        end
        
        
        co = cbiReadNifti(['co_' char(kk) 'D.hdr']);
        ph = cbiReadNifti(['ph_' char(kk) 'D.hdr']);
        
        nanindex = isnan(co);
        co(nanindex) = 0; 
        
        nanindexph = isnan(ph);
        ph(nanindexph) = 0; 
        
%         co = co(:);
%         co(isnan(co))=0;
%         ph = ph(:);
%         ph(isnan(ph))=0;
        
        co(co<0.3)=0;
        co = logical(co);
        
        bin = (2*pi)/5;
       % mask with cohernece at 0.3 
        phMask = ph.*co;
        
        % make binary digit bins 
        % need to mask with coherence first 
        d1 = double(ph<bin);
    
        figure, imagesc(d1(:,:,7))
        d2 = double(ph>bin & ph<bin*2);
        d3 = double(ph>bin*2 & ph < bin*3);
        d4 = double(ph>bin*3 & ph < bin*4);
        d5 = double(ph>bin*4 & ph < bin*5);
        
%         eachMask = cell(5,1);
%         %reads in digit ROIs
%         for zz = 1:5
%             eachMask{zz} = cbiReadNifti([char(kk) 'D' num2str(zz) '.hdr']);
%         end
%         mask = eachMask{1} + eachMask{2} + eachMask{3} + eachMask{4} + eachMask{5};
%         mask = mask(:);
%         maskPH = mask .* ph;
%         maskPH(isnan(maskPH))=0;
%         co(co<0.3)=0;
%         co = logical(co);
%         finalmaskA = maskPH .* co;
    
        % second part 
        
        if strcmpi(subs{ii},'13945') & two
            cd([subdir 'HC/' subs{ii} '_motor/patchSpace/newmot/'])
        else
        
        cd(['~/data/13172_HC7/motglm/'])
        end
        % phase difference here
        wta = cbiReadNifti(['WTA.img']);
        
        nanindex = isnan(wta);
        wta(nanindex) = 0;
        d1w = double(wta==1);
        d2w = double(wta==2);
        d3w = double(wta==3);
        d4w = double(wta==3);
        d5w = double(wta==5);
        
%         co = cbiReadNifti(['co_' char(kk) 'D.hdr']);
%         ph = cbiReadNifti(['ph_' char(kk) 'D.hdr']);
%         co = co(:);
%         co(isnan(co))=0;
%         ph = ph(:);
%         ph(isnan(ph))=0;
%         eachMask2 = cell(5,1);
%         for zz = 1:5
%             eachMask2{zz} = cbiReadNifti([char(kk) 'D' num2str(zz) '.hdr']);
%         end
%         mask = eachMask2{1} + eachMask2{2} + eachMask2{3} + eachMask2{4} + eachMask2{5};
%         mask = mask(:);
%         maskPH = mask .* ph;
%         maskPH(isnan(maskPH))=0;
%         co(co<0.3)=0;
%         co = logical(co);
%         finalmaskB = maskPH .* co;
%         
%         finalmaskC = finalmaskA - finalmaskB;
%         finalmaskC(finalmaskC==0)=[];
%         
%         pHist_hc(ii).phdiff = finalmaskC;
        
        dice_hc = dice(d1,d1w);
        
        % dice
        for dd = 1:5
            for jj = 1:5
                Dice_hc(dd,jj,ii) = dice(reshape(eachMask{dd},length(finalmaskA),1),reshape(eachMask2{jj},length(finalmaskB),1));
            end
        end
    end
    
    clear mask eachMask eachMask2 co ph finalmaskA finalmaskB finalmaskC maskPH
end

kk = {'R'};

%% somato motor PA
for ii = 1:nPA
    if two==1
        cd([subdir subs{ii+nHC} '/2mm/patchSpace/orig_mot/'])
    else
        cd([subdir subs{ii+nHC} '/patchSpace'])
    end
    co = cbiReadNifti(['co_' char(kk) 'D.hdr']);
    ph = cbiReadNifti(['ph_' char(kk) 'D.hdr']);
    co = co(:);
    co(isnan(co))=0;
    ph = ph(:);
    ph(isnan(ph))=0;
    eachMask = cell(5,1);
    for zz = 1:5
        eachMask{zz} = cbiReadNifti([char(kk) 'D' num2str(zz) '.hdr']);
    end
    mask = eachMask{1} + eachMask{2} + eachMask{3} + eachMask{4} + eachMask{5};
    %     mask1 = cbiReadNifti([kk 'D1.hdr']);
    %     mask2 = cbiReadNifti([kk 'D2.hdr']);
    %     mask3 = cbiReadNifti([kk 'D3.hdr']);
    %     mask4 = cbiReadNifti([kk 'D4.hdr']);
    %     mask5 = cbiReadNifti([kk 'D5.hdr']);
    %     mask = mask1 + mask2 + mask3 + mask4 + mask5;
    mask = mask(:);
    maskPH = mask .* ph;
    maskPH(isnan(maskPH))=0;
    co(co<0.3)=0;
    co = logical(co);
    finalmaskA = maskPH .* co;
    
    if ii<7
        cd([subdir 'PA_motor/' subs{ii+nHC} '_motor/patchSpace'])
        
    else
        cutStr = subs{ii+nHC};
        cutStr = erase(cutStr,'_pre');
        cd([subdir 'PA_motor/' cutStr '_motor/patchSpace_pre'])
        
    end
    co = cbiReadNifti(['co_' char(kk) 'D.hdr']);
    ph = cbiReadNifti(['ph_' char(kk) 'D.hdr']);
    co = co(:);
    co(isnan(co))=0;
    ph = ph(:);
    ph(isnan(ph))=0;
    eachMask2 = cell(5,1);
    for zz = 1:5
        eachMask2{zz} = cbiReadNifti([char(kk) 'D' num2str(zz) '.hdr']);
    end
    mask = eachMask2{1} + eachMask2{2} + eachMask2{3} + eachMask2{4} + eachMask2{5};
    %     mask1 = cbiReadNifti([kk 'D1.hdr']);
    %     mask2 = cbiReadNifti([kk 'D2.hdr']);
    %     mask3 = cbiReadNifti([kk 'D3.hdr']);
    %     mask4 = cbiReadNifti([kk 'D4.hdr']);
    %     mask5 = cbiReadNifti([kk 'D5.hdr']);
    %     mask = mask1 + mask2 + mask3 + mask4 + mask5;
    mask = mask(:);
    maskPH = mask .* ph;
    maskPH(isnan(maskPH))=0;
    co(co<0.3)=0;
    co = logical(co);
    finalmaskB = maskPH .* co;
    
    finalmaskC = finalmaskA - finalmaskB;
    finalmaskC(finalmaskC==0)=[];
    %pHist_pa(:,ii) = finalmaskC;
    pHist_pa(ii).phdiff = finalmaskC;
    
    % dice
    for dd = 1:5
        for jj = 1:5
            smDice_pa(dd,jj,ii) = dice(reshape(eachMask{dd},length(finalmaskA),1),reshape(eachMask2{jj},length(finalmaskB),1));
        end
    end
    clear mask eachMask eachMask2 co ph finalmaskA finalmaskB finalmaskC
end

%% somato post to pre
nsubs = {
    '13382','13493', '13654','13658', '13695', '14001'...
    };
%nsubs = {'14001'};

for ii = 1:length(nsubs)
    for kk = {'L','R'}
        
        if two == 1
            cd([subdir nsubs{ii} '/2mm/patchSpace/'])
        else
            
            cd([subdir nsubs{ii} '/patchSpace/'])
        end
        co = cbiReadNifti(['co_' char(kk) 'D.hdr']);
        ph = cbiReadNifti(['ph_' char(kk) 'D.hdr']);
        co = co(:);
        co(isnan(co))=0;
        ph = ph(:);
        ph(isnan(ph))=0;
        eachMask = cell(5,1);
        for zz = 1:5
            %if strcmpi(nsubs{ii},'14001')
            %    eachMask{zz} = cbiReadNifti([char(kk) 'D' num2str(zz) 't.hdr']);
            %else
                eachMask{zz} = cbiReadNifti([char(kk) 'D' num2str(zz) '.hdr']);
            %end
        end
        mask = eachMask{1} + eachMask{2} + eachMask{3} + eachMask{4} + eachMask{5};
        %         mask1 = cbiReadNifti([char(kk) 'D1.hdr']);
        %         mask2 = cbiReadNifti([char(kk) 'D2.hdr']);
        %         mask3 = cbiReadNifti([char(kk) 'D3.hdr']);
        %         mask4 = cbiReadNifti([char(kk) 'D4.hdr']);
        %         mask5 = cbiReadNifti([char(kk) 'D5.hdr']);
        %         mask = mask1 + mask2 + mask3 + mask4 + mask5;
        mask = mask(:);
        maskPH = mask .* ph;
        maskPH(isnan(maskPH))=0;
        co(co<0.3)=0;
        co = logical(co);
        finalmaskA = maskPH .* co;
        
        strAdd = strcat(nsubs{ii},'_pre');
        if two==1
            cd([subdir strAdd '/2mm/patchSpace/'])
        else
            cd([subdir strAdd '/patchSpace/'])
        end
        co = cbiReadNifti(['co_' char(kk) 'D.hdr']);
        ph = cbiReadNifti(['ph_' char(kk) 'D.hdr']);
        co = co(:);
        co(isnan(co))=0;
        ph = ph(:);
        ph(isnan(ph))=0;
        eachMask2 = cell(5,1);
        for zz = 1:5
            %if strcmpi(nsubs{ii},'14001')
            %    eachMask2{zz} = cbiReadNifti([char(kk) 'D' num2str(zz) 't.hdr']);
            %else
                eachMask2{zz} = cbiReadNifti([char(kk) 'D' num2str(zz) '.hdr']);
            %end
        end
        mask = eachMask2{1} + eachMask2{2} + eachMask2{3} + eachMask2{4} + eachMask2{5};
        %         mask1 = cbiReadNifti([char(kk) 'D1.hdr']);
        %         mask2 = cbiReadNifti([char(kk) 'D2.hdr']);
        %         mask3 = cbiReadNifti([char(kk) 'D3.hdr']);
        %         mask4 = cbiReadNifti([char(kk) 'D4.hdr']);
        %         mask5 = cbiReadNifti([char(kk) 'D5.hdr']);
        %         mask = mask1 + mask2 + mask3 + mask4 + mask5;
        mask = mask(:);
        maskPH = mask .* ph;
        maskPH(isnan(maskPH))=0;
        co(co<0.3)=0;
        co = logical(co);
        finalmaskB = maskPH .* co;
        
        finalmaskC = finalmaskA - finalmaskB;
        finalmaskC(finalmaskC==0)=[];
        %pHist_pa(:,ii) = finalmaskC;
        
        %pHist_ss(ii).phdiffL = finalmaskC;
        if strcmpi(char(kk),'L')
            pHist_ss(ii).phdiffL = finalmaskC;
            for dd = 1:5
                for jj = 1:5
                    smDice_ssL(dd,jj,ii) = dice(reshape(eachMask{dd},length(finalmaskA),1),reshape(eachMask2{jj},length(finalmaskB),1));
                end
            end
        elseif strcmpi(char(kk),'R')
            pHist_ss(ii).phdiffR = finalmaskC;
            for dd = 1:5
                for jj = 1:5
                    smDice_ssR(dd,jj,ii) = dice(reshape(eachMask{dd},length(finalmaskA),1),reshape(eachMask2{jj},length(finalmaskB),1));
                end
            end
        end
    end
    
    clear mask eachMask eachMask2 co ph finalmaskA finalmaskB finalmaskC
end


%% motor post to pre
for ii = 1:length(nsubs)
    for kk = {'R'}
        
        cd([subdir '/PA_motor/' nsubs{ii} '_motor/patchSpace/'])
        co = cbiReadNifti(['co_' char(kk) 'D.hdr']);
        ph = cbiReadNifti(['ph_' char(kk) 'D.hdr']);
        co = co(:);
        co(isnan(co))=0;
        ph = ph(:);
        ph(isnan(ph))=0;
        eachMask = cell(5,1);
        for zz = 1:5
            eachMask{zz} = cbiReadNifti([char(kk) 'D' num2str(zz) '.hdr']);
        end
        mask = eachMask{1} + eachMask{2} + eachMask{3} + eachMask{4} + eachMask{5};
        %         mask1 = cbiReadNifti([char(kk) 'D1.hdr']);
        %         mask2 = cbiReadNifti([char(kk) 'D2.hdr']);
        %         mask3 = cbiReadNifti([char(kk) 'D3.hdr']);
        %         mask4 = cbiReadNifti([char(kk) 'D4.hdr']);
        %         mask5 = cbiReadNifti([char(kk) 'D5.hdr']);
        %         mask = mask1 + mask2 + mask3 + mask4 + mask5;
        mask = mask(:);
        maskPH = mask .* ph;
        maskPH(isnan(maskPH))=0;
        co(co<0.3)=0;
        co = logical(co);
        finalmaskA = maskPH .* co;
        
        %strAdd = strcat(nsubs{ii},'_pre');
        cd([subdir '/PA_motor/' nsubs{ii} '_motor/patchSpace_pre/'])
        co = cbiReadNifti(['co_' char(kk) 'D.hdr']);
        ph = cbiReadNifti(['ph_' char(kk) 'D.hdr']);
        co = co(:);
        co(isnan(co))=0;
        ph = ph(:);
        ph(isnan(ph))=0;
        eachMask2 = cell(5,1);
        for zz = 1:5
            eachMask2{zz} = cbiReadNifti([char(kk) 'D' num2str(zz) '.hdr']);
        end
        mask = eachMask2{1} + eachMask2{2} + eachMask2{3} + eachMask2{4} + eachMask2{5};
        %         mask1 = cbiReadNifti([char(kk) 'D1.hdr']);
        %         mask2 = cbiReadNifti([char(kk) 'D2.hdr']);
        %         mask3 = cbiReadNifti([char(kk) 'D3.hdr']);
        %         mask4 = cbiReadNifti([char(kk) 'D4.hdr']);
        %         mask5 = cbiReadNifti([char(kk) 'D5.hdr']);
        %         mask = mask1 + mask2 + mask3 + mask4 + mask5;
        mask = mask(:);
        maskPH = mask .* ph;
        maskPH(isnan(maskPH))=0;
        co(co<0.3)=0;
        co = logical(co);
        finalmaskB = maskPH .* co;
        
        finalmaskC = finalmaskA - finalmaskB;
        finalmaskC(finalmaskC==0)=[];
        %pHist_pa(:,ii) = finalmaskC;
        
        %pHist_ss(ii).phdiffL = finalmaskC;
        if strcmpi(char(kk),'L')
            pHist_mm(ii).phdiffL = finalmaskC;
        elseif strcmpi(char(kk),'R')
            pHist_mm(ii).phdiffR = finalmaskC;
        end
        
    end
    
    for dd = 1:5
        for jj = 1:5
            smDice_mm(dd,jj,ii) = dice(reshape(eachMask{dd},length(finalmaskA),1),reshape(eachMask2{jj},length(finalmaskB),1));
        end
    end
    clear mask eachMask eachMask2 co ph finalmaskA finalmaskB finalmaskC
end


toc
%% Plot polar histograms!


figure('Position',[100 100 2000 400])
for ii = 1:length(pHist_hc)
    
    a1 = circ_mean(pHist_hc(ii).phdiff);
    b1 = circ_var(pHist_hc(ii).phdiff);
    
    if isempty(a1), a1 = 0; end
    if isempty(b1), b1 = 0; end
    
    c1(ii) = a1;
    d1(ii) = b1;
    
    subplot(1,length(pHist_hc),ii)
    polarhistogram(pHist_hc(ii).phdiff,'DisplayStyle','bar')
    title(['SM' subs{ii}])
    text(0,-0.3,['circ mean:' num2str(round(a1,2))],'Units','Normalized')
    text(0,-0.5,['circ var:' num2str(round(b1,2))],'Units','Normalized')
    set(gcf,'color', 'w');
end

meanCircMeanHC = mean(nonzeros(c1));
meanCircVarHC = mean(nonzeros(d1));

if shallisave
    if two
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'sm_hc_ph_2mm');
    else
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'sm_hc_ph');
    end
    print(filename,'-dpng')
end

figure('Position',[100 100 2000 800])
for ii = 1:length(pHist_pa)
    a2 = circ_mean(pHist_pa(ii).phdiff);
    b2 = circ_var(pHist_pa(ii).phdiff);
    
    c2(ii) = a2;
    d2(ii) = b2;
    
    subplot(2,6,ii)
    polarhistogram(pHist_pa(ii).phdiff)
    title(['SM' subs{ii+7}])
    text(0,-0.3,['circ mean:' num2str(round(a2,2))],'Units','Normalized')
    text(0,-0.5,['circ var:' num2str(round(b2,2))],'Units','Normalized')
    set(gcf,'color', 'w');
end

meanCircMeanPA = mean(nonzeros(c2(1:6)));
meanCircVarPA = mean(nonzeros(d2(1:6)));
meanCircMeanPre = mean(nonzeros(c2(7:end)));
meanCircVarPre = mean(nonzeros(d2(7:end)));



if shallisave
    if two
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'sm_pa_ph_2mm');
    else
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'sm_pa_ph');
    end
    print(filename,'-dpng')
end

figure('Position',[100 100 2000 400])
for ii = 1:length(pHist_ss)
    a3 = circ_mean(pHist_ss(ii).phdiffL);
    b3 = circ_var(pHist_ss(ii).phdiffL);
    c3(ii) = a3;
    d3(ii) = b3;
    subplot(1,6,ii)
    polarhistogram(pHist_ss(ii).phdiffL)
    title(['SSLD' subs{ii+7}])
    text(0,-0.3,['circ mean:' num2str(round(a3,2))],'Units','Normalized')
    text(0,-0.5,['circ var:' num2str(round(b3,2))],'Units','Normalized')
    set(gcf,'color', 'w');
end
if shallisave
    if two
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'ss_LD_ph_2mm');
    else
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'ss_LD_ph');
    end
    print(filename,'-dpng')
end

figure('Position',[100 100 2000 400])
for ii = 1:length(pHist_ss)
    a4 = circ_mean(pHist_ss(ii).phdiffR);
    b4 = circ_var(pHist_ss(ii).phdiffR);
    c4(ii) = a4;
    d4(ii) = b4;
    subplot(1,6,ii)
    polarhistogram(pHist_ss(ii).phdiffR)
    title(['SSRD' subs{ii+7}])
    text(0,-0.3,['circ mean:' num2str(round(a4,2))],'Units','Normalized')
    text(0,-0.5,['circ var:' num2str(round(b4,2))],'Units','Normalized')
    set(gcf,'color', 'w');
end
if shallisave
    if two
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'ss_RD_ph_2mm');
    else
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'ss_RD_ph');
    end
    print(filename,'-dpng')
end



meanCircMeanPAss = mean(nonzeros(c3));
meanCircVarPAss = mean(nonzeros(d3));
meanCircMeanPress = mean(nonzeros(c4));
meanCircVarPress = mean(nonzeros(d4));



figure('Position',[100 100 2000 400])
for ii = 1:length(pHist_mm)
    a5 = circ_mean(pHist_mm(ii).phdiffR);
    b5 = circ_var(pHist_mm(ii).phdiffR);
    subplot(1,6,ii)
    polarhistogram(pHist_mm(ii).phdiffR)
    title(['MM' subs{ii+7}])
    text(0,-0.3,['circ mean:' num2str(round(a5,2))],'Units','Normalized')
    text(0,-0.5,['circ var:' num2str(round(b5,2))],'Units','Normalized')
    set(gcf,'color', 'w');
end
if shallisave
    if two
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'mm_ph_2mm');
    else
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'mm_ph');
    end
    print(filename,'-dpng')
end


%% DICE coefficients

mylow = 0;
myhigh = 0.5;

figure('Position',[100 100 2000 200])
for ii = 1:length(smDice_hc)
    subplot(1,length(smDice_hc),ii)
    imagesc(smDice_hc(:,:,ii))
    title(['SM' subs{ii}])
    colormap(inferno)
    colorbar
    xticks(1:5)
    yticks(1:5)
    yticklabels({'SD1','SD2','SD3','SD4','SD5'});
    xticklabels({'MD1','MD2','MD3','MD4','MD5'});
    xtickangle(45)
    ytickangle(45)
    ax = gca;
    ax.FontSize = 10;
    axis square
    caxis([mylow myhigh])
    set(gcf,'color', 'w');
end
if shallisave
    if two
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'sm_hc_dice_2mm');
    else
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'sm_hc_dice');
    end
    print(filename,'-dpng')
end

figure('Position',[100 100 2000 500])
for ii = 1:length(smDice_pa)
    subplot(2,6,ii)
    imagesc(smDice_pa(:,:,ii))
    title(['SM' subs{ii+7}])
    colormap(inferno)
    colorbar
    xticks(1:5)
    yticks(1:5)
    yticklabels({'SD1','SD2','SD3','SD4','SD5'});
    xticklabels({'MD1','MD2','MD3','MD4','MD5'});
    xtickangle(45)
    ytickangle(45)
    ax = gca;
    ax.FontSize = 10;
    axis square
    caxis([mylow myhigh])
    set(gcf,'color', 'w');
end
if shallisave
    if two
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'sm_pa_dice_2mm');
    else
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'sm_pa_dice');
    end
    print(filename,'-dpng')
end


figure('Position',[100 100 2000 500])
suptitle('LD')
for ii = 1:length(smDice_ssL)
    subplot(1,6,ii)
    imagesc(smDice_ssL(:,:,ii))
    title(['SSLD' subs{ii+7}])
    colormap(inferno)
    colorbar
    xticks(1:5)
    yticks(1:5)
    yticklabels({'SpostD1','SpostD2','SpostD3','SpostD4','SpostD5'});
    xticklabels({'SpreD1','SpreD2','SpreD3','SpreD4','SpreD5'});
    xtickangle(45)
    ytickangle(45)
    ax = gca;
    ax.FontSize = 10;
    axis square
    caxis([mylow myhigh])
    set(gcf,'color', 'w');
end
if shallisave
    if two
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'ss_ld_dice_2mm');
    else
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'ss_ld_dice');
    end
    print(filename,'-dpng')
end


figure('Position',[100 100 2000 500])
suptitle('RD')
for ii = 1:length(smDice_ssR)
    subplot(1,6,ii)
    imagesc(smDice_ssR(:,:,ii))
    title(['SSRD' subs{ii+7}])
    colormap(inferno)
    colorbar
    xticks(1:5)
    yticks(1:5)
    yticklabels({'SpostD1','SpostD2','SpostD3','SpostD4','SpostD5'});
    xticklabels({'SpreD1','SpreD2','SpreD3','SpreD4','SpreD5'});
    xtickangle(45)
    ytickangle(45)
    ax = gca;
    ax.FontSize = 10;
    axis square
    caxis([mylow myhigh])
    set(gcf,'color', 'w');
end
if shallisave
    if two
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'ss_rd_dice_2mm');
    else
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'ss_rd_dice');
    end
    print(filename,'-dpng')
end


figure('Position',[100 100 2000 500])
suptitle('RD')
for ii = 1:length(smDice_mm)
    subplot(1,6,ii)
    imagesc(smDice_mm(:,:,ii))
    title(['MM' subs{ii+7}])
    colormap(inferno)
    colorbar
    xticks(1:5)
    yticks(1:5)
    yticklabels({'MpostD1','MpostD2','MpostD3','MpostD4','MpostD5'});
    xticklabels({'MpreD1','MpreD2','MpreD3','MpreD4','MpreD5'});
    xtickangle(45)
    ytickangle(45)
    ax = gca;
    ax.FontSize = 10;
    axis square
    caxis([mylow myhigh])
    set(gcf,'color', 'w');
end
if shallisave
    if two
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'mm_rd_dice_2mm');
    else
        filename = fullfile('/Users/ppzma/Google Drive/PhD/latex/affinity/touchmap_dice/', ...
            'mm_rd_dice');
    end
    print(filename,'-dpng')
end



end
