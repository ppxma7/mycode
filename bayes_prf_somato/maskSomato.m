%% Load label and its transform
labelpath = '/Volumes/hermes/11251/label/';
label = MRIread(fullfile(labelpath,'lh.BA3b_exvivo.label.volume.nii'));
label_vol = label.vol;                 % 3D binary mask
label_vox2ras = label.vox2ras;        % 4x4 matrix

%% Load surface
Srfpath = '/Volumes/hermes/prf7_bayesprf_test/GLM/';
load(fullfile(Srfpath, 'lh_Srf.mat'))

vertices_mm = Srf.Vertices;           % [N x 3]
n_points = size(vertices_mm,1);
vertices_hom = [vertices_mm, ones(n_points,1)]';

%% Convert RAS mm to voxel coordinates
ras2vox = inv(label_vox2ras);
vox_coords_hom = ras2vox * vertices_hom;
vox_coords = round(vox_coords_hom(1:3, :)');   % [N x 3]

%% Validate voxel bounds
vol_size = size(label_vol);  % e.g. [256 256 256]
valid_idx = all(vox_coords > 0, 2) & ...
            vox_coords(:,1) <= vol_size(1) & ...
            vox_coords(:,2) <= vol_size(2) & ...
            vox_coords(:,3) <= vol_size(3);

%% Initialize mask
in_region = false(n_points,1);

%% Check if each vertex is in the label
for i = 1:n_points
    if valid_idx(i)
        x = vox_coords(i,1);
        y = vox_coords(i,2);
        z = vox_coords(i,3);
        in_region(i) = label_vol(x, y, z) > 0;
    end
end

%% Optionally: Reduce to masked vertices
masked_voxels = Srf.Voxels(in_region, :);
masked_vertices = Srf.Vertices(in_region, :);


%%
fprintf('Retained %d of %d vertices in mask\n', sum(in_region), n_points);


