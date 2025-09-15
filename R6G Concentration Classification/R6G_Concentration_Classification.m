clear; clc; close all;

path = "D:\research\Zhou MDE Raman Impedance Cow\R6G Concentration Classification\data\";

data = loaddata(path);


sData(Nm).d = '';
sDataERS(Nm).d = '';

for i = 1:Nm
    T = t(i);

    L = load(AdjFP + "/Area Scan T" + T + " (CRR) (SG) (Sub BG).mat");
    s = "Area_Scan_T" + T + "_CRR_SG_Sub_BG";

    sData(i).d = getfield(L,s);

    L = load(RawFP + "/Area Scan T" + T + " (CRR) (SG).mat");
    s = "Area_Scan_T" + T + "_CRR_SG";

    sDataERS(i).d = getfield(L,s);
end

s1 = [sData(:).d];
s1ERS = [sDataERS(:).d];


function organizedData = loaddata(dataDir)
% 1) Set up
%dataDir     = 'path_to_your_data';            % change this to your folder
filePattern = fullfile(dataDir, '*.mat');
files       = dir(filePattern);

organizedData = struct();  % will hold everything

% 2) Loop over each .mat file
for k = 1:numel(files)
    fileName = files(k).name;
    filePath = fullfile(files(k).folder, fileName);
    
    % a) get base name (no “.mat”)
    [~, baseName] = fileparts(fileName);
    
    % b) split at comma and take first token as group prefix
    parts       = strsplit(baseName, ',');
    prefix      = parts{1};
    % make sure it’s a valid MATLAB field name
    prefixField = matlab.lang.makeValidName(prefix);
    
    % c) load the file
    fileData = load(filePath);
    % assume there’s one main variable—grab the first
    vars = fieldnames(fileData);
    thisStruct = fileData.(vars{1});
    
    % d) append it into organizedData.<prefixField> as a cell array
    if ~isfield(organizedData, prefixField)
        organizedData.(prefixField) = { thisStruct };
    else
        organizedData.(prefixField){end+1} = thisStruct;
    end
end


end