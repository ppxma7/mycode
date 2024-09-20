% convert real/imaginary images to magnitude


mypath = '/Users/ppzma/The University of Nottingham/T1 mapping - General/code/31May2022/';
cd(mypath)

filename_real = '31May2022_WIPwh_1mm_4p5s_20220531153022_2_real.nii';
filename_imag = '31May2022_WIPwh_1mm_4p5s_20220531153022_2_imaginary.nii';

% load data
thereal = load_untouch_nii([mypath filename_real]);
theimag = load_untouch_nii([mypath filename_imag]);


thereal_data = thereal.img;
theimag_data = theimag.img;

thereal_data = double(thereal_data);
theimag_data = double(theimag_data);

% get size of 4d matrix
sx = size(thereal_data,1);
sy = size(thereal_data,2);
sz = size(thereal_data,3);
st = size(thereal_data,4);

% for xx = 1:sx
%     for yy = 1:sy
%         for zz = 1:sz 
%             for tt = 1:st
%                 thismagn(sx,sy,sz,st) = sqrt( (thereal_data(sx,sy,sz,st).^2 + theimag_data(sx,sy,sz,st).^2) );
%                 thisphas(sx,sy,sz,st) = atan(theimag_data(sx,sy,sz,st)./thereal_data(sx,sy,sz,st));
%                 
%             end
%         end
%     end
% end

% vector
thereal_data_vec = thereal_data(:);
theimag_data_vec = theimag_data(:);

% convert to double
thereal_data_vec_db = double(thereal_data_vec);
theimag_data_vec_db = double(theimag_data_vec);

% mag = sqrt(re.^2 + im.^2)
% phase = atan(im/re)
themagn_data_vec = sqrt( (thereal_data_vec_db.^2 + theimag_data_vec_db.^2) );
thephas_data_vec = atan(theimag_data_vec_db./thereal_data_vec_db);

% reshape to 4d matrix
themagn_data = reshape(themagn_data_vec,[sx sy sz st]);
thephas_data = reshape(thephas_data_vec,[sx sy sz st]);

filename_magn = [mypath '/31May2022_magnitude'];
filename_phas = [mypath '/31May2022_phase'];

% remake the file for save_untouch_nii
themagn = thereal;
thephas = theimag;

% convert to int16
% themagn_data_int = int16(themagn_data);
% thephas_data_int = int16(thephas_data);

% insert mag data into previous struct
themagn.img = themagn_data; %themagn.img = thismagn;
thephas.img = thephas_data; %thephas.img = thisphas;

themagn.fileprefix = '31May2022_magnitude';
thephas.fileprefix = '31May2022_phase';

save_untouch_nii(themagn,filename_magn);
save_untouch_nii(thephas,filename_phas);







