clc;
clear;
close all;

%% ----------------------------------
%  STEP 1: Load and plot the raw line profile
% ----------------------------------

% Load experimental data from the large area scintillator sample
data = readtable('line_profile_large_area_scintillator_150kVp_23.0W.csv');

% Extract pixel positions and corresponding intensity values
pixelNumber = table2array(data(1,3:end));
intensity = table2array(data(3,3:end));

% Plot the raw intensity profile
font = 'Arial';
f = figure('DefaultTextFontName', font, 'DefaultAxesFontName', font);
plot(pixelNumber, intensity, '.r', 'LineWidth', 1.5);
xlabel('Pixel number');
ylabel('Intensity (a.u.)');
set(gca, 'FontSize', 12);
set(gcf, 'Units', 'inches', 'Position', [0, 0, 2, 2]);
set(gca, 'Position', [0.3, 0.3, 0.65, 0.65]);  % Adjusted spacing for better margins
set(gca, 'LineWidth', 1);  % Increase axis thickness
set(gca, 'Box', 'on');
set(gca, 'TickLength', [0.02, 0.025]);  % Adjust tick length
ylim([0, 3.3e4]);  % Set y-axis limit

% Save the figure
saveas(f,'Figure_2_Sample_2.svg');


%% ----------------------------------
%  STEP 2: Select patterned, unpatterned, and background regions
% ----------------------------------

% Preallocate arrays for edge coordinates
patternedEdges = zeros(1,2);
unpatternedEdges = zeros(1,2);
backgroundEdges = zeros(1,2);

% --- Patterned region selection ---

% Select left edge of patterned area
dcm_obj = datacursormode();
set(dcm_obj, 'DisplayStyle', 'datatip', 'SnapToDataVertex', 'off', 'Enable', 'on');
disp('Pick the LEFT edge of the pattern. Press any key to continue.');
pause;
c_info = getCursorInfo(dcm_obj);
Position = c_info.Position;
patternedEdges(1) = Position(1);

% Select right edge of patterned area
dcm_obj = datacursormode();
set(dcm_obj, 'DisplayStyle', 'datatip', 'SnapToDataVertex', 'off', 'Enable', 'on');
disp('Pick the RIGHT edge of the pattern. Press any key to continue.');
pause;
c_info = getCursorInfo(dcm_obj);
Position = c_info.Position;
patternedEdges(2) = Position(1);

% --- Unpatterned region selection ---

% Select left edge of unpatterned (bare) scintillator
dcm_obj = datacursormode();
set(dcm_obj, 'DisplayStyle', 'datatip', 'SnapToDataVertex', 'off', 'Enable', 'on');
disp('Pick the LEFT edge of the bare scintillator. Press any key to continue.');
pause;
c_info = getCursorInfo(dcm_obj);
Position = c_info.Position;
unpatternedEdges(1) = Position(1);

% Select right edge of unpatterned area
dcm_obj = datacursormode();
set(dcm_obj, 'DisplayStyle', 'datatip', 'SnapToDataVertex', 'off', 'Enable', 'on');
disp('Pick the RIGHT edge of the bare scintillator. Press any key to continue.');
pause;
c_info = getCursorInfo(dcm_obj);
Position = c_info.Position;
unpatternedEdges(2) = Position(1);

% --- Background region selection ---

% Select left edge of background area
dcm_obj = datacursormode();
set(dcm_obj, 'DisplayStyle', 'datatip', 'SnapToDataVertex', 'off', 'Enable', 'on');
disp('Pick the LEFT edge of the background. Press any key to continue.');
pause;
c_info = getCursorInfo(dcm_obj);
Position = c_info.Position;
backgroundEdges(1) = Position(1);

% Select right edge of background area
dcm_obj = datacursormode();
set(dcm_obj, 'DisplayStyle', 'datatip', 'SnapToDataVertex', 'off', 'Enable', 'on');
disp('Pick the RIGHT edge of the background. Press any key to continue.');
pause;
c_info = getCursorInfo(dcm_obj);
Position = c_info.Position;
backgroundEdges(2) = Position(1);


%% ----------------------------------
%  STEP 3: Calculate average signals in selected regions
% ----------------------------------

% Calculate mean and standard deviation for each selected region
averagePatterned = mean(intensity(patternedEdges(1):patternedEdges(2)));
stdevPatterned = std(intensity(patternedEdges(1):patternedEdges(2)));

averageUnpatterned = mean(intensity(unpatternedEdges(1):unpatternedEdges(2)));
stdevUnpatterned = std(intensity(unpatternedEdges(1):unpatternedEdges(2)));

averageBackground = mean(intensity(backgroundEdges(1):backgroundEdges(2)));
stdevBackground = std(intensity(backgroundEdges(1):backgroundEdges(2)));


%% ----------------------------------
%  STEP 4: Compute enhancement factor
% ----------------------------------

% Enhancement = (patterned - background) / (unpatterned - background)
numerator = (averagePatterned - averageBackground);
errorNumerator = sqrt(stdevPatterned^2 + stdevBackground^2);

denominator = (averageUnpatterned - averageBackground);
errorDenominator = sqrt(stdevUnpatterned^2 + stdevBackground^2);

enhancement = numerator / denominator;

% Error propagation
errorEnhancement = enhancement * sqrt((errorNumerator/numerator)^2 + (errorDenominator/denominator)^2);

% Display result
disp(['Enhancement = ' num2str(enhancement) ' +- ' num2str(errorEnhancement)]);


%% ----------------------------------
%  STEP 5: Plot normalized intensity profile
% ----------------------------------

f = figure('DefaultTextFontName', font, 'DefaultAxesFontName', font);

% Normalize by average unpatterned signal
plot(pixelNumber, intensity/averageUnpatterned, '.r', 'LineWidth', 1.5);

xlabel('Pixel number', 'FontName', 'Arial', 'FontSize', 12);
ylabel('Normalized signal', 'FontName', 'Arial', 'FontSize', 12);

set(gcf, 'Units', 'inches', 'Position', [0, 0, 2, 2]);
set(gca, 'Position', [0.3, 0.3, 0.65, 0.65]);  % Spacing
set(gca, 'LineWidth', 1);
set(gca, 'Box', 'on');
set(gca, 'TickLength', [0.02, 0.025]);
ylim([0, 7]);  % Set normalized y-limit

set(gca, 'FontSize', 12);
set(gca, 'LineWidth', 1);
set(gca, 'Box', 'on');
set(gca, 'TickLength', [0.02, 0.025]);

% Save normalized plot
saveas(f,'Figure_2_Sample_2.svg');
