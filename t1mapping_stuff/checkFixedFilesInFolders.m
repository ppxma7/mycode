function checkFixedFilesInFolders(parentFolder)
    % Get list of all subject folders in the parent directory
    subjectFolders = dir(parentFolder);
    subjectFolders = subjectFolders([subjectFolders.isdir]); % Keep only directories
    subjectFolders = subjectFolders(~ismember({subjectFolders.name}, {'.', '..'})); % Remove '.' and '..'

    % Initialize tracking variables
    allValid = true;

    % Loop through each subject folder
    for i = 1:length(subjectFolders)
        subjectPath = fullfile(parentFolder, subjectFolders(i).name, 'T1mapping');

        % Check if T1mapping directory exists
        if ~isfolder(subjectPath)
            fprintf('Missing T1mapping directory in: %s\n', subjectFolders(i).name);
            allValid = false;
            continue;
        end

        % Get list of files in the T1mapping folder
        fileList = {dir(fullfile(subjectPath, '*.nii')).name};

        % Check for required files
        hasFixedFile1 = any(startsWith(fileList, 'fixed_') & endsWith(fileList, '.nii'));
        hasFixedFile2 = any(startsWith(fileList, 'fixed_') & contains(fileList, '_ph.nii'));

        % Report if files are missing
        if ~(hasFixedFile1 && hasFixedFile2)
            fprintf('Missing required files in: %s\n', subjectPath);
            allValid = false;
        end
    end

    % Final status message
    if allValid
        disp('! All subject folders contain the required files.');
    else
        disp('! Some subject folders are missing the required files.');
    end
end
