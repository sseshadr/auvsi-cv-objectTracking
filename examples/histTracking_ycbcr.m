% Copyright 2015-2016 The MathWorks, Inc.
%%
close all
clear
clc
%% Set up video reader and player
videoFReader = vision.VideoFileReader('ball.mp4',...
    'VideoOutputDataType','double');
vidPlayer = vision.DeployableVideoPlayer;

%% Create tracker object
tracker = vision.HistogramBasedTracker;

%% Initialize tracker
img = step(videoFReader);
figure
imshow(img)
h = imrect;
wait(h)
boxLoc = getLoc(h);
imgYcbcr = rgb2ycbcr(img);
initializeObject(tracker,imgYcbcr(:,:,2),boxLoc);

%% Track object
idx = 1;
while ~isDone(videoFReader)
    img = step(videoFReader);
    imgYcbcr = rgb2ycbcr(img);
    [bbox,~,score(idx)] = step(tracker,imgYcbcr(:,:,2));
    out = insertShape(img,'Rectangle',bbox);
    step(vidPlayer,out);
    idx = idx + 1;
end

figure;
plot(score)
xlabel('Frame #')
ylabel('Confidence Score (0,1)')

%% Clean up
release(vidPlayer);
release(videoFReader);