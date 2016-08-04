% Copyright 2015-2016 The MathWorks, Inc.
%%
close all
clear all
clc
%% Setup the video reader and player
videoFReader = vision.VideoFileReader('multiObject.avi','VideoOutputDataType','double');
videoPlayer = vision.DeployableVideoPlayer;

%% Setup structure for storing tracks
tracks = struct(...
    'id', {}, ...
    'centroid', {}, ...
    'kalmanFilter', {}, ...
    'consecutiveInvisibleCount', {});
nextId = 1;

%% Setup parameters for the Kalman Filters
param.motionModel = 'ConstantVelocity';
param.initialEstimateError = [1e6 1e6];
param.motionNoise = [20 20];
param.measurementNoise = 10;

%% Track managment parameters 
maxInvisibleCount = 10;
costOfNonAssignment = 50;

%% Let's track
while ~isDone(videoFReader)
    videoFrame = step(videoFReader);
    
    % Detect objects in image
    [~,centroids] = segmentBall(videoFrame,2000);
    % Draw markers at detected objects centroids
    if ~isempty(centroids)
        videoFrame = insertMarker(videoFrame, centroids, 'x', 'color', 'black', 'size', 5); 
    end
    
    nDetections = size(centroids,1);
    nTracks = length(tracks);
    
    % Predict new position for all existing tracks
    for idx = 1:nTracks
        tracks(idx).centroid = predict(tracks(idx).kalmanFilter);
    end
    
    % ****** Track management ******
    
    % Calculate cost for assigning detections to tracks
    cost = zeros(nTracks, nDetections);
    for idx = 1:nTracks
        cost(idx, :) = distance(tracks(idx).kalmanFilter, centroids);
    end
    
    % Solve the assignment problem
    % costOfNonAssignment:
    % - cost for a track or detection remains unassigned
    % - must be tuned experimentally and depends on range of values
    %   returned by distance function
    % - decrease value -> increase likelihood of creating new track
    % It's also possible to specify different cost for tracks and detection
    % remaining unassigned (see doc)
    [assignments, unassignedTracks, unassignedDetections] = ...
        assignDetectionsToTracks(cost, costOfNonAssignment);
    
    %% Update assigned tracks
    for idx = 1:size(assignments, 1)
        trackIdx = assignments(idx, 1);
        detectionIdx = assignments(idx, 2);
        correct(tracks(trackIdx).kalmanFilter, centroids(detectionIdx, :));
        tracks(trackIdx).consecutiveInvisibleCount = 0;
    end
    
    %% Delete tracks that were unassigned for too long time
    toBeDeleted = false(nTracks,1);
    % Increase "invisible"-counter of unassigned tracks
    for idx = 1:length(unassignedTracks)
        ind = unassignedTracks(idx);
        tracks(ind).consecutiveInvisibleCount = tracks(ind).consecutiveInvisibleCount + 1;
        if tracks(ind).consecutiveInvisibleCount > maxInvisibleCount
            toBeDeleted(ind) = true;
        end
    end
    tracks(toBeDeleted) = [];  % Delete lost tracks
    
    %% Create new tracks for unassigend detections
    for idx = 1:size(unassignedDetections,1)
        
        % Create new Kalman Filter
        kalmanFilter = configureKalmanFilter(...
            param.motionModel, ...
            centroids(unassignedDetections(idx),:), ...  % Initial position
            param.initialEstimateError, ...
            param.motionNoise, ...
            param.measurementNoise);
        
        % Create a new track
        tracks(end+1).id = nextId; %#ok<SAGROW>
        tracks(end).kalmanFilter = kalmanFilter;
        tracks(end).centroid = centroids(unassignedDetections(idx),:);
        tracks(end).consecutiveInvisibleCount = 0;
        nextId = nextId + 1;
    end
    
    % Display the centroids of all tracks 
      for idx = 1:length(tracks)
        videoFrame = insertText(videoFrame,tracks(idx).centroid,num2str(tracks(idx).id));
      end
    step(videoPlayer, videoFrame);
    pause(0.1)
end

%% Clean up
release(videoPlayer);
release(videoFReader);