%%
subdir = '/Volumes/DRS-Touchmap/ma_ares_backup/patients_digits_2mm/';

%cd(subdir)
%
%
% subs = {'03942', '00393', '03677', '13287','13945', '13172',...
%     '13382','13493', '13654','13658', '13695', '14001'...
%     '13695_pre', '13493_pre', '13382_pre', '13658_pre','14001_pre', '13654_pre'};

subs = {'03942', '03677', '00393','13172', '13493','13658','13695','14001',...
    '13493_pre', '13658_pre', '13695_pre','14001_pre'};

subs = {'14001','14001_pre'};
userName = char(java.lang.System.getProperty('user.name'));

savedirUp = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Touch Remap - General/reproducibility/'];

%subs = {'13695', '13695_pre'};
% nHC = 4;
% nPA = 8;
% nPApre= 4;

nPA = 2;
%magicAmpu = 9;

%disp('Calculating Dice to the MPM, centend to the FPM and FOM between patient digits and the atlas')
%tic
for iSubject = 1:length(subs)

    RD_A = MRIread([subdir subs{iSubject} '_' 'RD' '.mgh']);
    RD_A = RD_A.vol;

    eachSubR_somato(:,:,iSubject) = RD_A;

end

sub14001a = eachSubR_somato(:,:,1);
sub14001b = eachSubR_somato(:,:,2);

for ii = 1:5
    for jj = 1:5
        thisDice(jj,ii) = dice(sub14001a(:,jj),sub14001b(:,ii));

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
yticklabels({'D1','D2','D3','D5','D5'});
xticklabels({'D1','D2','D3','D5','D5'});
axis square


png_filename = fullfile(savedirUp, [subs{1} '_dice.png']);
exportgraphics(gcf, png_filename, 'Resolution', 300);


%%

subject = 'fsaverage';
hemisphere = 'l';
subjects_dir = '/Volumes/DRS-Touchmap/ma_ares_backup/subs/';  % Update to actual path
%upThre = 1;

visit1 = eachSubR_somato(:,:,1);
visit2 = eachSubR_somato(:,:,2);

D1 = visit1(:,1);
D2 = visit1(:,2)+1;
D3 = visit1(:,3)+2;
D4 = visit1(:,4)+3;
D5 = visit1(:,5)+4;

D2(D2==1)=0;
D3(D3==2)=0;
D4(D4==3)=0;
D5(D5==4)=0;

%visit1_digits = D1+D2+D3+D4+D5;
visit1_digits = cat(2,D1,D2,D3,D4,D5);

D1b = visit2(:,1);
D2b = visit2(:,2)+1;
D3b = visit2(:,3)+2;
D4b = visit2(:,4)+3;
D5b = visit2(:,5)+4;

D2b(D2b==1)=0;
D3b(D3b==2)=0;
D4b(D4b==3)=0;
D5b(D5b==4)=0;

%visit2_digits = D1b+D2b+D3b+D4b+D5b;
visit2_digits = cat(2,D1b,D2b,D3b,D4b,D5b);


% %%
% close all
% figure;
% go_paint_freesurfer(D1, subject, hemisphere, ...
%     'subjects_dir', subjects_dir, ...
%     'surface', 'inflated', ...
%     'colormap', 'digits', ...
%     'range', [0.001 5], ...
%     'alpha', 1, 'cbar', true,...
%     'nchips',5, 'OutlineOnly', true);
% %%
% 
% figure;
% go_paint_freesurfer(visit2_digits, subject, hemisphere, ...
%     'subjects_dir', subjects_dir, ...
%     'surface', 'inflated', ...
%     'colormap', 'digits', ...
%     'range', [0.001 5], ...
%     'alpha', 1, 'cbar', true,...
%     'nchips',5);

%%
close all

% comp1 = D1;
% comp2 = D1b;


for jj = 1:5

    
    comp1 = visit1_digits(:,jj);
    comp2 = visit2_digits(:,jj);
    % Plot the first overlay
    figure; % Create a new figure
    go_paint_freesurfer(comp1, subject, hemisphere, ...
        'subjects_dir', subjects_dir, ...
        'surface', 'inflated', ...
        'colormap', 'digits', ...
        'range', [0.001 5], ...
        'alpha', 1, 'cbar', true,...
        'nchips',5);

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

    png_filename = fullfile(savedirUp, [subs{1} '_D' num2str(jj) 'fsavg_surf.png']);
    exportgraphics(gcf, png_filename, 'Resolution', 300);

end

