%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LeafClassification.m
%
% Demonstrates:
%   1) Shape Extraction (Thresholding & Morphological Cleanup)
%   2) Feature Extraction (regionprops)
%   3) Classification (Multi-class SVM)
%
% Folder Structure Assumptions:
%   - A folder "TrainImages" containing training leaf images (e.g., .jpg)
%   - A folder "TestImages" containing test leaf images
%   - Known class labels for each image in the same order as they appear
%     in the folder (or in a .mat/.csv that you load).
%
% You can customize:
%   - The morphological operations
%   - The regionprops features
%   - The classification method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% STEP 0: Setup and Class Label Definitions

% Adjust these paths to where your images are located:
trainFolder = 'F:\GitSourceTree\Computer_vision_ku\Lab6\trainset\trainset';
testFolder  = 'F:\GitSourceTree\Computer_vision_ku\Lab6\testset\testset';

% List of training images (e.g., all .jpg files)
trainFiles = dir(fullfile(trainFolder, '*.jpg'));
testFiles  = dir(fullfile(testFolder,  '*.jpg'));

% Example class labels for training images (must match the # of trainFiles)
% In practice, you might read these from a file or define them programmatically.
% Here we just provide an example. Adjust to your real classes and number of images.
load('trainLabel.mat','testLabel.mat')
trainSpecies=trainLabel;
% Example class labels for test images
testSpecies =testLabel;

% Number of training and test images
numTrain = length(trainFiles);
numTest  = length(testFiles);

% (Optional) Check that trainSpecies has the same length as trainFiles
if length(trainSpecies) ~= numTrain
    error('Mismatch between # of train images and # of train labels!');
end
if length(testSpecies) ~= numTest
    error('Mismatch between # of test images and # of test labels!');
end

% We will extract 4 features:
%   1) Area
%   2) Perimeter
%   3) Eccentricity
%   4) Circularity (4*pi*Area / Perimeter^2)
numFeatures = 4;

%% STEP 1: Shape Extraction + STEP 2: Feature Extraction (TRAINING SET)

% Pre-allocate feature matrix (Xtrain) and label array (ytrain)
Xtrain = zeros(numTrain, numFeatures);
ytrain = cell(numTrain, 1);

for i = 1:numTrain
    % Read the i-th training image
    imgPath = fullfile(trainFolder, trainFiles(i).name);
    I = imread(imgPath);
    
    % --- (1) SHAPE EXTRACTION ---
    % Convert to grayscale if needed
    if ndims(I) == 3
        Igray = rgb2gray(I);
    else
        Igray = I;
    end
    
    % Threshold (Otsu)
    level = graythresh(Igray);
    BW = imbinarize(Igray, level);
    
    % Morphological cleanup (closing + fill holes)
    BW = imclose(BW, strel('disk', 5));
    BW = imfill(BW, 'holes');
    
    % Keep the largest connected component (assuming only one leaf)
    BW = bwareafilt(BW, 1);

    % --- (2) FEATURE EXTRACTION ---
    stats = regionprops(BW, 'Area', 'Perimeter', 'Eccentricity');
    
    % If there's exactly one leaf region, stats(1) is valid
    leafArea         = stats(1).Area;
    leafPerimeter    = stats(1).Perimeter;
    leafEccentricity = stats(1).Eccentricity;
    
    % Circularity = 4 * pi * Area / Perimeter^2
    leafCircularity = 4 * pi * leafArea / (leafPerimeter^2);
    
    % Build feature vector
    featVec = [leafArea, leafPerimeter, leafEccentricity, leafCircularity];
    
    % Store in Xtrain
    Xtrain(i, :) = featVec;
    
    % Store class label
    ytrain{i} = trainSpecies{i};
    
    fprintf('Processed TRAIN image %d/%d: %s\n', i, numTrain, trainFiles(i).name);
end

% (Optional) Save training features & labels
save('trainLabel.mat', 'Xtrain', 'ytrain');

%% STEP 1 & 2 (TEST SET): Shape Extraction + Feature Extraction

% Pre-allocate feature matrix (Xtest) and label array (ytest)
Xtest = zeros(numTest, numFeatures);
ytest = cell(numTest, 1);

for i = 1:numTest
    % Read the i-th test image
    imgPath = fullfile(testFolder, testFiles(i).name);
    I = imread(imgPath);
    
    % Convert to grayscale if needed
    if ndims(I) == 3
        Igray = rgb2gray(I);
    else
        Igray = I;
    end
    
    % Threshold
    level = graythresh(Igray);
    BW = imbinarize(Igray, level);
    
    % Morphological cleanup
    BW = imclose(BW, strel('disk', 5));
    BW = imfill(BW, 'holes');
    BW = bwareafilt(BW, 1);
    
    % Extract features
    stats = regionprops(BW, 'Area', 'Perimeter', 'Eccentricity');
    leafArea         = stats(1).Area;
    leafPerimeter    = stats(1).Perimeter;
    leafEccentricity = stats(1).Eccentricity;
    leafCircularity  = 4 * pi * leafArea / (leafPerimeter^2);
    
    featVec = [leafArea, leafPerimeter, leafEccentricity, leafCircularity];
    Xtest(i, :) = featVec;
    
    % Store test label
    ytest{i} = testSpecies{i};
    
    fprintf('Processed TEST image %d/%d: %s\n', i, numTest, testFiles(i).name);
end

% (Optional) Save test features & labels
save('testLabel.mat', 'Xtest', 'ytest');

%% STEP 3: Classification (Multi-class SVM)

% Train a multi-class SVM using ECOC with default options
Mdl = fitcecoc(Xtrain, ytrain);

% Predict on the test set
predictedLabels = predict(Mdl, Xtest);

% Display results in a table: TrueLabel vs. PredictedLabel
resultsTable = table(ytest(:), predictedLabels(:), ...
                     'VariableNames', {'TrueLabel','PredictedLabel'});
disp(resultsTable);

% Calculate accuracy if you have ground-truth labels in ytest
correct = strcmp(predictedLabels, ytest);
accuracy = mean(correct) * 100;
fprintf('Test Accuracy: %.2f%%\n', accuracy);

%% (Optional) Confusion Matrix
figure;
confusionchart(ytest, predictedLabels);
title('Confusion Matrix for Leaf Classification');

%% (Optional) Display Some Training Images (Montage)
% If you want to visualize your training set:
% (Requires all images to be the same size or you can adjust code accordingly)
% trainImagePaths = fullfile(trainFolder, {trainFiles.name});
% montage(trainImagePaths, 'Size', [2 3]); % Adjust 'Size' for your dataset
% title('Training Set Examples');
