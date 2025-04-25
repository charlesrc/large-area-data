clc;
clear all
close all

%% For smaple one
A_rcwa_data_1  =  load('A_rcwa_data_0.5mm.txt'); % data phc
% A_rcwa_data_1 =  load('A_rcwa_data_1mm.txt'); % data phc
wvl = A_rcwa_data_1(:,1);
A_rcwa_off_patern = A_rcwa_data_1(:,2); 
A_rcwa_phc = A_rcwa_data_1(:,3); 
%% Enhancement calculation
FWHM = 0.080;
sigma = FWHM/2.355;
lambda_0 = 0.55;
emissionSpectrum = exp(-(wvl - lambda_0).^2/(2*sigma^2));
enh_phc = trapz(wvl*1e3, A_rcwa_phc.*emissionSpectrum,1); 
enh_ref = trapz(wvl*1e3, A_rcwa_off_patern.*emissionSpectrum,1);
enhancement_factor = enh_phc./enh_ref
% 
%% Data smooting and normalizing 
ff1 = 40000;
ff2 = 10000;
data1 = A_rcwa_phc.*emissionSpectrum; % 
data2 = A_rcwa_off_patern.*emissionSpectrum; % 

windowSize1 = 3; % adjust as needed
windowSize2 = 1; % adjust as needed

data1_median_filtered1 = medfilt1(data1, windowSize1);
data2_median_filtered2 = medfilt1(data2, windowSize2);

% norm = mean(smoothdata(data2, 'gaussian', ff1))/3.8064e+03;
norm = mean(smoothdata(data2, 'gaussian', ff1));
smoothedData2= smoothdata(data2, 'gaussian', ff2);
smoothedData1= smoothdata(data1_median_filtered1, 'gaussian', ff1);

%% normalized smoothed data for main text/norm to the max of phc
f = figure(1)
set(gcf, 'Position', [100, 100, 400, 300]) % for the size, maybe this is small  
plot(wvl*1e3, smoothedData2./norm, 'LineWidth', 1) % Increase line width
hold on
plot(wvl*1e3, smoothedData1./norm, 'LineWidth', 1) % 
xlabel('Wavelength (nm)', 'FontName', 'Arial', 'FontSize', 12) % 
ylabel('Normalized signal', 'FontName', 'Arial', 'FontSize', 12) % 
set(gca, 'FontName', 'Arial', 'FontSize', 12, 'LineWidth', 1) % 
% ylim([0 1])
legend({'Bare', 'Phc'}, 'FontSize', 12, 'Location', 'best')
set(gcf, 'Units', 'inches', 'Position', [0, 0, 2, 2]);
set(gca, 'Position', [0.3, 0.3, 0.65, 0.65]);  % Adjusted for better spacing
set(gca, 'TickLength', [0.02, 0.025]);  % [Inside length, outside length]
set(gca, 'Box', 'on');
% ylim([0, 3.3e4])
ylim([0, 7])
saveas(f,'Figure_2_Sample_2_Theory.svg');


% Raw/original data for the SI 
figure(2)
set(gcf, 'Position', [100, 100, 400, 300]) % 
semilogy(wvl*1e3, A_rcwa_off_patern, 'LineWidth', 0.5) % 
hold on
semilogy(wvl*1e3, A_rcwa_phc, 'LineWidth', 0.5) % 
xlabel('Wavelength [nm]', 'FontName', 'Arial', 'FontSize', 12) % 
ylabel('Scintillation signal', 'FontName', 'Arial', 'FontSize', 12) % 
set(gca, 'FontName', 'Arial', 'FontSize', 12, 'LineWidth', 1) % 
legend({'Bare', 'Phc'}, 'FontSize', 12, 'Location', 'best')
box on

%% Smaple 2, here separtley so  



