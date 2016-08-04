% Copyright 2015-2016 The MathWorks, Inc.
%%
close all
clear
clc
%% Set up video reader and player
vidFReader = vision.VideoFileReader('ball.mp4',...
    'VideoOutputDataType','double');
vidPlayer = vision.DeployableVideoPlayer;

%% Initialize tracking
img = step(vidFReader);
figure
imshow(img)
h = imrect;
wait(h);
[~,centLoc] = getLoc(h);

MotionModel = 'ConstantVelocity';
InitLoc = centLoc;
InitErr = 10 * ones(1,2);
MotionNoise = [20 20];
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
    img = step(vidFReader);
    trackedLocation = predict(kf);
    out = insertShape(img,'circle',[trackedLocation 20],...
        'Color','green','LineWidth',5);
    
    % Find the ball  
    [~,detectedLocation] = segmentBall(img,5000);
    if (~isempty(detectedLocation))
        % If ball is found, correct kalman filter
        trackedLocation = correct(kf,detectedLocation);
        out = insertShape(out,'circle',[trackedLocation 5],...
        'Color','blue','LineWidth',5);
    end
    
    step(vidPlayer,out);
    
    pos(idx,:) = trackedLocation;
    idx = idx+1;
    pause(0.1);

end

figure;
imshow(img)
hold on
plot(pos(:,1),pos(:,2),'rx-','LineWidth',2)

%% Clean up
release(vidPlayer);
release(vidFReader);