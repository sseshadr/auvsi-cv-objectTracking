% Copyright 2015-2016 The MathWorks, Inc.
%%
close all
clear
clc
%% Setup the video reader and player
videoFReader = vision.VideoFileReader('ball.mp4','VideoOutputDataType','double');
videoPlayer = vision.DeployableVideoPlayer;

%% Apply the yellow ball segmentation algorithm to all video frames
frameNr = 1;
while ~isDone(videoFReader)
    
    videoFrame = step(videoFReader);

    % Segment the ball  
    [~,detectedLocation] = segmentBall(videoFrame,5000);
    
    % If object is detected place a marker at object position and store the
    % location.
    if ~isempty(detectedLocation)
        videoFrame = insertShape(videoFrame,'circle',[detectedLocation 5],...
        'Color','blue','LineWidth',5);
        pos(frameNr,:) = detectedLocation;
    else
        pos(frameNr,:) = [NaN NaN];
    end
    
    % Display the frame.
    step(videoPlayer,videoFrame);
     
    frameNr = frameNr + 1;
end

%% Visualize the trajectory
figure, imshow(videoFrame)
hold on
plot(pos(:,1),pos(:,2),'rx-','LineWidth',2)

%% Release reader and player object
release(videoPlayer);
release(videoFReader);