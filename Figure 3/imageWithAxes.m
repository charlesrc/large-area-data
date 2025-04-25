% This script outputs a PDF file of a given image with scaled axes in
% object plane units. Note that it will not work if the filename does not
% contain the string 'lo-mag' or 'hi-mag'.

clc;
clear;

% Add the current folder and subfolders to the MATLAB path.
folder = fileparts(which('imageWithAxes.m'));
addpath(genpath(folder));

% Load image.
disp('Load the image.');
imageFilename = uigetfile('*.tif');
image = imread(imageFilename);

[x_size, y_size] = size(image);
txt = input('Symmetric axes? [Y/N] ', "s");
if txt == 'Y'
    x_pixel = (floor(-x_size/2)):(+floor(x_size/2)-1); % Subtract 1 to get the right size.
    y_pixel = (floor(-y_size/2)):(+floor(y_size/2)-1);
else
    x_pixel = (1:x_size)-1; % Subtract 1 so the origin is (0, 0).
    y_pixel = (1:y_size)-1;
end

% Scaling from pixels to object space position.
binning = str2double(regexp(imageFilename, '(?<=binning*)[0-9]', 'match'));
if isempty(binning)
    binning = 1;
end
pixelSize = binning*6.5e-6; % Binning times base pixel size (6.5 microns).
ppmm = 1/((pixelSize/0.0737)/1e-3); % Pixels per mm (in the scintillator plane).
x_position = x_pixel/ppmm; % Position in the scintillator plane.
y_position = y_pixel/ppmm;
% Geometric magnification.
% Object distance in mm.
if contains(imageFilename, 'hi-mag')
    d_o = 150-75; % High magnification.
elseif contains(imageFilename, 'lo-mag')
    d_o = 150-25; % Low magnification.
end
d_i = 150; % Image distance in mm.
M = d_i/d_o;
x_position = (1/M)*x_position; % Position in object space.
y_position = (1/M)*y_position;

[X, Y] = meshgrid(x_position, y_position);

%% Show image with axes.
% Font for plots.
font = 'Arial';
f = figure('DefaultTextFontName', font, 'DefaultAxesFontName', font);
imshow(image, 'XData', x_position, 'YData', y_position);
axis('on', 'image');
if txt == 'N'
    set(gca, 'XAxisLocation', 'top');
end
colormap(gray);
% Axes.
set(gca, 'YDir', 'reverse'); % Right side up.
xlabel('X [mm]');
ylabel('Y [mm]');
set(gca, 'FontSize', 12);
axis tight; % Axis limits.
% pbaspect([max(X,[],'all') max(Y,[],'all') 1]); % Aspect ratio.

% Save image.
exportgraphics(f, [erase(imageFilename, '.tif') '.pdf']);

clc;