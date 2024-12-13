% Clear the workspace to remove any existing variables or data
clear;

% Load the data from the .mat file named 'ExampleData.mat'
% The .mat file is expected to contain structures such as Position and Acceleration
load('ExampleData.mat');

% Extract latitude, longitude, and timestamps from the Position structure
lat = Position.latitude; % Latitude values of the position data
lon = Position.longitude; % Longitude values of the position data
positionDatetime = Position.Timestamp; % Timestamps corresponding to the position data

% Extract acceleration components (X, Y, Z) and timestamps from the Acceleration structure
Xacc = Acceleration.X; % Acceleration in the X-axis
Yacc = Acceleration.Y; % Acceleration in the Y-axis
Zacc = Acceleration.Z; % Acceleration in the Z-axis
accelDatetime = Acceleration.Timestamp; % Timestamps corresponding to the acceleration data

% Use the timeElapsed function to compute the elapsed time (in seconds)
% relative to the first timestamp for both position and acceleration data
% The timeElapsed function ensures the timestamps are linear and in seconds.
positionTime = timeElapsed(positionDatetime); % Linear elapsed time for position data
accelTime = timeElapsed(accelDatetime); % Linear elapsed time for acceleration data

% Add Earth’s circumference and initialize total distance
earthCirc = 24901; % Earth's circumference in miles (approximate value)
totaldis = 0; % Initialize total distance traveled to zero

% Calculate total distance by iterating through each pair of latitude and longitude points
for i = 1:(length(lat)-1) % Loop through all latitude points except the last
    % Extract latitude and longitude for the current and next points
    lat1 = lat(i); % The first latitude
    lat2 = lat(i+1); % The second latitude
    lon1 = lon(i); % The first longitude
    lon2 = lon(i+1); % The second longitude
   
    % Calculate the angular distance (in degrees) between the two points
    degDis = distance(lat1, lon1, lat2, lon2); % Angular distance in degrees
   
    % Convert the angular distance to miles using Earth's circumference
    dis = (degDis / 360) * earthCirc; % Convert degrees to miles based on Earth's circumference
   
    % Add the computed segment distance to the total distance
    totaldis = totaldis + dis; % Accumulate the total distance
end

% Convert total distance from miles to feet and calculate the number of steps
stride = 2.5; % Average stride length in feet
totaldis_ft = totaldis * 5280; % Convert distance from miles to feet
steps = totaldis_ft / stride; % Calculate the number of steps

% Display the results
disp(['The total distance traveled is: ', num2str(totaldis), ' miles']);
disp(['You took ', num2str(steps), ' steps']);

% Plot acceleration data for the X, Y, and Z axes over time
figure; % Create a new figure for the plot
plot(accelTime, Xacc); % Plot acceleration in the X-axis
hold on; % Retain the current plot to overlay more data
plot(accelTime, Yacc); % Plot acceleration in the Y-axis
plot(accelTime, Zacc); % Plot acceleration in the Z-axis

% Limit the x-axis to the range [0, 50] seconds
xlim([0 50]); % Set the x-axis range to focus on the first 50 seconds

% Add a legend for the X, Y, and Z acceleration data
legend('X Acceleration', 'Y Acceleration', 'Z Acceleration');

% Add labels and a title for better visualization
xlabel('Time (s)'); % Label for the X-axis (time in seconds)
ylabel('Acceleration (m/s^2)'); % Label for the Y-axis (acceleration in m/s^2)
title('Acceleration Data Vs. Time'); % Title for the plot

% --- Add a visualization for the formula ---
figure; % Create a new figure for the formula

% Add title for the figure
title('Steps Calculation Formula', 'FontSize', 14);

% Use text to display the formula
text(0.5, 0.7, 'Steps = Total Distance (ft) / Stride Length (ft/step)', ...
    'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');

% Add explanation of the formula
text(0.5, 0.5, ...
    ['This formula calculates the total number of steps taken. ', ...
    'The total distance traveled in feet is divided by the stride length ', ...
    'to estimate the number of steps.'], ...
    'HorizontalAlignment', 'center', 'FontSize', 10);

% Add additional information about units
text(0.5, 0.3, ...
    ['Ensure the stride length is measured in feet per step, ', ...
    'and the total distance is in feet.'], ...
    'HorizontalAlignment', 'center', 'FontSize', 10, 'FontAngle', 'italic');

% Adjust axis to remove ticks and labels
axis off;
xlim([0 1]);
ylim([0 1]);