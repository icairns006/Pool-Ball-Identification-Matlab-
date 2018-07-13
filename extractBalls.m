% Extract images of pool balls.
clear all
close all
disp('Use this program to crop images of pool balls.');
disp('Here are the types of balls:');
disp(' 0:Cue ball');
disp(' Solid Balls:');
disp(' 1:Yellow, 2:Blue, 3:Red, 4:Purple, 5:Orange, 6:Green, 7: Maroon, 8:Black');
disp(' Striped Balls:');
disp(' 9:Yellow, 10:Blue, 11:Red, 12:Purple, 13:Orange, 14:Green, 15:Maroon');
disp(' ');
inputDirectoryPathName = '';
% inputFileName = 'TableA_movie2.MOV';
% inputFullPathName = sprintf('%s\\%s', inputDirectoryPathName, inputFileName);
% Read in movie file.
frame = imread('ProPool/pool9.png');
% videoReader = VideoReader(inputFileName);
% Set output directory name "trainingImages" or "testImages".
cd('trainingImages');
outputDirectoryName = 'trainingImages';
if exist(outputDirectoryName, 'dir')==0
fprintf('Hey! You need to create the output directory %s!\n', outputDirectoryName);
pause
end
fprintf('Extract images to directory %s\n', outputDirectoryName);
% Set the starting time (if you don't set it, it starts at 0).
% A good way to figure out the approximate starting time is to look at your
% movie in Windows MovieMaker (assuming you have Windows).
minutes = 0.0;
seconds = 0.0;
t = 60*minutes + seconds;
% videoReader.CurrentTime = t; % time in seconds
 
while true %hasFrame(videoReader)
    
%frame = imread('pool3.png');%readFrame(videoReader);
% t = videoReader.CurrentTime;
figure(1), imshow(frame);
% Show the time on the displayed image.
text(20,20, sprintf('%.02f sec', t), 'BackgroundColor', 'w');
drawnow;
while true
s = input('Hit enter to continue to next image, or number of ball to crop: ', 's');
n = sscanf(s, '%d');
if isempty(s)
break;
else
C = imcrop; % Let user crop the image
outputImageNumber = 0;
while true
% Write cropped image to a file. If filename already exists,
% advance the image number to create a new filename.
outputImageNumber = outputImageNumber + 1;
fname = sprintf('ball%02d_%04d.png', ...
n, outputImageNumber);
if ~exist(fname, 'file') break; end
end
fprintf('Saving image to %s...\n', fname);
imwrite(C, fname);
end
end
t = t + 1; % Advance time by 1 second
if t > videoReader.Duration
break;
end
videoReader.CurrentTime = t;
end