function isDEmpty = isDirEmpty(folderPath)
    % Get list of all files and folders in the directory
    contents = dir(folderPath);
    
    % Remove '.' and '..' which are always present
    contents = contents(~ismember({contents.name}, {'.', '..'}));
    
    % Check if the directory is empty
    isDEmpty = isempty(contents);
end
