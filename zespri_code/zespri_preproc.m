clear all
close all
clc
close all hidden

thisDay = '060723';
thisSub = '12D';


% we actually might want to make the folders that we need
toppath = '/Volumes/ares/ZESPRI/';

thispath = [toppath 'zespri_' thisDay '/zespri_' thisSub ];
cd(thispath)

if ~isfolder('parrec')
    mkdir parrec
    disp('Need to convert your PARRECs to niftis now')
    movefile('*.PAR', 'parrec/')
    movefile('*.REC', 'parrec/')
    cd(thispath)
    return
end

file = 'parrec_WIPN-BACK_SENSE2_MB3_DE_EPI_20230706083630_17';
rsfile1 = 'parrec_WIP10minRSfMRI_SENSE2_MB3_DE_EPI_20230706083630_3';
rsfile2 = 'parrec_WIP10minRSfMRI_SENSE2_MB3_DE_EPI_20230706083630_4';
brandfile1 = 'parrec_WIPbrand_SENSE2_MB3_DE_EPI_20230706083630_18';
brandfile2 = 'parrec_WIPbrand_SENSE2_MB3_DE_EPI_20230706083630_19';

rsfile1A = [rsfile1 '_e1.nii'];
rsfile2A = [rsfile1 '_e2.nii'];
rsfile1B = [rsfile2 '_e1.nii'];
rsfile2B = [rsfile2 '_e2.nii'];

magfile1 = [file '_e1.nii'];
magfile2 = [file '_e2.nii'];
phfile1 = [file '_e1_ph.nii'];
phfile2 = [file '_e2_ph.nii'];



if ~isfolder('nback')
    mkdir nback
    cd([toppath 'zespri_' thisDay '/zespri_' thisSub '/parrec/' ])
    movefile('*N-BACK*.nii',[toppath 'zespri_' thisDay '/zespri_' thisSub '/nback/' ])
    cd(thispath)
end

if ~isfolder('qflow')
    mkdir qflow
    cd([toppath 'zespri_' thisDay '/zespri_' thisSub '/parrec/' ])
    if ~isempty(dir('*QFLOW*.nii'))
        movefile('*QFLOW*.nii',[toppath 'zespri_' thisDay '/zespri_' thisSub '/qflow/' ])
    else
        disp('No QFLOWs detected,bailing out..')
    end
    cd(thispath)
end

if contains(thisSub,'D')
    brfile1A = [brandfile1 '_e1.nii'];
    brfile2A = [brandfile1 '_e2.nii'];
    brfile1B = [brandfile2 '_e1.nii'];
    brfile2B = [brandfile2 '_e2.nii'];
    brfile1Aph = [brandfile1 '_e1_ph.nii'];
    brfile2Aph = [brandfile1 '_e2_ph.nii'];
    brfile1Bph = [brandfile2 '_e1_ph.nii'];
    brfile2Bph = [brandfile2 '_e2_ph.nii'];

    if ~isfolder('brand')
        mkdir brand
        cd([toppath 'zespri_' thisDay '/zespri_' thisSub '/parrec/' ])
        movefile('*brand*.nii',[toppath 'zespri_' thisDay '/zespri_' thisSub '/brand/' ])
        cd(thispath)
    end
end

%% RESTING STATE
rspath = [toppath 'zespri_' thisDay '/zespri_' thisSub '/rs/' ];
if ~isfolder('rs')
    mkdir rs
    cd([toppath 'zespri_' thisDay '/zespri_' thisSub '/parrec/' ])
    movefile('*RSfMRI*.nii',[toppath 'zespri_' thisDay '/zespri_' thisSub '/rs/' ])
end


cd(rspath)
if ~isfolder('RETROicor/')
    findlogs = dir('*markers.log');
    if isempty(findlogs)
        disp('move log files')
        return
    end
end


cd(rspath)
if ~isfolder([rspath 'DE/'])
    de(rsfile1A,rsfile2A, [20 45],'noiseCutoff=calculate')
    de(rsfile1B,rsfile2B, [20 45],'noiseCutoff=calculate')
end

cd(rspath)

if ~isfolder([rspath 'RETROicor/'])


    mkdir RETROicor
    findlogs = dir('*markers.log');
    movefile(findlogs(1).name, [rspath 'RETROicor/'])
    movefile(findlogs(2).name, [rspath 'RETROicor/'])

    movefile([rspath '/DE/' extractBefore(rsfile1A,'_e1') '_ws_map.nii'],...
        [rspath 'RETROicor/'])
    movefile([rspath '/DE/' extractBefore(rsfile1B,'_e1') '_ws_map.nii'],...
        [rspath 'RETROicor/'])

    % now run retroicor
    cd([rspath 'RETROicor/'])
    %rinput = [extractBefore(magfile1,'_echo') '_ws_map.nii'];
    rinput = [extractBefore(rsfile1A,'_e1') '_ws_map.nii'];
    markerfile = findlogs(1).name;
    retroicor_2023([rspath 'RETROicor/'],'y',3,2,2,3,'y','r','y',rinput,markerfile)

    rinput = [extractBefore(rsfile1B,'_e1') '_ws_map.nii'];
    markerfile = findlogs(2).name;
    retroicor_2023([rspath 'RETROicor/'],'y',3,2,2,3,'y','r','y',rinput,markerfile)

