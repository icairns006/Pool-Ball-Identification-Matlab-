% Extract features from images of pool balls.
clear all
close all
% Number of bins in histograms.
% Histogram 1 is NHUExNSAT, histogram 2 is NSATxNVAL.
NHUE = 32;
NSAT = 8;
NVAL = 8;
% This is the number of dimensions of a feature vector.
Ndim = NHUE*NSAT + NSAT*NVAL;
% Define the input directory ('trainingImages' or 'testImages').
inputDirectory = 'trainingImages';
if ~exist(inputDirectory, 'dir')
fprintf('Hey! can''t find directory named %s\n', inputDirectory);
pause;
end
cd(inputDirectory); % Go into the directory containing the images
% Process all png images in the folder.
folderInfo = dir('ball*.png');
Nimages = length(folderInfo);
% This will hold all the feature vectors. Each row is a feature vector.
featureVectors = zeros(Nimages, Ndim);
% This will hold all the feature class ids.
featureClasses = zeros(Nimages, 1);
% This will hold the corresponding image file names.
imageFileNames = cell(Nimages, 1);
for i=1:Nimages
fileName = folderInfo(i).name;
[vals,count] = sscanf(fileName, 'ball%d_%d.png');
if count ~= 2
fprintf('Hey! bad filename, should have form: ballXX_YYYY.png.\n');
break;
end

ballId = vals(1);
assert(ballId >= 0 && ballId <= 30);
imageNum = vals(2);
fprintf(' Processing image %s: ball %d, image %d\n', ...
fileName, ballId, imageNum);
I = imread(fileName);
assert(size(I,3) == 3); % Should be an RGB image
% Convert RGB to HSV image.
HSV = rgb2hsv(I);
%figure(3), imshow(HSV,[]), impixelinfo
H = HSV(:,:,1);
S = HSV(:,:,2);
V = HSV(:,:,3);
% Extract pixels in the center circle.
[h,w,~] = size(HSV);
x0 = round(w/2);
y0 = round(h/2);
r = min(x0,y0); % Radius of circle
% Get the x,y coordinates of all pixels inside this circle.
xMin = max(x0-r, 1);
xMax = min(x0+r, size(HSV,2));
yMin = max(y0-r, 1);
yMax = min(y0+r, size(HSV,1));
[Xi,Yi] = meshgrid(xMin:xMax, yMin:yMax);
R = ((Xi-x0).^2 + (Yi-y0).^2) .^ 0.5;
% Flag those that within radius r from the center.
Rinside = (R < r);

% Get (x,y) coordinates of the inside pixels.
Xinside = Xi(Rinside);
Yinside = Yi(Rinside);
% Get equivalent linear indices.
indices = sub2ind([h,w], Yinside, Xinside);
% Get HSV values of all pixels inside circle.
Vi = [H(indices), S(indices), V(indices)];
% Create a 2D historgram of hue vs saturation.
[h1,~,~] = histcounts2(Vi(:,1), Vi(:,2), 0:(1/NHUE):1, 0:(1/NSAT):1);
h1 = h1/sum(h1(:)); % Normalize counts
figure(1), imshow(h1,[], 'InitialMagnification', 800), title(sprintf('Ball %d', ballId));
%figure(1), histogram2(Vi(:,1), Vi(:,2), 0:(1/NHUE):1, 0:(1/NSAT):1), xlabel('H'), ylabel('S');
% Create a 2D historgram of saturation vs value.
[h2,~,~] = histcounts2(Vi(:,2), Vi(:,3), 0:(1/NSAT):1, 0:(1/NVAL):1);
h2 = h2/sum(h2(:)); % Normalize counts
figure(2), imshow(h2,[], 'InitialMagnification', 800), title(sprintf('Ball %d', ballId));;
%figure(2), histogram2(Vi(:,2), Vi(:,3), 0:(1/NSAT):1, 0:(1/NVAL):1), xlabel('S'), ylabel('V');
% Assemble counts into a single long vector.
X = [h1(:); h2(:)];
% Store into the arrays.
featureVectors(i,:) = X';
featureClasses(i) = ballId;
imageFileNames{i} = fileName;
pause(0.25);
end
% Write out data to a "mat" file.
fprintf(' Writing out features to features.mat\n');
save('features', 'featureVectors', 'featureClasses', 'imageFileNames');
cd('..'); % Go back up to original directory