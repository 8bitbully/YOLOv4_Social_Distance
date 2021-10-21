clearvars, clc, home

%% load pretrained network parameters

addpath src\

pretYolov4 = PeopleDetector()...
               .loadNetwork("YOLOv4-tiny-coco")...
               .loadAnchors("YOLOv4-tiny-coco")...
               .loadClassNames("coco");

%% Load stereo parameters.

load('webcamsSceneReconstruction.mat');

%% read frames
% 
frameLeft = imread('sceneReconstructionLeft.jpg');
frameRight = imread('sceneReconstructionRight.jpg');

frameLeft = undistortImage(frameLeft, stereoParams.CameraParameters1);
frameRight = undistortImage(frameRight, stereoParams.CameraParameters2);

%%

detectLeft = detectPeople(pretYolov4, frameLeft, executionEnvironment= "gpu");
detectRight = detectPeople(pretYolov4, frameRight, executionEnvironment= "gpu");

[detectLeft, detectRight] = matchBoundingBox(detectLeft, detectRight);

point3d = triangulatePoints(detectLeft, detectRight, "stereoParams", stereoParams);

zoneProp = detectedObjectProperty(point3d, detectLeft, distance= 2.5);

frameLeft = insertObjectShapes(frameLeft, zoneProp, detectLeft, ...
                                shape= "FilledRectangle", ...
                                drawSafe=true, ...
                                showDist=true);

imshow(frameLeft)