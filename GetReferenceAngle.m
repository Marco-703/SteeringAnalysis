% MATLAB Script for Vehicle Data Analysis

% Clear workspace, close all figures, and clear command window
clear;
clc;
close all;


%% Step 1: Load optical tracking data from file
% Specify the filename of the cleaned optical tracking data
opticalTrackingFile = 'Data2_reference.txt';

% Configure options for reading the CSV file (comma as delimiter)
importOptions = detectImportOptions(opticalTrackingFile, 'Delimiter', ',', 'ReadVariableNames', true);

% Read the optical tracking data into a table
opticalTrackingData = readtable(opticalTrackingFile, importOptions);

%% Step 2: Extract and process optical tracking data
% Extract relevant columns from the optical tracking table
timeOpticalTracking = opticalTrackingData.t; % Time vector
posXA = opticalTrackingData.xA;              % Position xA
posYA = opticalTrackingData.yA;              % Position yA
posXB = opticalTrackingData.xB;              % Position xB
posYB = opticalTrackingData.yB;              % Position yB

% Calculate vehicle heading using arctangent of position differences
headingAngle = atan2(posYA - posYB, posXA - posXB) * (180/pi);
headingAngle = mean(headingAngle);

disp('Average');
disp(headingAngle);


