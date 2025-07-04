# Figure 4 – Experimental and Theoretical Data

This folder contains all data and scripts necessary to reproduce Figure 4 of the project. Figure 4 compares experimental measurements of surface morphology and optical response with theoretical predictions.

## Folder structure

- AFM/
  - Processed Atomic Force Microscopy (AFM) surface data.
- Experiment/
  - Raw and processed experimental measurements.
- Theory/
  - Theoretical simulation results.
- effective-depth.ipynb
  - Jupyter Notebook for post-processing depth-related data.
- yagce.csv
  - Optical constants (n, k) for Cerium-doped Yttrium Aluminum Garnet (Ce:YAG).

## File descriptions

### AFM/
- `processed_afm_data.mat`: MATLAB `.mat` file containing processed AFM topography data.

### Experiment/
- `raw_data/`: Contains raw experimental images. The two subfolders, to be described below, are organized in the same way.
  - `EL/` or `IL/`: raw data for the EL and IL samples described in the paper.
    - `flat-field-corrected\`: flat-field-corrected images of the razor blade used for spatial resolution analysis.
    - `high-magnificaiton\`: raw images of the razor blade taken at "high" geometric magnification (2.0x).
    - `low-magnificaiton\`: raw images of the razor blade taken at "low" geometric magnification (1.3x).
      - `90-kVp/`, `120-kVp/`, and `150-kVp`: raw images for each energy setting.
- `processed_data/`: Contains processed spatial resolution line profiles to be analyzed. Patterned and unpatterned regions are stored in separate files.
  - `EL/` or `IL/`: processed data for the EL and IL samples described in the paper.
      - `high-magnificaiton\`: spatial resolution profiles at "high" geometric magnification (2.0x).
      - `low-magnificaiton\`: spatial resolution profiles at "low" geometric magnification (1.3x).
        - `90-kVp/`, `120-kVp/`, and `150-kVp`: profiles for each energy setting.
- `rois/`: `.mat` files containing the regions of interest used to generate spatial resolution line profiles in `processed_data/`.
- `plotSpatialResolution.m`: script to plot the spatial resolution in three different styles (user is prompted to load data):
  1. separate patterned and unpatterned plots for each sample;
  2. a single plot with patterned and unpatterned in different plots (Fig. 4 in the main text); and
  3. as a surface plot, showing the full 2-D region of interest from which the spatial resolution was computed.
- `plotSpatialResolution_sample1.m`: script to generate Fig. 4.e. in the main text.
- `plotSpatialResolution_sample3.m`: script to generate Fig. 4.f. in the main text.
- `spatialResolution.m`: script to generate a spatial resolution line profile and fit the ESF to it. The user should
                         follow the instructions and can either draw their own ROIs to fit or load pre-generated ones.
- `beerlamberlaw.m`: script to generate the Beer-Lambert law plot in Fig. S11 in the SI. The user is prompted to
                     choose the edge of the razor blade; use the figure as a guide.
- `nlparcise.m`: modified version of the MATLAB built-in function nlparci that also returns standard error.
NOTE: to generate the plots, the user needs to download shadedErrorBar from the MATLAB File Exchange.
  Credited to Rob Campbell. See here (https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar)
  and here (https://github.com/raacampbell/shadedErrorBar).

### Theory/
- Various `.mat` files containing theoretical calculations of optical properties.

### effective-depth.ipynb
- Jupyter Notebook that processes AFM and experimental data to compute effective depth parameters for optical simulations.
- Note: Please add introductory markdown cells explaining the notebook steps for clarity.

### yagce.csv
- CSV file listing optical constants for Ce:YAG.

## How to reproduce the analysis

1. Open `effective-depth.ipynb` in Jupyter Notebook.
2. Follow the cells to process experimental data and calculate effective depth parameters.
3. Use MATLAB to inspect `.mat` files and compare theory with experimental results.

## Software requirements

- Python 3.x
- numpy, pandas, matplotlib
- MATLAB R2020a or newer
- Jupyter Notebook

## Notes

- `.DS_Store` and `.ipynb_checkpoints/` files are automatically generated and not relevant to the project.
- Some assumptions (such as simulation parameters and experimental conditions) are described in the main text of the publication.
- Additional metadata (e.g., AFM acquisition settings) could be added for completeness.

