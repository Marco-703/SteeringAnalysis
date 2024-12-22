% MATLAB Script for Vehicle Data Analysis

% Clear workspace, close all figures, and clear command window
clear;
clc;
close all;

% Define the neutral steering input threshold
neutralSteeringInput = 4433;
referenceHeading = 87.6688;

%% Step 1: Load optical tracking data from file
% Specify the filename of the cleaned optical tracking data
opticalTrackingFile = 'Data2.txt';

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
headingAngle = atan2(posYA - posYB, posXA - posXB) * (180/pi) - referenceHeading;


%% Step 3: Load steering data from logger
% Specify the path to the steering data CSV file
steeringDataFile = 'steering.csv';

% Read the steering data into a table
steeringData = readtable(steeringDataFile);

% Extract relevant columns from the steering data
timeMillisLogger = steeringData.millis;              % Time vector in milliseconds
steeringValuesLogger = steeringData.loggingValueSteering; % Steering angle values


%% Plot the raw data

loggerIndices = (1:length(steeringValuesLogger));
indicesOpticalTracking = (1:length(headingAngle));

% Plot Logger Indices vs. Steering Values
figure;
plot(loggerIndices, steeringValuesLogger);
title('Logger Indices vs. Steering Values');
xlabel('Logger Indices');
ylabel('Steering Values');

% Plot Optical Tracking Indices vs. Heading Angle
figure;
plot(indicesOpticalTracking, headingAngle);
title('Tracking Indices vs. Heading Angle');
xlabel('Optical Tracking Indices');
ylabel('Heading Angle');


%% Define Start and Stop Indices

loggerStartIndex = 29370;
loggerEndIndex = 30741; %length(steeringValuesLogger);

opticalTrackingStartIndex = 46;
opticalTrackingEndIndex = 1063; %length(headingAngle);


%% Crop the data

croppedSteeringValuesLogger = steeringValuesLogger(loggerStartIndex:loggerEndIndex);
croppedLoggerIndices = (1:length(croppedSteeringValuesLogger));

croppedHeadingAngle = headingAngle(opticalTrackingStartIndex:opticalTrackingEndIndex);
croppedIndicesOpticalTracking = (1:length(croppedHeadingAngle));


%% Norm the Data


maxLoggerIndices = max(croppedLoggerIndices);  % Find maximum value
normedLoggerIndices = croppedLoggerIndices / maxLoggerIndices;  % Normalize

maxIndicesOpticalTracking = max(croppedIndicesOpticalTracking);  % Find maximum value
normedIndicesOpticalTracking = croppedIndicesOpticalTracking / maxIndicesOpticalTracking;  % Normalize


% Plot Logger Indices vs. Normed Steering Values
figure;
plot(normedLoggerIndices, croppedSteeringValuesLogger);
title('Logger Indices vs. Normed Steering Values');
xlabel('Logger Indices');
ylabel('Normed Steering Values');

% Plot Optical Tracking Indices vs. Normed Heading Angle
figure;
plot(normedIndicesOpticalTracking, croppedHeadingAngle);
title('Tracking Indices vs. Normed Heading Angle');
xlabel('Optical Tracking Indices');
ylabel('Normed Heading Angle');



%% Regression Line

% Ensure the vectors are of the same length
n = min(length(croppedSteeringValuesLogger), length(croppedHeadingAngle));

% Interpolate the longer vector to match the length of the shorter vector
if length(croppedSteeringValuesLogger) > n
    croppedSteeringValuesLogger = interp1(1:length(croppedSteeringValuesLogger), croppedSteeringValuesLogger, linspace(1, length(croppedSteeringValuesLogger), n));
elseif length(croppedHeadingAngle) > n
    croppedHeadingAngle = interp1(1:length(croppedHeadingAngle), croppedHeadingAngle, linspace(1, length(croppedHeadingAngle), n));
end

% Center and scale the input data to avoid poorly conditioned polynomial fits
[croppedSteeringValuesLogger_scaled, mu] = normalize(croppedSteeringValuesLogger); % Centers and scales the steering values

% Set up figure
figure;
hold on;

% Loop through polynomial orders (1 to 3)
for order = 1:3
    % Perform the polynomial regression
    p = polyfit(croppedSteeringValuesLogger_scaled, croppedHeadingAngle, order);
    
    % Generate fitted values using the polynomial
    fittedValues = polyval(p, croppedSteeringValuesLogger_scaled);
    
    % Plot the polynomial fit
    plot(croppedSteeringValuesLogger, fittedValues, 'DisplayName', ['Order ' num2str(order)]);
    
    % Display the regression coefficients
    fprintf('Order %d Polynomial Coefficients:\n', order);
    disp(p);
end

% Plot the original data points
plot(croppedSteeringValuesLogger, croppedHeadingAngle, 'ko', 'DisplayName', 'Data Points');

% Add labels and legend
xlabel('Cropped Steering Values');
ylabel('Cropped Heading Angle');
title('Polynomial Regression (Orders 1 to 3)');
legend('show');
grid on;


