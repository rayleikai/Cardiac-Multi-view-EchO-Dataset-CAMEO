close all;clear;clc;
% Set your local path for saving the downloaded dataset
tarPath = 'YOUR_LOCAL_SAVE_PATH';
imgDir = 'CAMEO';
numDir = dir(fullfile(tarPath, imgDir));
numDir = numDir([numDir.isdir]); 
numDir = numDir(~ismember({numDir.name}, {'.', '..'}));

for i = 1:2
    Split = ["train", "test"];
    destDir = fullfile(tarPath, 'Temp', Split(i));
    if exist(destDir)==0
        mkdir(destDir);
        mkdir(fullfile(destDir,"PLAX"));
        mkdir(fullfile(destDir,"PSAX-Aortic"));
        mkdir(fullfile(destDir,"PSAX-Mitral"));
        mkdir(fullfile(destDir,"PSAX-Papillary"));
        mkdir(fullfile(destDir,"PSAX-Apical"));
        mkdir(fullfile(destDir,"A4C"));
        mkdir(fullfile(destDir,"A2C"));
        mkdir(fullfile(destDir,"A3C"));
        mkdir(fullfile(destDir,"S4C"));
    else
        disp('dir is exist');
    end
end

%% Training Set
numTrain = "1-4,6-7,9-14,16-17,19-24,26,34-40,42-70,72-73,80-100"; % Training set
numTrain = parseFields(numTrain);
for i = 1:length(numTrain)
    idx = numTrain(i);
    num = numDir(idx).name;
    viewDir = dir(fullfile(tarPath, imgDir, num));
    viewDir = viewDir([viewDir.isdir]); 
    viewDir = viewDir(~ismember({viewDir.name}, {'.', '..'}));
    for j = 1:9
        view = viewDir(j).name;
        fileDir = dir(fullfile(tarPath, imgDir, num, view,"*.png"));
        for k = 1:length(fileDir)
            src = fullfile(fileDir(k).folder, fileDir(k).name);
            dst = fullfile(tarPath, 'Temp/train/',view,fileDir(k).name);  % 複製到根目錄 nas
            copyfile(src, dst);
        end
    end
end

%% Testing Set
numTest = "5,8,15,18,25,27-33,41,71,74-79"; % Testing set
numTest = parseFields(numTest);
for i = 1:length(numTest)
    idx = numTest(i);
    num = numDir(idx).name;
    viewDir = dir(fullfile(tarPath, imgDir, num));
    viewDir = viewDir([viewDir.isdir]); 
    viewDir = viewDir(~ismember({viewDir.name}, {'.', '..'}));
    for j = 1:9
        view = viewDir(j).name;
        fileDir = dir(fullfile(tarPath, imgDir, num, view,"*.png"));
        for k = 1:length(fileDir)
            src = fullfile(fileDir(k).folder, fileDir(k).name);
            dst = fullfile(tarPath, 'Temp/test/',view,fileDir(k).name);  % 複製到根目錄 nas
            copyfile(src, dst);
        end
    end
end

%% Functions
function expandedNumbers = parseFields(inputStr)
    inputStr = strrep(inputStr, '"', '');
    inputStr = strrep(inputStr, '"', '');
    
    parts = split(inputStr, ',');
    expandedNumbers = [];

    for i = 1:length(parts)
        part = strtrim(parts{i});
        if contains(part, '-')
            rangeBounds = split(part, '-');
            startVal = str2double(rangeBounds{1});
            endVal = str2double(rangeBounds{2});
            expandedNumbers = [expandedNumbers, startVal:endVal];
        else
            expandedNumbers = [expandedNumbers, str2double(part)];
        end
    end
end