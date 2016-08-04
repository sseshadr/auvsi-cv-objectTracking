% Copyright 2015-2016 The MathWorks, Inc.
%%
close all
clear
clc
%% Set up video reader and player
videoFReader = vision.VideoFileReader('yeast.avi',...
    'VideoOutputDataType','double');
% Source: http://www.cellimagelibrary.org/images/7326

vidPlayer = vision.DeployableVideoPlayer;

%% Create tracker object
tracker = vision.HistogramBasedTracker;

%% Initialize tracker
% Read the first video frame
objectFrame = step(videoFReader); 
 
% Convert to HSV color space
objectFrameHsv = rgb2hsv(objectFrame);

% Initialize object position using predefined values.
objectRegion = [110,12,38,36];

% Initialize object by interactivley drawing a rectangle.
% figure
% imshow(objectFrame)
% h = imrect;
% wait(h)
% objectRegion = getLoc(h);

% We use the saturation channel for segmentation
initializeObject(tracker,objectFrameHsv(:,:,2),objectRegion,32);

%% Track object
while ~isDone(videoFReader)
    % Read image and convert to HSV space
    frame = step(videoFReader);
    Ihsv = rgb2hsv(frame);
    
    % Track object and display result
    bbox = step(tracker,Ihsv(:,:,2));
    
    % Visualize result
    outFrame = insertShape(frame,'Rectangle',bbox);
    
    % Update video player
    step(vidPlayer,outFrame);
    
    % Pause for demonstration purposes
    pause(0.2)
end

%% Clean up
release(vidPlayer);
release(videoFReader);