end
close all

cd(rspath)

if ~isfolder([rspath 'Topup/'])
    mkdir Topup

    movefile([rspath 'RETROicor/' extractBefore(rsfile1A,'_e1') '_ws_map_RCR.nii'],...
        [rspath 'Topup/'])
    movefile([rspath 'RETROicor/' extractBefore(rsfile1B,'_e1') '_ws_map_RCR.nii'],...
        [rspath 'Topup/'])

    %cd([rspath '../parrec/'])

    %         findfiles = dir('*SE*.nii');
    %
    %         for ii = 1:length(findfiles)
    %             movefile(findfiles(ii).name, [mypath 'Topup/'])
    %         end
    %
    cd('../../../')

    copyfile('acqparams.txt', [rspath 'Topup/'])

end




cd(thispath)


%%

if ~isfolder('structural')
    mkdir structural
    if contains(thisSub,'A')
        cd([toppath 'zespri_' thisDay '/zespri_' thisSub '/parrec/' ])
        movefile('*MPRAGE*.nii',[toppath 'zespri_' thisDay '/zespri_' thisSub '/structural/' ])
    end
    cd(thispath)
end

if ~isfolder('json')
    mkdir json
    cd([toppath 'zespri_' thisDay '/zespri_' thisSub '/parrec/' ])
    movefile('*.json',[toppath 'zespri_' thisDay '/zespri_' thisSub '/json/' ])
    cd(thispath)
end

if isempty(dir([thispath '/nback/*markers.log']))
    if isfolder([thispath '/nback/RETROicor/'])
        if isempty(dir([thispath '/nback/RETROicor/*markers.log']))
            disp('You need to run AddMarkers_fast.m to make the marker file')
            cd([toppath 'zespri_' thisDay])
            return
        end
    end
end



%%
% batch script for nordic and de

mypath = [thispath '/nback/'];

cd(mypath)

if ~exist('magnitude','dir')
    mkdir magnitude
    mkdir phase
    movefile([mypath magfile1], [mypath 'magnitude/'])
    movefile([mypath magfile2], [mypath 'magnitude/'])
    movefile([mypath phfile1], [mypath 'phase/'])
    movefile([mypath phfile2], [mypath 'phase/'])
end
mycell = {magfile1, magfile2};

% send to nordic
if ~exist('magnitude/NORDIC/','dir')
    Nordic_batch_func(mypath,mycell)
end

close all

%%
% send to de
nordicfile1 = [extractBefore(magfile1,'.') '_nordic.nii'];
nordicfile2 = [extractBefore(magfile2,'.') '_nordic.nii'];

cd([mypath 'magnitude/NORDIC/Noise_input/']);

% de([mypath 'magnitude/NORDIC/Noise_input/' nordicfile1], ...
%     [mypath 'magnitude/NORDIC/Noise_input/' nordicfile2], [20 45],'noiseCutoff=calculate')
%
if ~isfolder('DE/')
    de(nordicfile1,nordicfile2, [20 45],'noiseCutoff=calculate')
end

%%
%cd([mypath '../'])
cd(mypath)
if ~isfolder('RETROicor')
    mkdir RETROicor
    %cd([mypath '../'])
    findlogs = dir('*markers.log');

    if ~isempty(findlogs)
        movefile(findlogs.name, [mypath 'RETROicor/'])

        %     movefile([mypath 'magnitude/NORDIC/Noise_input/DE/' extractBefore(magfile1,'_echo') '_ws_map.nii'],...
        %         [mypath 'RETROicor/'])
    end

    movefile([mypath 'magnitude/NORDIC/Noise_input/DE/' extractBefore(magfile1,'_e1') '_ws_map.nii'],...
        [mypath 'RETROicor/'])

    % now run retroicor

    cd([mypath 'RETROicor/'])
    if ~isempty(findlogs)
        %rinput = [extractBefore(magfile1,'_echo') '_ws_map.nii'];
        rinput = [extractBefore(magfile1,'_e1') '_ws_map.nii'];
        markerfile = findlogs.name;
        retroicor_2023([mypath 'RETROicor/'],'y',3,2,2,3,'y','r','y',rinput,markerfile)
    end

end
close all


%%
cd(mypath)
if ~isfolder('Topup')
    mkdir Topup
    %     movefile([mypath 'RETROicor/' extractBefore(magfile1,'_echo') '_ws_map_RCR.nii'],...
    %        [mypath 'Topup/'])

    if ~isempty(findlogs)
        movefile([mypath 'RETROicor/' extractBefore(magfile1,'_e1') '_ws_map_RCR.nii'],...
            [mypath 'Topup/'])
    else
        movefile([mypath 'RETROicor/' extractBefore(magfile1,'_e1') '_ws_map.nii'],...
            [mypath 'Topup/'])
    end

    cd([mypath '../parrec/'])

    findfiles = dir('*SE*.nii');

    for ii = 1:length(findfiles)
        movefile(findfiles(ii).name, [mypath 'Topup/'])
    end

    cd([mypath '../../../'])

    copyfile('acqparams.txt', [mypath 'Topup/'])

