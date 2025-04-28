
clc;
clear;
close all;

% Add the current folder and subfolders to the MATLAB path.
folder = fileparts(which('spatialResolution.m'));
addpath(genpath(folder));

% Load the image.
disp('Load the image.');
imageFilename = uigetfile('*.tif');
image = imread(imageFilename);
% Rotation angle in degrees. The edge should be as vertical as possible.
if contains(imageFilename, 'sample1')
    rotation = 90; % Sample 1.
elseif contains(imageFilename, 'sample2')
    rotation = -3.5; % Sample 2.
else
    rotation = 0;
end
image = imrotate(image,rotation,'bilinear','crop');

% Prompt the user to declare whether they will crop
% a patterned or unpatterned region of interest.
txt = input('Patterned or unpatterned? [P/U] ', "s");
if txt == 'P'
    label = 'patterned';
else
    label = 'unpatterned';
end

% Prompt the user to load the coordinates of a cropped image
% or crop from scratch.
txt = input('Load the coordinates of a cropped image? [Y/N] ',"s");

if txt == 'Y'
    % Load coordinates.
    filename = uigetfile('*.mat');
    load(filename);
    region_of_interest = imcrop(image, coordinates);
else
    % Extract rectangular region of interest.
    imshow(image);
    % caxis([0, 15e3]);
    fprintf('Extract region of interest. Draw a rectangle, then right-click\nand select ''Crop Image''.\n');
    [region_of_interest, coordinates] = imcrop;

    txt = input('Save? [Y/N] ', "s");
    if txt == 'Y'
        filename = input('Filename? (Press enter to have the same filename as the original image) ', "s");
        if isempty(filename)
            filename = erase(imageFilename, '.tif');
        end
        save([filename '_' label '_roi.mat'], 'region_of_interest', 'coordinates');
    end
end
[x_size, y_size] = size(region_of_interest);
x_pixel = 1:x_size;
y_pixel = 1:y_size;

% Scaling from pixels to object space position.
% Conversion factor from pixels to scintillator plane mm.
ppmm = 1/((6.5e-6/0.0737)/1e-3);
x_position = x_pixel/ppmm; % Position in the scintillator plane.
y_position = y_pixel/ppmm;
% Geometric magnification.
% Object distance in mm.
if contains(imageFilename, 'hi-mag')
    d_o = 150-75; % High magnification.
elseif contains(imageFilename, 'lo-mag')
    d_o = 150-35; % Low magnification.
else
    txt = input('High or low geometric magnification? [H/L] ', "s");
    if txt == 'H'
        d_o = 150-75;
    else
        d_o = 150-35;
    end
end
d_i = 150; % Image distance in mm.
M = d_i/d_o;
x_position = (1/M)*x_position; % Position in object space.
y_position = (1/M)*y_position;

[X, Y] = meshgrid(x_position, y_position);

%% Delete outliers.
region_of_interest_filtered = filloutliers(double(region_of_interest), NaN, ...
    'median',1);

%% Fit the data.
ESF = @(x,xdata)(1/2)*x(1)*erf((xdata-x(2))/(sqrt(2)*x(3)))+x(4);
LSF = @(x,xdata)(x(1)/(sqrt(2*pi)*x(3)))*exp(-((xdata-x(2))/(sqrt(2)*x(3))).^2);
disp('Form of the ESF: (A/2)*erf((x - mu)/(sqrt(2)*sigma)) + B');
% Just use the first row of the array to generate an initial guess.
ROI = flip(region_of_interest_filtered,2);
x0 = initial_guess(y_position, ROI(1,:));

% Run the fit.
[x,r,Jac,cov,MSE] = nlinfit(reshape(Y,1,[]),reshape(ROI.',1,[]),ESF,x0);
[ci, se] = nlparcise(x,r,"Covar",cov);

% Find the FWHM of the LSF.
fwhm = 2*sqrt(2*log(2))*x(3);
spares = fwhm;
t.Title.String = ['Spatial resolution: ' num2str(spares) ' \pm ' num2str(se(3)) ' mm'];
disp(['Spatial resolution: ' num2str(spares) ' +- ' num2str(2*sqrt(2*log(2))*se(3)) ' mm']);

%% Save data.
txt = input('Save? [Y/N] ', "s");
if txt == 'Y'
    filename = input('Filename? (Press enter to have the same filename as the original image) ', "s");
    if isempty(filename)
        filename = erase(imageFilename, '.tif');
    end
    save([filename '_' label '_results.mat'], ...
        'X', 'Y', 'x_position', 'y_position', 'ROI', ... % Raw data.
        'x', 'r', 'Jac', 'cov', 'MSE', 'se'); % Curve fit.
end

%% Quick plot.
figure;
hold on;
shadedErrorBar(y_position, mean(ROI, 1, 'omitnan'), std(ROI, 1, 'omitnan'), ...
    'LineProps', {'b'});
plot(y_position, ESF(x, y_position), 'b', 'LineWidth', 1.5);
% close all;


% === === === === ===
% Function to generate an initial guess for curve fitting
% the error function to the ESF.
% === === === === ===
function x0 = initial_guess(x, I)
    % Smooth the data.
    I_filtered = smoothdata(I, 'gaussian', 10); % This is the ESF.
    
    % LSF = d(ESF)/dx.
    dI = diff(I_filtered)./diff(x);
    dx = (x(2:end)+x(1:(end-1)))/2;
    
    [peaks, locations, widths, ~] = findpeaks(dI, dx);
    % The LSF corresponds to the tallest, widest peak.
    [~, idx] = max(peaks);
    fwhm = widths(idx);
    sigma = fwhm/(2*sqrt(2*log(2)));
    mu = locations(idx);
%     A = (max(I_filtered) - min(I_filtered))/2/2;
    A = max(I_filtered) - min(I_filtered);
    B = mean(I_filtered,'omitnan');
    
    x0 = [A, mu, sigma, B];
end
