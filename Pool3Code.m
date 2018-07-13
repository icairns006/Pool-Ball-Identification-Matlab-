clear all;
close all; 
clear all
close all


NHUE = 32;
NSAT = 8;
NVAL = 8;
% This is the number of dimensions of a feature vector.
Ndim = NHUE*NSAT + NSAT*NVAL;
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














frame = imread('pool3.png');
gray=rgb2gray(frame);
BW1 = edge(gray,'Prewitt');
[H,T,R] = hough(BW1);
P  = houghpeaks(H,60,'threshold',ceil(0.0001*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
lines = houghlines(BW1,T,R,P,'FillGap',20,'MinLength',50);
figure(1), imshow(frame), hold on



% % Find lines that are edges of pool table
% for k=1:length(lines)
%     
%     xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',4,'Color','green');
% 
%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',4,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',4,'Color','red');
%    
% end
max_len = 0;
smallestD=[100000, 100000, 100000, 100000];

closeLines=lines(1);
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
   
   sizey=size(frame(:,1,1));
   sizex = size(frame(1,:,1));
   
   v1 = [lines(k).point1, 0];
    v2 = [lines(k).point2, 1];
    pt = [sizex(2)/2, sizey(1)/2,0];
    
      a = v1 - v2;
      b = pt - v2;
      d = norm(cross(a,b)) / norm(a);
      DK(k)=d;
      if(lines(k).theta<-10)
          d=abs(lines(k).point1(2)-pt(2));
      else
          d=abs(lines(k).point1(1)-pt(1));
      end
    for j=1:4;
        
            linesSize = size(closeLines);
            
            
             if(linesSize(2)>=j)
                signXClose = abs(closeLines(j).point1(1)-pt(1))/(closeLines(j).point1(1)-pt(1));
                signX = abs(lines(k).point1(1)-pt(1))/(lines(k).point1(1)-pt(1));
                signYClose = abs(closeLines(j).point1(2)-pt(2))/(closeLines(j).point1(2)-pt(2));
                signY = abs(lines(k).point1(2)-pt(2))/(lines(k).point1(2)-pt(2));
                if(closeLines(j).theta<-10)
                   sign1=signY;
                   sign2=signYClose;
                else
                    sign1=signX;
                   sign2=signXClose;
                end
               
                 
                 
                if(abs(closeLines(j).theta - lines(k).theta)<10 && sign1==sign2 )
                    if(d<smallestD(j))
                        closeLines(j)=lines(k);
                        smallestD(j)=d;
                        break;
                    else
                        break;
                   end
              
               end
             else
                 closeLines(j)=lines(k);
                 smallestD(j)=d;
                 break;
            end
            
       
            
    end
   
   %d = abs(cross([lines(k).point1, 1]-[lines(k).point2, 1],[sizex(1)/2, sizey(1)/2,1]-[lines(k).point1,1]))/abs([lines(k).point2,1]-[lines(k).point1,1]);
   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

% Find lines that are edges of pool table
for k=1:length(closeLines)
    
    xy = [closeLines(k).point1; closeLines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',4,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',4,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',4,'Color','red');
   
end
% for k = 1:length(lines)
%     xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% end

%find and plot the corner pockets
i = 1;
for k=1:length(closeLines)-1
    for j=k:length(closeLines)
    if(abs(closeLines(k).theta-closeLines(j).theta)>45)
        xy = [closeLines(k).point1; closeLines(k).point2];
        xy2 = [closeLines(j).point1; closeLines(j).point2];
        %line1
        x1  = [ xy(1,1); xy(2,1)];
        y1  = [xy(1,2); xy(2,2)];
        %line2
        x2 =  [ xy2(1,1) xy2(2,1)];
        y2 = [xy2(1,2) xy2(2,2)];
        %fit linear polynomial
        p1 = polyfit(x1,y1,1);
        p2 = polyfit(x2,y2,1);
        %calculate intersection
        x_intersect(i) = fzero(@(x) polyval(p1-p2,x),3);
        
        y_intersect(i) = polyval(p2,x_intersect(i));
        if(y_intersect(i)<50 || y_intersect(i)>sizey(1)-50)
            y_intersect(i) = polyval(p1,x_intersect(i));
        end
        i=i+1;
        plot(x_intersect,y_intersect,'x','LineWidth',4,'Color','red');
    end
    end
end
point1=[0,0]
ittPockets = 5;
for i =1:3
    for j = i+1:4
        if(y_intersect(i)-y_intersect(j)<50)
            if(ittPockets ==5)
               x_intersect(5)=(x_intersect(i)+x_intersect(j))/2;
               y_intersect(5)=(y_intersect(i)+y_intersect(j))/2;
               ittPockets=ittPockets+1;
            else
                test1=(x_intersect(i)+x_intersect(j))/2;
               test2=(y_intersect(i)+y_intersect(j))/2;
               if(test1~=x_intersect(5)&&test2~=y_intersect(5))
                   x_intersect(6)=test1;
               y_intersect(6)=test2;
               end
            end
        end    
    end
end
plot(x_intersect,y_intersect,'x','LineWidth',4,'Color','red');
%Find balls using Hough circles

[centers, radii, metric] = imfindcircles(frame,[15 20],'ObjectPolarity','dark','Sensitivity',0.955,'Method','twostage');
% h = viscircles(centers,radii);

% [centersBright, radiiBright, metricBright] = imfindcircles(frame,[30 60], ...
%     'ObjectPolarity','bright','Sensitivity',0.95,'EdgeThreshold',0.1);



%plot centers
i=1;
for j = 1:length(centers)
use = true;
for k=1:length(closeLines)
    lineAngle = closeLines(k).theta;%radtodeg(atan2(-(closeLines(k).point2(2)-closeLines(k).point1(2)) , closeLines(k).point2(1)-closeLines(k).point1(1)));
    if(abs(lineAngle)> 45)
       if(closeLines(k).point1(2) > sizey(1)/2)
           if(centers(j,2)>closeLines(k).point1(2)) 
               use = false;
           end
       else
           if(centers(j,2)<closeLines(k).point1(2)) 
               use = false;
           end
       end
    else
        if(closeLines(k).point1(1) > sizex(2)/2)
           if(centers(j,1)>closeLines(k).point1(1)) 
               use = false;
           end
       else
           if(centers(j,1)<closeLines(k).point1(1)) 
               use = false;
           end
       end
    end
    
    
     
end
if(use)
   centers1(i,:) = centers(j,:);
   MyRadius1(i)= radii(j);
   i=i+1;
end
end
%viscircles(centers1, MyRadius1,'Color','r');
i=1;
for k = 1:length(centers1(:,1))
    doplot=true;
    for j=1:length(x_intersect)
    if(((centers1(k,1)-x_intersect(j))^2+(centers1(k,2)-y_intersect(j))^2)^.5 < 200)
        doplot=false;
        
    end
        
    end
    if(doplot)
       MyCenters(i,:)=centers1(k,:);
        MyRadius(i)=MyRadius1(k);
        i=i+1; 
    end
end



MyCenters = centers1;
MyRadius = MyRadius1;
RGB = frame;
count = 1;
for i = 1:length(MyCenters);
 I2 = imcrop(frame,[MyCenters(i,1)-2*MyRadius(i)/3, MyCenters(i,2)-2*MyRadius(i)/3, 4*MyRadius(i)/3, 4*MyRadius(i)/3]);
  figure(5);
 imshow(I2);
 
 
 HSV = rgb2hsv(I2);
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
%figure(1), imshow(h1,[], 'InitialMagnification', 800), title(sprintf('Ball %d', ballId));
%figure(1), histogram2(Vi(:,1), Vi(:,2), 0:(1/NHUE):1, 0:(1/NSAT):1), xlabel('H'), ylabel('S');
% Create a 2D historgram of saturation vs value.
[h2,~,~] = histcounts2(Vi(:,2), Vi(:,3), 0:(1/NSAT):1, 0:(1/NVAL):1);
h2 = h2/sum(h2(:)); % Normalize counts
%figure(2), imshow(h2,[], 'InitialMagnification', 800), title(sprintf('Ball %d', ballId));;
%figure(2), histogram2(Vi(:,2), Vi(:,3), 0:(1/NSAT):1, 0:(1/NVAL):1), xlabel('S'), ylabel('V');
% Assemble counts into a single long vector.
X = [h1(:); h2(:)];
% Store into the arrays.
featureVectors = X';
    
[labels, scores] = predict(cl, featureVectors);
fprintf('Score\tTrue class\tEstimated class\tImage\n');
for j=1:length(labels)
fprintf('%f\t%d\t%d\t%s\n', scores(j), featureClasses(j), ...
labels(j), imageFileNames{j});
end
if(labels<16)
    goodLabel(count)=labels;
    goodCenters(count,:)=MyCenters(i,:);
    goodRadius(count,:)=MyRadius(i);
    goodScore(count)=scores(1);
    count=count+1;
%      RGB = insertText(RGB,MyCenters(i,:),labels,'FontSize' ,20, 'TextColor', 'r','BoxColor','w');

end
%RGB = insertText(RGB,MyCenters(i,:),labels,'FontSize' ,20, 'TextColor', 'r','BoxColor','w');
end
% h = viscircles(goodCenters,goodRadius);
for i=1:length(goodLabel)
    for j=i:length(goodLabel)
        do = true;
        if(norm(goodCenters(i,:)'-goodCenters(j,:)')< 25 && i~=j)
            if((goodLabel(i)==9&&goodLabel(j)==0))
                goodScore(j)=[0];
                goodRadius(j)=[0];
                goodCenters(j,:)=[0,0];
                goodLabel(j)=[16];
            elseif(goodLabel(i)==0&&goodLabel(j)==9)
                goodScore(i)=[0];
                goodRadius(i)=[0];
                goodCenters(i,:)=[0,0];
                goodLabel(i)=[16];
            else
             
                if(goodScore(i)>goodScore(j))
                    goodScore(j)=[0];
                    goodRadius(j)=[0];
                    goodCenters(j,:)=[0,0];
                    goodLabel(j)=[16];
                else
                    goodScore(i)=[0];
                    goodRadius(i)=[0];
                    goodCenters(i,:)=[0,0];
                    goodLabel(i)=[16];
                    do=false;
                end
            end
           

        end
        if(do)
           %RGB = insertText(RGB,MyCenters(i,:),goodLabel(i),'FontSize' ,20, 'TextColor', 'r','BoxColor','w');
        end
    end
end
nine = -1;
eight = -1;
for i = 1:length(goodRadius)
   if(goodLabel(i)==9)
       if(nine==-1)
           nine=i;
       else
            if(goodScore(i)<goodScore(nine))
                goodLabel(i)=1;
            else
                goodLabel(nine)=1;
            end
       end
   end
   if(goodLabel(i)==8)
       if(eight ==-1)
           eight = i;
       else
           if(goodScore(i)<goodScore(eight))
               goodScore(i)=[0];
                goodRadius(i)=[0];
                goodCenters(i,:)=[0,0];
                goodLabel(i)=[16];
           else
               goodScore(eight)=[0];
                goodRadius(eight)=[0];
                goodCenters(eight,:)=[0,0];
                goodLabel(eight)=[16];
                eight = i;
           end
       end
   end
end

for i = 1:length(goodRadius)
   if(goodRadius(i)>0)
       RGB = insertText(RGB,goodCenters(i,:)+5,goodLabel(i),'FontSize' ,20, 'TextColor', 'r','BoxColor','w');
   end
end
    
figure(7);
imshow(RGB);
hold on;
viscircles(goodCenters, goodRadius,'Color','r');
plot(x_intersect,y_intersect,'x','LineWidth',4,'Color','red');


%%Find Shots

s = input('Are you solid or stripes (1=solid 2=stripes): ', 's');
n = sscanf(s, '%d');

center = [0,0];
for i=1:length(goodRadius)
   if(goodLabel(i)==0) 
    center = goodCenters(i,:);
   end
end
shot = -1;
bestDist=100000000;
ittNumber=0;
if(n==2)
    for i=1:length(goodRadius)
        
        if(norm(goodCenters(i,:)'-center')<bestDist && goodLabel(i)>8 &&goodLabel(i)<16)
            bestDist = norm(goodCenters(i,:)'-center');
            ittNumber=i;
        end
    end
elseif(n==1)
    for i=1:length(goodRadius)
        
        if(norm(goodCenters(i,:)'-center')<bestDist && goodLabel(i)>0 &&goodLabel(i)<8)
            bestDist = norm(goodCenters(i,:)'-center');
            ittNumber=i;
        end
    end
end
ittNumber
goodLabel(ittNumber)

vecToBall= goodCenters(ittNumber,:)-center;

%plot([goodCenters(ittNumber,1), center(1)], [goodCenters(ittNumber,2), center(2)], 'Color','green','LineWidth',4)
vecToPocket=[0,0];
ittBestPocket=0;
maxDot = 0;
for i=1:length(x_intersect)
   vecToPocket(i,:)=  ([x_intersect(i),y_intersect(i)]-goodCenters(ittNumber,:))/norm([x_intersect(i),y_intersect(i)]-goodCenters(ittNumber,:));
   dot1 = dot(vecToPocket(i,:),vecToBall);
   if(dot1>maxDot)
       maxDot=dot1;
       ittBestPocket = i;
   end

end
plot([x_intersect(ittBestPocket), goodCenters(ittNumber,1)], [y_intersect(ittBestPocket), goodCenters(ittNumber,2)], 'Color','green','LineWidth',4)


%where to shoot the ball
disBalltoPocket = norm([x_intersect(ittBestPocket),y_intersect(ittBestPocket)]-goodCenters(ittNumber,:));
disPockettoHit = disBalltoPocket+(goodRadius(ittNumber)*2);

t=disPockettoHit/disBalltoPocket;

xt=((1-t)*x_intersect(ittBestPocket))+(t*goodCenters(ittNumber,1));
yt=((1-t)*y_intersect(ittBestPocket))+(t*goodCenters(ittNumber,2)); 

plot([xt, center(1)], [yt, center(2)], 'Color','green','LineWidth',4)
