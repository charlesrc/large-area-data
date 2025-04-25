
clc;
clear;

% Feel free to load any other line profile, but this is the best one.
data = load('YAGCe_Louis_60kV_6.5W_linewidth=20_xcross-pattern_1-3.csv');
pixelNumber = data(:,1);
intensity = data(:,2);

font = 'Arial';
f = figure('DefaultTextFontName', font, 'DefaultAxesFontName', font);
plot(pixelNumber, intensity, '.r', 'LineWidth', 1.5);
xlim([0, 200]);
xlabel('Pixel number');
ylabel('Intensity (a.u.)');
set(gca, 'FontSize', 12);
set(gcf, 'Units', 'inches', 'Position', [0, 0, 5, 4]);
set(gca, 'Position', [0.25, 0.25, 0.65, 0.65]);

saveas(f,'Figure_2_Sample_1.svg');

%% Enhancement.
%% ~~~ Load data. ~~~
% Load background.
filenames = {'YAGCe_Louis_60kV_6.5W_linewidth=20_background_1.csv', ...
             'YAGCe_Louis_60kV_6.5W_linewidth=20_background_2.csv', ...
             'YAGCe_Louis_60kV_6.5W_linewidth=20_background_3.csv'};
background = zeros(3,2); % First column is average, second column is standard deviation.
all_background = 0;
for i = 1:3
    currentData = load(filenames{i});
    background(i,1) = mean(currentData(:,2));
    background(i,2) = std(currentData(:,2));
    all_background = all_background + currentData(1:159,2)
end
averageBackground = mean(background(:,1));
errorBackground = sqrt(sum(background(:,2).^2));
all_background = all_background / 3.;

font = 'Arial';
pixelNumber_background = currentData(:,1);
f = figure('DefaultTextFontName', font, 'DefaultAxesFontName', font);
plot(pixelNumber_background, all_background, '.r', 'LineWidth', 1.5);
xlim([0, 200]);
xlabel('Pixel number');
ylabel('Intensity (a.u.)');
set(gca, 'FontSize', 12);
set(gcf, 'Units', 'inches', 'Position', [0, 0, 5, 4]);
set(gca, 'Position', [0.25, 0.25, 0.65, 0.65]);

saveas(f,'Figure_2_Sample_1_Background.svg');

% Load unpatterned.
dataset = '1'; % Two datasets of three line profiles, pick '1' or '2'.
% ! The dataset refers to the 'Image_#' in this directory
%   from which the line profile was extracted. !
filenames = {['YAGCe_Louis_60kV_6.5W_linewidth=20_uncoated_unpatterned_1-' dataset '.csv'], ...
             ['YAGCe_Louis_60kV_6.5W_linewidth=20_uncoated_unpatterned_2-' dataset '.csv'], ...
             ['YAGCe_Louis_60kV_6.5W_linewidth=20_uncoated_unpatterned_3-' dataset '.csv']};
data_up = zeros(3,2);
all_unpatterned = 0; % First column is average, second column is standard deviation.
for i = 1:3
    currentData = load(filenames{i});
    data_up(i,1) = mean(currentData(:,2));
    data_up(i,2) = std(currentData(:,2));
    all_unpatterned = all_unpatterned + currentData(1:142,2)
end
pixelNumber_unpatterned = currentData(1:142,1);
averageUnpatterned = mean(data_up(:,1));
errorUnpatterned = sqrt(sum(data_up(:,2).^2));
all_unpatterned = all_unpatterned / 3.;

% Load patterned.
dataset = '3'; % Two datasets of three line profiles, pick '3' or '4'.
filenames = {['YAGCe_Louis_60kV_6.5W_linewidth=20_coated_patterned_1-' dataset '.csv'], ...
             ['YAGCe_Louis_60kV_6.5W_linewidth=20_coated_patterned_2-' dataset '.csv'], ...
             ['YAGCe_Louis_60kV_6.5W_linewidth=20_coated_patterned_3-' dataset '.csv']};
data_p = zeros(3,2);
for i = 1:3
    currentData = load(filenames{i});
    data_p(i,1) = mean(currentData(:,2));
    data_p(i,2) = std(currentData(:,2));
end
averagePatterned = mean(data_p(:,1));
errorPatterned = sqrt(sum(data_p(:,2).^2));


font = 'Arial';
f = figure('DefaultTextFontName', font, 'DefaultAxesFontName', font); hold on;
plot(pixelNumber+200, intensity/averageUnpatterned, '.r', 'LineWidth', 1.5);
% plot(pixelNumber_background, all_background, '.r', 'LineWidth', 1.5);
plot(pixelNumber_unpatterned, all_unpatterned/averageUnpatterned, '.r', 'LineWidth', 1.5);
xlim([0, 475]);
ylim([0, max(ylim)]);
xlabel('Pixel number', 'FontName', 'Arial', 'FontSize', 12); % 
ylabel('Normalized signal', 'FontName', 'Arial', 'FontSize', 12); % 
set(gca, 'FontSize', 12);
set(gcf, 'Units', 'inches', 'Position', [0, 0, 2, 2]);
set(gca, 'Position', [0.3, 0.3, 0.65, 0.65]);  % Adjusted for better spacing
set(gca, 'LineWidth', 1);  % Increase the thickness (default is usually 0.5)
set(gca, 'Box', 'on');
set(gca, 'TickLength', [0.02, 0.025]);  % [Inside length, outside length]
ylim([0, 4])


saveas(f,'Figure_2_Sample_1_All.svg');


%% ~~~ Calculate enhancement. ~~~
numerator = (averagePatterned - averageBackground);
errorNumerator = sqrt(errorPatterned^2 + errorBackground^2);
denominator = (averageUnpatterned - averageBackground);
errorDenominator = sqrt(errorUnpatterned^2 + errorBackground^2);

enhancement = numerator/denominator;
errorEnhancement = enhancement*sqrt((errorNumerator/numerator)^2 + (errorDenominator/denominator)^2);

disp(['Enhancement = ' num2str(enhancement) ' +- ' num2str(errorEnhancement)]);
