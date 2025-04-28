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

%% Style 1: Two plots.
f = figure('DefaultTextFontName', font, 'DefaultAxesFontName', font);
t = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% Unpatterned.
disp('Load UNPATTERNED data (filename ends in "_results.dat").');
load(uigetfile('*.mat'));
ROI = rescaleESF(ROI, x);
y = linspace(min(y_position), max(y_position), 100);
[ESFpred, delta] = nlpredci(ESF, y, x, r, 'Covar', cov,...
    'MSE', MSE, 'SimOpt', 'on');

nexttile;
hold on;
shadedErrorBar(shiftY(y_position, x), mean(ROI, 1, 'omitnan'), std(ROI, 1, 'omitnan'))
plot(shiftY(y, x), rescaleESF(ESFpred, x), 'k-', 'LineWidth', 1.5);
plot(shiftY(y, x), rescaleESF(ESFpred+delta, x), 'k--', 'LineWidth', 1.5);
plot(shiftY(y, x), rescaleESF(ESFpred-delta, x), 'k--', 'LineWidth', 1.5);
% plot(shiftY(y_position, x), rescaleLSF(LSF(x, y_position), x), 'k', 'LineWidth', 1.5);
xlim([-1.75, 1.75]);
ylim([-0.2, 1.2]);
yticks([]);
title(['\sigma = ' num2str(2*sqrt(2*log(2))*x(3)) ...
    '\pm ' num2str(2*sqrt(2*log(2))*se(3)) ' mm'], ...
    'FontWeight', 'normal');set(gca, 'FontSize', 12);
box on;

legend({'Measurement', 'Fit'}, 'FontSize', 9, ...
    'Location', 'southeast');

% Patterned.
disp('Load PATTERNED data (filename ends in "_results.dat").');
load(uigetfile('*.mat'));
ROI = rescaleESF(ROI, x);
y = linspace(min(y_position), max(y_position), 100);
[ESFpred, delta] = nlpredci(ESF, y, x, r, 'Covar', cov,...
    'MSE', MSE, 'SimOpt', 'on');

nexttile;
hold on;
shadedErrorBar(shiftY(y_position, x), mean(ROI, 1, 'omitnan'), std(ROI, 1, 'omitnan'))
plot(shiftY(y, x), rescaleESF(ESFpred, x), 'k-', 'LineWidth', 1.5);
plot(shiftY(y, x), rescaleESF(ESFpred+delta, x), 'k--', 'LineWidth', 1.5);
plot(shiftY(y, x), rescaleESF(ESFpred-delta, x), 'k--', 'LineWidth', 1.5);
% plot(shiftY(y_position, x), rescaleLSF(LSF(x, y_position), x), 'k', 'LineWidth', 1.5);
xlim([-1.75, 1.75]);
ylim([-0.2, 1.2]);
yticks([]);
title(['\sigma = ' num2str(2*sqrt(2*log(2))*x(3)) ...
    '\pm ' num2str(2*sqrt(2*log(2))*se(3)) ' mm'], ...
    'FontWeight', 'normal');
set(gca, 'FontSize', 12);
box on;

t.XLabel.String = 'Position [mm]';
t.XLabel.FontName = font;
t.XLabel.FontSize = 18;
t.YLabel.String = 'Intensity (a.u.)';
t.YLabel.FontName = font;
t.YLabel.FontSize = 18;

set(gcf, 'Units', 'inches', 'Position', [0, 0, 6, 3]);
% exportgraphics(f, 'Figure_S13_90kVp_plot.pdf');

clc;

%% Style 2: One plot.
f = figure('DefaultTextFontName', font, 'DefaultAxesFontName', font);
hold on;

% Unpatterned.
disp('Load UNPATTERNED data (filename ends in "_results.dat").');
load(uigetfile('*.mat'));
ROI = rescaleESF(ROI, x);
y = linspace(min(y_position), max(y_position), 100);
[ESFpred, delta] = nlpredci(ESF, y, x, r, 'Covar', cov,...
    'MSE', MSE, 'SimOpt', 'on');
shadedErrorBar(shiftY(y_position, x), mean(ROI, 1, 'omitnan'), std(ROI, 1, 'omitnan'), ...
    'lineProps', {'r-'})
