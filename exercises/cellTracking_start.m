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
% Read the first video frame
 
% Convert to HSV color space

% Initialize object by interactivley drawing a rectangle. 
% Use the provided utility function getLoc to get box location.


%% Initialize tracker
% Use the saturation channel for segmentation


%% Track object
while ~isDone(videoFReader)
    % Read image and convert to HSV space
    
    % Track object 
    
    % Visualize result
    
    % Update video player
        
    % Pause for demonstration purposes
    pause(0.2)
    
end

%% Clean up
release(vidPlayer);
release(videoFReader);