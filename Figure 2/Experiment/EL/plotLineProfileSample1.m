clc;
clear;

%% ----------------------------------
%  STEP 1: Plot a line profile from a structured (patterned) sample
% ----------------------------------

% Load experimental line profile from patterned scintillator sample
% Feel free to replace this with other line profiles if needed
data = load('YAGCe_Louis_60kV_6.5W_linewidth=20_xcross-pattern_1-3.csv');
pixelNumber = data(:,1);    % First column = pixel number (position)
intensity = data(:,2);      % Second column = measured intensity

% Plot the line profile
font = 'Arial';
f = figure('DefaultTextFontName', font, 'DefaultAxesFontName', font);
plot(pixelNumber, intensity, '.r', 'LineWidth', 1.5);
xlim([0, 200]);
xlabel('Pixel number');
ylabel('Intensity (a.u.)');
set(gca, 'FontSize', 12);
set(gcf, 'Units', 'inches', 'Position', [0, 0, 5, 4]);
set(gca, 'Position', [0.25, 0.25, 0.65, 0.65]);

% Save the figure
saveas(f,'Figure_2_Sample_1.svg');


%% ----------------------------------
%  STEP 2: Load background measurements
% ----------------------------------

% List of background measurement files (three repeated measurements)
filenames = {'YAGCe_Louis_60kV_6.5W_linewidth=20_background_1.csv', ...
             'YAGCe_Louis_60kV_6.5W_linewidth=20_background_2.csv', ...
             'YAGCe_Louis_60kV_6.5W_linewidth=20_background_3.csv'};

background = zeros(3,2);  % Preallocate: [mean intensity, std intensity] for each background
all_background = 0;       % To accumulate background profiles

for i = 1:3
    currentData = load(filenames{i});
    background(i,1) = mean(currentData(:,2));   % Mean background intensity
    background(i,2) = std(currentData(:,2));    % Std deviation background
    all_background = all_background + currentData(1:159,2); % Sum pixel intensities (first 159 pixels)
end

% Average background profile across 3 measurements
averageBackground = mean(background(:,1)); % Mean intensity across files
errorBackground = sqrt(sum(background(:,2).^2)); % Combined error assuming independent measurements
all_background = all_background / 3.0;  % Final averaged pixel-wise background

% Plot the averaged background profile
pixelNumber_background = currentData(:,1);  % Assume same pixel numbering
f = figure('DefaultTextFontName', font, 'DefaultAxesFontName', font);
plot(pixelNumber_background, all_background, '.r', 'LineWidth', 1.5);
xlim([0, 200]);
xlabel('Pixel number');
ylabel('Intensity (a.u.)');
set(gca, 'FontSize', 12);
set(gcf, 'Units', 'inches', 'Position', [0, 0, 5, 4]);
set(gca, 'Position', [0.25, 0.25, 0.65, 0.65]);

% Save background plot
saveas(f,'Figure_2_Sample_1_Background.svg');


%% ----------------------------------
%  STEP 3: Load unpatterned sample measurements
% ----------------------------------

% Choose dataset: '1' or '2'
dataset = '1';  
% Unpatterned = flat sample without any nanostructure
filenames = {['YAGCe_Louis_60kV_6.5W_linewidth=20_uncoated_unpatterned_1-' dataset '.csv'], ...
             ['YAGCe_Louis_60kV_6.5W_linewidth=20_uncoated_unpatterned_2-' dataset '.csv'], ...
             ['YAGCe_Louis_60kV_6.5W_linewidth=20_uncoated_unpatterned_3-' dataset '.csv']};

data_up = zeros(3,2);  % Preallocate
all_unpatterned = 0;

for i = 1:3
    currentData = load(filenames{i});
    data_up(i,1) = mean(currentData(:,2));   % Mean
    data_up(i,2) = std(currentData(:,2));    % Std
    all_unpatterned = all_unpatterned + currentData(1:142,2); % Sum intensity values
end

% Average profile across unpatterned measurements
pixelNumber_unpatterned = currentData(1:142,1);
averageUnpatterned = mean(data_up(:,1));
errorUnpatterned = sqrt(sum(data_up(:,2).^2));
all_unpatterned = all_unpatterned / 3.0;  % Pixel-wise averaging


%% ----------------------------------
%  STEP 4: Load patterned sample measurements
% ----------------------------------

% Choose dataset: '3' or '4'
dataset = '3';
% Patterned = sample with nanostructured extraction layer
filenames = {['YAGCe_Louis_60kV_6.5W_linewidth=20_coated_patterned_1-' dataset '.csv'], ...
             ['YAGCe_Louis_60kV_6.5W_linewidth=20_coated_patterned_2-' dataset '.csv'], ...
             ['YAGCe_Louis_60kV_6.5W_linewidth=20_coated_patterned_3-' dataset '.csv']};

data_p = zeros(3,2);  % Preallocate

for i = 1:3
    currentData = load(filenames{i});
    data_p(i,1) = mean(currentData(:,2));
    data_p(i,2) = std(currentData(:,2));
end

% Average extraction from patterned samples
averagePatterned = mean(data_p(:,1));
errorPatterned = sqrt(sum(data_p(:,2).^2));


%% ----------------------------------
%  STEP 5: Plot comparison between patterned and unpatterned
% ----------------------------------

f = figure('DefaultTextFontName', font, 'DefaultAxesFontName', font); hold on;

% Plot normalized structured line profile
plot(pixelNumber+200, intensity/averageUnpatterned, '.r', 'LineWidth', 1.5);

% Plot normalized unpatterned line profile
plot(pixelNumber_unpatterned, all_unpatterned/averageUnpatterned, '.r', 'LineWidth', 1.5);

xlim([0, 475]);
ylim([0, max(ylim)]);

xlabel('Pixel number', 'FontName', 'Arial', 'FontSize', 12);
ylabel('Normalized signal', 'FontName', 'Arial', 'FontSize', 12);

set(gca, 'FontSize', 12);
set(gcf, 'Units', 'inches', 'Position', [0, 0, 2, 2]);
set(gca, 'Position', [0.3, 0.3, 0.65, 0.65]);
set(gca, 'LineWidth', 1);
set(gca, 'Box', 'on');
set(gca, 'TickLength', [0.02, 0.025]);
ylim([0, 4]);

% Save combined figure
saveas(f,'Figure_2_Sample_1_All.svg');


%% ----------------------------------
%  STEP 6: Calculate extraction enhancement factor
% ----------------------------------

% Enhancement is defined as: (patterned-background)/(unpatterned-background)
numerator = (averagePatterned - averageBackground);
errorNumerator = sqrt(errorPatterned^2 + errorBackground^2);

denominator = (averageUnpatterned - averageBackground);
errorDenominator = sqrt(errorUnpatterned^2 + errorBackground^2);

% Final enhancement and error propagation
enhancement = numerator / denominator;
errorEnhancement = enhancement * sqrt((errorNumerator/numerator)^2 + (errorDenominator/denominator)^2);

% Display result
disp(['Enhancement = ' num2str(enhancement) ' +- ' num2str(errorEnhancement)]);
