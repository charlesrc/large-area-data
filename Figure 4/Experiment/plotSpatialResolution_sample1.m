% Before running this script, make sure to add shadedErrorBar
% to the path. You can download it from here:
% https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar

clc;
clear;
close all;

% Add the current folder and subfolders to the MATLAB path.
folder = fileparts(which('spatialResolution.m'));
addpath(genpath(folder));

% ESF and LSF.
ESF = @(x,xdata)(1/2)*x(1)*erf((xdata-x(2))/(sqrt(2)*x(3)))+x(4);
LSF = @(x,xdata)(x(1)/(sqrt(2*pi)*x(3)))*exp(-((xdata-x(2))/(sqrt(2)*x(3))).^2);

% Font for plots.
font = 'Arial';

f = figure('DefaultTextFontName', font, 'DefaultAxesFontName', font);
hold on;

% Unpatterned.
load('processed_data/EL/high-magnification/90-kVp/razor_blade_sample1_90kVp_12W_3.0s_hi-mag_unpatterned_results.mat');
ROI = rescaleESF(ROI, x);
shadedErrorBar(shiftY(y_position, x), mean(ROI, 1, 'omitnan'), std(ROI, 1, 'omitnan'), ...
    'lineProps', {'r-'})
plot(shiftY(y_position, x), rescaleESF(ESF(x, y_position), x), 'r--', 'LineWidth', 1.5);
text(-0.8, 1.7, ['Bare, \sigma = ' num2str(2*sqrt(2*log(2))*x(3), '%.3f') ' \pm ' num2str(2*sqrt(2*log(2))*se(3), '%.3f') ' mm'], 'Color', 'r', 'FontSize', 12);

% Patterned.
load('processed_data/EL/high-magnification/90-kVp/razor_blade_sample1_90kVp_12W_3.0s_hi-mag_patterned_results.mat');
ROI = rescaleESF(ROI, x);
shadedErrorBar(shiftY(y_position, x), mean(ROI, 1, 'omitnan'), std(ROI, 1, 'omitnan'), ...
    'lineProps', {'b-'});
plot(shiftY(y_position, x), rescaleESF(ESF(x, y_position), x), 'b--', 'LineWidth', 1.5);
text(-0.8, 1.4, ['PhC, \sigma = ' num2str(2*sqrt(2*log(2))*x(3), '%.3f') ' \pm ' num2str(2*sqrt(2*log(2))*se(3), '%.3f') ' mm'], 'Color', 'b', 'FontSize', 12);

xlim([-1, 1]);
ylim([-0.1, 1.9]);
yticks([0,1]);
box on;

set(gcf, 'Units', 'inches', 'Position', [0, 0, 4, 2]);
set(gca, 'Position', [0.3, 0.3, 0.65, 0.65]);  % Adjusted for better spacing.
xlabel('Position (mm)', 'FontName', 'Arial', 'FontSize', 12);
ylabel('Signal (a.u.)', 'FontName', 'Arial', 'FontSize', 12);
set(gca, 'FontName', 'Arial', 'FontSize', 12, 'LineWidth', 1);
box on;
% exportgraphics(f, 'Figure_S13_90kVp_sample1_plot.pdf');

clc;

% ### ### ###
% Function to shift the y-position of the ESF/LSF such that
% the inflection point/peak is located at y = 0.
% # Inputs: #
%   Y = y-position.
%   x = curve fit parameters.
% # Output: #
%   rescaled = shifted y-position.
% ### ### ###
function shifted = shiftY(Y, x)
    shifted = Y - x(2);
end

% ~~~ ~~~ ~~~
% Function to rescale and normalize the ESF.
% ~ Inputs: ~
%   ESF = edge spread function.
%   x = curve fit parameters.
% ~ Output: ~
%   rescaled = rescaled edge spread function.
% ~~~ ~~~ ~~~
function rescaled = rescaleESF(ESF, x)
    rescaled = (ESF - x(4))/x(1) + (1/2);
end

% ^^^ ^^^ ^^^
% Function to rescale and normalize the LSF.
% ^ Inputs: ^
%   LSF = line spread function.
%   x = curve fit parameters.
% ^ Output: ^
%   rescaled = rescaled line spread function.
% ^^^ ^^^ ^^^
function rescaled = rescaleLSF(LSF, x)
    rescaled = LSF/(x(1)/(sqrt(2*pi)*x(3)));
end