end

cd(mypath)
close all

%% now do same for brand fMRI
cd(thispath)

if isfolder('brand')
    % batch script for nordic and de
    brpath = [toppath 'zespri_' thisDay '/zespri_' thisSub '/brand/' ];


    cd(brpath)

    if ~isfolder('RETROicor/')
        findlogs = dir('*markers.log');
        if length(findlogs)<2
            disp('only one brand scan happened')
            %return
        elseif isempty(findlogs)
            disp('move log files')
            return
        end
    end

    
%     findlogs = dir('*markers.log');
%     if isempty(findlogs)
%         disp('move log files')
%         return
%     end

%     if length(findlogs)<2
%         disp('only one brand scan happened')
%         return
%     end
    
    cd(brpath)
    if ~isfolder('magnitude')
        mkdir magnitude
        mkdir phase
        movefile([brpath brfile1A], [brpath 'magnitude/'])
        movefile([brpath brfile2A], [brpath 'magnitude/'])
        movefile([brpath brfile1Aph], [brpath 'phase/'])
        movefile([brpath brfile2Aph], [brpath 'phase/'])
        movefile([brpath brfile1B], [brpath 'magnitude/'])
        movefile([brpath brfile2B], [brpath 'magnitude/'])
        movefile([brpath brfile1Bph], [brpath 'phase/'])
        movefile([brpath brfile2Bph], [brpath 'phase/'])
    end
    mycell = {brfile1A, brfile2A, brfile1B, brfile2B};
    cd(brpath)
    % send to nordic
    if ~isfolder('magnitude/NORDIC/')
        Nordic_batch_func(brpath,mycell)
    end
    

    % send to de
    nordicfile1 = [extractBefore(brfile1A,'.') '_nordic.nii'];
    nordicfile2 = [extractBefore(brfile2A,'.') '_nordic.nii'];
    nordicfile3 = [extractBefore(brfile1B,'.') '_nordic.nii'];
    nordicfile4 = [extractBefore(brfile2B,'.') '_nordic.nii'];

    close all
    cd([brpath 'magnitude/NORDIC/Noise_input/']);

    
    %cd(brpath)
    if ~isfolder('DE/')
        de(nordicfile1,nordicfile2, [20 45],'noiseCutoff=calculate')
        de(nordicfile3,nordicfile4, [20 45],'noiseCutoff=calculate')
    end

    cd(brpath)
    if ~isfolder('RETROicor/')
        
        

        mkdir RETROicor
        findlogs = dir('*markers.log');

        if length(findlogs)==2

            movefile(findlogs(1).name, [brpath 'RETROicor/'])
            movefile(findlogs(2).name, [brpath 'RETROicor/'])

            movefile([brpath 'magnitude/NORDIC/Noise_input/DE/' extractBefore(brfile1A,'_e1') '_ws_map.nii'],...
                [brpath 'RETROicor/'])
            movefile([brpath 'magnitude/NORDIC/Noise_input/DE/' extractBefore(brfile1B,'_e1') '_ws_map.nii'],...
                [brpath 'RETROicor/'])

            % now run retroicor
            cd([brpath 'RETROicor/'])
            %rinput = [extractBefore(magfile1,'_echo') '_ws_map.nii'];
            rinput = [extractBefore(brfile1A,'_e1') '_ws_map.nii'];
            markerfile = findlogs(1).name;
            retroicor_2023([brpath 'RETROicor/'],'y',3,2,2,3,'y','r','y',rinput,markerfile)

            rinput = [extractBefore(brfile1B,'_e1') '_ws_map.nii'];
            markerfile = findlogs(2).name;
            retroicor_2023([brpath 'RETROicor/'],'y',3,2,2,3,'y','r','y',rinput,markerfile)

        end

    end
    close all

    cd(brpath)

    if ~isfolder('Topup/')
        mkdir Topup

        if numel(dir([brpath 'RETROicor/'])) ~= 2

            movefile([brpath 'RETROicor/' extractBefore(brfile1A,'_e1') '_ws_map_RCR.nii'],...
                [brpath 'Topup/'])
            movefile([brpath 'RETROicor/' extractBefore(brfile1B,'_e1') '_ws_map_RCR.nii'],...
                [brpath 'Topup/'])

        else
            movefile([brpath 'magnitude/NORDIC/Noise_input/DE/' extractBefore(brfile1A,'_e1') '_ws_map.nii'],...
                [brpath 'Topup/'])
            movefile([brpath 'magnitude/NORDIC/Noise_input/DE/' extractBefore(brfile1B,'_e1') '_ws_map.nii'],...
                [brpath 'Topup/'])



        end

        %cd([rspath '../parrec/'])

        %         findfiles = dir('*SE*.nii');
        %
        %         for ii = 1:length(findfiles)
        %             movefile(findfiles(ii).name, [mypath 'Topup/'])
        %         end
        %
        cd('../../../')

        copyfile('acqparams.txt', [brpath 'Topup/'])

    end





end



















