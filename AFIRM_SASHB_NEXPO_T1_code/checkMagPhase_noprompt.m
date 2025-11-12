function[] = checkMagPhase_noprompt(mypath, magData, varargin)
% checkMagPhase: phase and magnitude values are correct before running T1 map
% Need JSON files to read in philips params
% Prequisites: Need nifti tools https://uk.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image
% Michael Asghar May 2023
%


if nargin<2
    error('Need path, need magnitude data')
end

if nargin == 2
    ignoreJson = false;
end

if nargin == 3
    if strcmpi(varargin(1),'ignore')
        ignoreJson = true;
    else
        ignoreJson = false;
    end
end
cd(mypath)


% if strcmpi(varargin(1),'ignore')
%     ignoreJson = true;
% end
  

magData = fullfile(mypath,magData);

phData = [extractBefore(magData,'.') '_ph.nii'];

%edges = 128;
% if strcmpi(magData(end-2:end),'.gz')
%     ext = '.nii.gz';

% load JSON

if ~ignoreJson

    if ~isempty(dir('*.json'))
        json_name = [extractBefore(magData,'.') '.json'];
        json_ph_name = [extractBefore(phData,'.') '.json'];
        %json = jsondecode(fileread([mypath '/' json_name]));
        %json_ph = jsondecode(fileread([mypath '/' json_ph_name]));
        json = jsondecode(fileread(json_name));
        json_ph = jsondecode(fileread(json_ph_name));

    else
        disp('No JSON file found!')
    end

end



%outname = [extractBefore(magData,'.') '_fixed.nii'];
%outname_ph = [extractBefore(phData,'.') '_fixed.nii'];

outname = [extractBefore(magData,'WIP') 'fixed' extractAfter(magData,'WIP')];
outname_ph = [extractBefore(phData,'WIP') 'fixed' extractAfter(phData,'WIP')];
% elseif strcmpi(magData(end-2:end),'nii')
%     ext = '.nii';
%     json_name = [myt1map(1:end-8),'.json'];
%     json_ph_name = [myt1map(1:end-8),'_ph.json'];
%     outname = myt1map(1:end-4);
% else
%     disp('Please using .nii or .nii.gz files')
%     exit
% end

disp('Loading files...')
magDataFile = load_untouch_nii(magData);
phDataFile = load_untouch_nii(phData);

%dim = size(magDataFile.img);
mag_data = magDataFile.img;
ph_data = phDataFile.img;
nX = size(mag_data,1);
nY = size(mag_data,2);
nS = size(mag_data,3);
nT = size(mag_data,4);

data_mag_vec = mag_data(:);
data_ph_vec = ph_data(:);



% need these values from json file for philips data
% these are philips slope and intercept
% need this to correct nifti file, if converting from dicom->nifti.
%phase

if ~ignoreJson
    if ~isempty(dir('*.json'))

        if isfield(json_ph,'PhilipsRescaleSlope')

            RS = json_ph.PhilipsRescaleSlope;
            RI = json_ph.PhilipsRescaleIntercept;
            SS = json_ph.PhilipsScaleSlope;

            RSm = json.PhilipsRescaleSlope;
            RIm = json.PhilipsRescaleIntercept;
            SSm = json.PhilipsScaleSlope;
        else
            RS = 1.53455;
            RI = -3142;
            SS = 651.74;
            %
            % %magnitude
            RSm = 19.5802;
            RIm = 0;
            SSm = 0.0245663;
        end

    end
else % just some default values from a t1 map
    RS = 1.53455;
    RI = -3142;
    SS = 651.74;
    %
    % %magnitude
    RSm = 19.5802;
    RIm = 0;
    SSm = 0.0245663;
end

%% check data before running correction
% figure
% tiledlayout(1,2)
% nexttile
% histogram(nonzeros(data_mag_vec),edges);
% title(sprintf('min=%d max=%d',min(data_mag_vec),max(data_mag_vec)))
% axis square


disp(min(data_mag_vec))
disp(max(data_mag_vec))
disp(class(data_mag_vec))

% nexttile
% histogram(nonzeros(data_ph_vec),edges);
% title(sprintf('min=%d max=%d',min(data_ph_vec),max(data_ph_vec)))
% axis square

disp(min(data_ph_vec))
disp(max(data_ph_vec))
disp(class(data_ph_vec))

%%

% prompt = 'Correct Phase data only (1) or Correct everything (2)? Or bail out (3)';
% x = input(prompt,'s');
% 
% if strcmpi(x,'1')
%     %run phase
%     disp('correcting phase')
% 
%     mag_data_d = mag_data;
%     ph_data_d = ph_data;
%     
%     mag_data_d_div = mag_data_d;
%     ph_data_d_div = ph_data_d./1000;
% 
%     disp(min(mag_data_d_div(:)));
%     disp(max(mag_data_d_div(:)));
% 
%     disp(min(ph_data_d_div(:)));
%     disp(max(ph_data_d_div(:)));
% 
%
%
%
% elseif strcmpi(x,'2')


% run everything
mag_data_d = single(mag_data);
mag_data_d_vec = mag_data_d(:);

ph_data_d = single(ph_data);
ph_data_d_vec = ph_data_d(:);


if isfield(json_ph,'PhilipsRescaleSlope')

    disp('correct phase and magnitude using philips rescale values from json')


    D = ph_data_d_vec.*RS+RI;
    %D = D./RS.*SS;
    ph_data_d_vec_resh = reshape(D,[nX nY nS nT]);
    ph_data_d_div = ph_data_d_vec_resh./1000;


    Dm = mag_data_d_vec.*RSm+RIm;
    %D = D./RSm.*SSm;
    mag_data_d_vec_resh = reshape(Dm,[nX nY nS nT]);
    mag_data_d_div = mag_data_d_vec_resh;

    disp(min(mag_data_d_div(:)));
    disp(max(mag_data_d_div(:)));

    disp(min(ph_data_d_div(:)));
    disp(max(ph_data_d_div(:)));

elseif ~isfield(json_ph,'PhilipsRescaleSlope')

    disp('no json file, just doing divide')

    mag_data_d = mag_data;
    ph_data_d = ph_data;

    mag_data_d_div = mag_data_d;
    ph_data_d_div = ph_data_d./1000;

    disp(min(mag_data_d_div(:)));
    disp(max(mag_data_d_div(:)));

    disp(min(ph_data_d_div(:)));
    disp(max(ph_data_d_div(:)));

else
    keyboard

end

%saving
info_mag = make_nii(mag_data_d_div);
save_nii(info_mag,outname)
info_ph = make_nii(ph_data_d_div);
save_nii(info_ph,outname_ph)








end
