clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get training data.
inputDirectory = 'trainingImages'; % Directory for training data
if ~exist(inputDirectory, 'dir')
fprintf('Hey! can''t find directory named %s\n', inputDirectory);
pause;
end
cd(inputDirectory); % Go into the directory containing the images
% Load feature vectors and classes from a "mat" file.
% This should load in 'featureVectors', 'featureClasses', 'imageFileNames'.
fprintf('Reading training features from features.mat\n');
load('features');
classes = unique(featureClasses);
disp('Feature classes present in training data: '), disp(classes);
cd('..'); % Go back up to original directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Train the SVM Classifier.
cl = fitcecoc(featureVectors,featureClasses, ...
'Verbose', 2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get testing data.
inputDirectory = 'testImages'; % Directory for test data
if ~exist(inputDirectory, 'dir')
fprintf('Hey! can''t find directory named %s\n', inputDirectory);
pause;
end
cd(inputDirectory); % Go into the directory containing the images
% Load feature vectors and classes from a "mat" file.
% This should load in 'featureVectors', 'featureClasses', 'imageFileNames'.
fprintf('Reading test features from features.mat\n');
%load('features');
classes = unique(featureClasses);
disp('Feature classes present in test data: '), disp(classes);
cd('..'); % Go back up to original directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Classify the test data.
[labels, scores] = predict(cl, featureVectors);
fprintf('Score\tTrue class\tEstimated class\tImage\n');
for i=1:length(labels)
fprintf('%f\t%d\t%d\t%s\n', scores(i), featureClasses(i), ...
labels(i), imageFileNames{i});
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
