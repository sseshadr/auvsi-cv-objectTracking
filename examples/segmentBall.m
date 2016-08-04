function [boxLoc,centroidLoc] = segmentBall(videoFrame,minArea)
% Copyright 2015-2016 The MathWorks, Inc.
%% To avoid that the system objects are recreated for every frame make them
% persistent
persistent hBlob  

% Create a BlobAnanlysis object to calculate detected objects’ area,
% centroid, major axis length and label matrix.
if isempty(hBlob)
hBlob = vision.BlobAnalysis;
hBlob.AreaOutputPort = false;

% Exclude the objects that are touching the border.
hBlob.ExcludeBorderBlobs = true;

% Exclude any objects which have less than minArea pixels.
hBlob.MinimumBlobArea = minArea;

end

%% Apply the image processing algorithms

Ihsv = rgb2hsv(videoFrame);
hue = Ihsv(:,:,1);
BW = hue >= 0.1 & hue < 0.15;

% Use morphological operations to remove disturbances
BW = imopen(BW,strel('disk', 7));

% Get shape properties of all object which have more than minArea pixels.
[centroidLoc,boxLoc] = step(hBlob, BW);

boxLoc = round(boxLoc);


