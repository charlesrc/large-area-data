
clc;
clear;

% Add the current folder and subfolders to the MATLAB path.
folder = fileparts(which('beerlambertlaw.m'));
addpath(genpath(folder));

% Load experimental data.
load('razor_blade_sample1_90kVp_12W_3.0s_hi-mag_unpatterned_results.mat');
ROI = rescaleESF(ROI, x);
y = shiftY(y_position, x)*1e-1;

shadedErrorBar(y, flip(mean(ROI, 1, 'omitnan')), flip(std(ROI, 1, 'omitnan')), ...
    'lineProps', {'k-'});
dcm_obj = datacursormode();
set(dcm_obj, 'DisplayStyle', 'datatip', ...
    'SnapToDataVertex', 'off', 'Enable', 'on');
disp('Pick the edge of the razor blade. Press any key to continue.');
pause;
c_info = getCursorInfo(dcm_obj);
Position = c_info.Position;
addshift = Position(1);
y = y-addshift;
close all;

%% Beer-Lambert law model.
% Properties of Fe.
density = 7.81; % Density of Fe [g/cm^3].
% Properties of the razor blade.
d_edge = 0.03; % Thickness [cm].
y_taper = 0.07; % Taper distance [cm].

% Fit the data.
BLL = @(x,xdata)exp(-x(1)*density*(d_edge/2/y_taper)*xdata);
Y = y(y>0 & y<=y_taper);
A = flip(mean(ROI, 1, 'omitnan'));
A = A(y>0 & y<=y_taper);
x0 = 15;
[x,r,Jac,cov,MSE] = nlinfit(Y, A, BLL, x0);
[ci, se] = nlparcise(x,r,"Covar",cov);
massatt = x;

% Razor blade edge.
A_razorblade = beerlambertfit(y, massatt);

% "True" edge.
A_edge = zeros(1, length(y));
A_edge(y<=0) = 1;
A_edge(y>0) = exp(-massatt*density*d_edge);

%% Plot.
figure;
hold on;
shadedErrorBar(y/1e-1, flip(mean(ROI, 1, 'omitnan')), flip(std(ROI, 1, 'omitnan')), ...
    'lineProps', {'k-'});
plot(y/1e-1, A_razorblade, 'r', 'LineWidth', 1.5);
% plot(y/1e-1, A_edge, 'b', 'LineWidth', 1.5);
xlim([-0.8, 0.8]);
xticks([-0.5, 0, 0.5]);
ylim([-0.1, 1.1]);
yticks([0, 1]);
xlabel('Position (mm)');
ylabel('Intensity (a.u.)');
box on;

title(['\mu/\rho = ' num2str(massatt) ' \pm ' num2str(se) ' cm^2/g'], 'FontWeight', 'normal');

set(gcf, 'Units', 'inches', 'Position', [0, 0, 2.5, 2]);
% exportgraphics(gcf, 'beerlambertexample_sample1_90kVp.pdf');

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

function A = beerlambertfit(y, massatt)
    % Properties of Fe.
    density = 7.81; % Density of Fe [g/cm^3].
    % Properties of the razor blade.
    d_edge = 0.05; % Thickness [cm].
    y_taper = 0.1; % Taper distance [cm].
    
    % Calculate function.
    A = zeros(1, length(y));
    A(y<=0) = 1;
    A(y>0 & y<=y_taper) = exp(-massatt*density*(d_edge/2/y_taper)*y((y>0 & y<=y_taper)));
    A(y>y_taper) = exp(-massatt*density*d_edge);
end