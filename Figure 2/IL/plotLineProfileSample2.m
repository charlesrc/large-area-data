
clc;
clear;
close all;

data = readtable('line_profile_large_area_scintillator_150kVp_23.0W.csv');
pixelNumber = table2array(data(1,3:end));
intensity = table2array(data(3,3:end));

font = 'Arial';
f = figure('DefaultTextFontName', font, 'DefaultAxesFontName', font);
plot(pixelNumber, intensity, '.r', 'LineWidth', 1.5);
xlabel('Pixel number');
ylabel('Intensity (a.u.)');
set(gca, 'FontSize', 12);
set(gcf, 'Units', 'inches', 'Position', [0, 0, 2, 2]);
set(gca, 'Position', [0.3, 0.3, 0.65, 0.65]);  % Adjusted for better spacing
set(gca, 'LineWidth', 1);  % Increase the thickness (default is usually 0.5)
set(gca, 'Box', 'on');
set(gca, 'TickLength', [0.02, 0.025]);  % [Inside length, outside length]
ylim([0, 3.3e4])


saveas(f,'Figure_2_Sample_2.svg');

%% Enhancement.
%% ~~~ Pick edges. ~~~
patternedEdges = zeros(1,2);
unpatternedEdges = zeros(1,2);
backgroundEdges = zeros(1,2);

% Patterned area.
dcm_obj = datacursormode();
set(dcm_obj, 'DisplayStyle', 'datatip', ...
    'SnapToDataVertex', 'off', 'Enable', 'on');
disp('Pick the LEFT edge of the pattern. Press any key to continue.');
pause;
c_info = getCursorInfo(dcm_obj);
Position = c_info.Position;
patternedEdges(1) = Position(1);

dcm_obj = datacursormode();
set(dcm_obj, 'DisplayStyle', 'datatip', ...
    'SnapToDataVertex', 'off', 'Enable', 'on');
disp('Pick the RIGHT edge of the pattern. Press any key to continue.')
pause;
c_info = getCursorInfo(dcm_obj);
Position = c_info.Position;
patternedEdges(2) = Position(1);

% Unpatterned area.
dcm_obj = datacursormode();
set(dcm_obj, 'DisplayStyle', 'datatip', ...
    'SnapToDataVertex', 'off', 'Enable', 'on');
disp('Pick the LEFT edge of the bare scintillator. Press any key to continue.');
pause;
c_info = getCursorInfo(dcm_obj);
Position = c_info.Position;
unpatternedEdges(1) = Position(1);

dcm_obj = datacursormode();
set(dcm_obj, 'DisplayStyle', 'datatip', ...
    'SnapToDataVertex', 'off', 'Enable', 'on');
disp('Pick the RIGHT edge of the bare scintillator. Press any key to continue.')
pause;
c_info = getCursorInfo(dcm_obj);
Position = c_info.Position;
unpatternedEdges(2) = Position(1);

% Background.
dcm_obj = datacursormode();
set(dcm_obj, 'DisplayStyle', 'datatip', ...
    'SnapToDataVertex', 'off', 'Enable', 'on');
disp('Pick the LEFT edge of the background. Press any key to continue.');
pause;
c_info = getCursorInfo(dcm_obj);
Position = c_info.Position;
backgroundEdges(1) = Position(1);

dcm_obj = datacursormode();
set(dcm_obj, 'DisplayStyle', 'datatip', ...
    'SnapToDataVertex', 'off', 'Enable', 'on');
disp('Pick the RIGHT edge of the background. Press any key to continue.')
pause;
c_info = getCursorInfo(dcm_obj);
Position = c_info.Position;
backgroundEdges(2) = Position(1);

%% ~~~ Calculate enhancement. ~~~
averagePatterned = mean(intensity(patternedEdges(1):patternedEdges(2)));
stdevPatterned = std(intensity(patternedEdges(1):patternedEdges(2)));

averageUnpatterned = mean(intensity(unpatternedEdges(1):unpatternedEdges(2)));
stdevUnpatterned = std(intensity(unpatternedEdges(1):unpatternedEdges(2)));

averageBackground = mean(intensity(backgroundEdges(1):backgroundEdges(2)));
stdevBackground = std(intensity(backgroundEdges(1):backgroundEdges(2)));

numerator = (averagePatterned - averageBackground);
errorNumerator = sqrt(stdevPatterned^2 + stdevBackground^2);
denominator = (averageUnpatterned - averageBackground);
errorDenominator = sqrt(stdevUnpatterned^2 + stdevBackground^2);

enhancement = numerator/denominator;
errorEnhancement = enhancement*sqrt((errorNumerator/numerator)^2 + (errorDenominator/denominator)^2);

disp(['Enhancement = ' num2str(enhancement) ' +- ' num2str(errorEnhancement)]);

%%
font = 'Arial';
f = figure('DefaultTextFontName', font, 'DefaultAxesFontName', font);
plot(pixelNumber, intensity/averageUnpatterned, '.r', 'LineWidth', 1.5);
xlabel('Pixel number', 'FontName', 'Arial', 'FontSize', 12); % 
ylabel('Normalized signal', 'FontName', 'Arial', 'FontSize', 12); % 
set(gcf, 'Units', 'inches', 'Position', [0, 0, 2, 2]);
set(gca, 'Position', [0.3, 0.3, 0.65, 0.65]);  % Adjusted for better spacing
set(gca, 'LineWidth', 1);  % Increase the thickness (default is usually 0.5)
set(gca, 'Box', 'on');
set(gca, 'TickLength', [0.02, 0.025]);  % [Inside length, outside length]
% ylim([0, 3.3e4])
ylim([0, 7])

set(gca, 'FontSize', 12);
set(gca, 'LineWidth', 1);  % Increase the thickness (default is usually 0.5)
set(gca, 'Box', 'on');
set(gca, 'TickLength', [0.02, 0.025]);  % [Inside length, outside length]

saveas(f,'Figure_2_Sample_2.svg');
