%close 1l
clear all

data = load('sigma1_sigma2_rms.txt');
data_eff = load('sigma1_sigma2_rms_eff.txt');

rms = data_eff(:,1);
sigma_1 =data(:,2);
sigma_2 = data(:,3);
sigma_1_eff =data_eff(:,2);  % for effective thickness 
sigma_2_eff = data_eff(:,3);

sigma_1= smoothdata(sigma_1, 'gaussian', 100); % for smoothing the data 
sigma_2 = smoothdata(sigma_2, 'gaussian', 100);
sigma_1_eff= smoothdata(sigma_1_eff, 'gaussian', 100); % for smoothing the data 
sigma_2_eff = smoothdata(sigma_2_eff, 'gaussian', 100);

 f = figure;
 set(gca, 'FontSize', 12, 'FontName', 'Arial');  % Set axis font size and font to Arial
 plot(rms, sigma_1,'k', 'LineWidth', 1)
 hold on 
 plot(rms, sigma_2,'r', 'LineWidth', 1)
 plot(rms, sigma_1_eff,'--k','LineWidth', 1)
 plot(rms, sigma_2_eff,'--r','LineWidth', 1)
 % legend('Sample 1', 'Sample 2');  
 xlim([0 11])
 grid off;

 
% % find expermental values (1.1166   2.545)
% y_value1 = 1.2;
% y_value2 = 2.5; 
% 
% % Find the corresponding x-values for y_value (closest points)
% [~, idx1] = min(abs(sigma_1 - y_value1));  % Find index for sigma_1 closest to y_value
% [~, idx2] = min(abs(sigma_2 - y_value2));  % Find index for sigma_2 closest to y_value
% 
% % Get the x (rms) values corresponding to the found indices
% x_value1 = rms(idx1);
% x_value2 = rms(idx2);
% 
% % Plot markers on the graph at the found points
% plot(x_value1, y_value1, 'ok', 'MarkerSize', 5, 'MarkerFaceColor', 'k');  % Marker for sigma_1
% plot(x_value2, y_value2, 'or', 'MarkerSize', 5, 'MarkerFaceColor', 'r');  % Marker for sigma_2

% Experimental parameters

% Sample 1 
% Sigma: 3.997508416956707
% Sigma_error: 0.015891510694141766
% Bare : 0.27 +/- 0.013
% PhC : 0.29 +/- 0.026
sigma_sample1 = 3.997508416956707;
sigma_err_sample1 = 0.015891510694141766;
res_bare_sample1 = 0.27;
res_bare_err_sample1 = 0.013;
res_phc_sample1 = 0.29;
res_phc_err_sample1 = 0.026;
res_enhancement_sample1 = res_phc_sample1/res_bare_sample1;
res_enhancement_err_sample1 = res_phc_err_sample1 / res_bare_sample1 + res_phc_sample1 / res_bare_sample1^2.*res_bare_err_sample1;

% Sample 2
% Sigma: 9.223842986507826
% Sigma_error: 0.03362826380024821
% Bare : 0.40 +/- 0.004
% PhC : 0.99 +/- 0.029
sigma_sample2 = 9.223842986507826;
sigma_err_sample2 = 0.03362826380024821;
res_bare_sample2 = 0.40;
res_bare_err_sample2 = 0.004;
res_phc_sample2 = 0.99;
res_phc_err_sample2 = 0.029;
res_enhancement_sample2 = res_phc_sample2/res_bare_sample2;
res_enhancement_err_sample2 = res_phc_err_sample2 / res_bare_sample2 + res_phc_sample2 / res_bare_sample2^2.*res_bare_err_sample2;

% Add experimental points 
errorbar(sigma_sample1,res_enhancement_sample1, ...
    res_enhancement_err_sample1/2.,res_enhancement_err_sample1/2., ...
    sigma_err_sample1/2., sigma_err_sample1/2., 'o', color = 'black');

errorbar(sigma_sample2,res_enhancement_sample2, ...
    res_enhancement_err_sample2/2.,res_enhancement_err_sample2/2., ...
    sigma_err_sample2/2., sigma_err_sample2/2., 'x', color = 'red');


% set(gcf, 'Units', 'inches', 'Position', [0, 0, 2.6, 5.2]);
set(gcf, 'Units', 'inches', 'Position', [0, 0, 2.6, 3.5]);
set(gca, 'Position', [0.3, 0.3, 0.65, 0.65]);  % Adjusted for better spacing
xlabel('Disorder RMS (nm)', 'FontName', 'Arial', 'FontSize', 12) % 
ylabel('Relative spatial resolution', 'FontName', 'Arial', 'FontSize', 12) % 
set(gca, 'FontName', 'Arial', 'FontSize', 12, 'LineWidth', 1) % 


saveas(f,'disorder-compiled.svg');

