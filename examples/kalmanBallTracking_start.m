% Copyright 2015-2016 The MathWorks, Inc.
%%
close all
clear
clc
%% Set up video reader and player
videoFReader = vision.VideoFileReader('ball.mp4',...
    'VideoOutputDataType','double');
vidPlayer = vision.DeployableVideoPlayer;

%% Initialize tracking


%% Loop algorithm


%% Clean up
release(vidPlayer);
release(videoFReader);