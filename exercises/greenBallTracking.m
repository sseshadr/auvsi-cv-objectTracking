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
MotionModel = 'ConstantVelocity';
InitLoc = centLoc;
InitErr = 10 * ones(1,2);
MotionNoise = [200 200];
MeasurementNoise = 200;
kf = configureKalmanFilter(...
                        MotionModel,...
                        InitLoc,...
                        InitErr,...
                        MotionNoise,...
                        MeasurementNoise);

%% Loop algorithm
idx = 1;
while ~isDone(vidFReader)
    
    % Acquire frame
    img = step(vidFReader);
    
    % Track location
    trackedLocation = predict(kf);
    
    % Visualize tracked location
    out = insertShape(img,'circle',[trackedLocation 20],...
        'Color','green','LineWidth',5);
    
    % Find the ball to see if update is possible
    [~,detectedLocation] = segmentGreenBall(img,50);
    if (~isempty(detectedLocation))
        % If ball is found, correct kalman filter
        trackedLocation = correct(kf,detectedLocation);
        % Visualize detected location
        out = insertShape(out,'circle',[trackedLocation 5],...
        'Color','blue','LineWidth',5);
    end
    
    % Update video player
    step(vidPlayer,out);
    
    % Accumulate tracked location for viewing
    pos(idx,:) = trackedLocation;
    idx = idx+1;
    
    % Pause for demonstration purposes
    pause(0.1);

end

% Visualize tracked location
figure;
imshow(img)
hold on
plot(pos(:,1),pos(:,2),'rx-','LineWidth',2)
title('Tracked Location')

%% Clean up
release(vidPlayer);
release(vidFReader);