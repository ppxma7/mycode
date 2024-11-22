close all
clc
clear variables

subdir = '/Volumes/styx/prf_fsaverage/';

subs = {'prf1','03677_RD_prf4x4'};

userName = char(java.lang.System.getProperty('user.name'));

savedirUp = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Touch Remap - General/reproducibility/'];

subject = 'fsaverage';
hemisphere = 'l';
subjects_dir = '/Volumes/DRS-Touchmap/ma_ares_backup/subs/';  % Update to actual path


nDigs = 4;
magicVec = 163842;
eachSubR_somato = zeros(magicVec,4,2);

files = {'co_masked_0_1_57_co_thresh_fsaverage.mgh',...
    'co_masked_1_57_3_14_co_thresh_fsaverage.mgh',...
    'co_masked_3_14_4_71_co_thresh_fsaverage.mgh',...
    'co_masked_4_71_6_28_co_thresh_fsaverage.mgh'};

for iSubject = 1:length(subs)

    for ii = 1:nDigs

        RD_A = MRIread(fullfile(subdir,subs{iSubject},files{ii}));
        RD_A = RD_A.vol';

        eachSubR_somato(:,ii,iSubject) = RD_A;
    end

end

%%
visit1 = eachSubR_somato(:,:,1);
visit2 = eachSubR_somato(:,:,2);

for ii = 1:nDigs
    for jj = 1:nDigs
        thisDice(jj,ii) = dice(visit1(:,jj),visit2(:,ii));
    end
end


close all
figure

imagesc(thisDice)
xlabel('sub1 visit2')
ylabel('sub1 visit1')
%title('NoBTX somato vs NoBTX motor')
colormap(inferno)
colorbar
%clim([])
xticks(1:5)
yticks(1:5)
yticklabels({'D1','D2','D3','D4'});
xticklabels({'D1','D2','D3','D4'});
axis square

png_filename = fullfile(savedirUp, ['03677_dice.png']);
exportgraphics(gcf, png_filename, 'Resolution', 300);


%%
clc
visit1 = eachSubR_somato(:,:,1);
visit2 = eachSubR_somato(:,:,2);

D1 = visit1(:,1);
D2 = visit1(:,2)+1;
D3 = visit1(:,3)+2;
D4 = visit1(:,4)+3;

D2(D2==1)=0;
D3(D3==2)=0;
D4(D4==3)=0;


%visit1_digits = D1+D2+D3+D4+D5;
visit1_digits = cat(2,D1,D2,D3,D4);

D1b = visit2(:,1);
D2b = visit2(:,2)+1;
D3b = visit2(:,3)+2;
D4b = visit2(:,4)+3;


D2b(D2b==1)=0;
D3b(D3b==2)=0;
D4b(D4b==3)=0;

%visit2_digits = D1b+D2b+D3b+D4b+D5b;
visit2_digits = cat(2,D1b,D2b,D3b,D4b);
%%
close all

for jj = 1:4
    
    comp1 = visit1_digits(:,jj);
    comp2 = visit2_digits(:,jj);
    % Plot the first overlay
    figure; % Create a new figure
    go_paint_freesurfer(comp1, subject, hemisphere, ...
        'subjects_dir', subjects_dir, ...
        'surface', 'inflated', ...
        'colormap', 'digits', ...
        'range', [0.001 4], ...
        'alpha', 1, 'cbar', true,...
        'nchips',4);

    % Compute edges for D1b
    threshold = 0; % Adjust threshold as needed
    binary_data = comp2 > threshold;

    % Identify edges: vertices with different binary states in connected faces
    [vertices, faces] = read_surf(fullfile(subjects_dir, subject, ['surf/', hemisphere, 'h.inflated']));
    faces = faces + 1;
    edge_mask = false(size(vertices, 1), 1);
    for ii = 1:size(faces, 1)
        face_data = binary_data(faces(ii, :));
        if any(face_data) && ~all(face_data) % Mixed binary states in the face
            edge_mask(faces(ii, :)) = true;
        end
    end

    % Get the indices of edge vertices
    edge_vertices = find(edge_mask);

    % Overlay the outline
    hold on;
    plot3(vertices(edge_vertices, 1), vertices(edge_vertices, 2), vertices(edge_vertices, 3), ...
        'k.', 'MarkerSize', 1); % Adjust marker size as needed
    hold off;

    % Adjust visualization (optional)
    camlight; material([0.7 0.2 0.1 0.1]);
    view([-90, 14]); % Left hemisphere default view
    axis equal;

    png_filename = fullfile(savedirUp, [subs{2} '_D' num2str(jj) 'fsavg_surf.png']);
    exportgraphics(gcf, png_filename, 'Resolution', 300);

end
