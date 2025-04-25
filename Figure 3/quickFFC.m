% This script "quickly" performs a flat-field correction.
% You only need to load the image and the flat-field,
% MATLAB does the rest.

clc;
clear;

% Add the current folder and subfolders to the MATLAB path.
folder = fileparts(which('quickFFC.m'));
addpath(genpath(folder));

% Load image.
disp('Load the image.');
image_filename = uigetfile('*.tif');
image = imread(image_filename);

% Load flat-field.
disp('Load the flat-field.');
flatfield = imread(uigetfile('*.tif'));

% Flat-field correction.
corrected_image = uint16(double(image)./double(flatfield)*mean2(flatfield));

% Print information.
disp(['Flat-field mean: ' num2str(mean2(flatfield))]);

% Show the results.
figure;
tiledlayout(1, 3, 'TileSpacing', 'tight', 'Padding', 'tight');
nexttile;
imshow(image);
title('Image');
nexttile;
imshow(flatfield);
title('Flat-field');
nexttile;
imshow(corrected_image);
title('Flat-field corrected image');
set(gcf, 'Units', 'inches', 'Position', [1.5, 1.5, 12, 4]);

corrected_image_filename = [erase(image_filename, '.tif') '_ffc'];
imwrite(corrected_image, [corrected_image_filename '.tif']);