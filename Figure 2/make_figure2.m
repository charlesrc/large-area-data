% make_figure2.m
%
% Purpose:
%   Automates generation of all plots required for Figure 2.
%
% Requirements:
%   - MATLAB
%   - Raw images and RCWA data in proper folders

clear;
close all;

disp('Starting full Figure 2 generation...');

% --- Experimental Line Profiles ---

disp('Generating EL line profile...');
cd('Experiment/EL');
plotLineProfileSample1;
cd('../../');

disp('Generating IL line profile...');
cd('Experiment/IL');
plotLineProfileSample2;
cd('../../');

% --- Theoretical Extraction Plots ---

disp('Generating RCWA theoretical plot for EL sample...');
cd('Theory/EL');
For_figure_2_sample1;
cd('../../');

disp('Generating RCWA theoretical plot for IL sample...');
cd('Theory/IL');
For_figure_2_sample2;
cd('../../');

% --- Benchmark (optional) ---

disp('Benchmark step: Please manually run Benchmark/benchmark.ipynb');

disp('Finished generating all Figure 2 components.');
