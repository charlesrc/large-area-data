# Data repository for "Large-scale self-assembled nanophotonic scintillators for X-ray imaging" 
Data for "Large-scale self-assembled nanophotonic scintillators for X-ray imaging" by Louis Martin-Monier et al. (arXiv:2410.07141).

# Requirements
## Python
Install packages needed to run all notebooks with the following command in the main folder: `pip freeze > requirements.txt`

# Figure 2 
- To generate the plot shown in Fig. 2a, run Figure 2/Experiment/EL/`plotLineProfileSample1.m`(Matlab)
- To generate the plot shown in Fig. 2b, Figure 2/Theory/EL/`For_figure_2_sample2.m` (Matlab) [This requires manual selection of sample boundaries -- see color in Fig. 2 of the manuscript for indication.]
- To generate the plot shown in Fig. 2c, Figure 2/Experiment/IL/`plotLineProfileSample2.m` (Matlab) [This requires manual selection of sample boundaries -- see color in Fig. 2 of the manuscript for indication.]
- To generate the plot shown in Fig. 2d, Figure 2/Theory/IL/`For_figure_2_sample2.m` (Matlab)
- To generate the plot shown in Fig. 2e, run Figure 2/Benchmark/`benchmark.ipynb` (Python Jupyter notebook)

# Figure 3
- To generate images from Fig. 3, run Figure 3/`quickFFC.m` (Matlab) and follow instructions
 
# Figure 4
- To generate the plot shown in Fig. 4c-d and inset in Fig. 4g, run Figure 4/AFM/`2d-fourier-fit-afm.ipynb` (Python Jupyter notebook)
- To generate the plot shown in Fig. 4f, run Figure 4/Experiment/
- To generate the plot shown in Fig. 4g, run Figure 4/Theory/`plot_rms.m` (Matlab)
- To calculate the effective depths used in Fig. 4, run Figure 4/`effective-depth.ipynb` (Python Jupyter notebook)

# How to cite
`@article{martin2024large,
  title={Large-scale self-assembled nanophotonic scintillators for X-ray imaging},
  author={Martin-Monier, Louis and Pajovic, Simo and Abebe, Muluneh G and Chen, Joshua and Vaidya, Sachin and Min, Seokhwan and Choi, Seou and Kooi, Steven E and Maes, Bjorn and Hu, Juejun and others},
  journal={arXiv preprint arXiv:2410.07141},
  year={2024}
}`

# Funding

This work is supported in part by the DARPA Agreement No. HO0011249049, as well as being also supported in part by the U. S. Army Research Office
through the Institute for Soldier Nanotechnologies at MIT, under Collaborative Agreement Number W911NF-23-2-0121.

# Corresponding authors
- Louis Martin-Monier, lmmartin@mit.edu
- Simo Pajovic, pajovics@mit.edu
- Muluneh Abebe, abebe181@mit.edu
- Charles Roques-Carmes, chrc@stanford.edu

