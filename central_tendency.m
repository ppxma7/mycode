function CT = central_tendency(subjectROI, atlasFPM)
% subjectROI : binary matrix (Xx1 or Xx5)
% atlasFPM   : probabilistic matrix (Xx1 or Xx5)

% Make sure both are 2D
if isvector(subjectROI)
    subjectROI = subjectROI(:); % ensure column
end
if isvector(atlasFPM)
    atlasFPM = atlasFPM(:); % ensure column
end

[X1, N1] = size(subjectROI);
[X2, N2] = size(atlasFPM);

if X1 ~= X2
    error('subjectROI and atlasFPM must have the same number of rows (voxels)');
end

CT = zeros(N1, N2); % subject digits (rows) vs atlas digits (cols)

for ii = 1:N1 % subject digits
    id = subjectROI(:,ii) == 1; % indices of current subject digit ROI
    
    for jj = 1:N2 % atlas digits
        if any(id)
            atlas_vals_in_subject = atlasFPM(id, jj);
            mean_in_subject = mean(atlas_vals_in_subject);
        else
            mean_in_subject = NaN; % handle empty ROI
        end

        atlas_vals = atlasFPM(:,jj);
        if any(atlas_vals > 0)
            mean_in_atlas = mean(atlas_vals(atlas_vals > 0));
        else
            mean_in_atlas = NaN;
        end

        CT(ii,jj) = mean_in_subject / mean_in_atlas;
    end
end
end
