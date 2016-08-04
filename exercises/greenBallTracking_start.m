% Copyright 2015-2016 The MathWorks, Inc.
%%
close all
clear
clc
%% Set up video reader and player
vidFReader = vision.VideoFileReader('greenBall.avi',...
    'VideoOutputDataType','double');
vidPlayer = vision.DeployableVideoPlayer;

%% Initialize tracking
img = step(vidFReader);
figure
imshow(img)
h = imrect;
wait(h);
[~,centLoc] = getLoc(h);

% Configure Kalman Filter


%% Loop algorithm
while ~isDone(vidFReader)
    
    % Acquire frame
        
    % Track location
       
    % Visualize tracked location
        
    % Find the ball to see if update is possible  
    
    if (1)
        % If ball is found, correct kalman filter
        
        % Visualize detected location
        
    end
    
    % Update video player
        
    % Pause for demonstration purposes
    pause(0.1);

end

%% Clean up
release(vidPlayer);
release(vidFReader);