plot(shiftY(y, x), rescaleESF(ESFpred, x), 'r-', 'LineWidth', 1.5);
plot(shiftY(y, x), rescaleESF(ESFpred+delta, x), 'r--', 'LineWidth', 1.5);
plot(shiftY(y, x), rescaleESF(ESFpred-delta, x), 'r--', 'LineWidth', 1.5);
% plot(shiftY(y_position, x), rescaleLSF(LSF(x, y_position), x), 'r-', 'LineWidth', 1.5);
text(-1.8, 0.90, ['\sigma = ' num2str(2*sqrt(2*log(2))*x(3)) ' mm'], 'Color', 'r', 'FontSize', 12);

% Patterned.
disp('Load PATTERNED data (filename ends in "_results.dat").');
load(uigetfile('*.mat'));
ROI = rescaleESF(ROI, x);
y = linspace(min(y_position), max(y_position), 100);
[ESFpred, delta] = nlpredci(ESF, y, x, r, 'Covar', cov,...
    'MSE', MSE, 'SimOpt', 'on');
shadedErrorBar(shiftY(y_position, x), mean(ROI, 1, 'omitnan'), std(ROI, 1, 'omitnan'), ...
    'lineProps', {'b-'})
plot(shiftY(y, x), rescaleESF(ESFpred, x), 'b-', 'LineWidth', 1.5);
plot(shiftY(y, x), rescaleESF(ESFpred+delta, x), 'b--', 'LineWidth', 1.5);
plot(shiftY(y, x), rescaleESF(ESFpred-delta, x), 'b--', 'LineWidth', 1.5);
% plot(shiftY(y_position, x), rescaleLSF(LSF(x, y_position), x), 'b-', 'LineWidth', 1.5);
text(-1.8, 0.75, ['\sigma = ' num2str(2*sqrt(2*log(2))*x(3)) ' mm'], 'Color', 'b', 'FontSize', 12);

xlim([-2, 2]);
ylim([-0.1, 1.1]);
yticks([]);
xlabel('Position [mm]');
ylabel('Intensity [a.u.]');
set(gca, 'FontSize', 18);
box on;

set(gcf, 'Units', 'inches', 'Position', [0, 0, 6, 3]);
% exportgraphics(f, 'Figure_S13_90kVp_plot.pdf');

clc;

%% Style 3: Surface plot.
f = figure('DefaultTextFontName', font, 'DefaultAxesFontName', font);
t = tiledlayout(1, 2, 'Padding', 'compact');

% Unpatterned.
disp('Load UNPATTERNED data (filename ends in "_results.dat").');
load(uigetfile('*.mat'));
ROI = rescaleESF(ROI, x);

nexttile;
scatter3(reshape(X,1,[]), shiftY(reshape(Y,1,[]), x), reshape(ROI.',1,[]), 'k.')
surface(X, shiftY(Y, x), rescaleESF(ESF(x,Y), x), 'FaceAlpha', 0.8, 'EdgeColor', 'none');
xticks([]);
ylim([-2, 2]);
zlim([-0.1, 1.1]);
zticks([]);
ylabel('Y [mm]');
zlabel('Intensity [a.u.]');
title(['\sigma = ' num2str(2*sqrt(2*log(2))*x(3)) ' mm'], 'FontWeight', 'normal');
set(gca, 'FontSize', 12);
view(60, 30);

% Patterned.
disp('Load PATTERNED data (filename ends in "_results.dat").');
load(uigetfile('*.mat'));
ROI = rescaleESF(ROI, x);

nexttile;
scatter3(reshape(X,1,[]), shiftY(reshape(Y,1,[]), x), reshape(ROI.',1,[]), 'k.')
surface(X, shiftY(Y, x), rescaleESF(ESF(x,Y), x), 'FaceAlpha', 0.8, 'EdgeColor', 'none');
xticks([]);
ylim([-2, 2]);
zlim([-0.1, 1.1]);
zticks([]);
ylabel('Y [mm]');
zlabel('Intensity [a.u.]');
title(['\sigma = ' num2str(2*sqrt(2*log(2))*x(3)) ' mm'], 'FontWeight', 'normal');
set(gca, 'FontSize', 12);
view(60, 30);

set(gcf, 'Units', 'inches', 'Position', [0, 0, 6, 3]);
% exportgraphics(f, 'Figure_3_surfplot.png', 'Resolution', 600);

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