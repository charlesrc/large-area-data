clc;
clear all;
close all;

%% ----------------------------------
%  STEP 1: Load RCWA simulation data for Sample 2
% ----------------------------------

% Load theoretical extraction data (RCWA) for sample 2
A_rcwa_data_1 = load('A_rcwa_data_0.5mm.txt');   % Columns: [Wavelength, Unpatterned, Patterned (PhC)]
% Alternatively: load 1mm sample if needed
% A_rcwa_data_1 = load('A_rcwa_data_1mm.txt');

% Extract data columns
wvl = A_rcwa_data_1(:,1);                   % Wavelength [microns]
A_rcwa_off_patern = A_rcwa_data_1(:,2);      % Extraction efficiency for unpatterned reference
A_rcwa_phc = A_rcwa_data_1(:,3);             % Extraction efficiency for patterned photonic crystal (PhC)

%% ----------------------------------
%  STEP 2: Enhancement calculation via emission spectrum weighting
% ----------------------------------

% Define Gaussian emission spectrum parameters
FWHM = 0.080;               % Full-width at half-maximum [microns]
sigma = FWHM / 2.355;        % Standard deviation of Gaussian
lambda_0 = 0.55;             % Central wavelength [microns]

% Generate Gaussian emission profile centered at 550 nm
emissionSpectrum = exp(-(wvl - lambda_0).^2 / (2*sigma^2));

% Calculate weighted integrals
enh_phc = trapz(wvl*1e3, A_rcwa_phc .* emissionSpectrum, 1);   % Integrated PhC extraction
enh_ref = trapz(wvl*1e3, A_rcwa_off_patern .* emissionSpectrum, 1);  % Integrated reference extraction

% Compute enhancement factor
enhancement_factor = enh_phc ./ enh_ref

%% ----------------------------------
%  STEP 3: Data smoothing and normalization for plot clarity
% ----------------------------------

% Smoothing parameters
ff1 = 40000;   % Smoothing window size 1 (for PhC)
ff2 = 10000;   % Smoothing window size 2 (for unpatterned)

% Apply emission spectrum weighting to raw data
data1 = A_rcwa_phc .* emissionSpectrum;
data2 = A_rcwa_off_patern .* emissionSpectrum;

% Median filtering to remove outliers
windowSize1 = 3;  
windowSize2 = 1;
data1_median_filtered1 = medfilt1(data1, windowSize1);
data2_median_filtered2 = medfilt1(data2, windowSize2);

% Gaussian smoothing
smoothedData2 = smoothdata(data2, 'gaussian', ff2);
smoothedData1 = smoothdata(data1_median_filtered1, 'gaussian', ff1);

% Normalization based on mean of smoothed unpatterned data
norm = mean(smoothdata(data2, 'gaussian', ff1));

%% ----------------------------------
%  STEP 4: Plot normalized smoothed data (for main text)
% ----------------------------------

f = figure(1);
set(gcf, 'Position', [100, 100, 400, 300]);  % Initial figure size

% Plot normalized extraction efficiencies
plot(wvl*1e3, smoothedData2 ./ norm, 'LineWidth', 1);  % Unpatterned
hold on;
plot(wvl*1e3, smoothedData1 ./ norm, 'LineWidth', 1);  % Patterned (PhC)

xlabel('Wavelength (nm)', 'FontName', 'Arial', 'FontSize', 12);
ylabel('Normalized signal', 'FontName', 'Arial', 'FontSize', 12);

% Plot formatting
set(gca, 'FontName', 'Arial', 'FontSize', 12, 'LineWidth', 1);
legend({'Bare', 'PhC'}, 'FontSize', 12, 'Location', 'best');
set(gcf, 'Units', 'inches', 'Position', [0, 0, 2, 2]);
set(gca, 'Position', [0.3, 0.3, 0.65, 0.65]);  % Adjusted for better margins
set(gca, 'TickLength', [0.02, 0.025]);
set(gca, 'Box', 'on');
ylim([0, 7]);  % Set y-axis limits for better comparison

% Save figure
saveas(f,'Figure_2_Sample_2_Theory.svg');

%% ----------------------------------
%  STEP 5: Plot raw (unsmoothed) data for supplementary information (SI)
% ----------------------------------

figure(2);
set(gcf, 'Position', [100, 100, 400, 300]);  % Initial figure size

% Plot original RCWA simulation data on log scale
semilogy(wvl*1e3, A_rcwa_off_patern, 'LineWidth', 0.5);  % Unpatterned
hold on;
semilogy(wvl*1e3, A_rcwa_phc, 'LineWidth', 0.5);         % Patterned (PhC)

xlabel('Wavelength [nm]', 'FontName', 'Arial', 'FontSize', 12);
ylabel('Scintillation signal', 'FontName', 'Arial', 'FontSize', 12);

% Plot formatting
set(gca, 'FontName', 'Arial', 'FontSize', 12, 'LineWidth', 1);
legend({'Bare', 'PhC'}, 'FontSize', 12, 'Location', 'best');
box on;

%% ----------------------------------
%  Note:
%  This script processes "Sample 2" using a different RCWA dataset.
%  A similar workflow was previously done for Sample 1.
% ----------------------------------
