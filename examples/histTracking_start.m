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


%% Initialize tracker


%% Track object


%% Clean up
release(vidPlayer);
release(videoFReader);