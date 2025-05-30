magData = 'fMRI_somato_pilot3_WIPFLASH_MB0_74slc_CS4_20250529142302_13.nii';
phData = 'fMRI_somato_pilot3_WIPFLASH_MB0_74slc_CS4_20250529142302_13_ph.nii';
json_name = 'fMRI_somato_pilot3_WIPFLASH_MB0_74slc_CS4_20250529142302_13.json';
json_ph_name = 'fMRI_somato_pilot3_WIPFLASH_MB0_74slc_CS4_20250529142302_13_ph.json';


json = jsondecode(fileread(json_name));
json_ph = jsondecode(fileread(json_ph_name));



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

RS = json_ph.PhilipsRescaleSlope;
RI = json_ph.PhilipsRescaleIntercept;
SS = json_ph.PhilipsScaleSlope;

RSm = json.PhilipsRescaleSlope;
RIm = json.PhilipsRescaleIntercept;
SSm = json.PhilipsScaleSlope;


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



mag_data_d = single(mag_data);
mag_data_d_vec = mag_data_d(:);

ph_data_d = single(ph_data);
ph_data_d_vec = ph_data_d(:);



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

 
outname_ph = 'flash_fixed_ph';
outname = 'flash_fixed';

%% saving
info_mag = make_nii(mag_data_d_div);
info_mag.hdr.hist = magDataFile.hdr.hist;
info_mag.hdr.hist.originator = [0 0 0 0 0 ];
save_nii(info_mag,outname)

info_ph = make_nii(ph_data_d_div);
info_ph.hdr.hist = magDataFile.hdr.hist;
info_ph.hdr.hist.originator = [0 0 0 0 0 ];
save_nii(info_ph,outname_ph)







