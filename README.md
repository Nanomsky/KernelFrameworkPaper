# KernelFrameworkPaper
Contains the data and scripts used for Nature paper 

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Setup](#setup)

## General info
This project contains the various codes and data used in conducting experiments for the Nature paper titled - <b> A Novel Kernel-Based Approach For Uneven length
Symbolic Data: A Case Study for Establishing Type 2 Diabetes Risk </b>.
	
## Technologies
Project is created with:

* Python 3.7
* IPython -Jupyter Notebook
* Matlab R2021b
* Matlab deep learning toolbox 14.3
* Libsvm - 3.21
* SimpleMKL

## Prerequisite
* Add the libsvm and SimpleMKL location to Matlab search path 


## Setup
To run this project, retain the file structure and run the matlab scripts from matlab. :

## List of Files
 * [A1_Develop kernel.m](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Matlab_Code/A1_DevelopKernel.m) - Script for executing the kernel functions and generating the kernel matrices
 * A2_eigEval.m - Provides a list of kernels matrices that are positive semi definite, indefinite and invalid.
 * A3_Universal_Script_NSD.m - Script for training an SVM classifier with indefinite kernel matrices
 * A3_Universal_Script_Psd.m - Script for training an SVM classifier with psd kernel matrices
 * A4_AnalyzeResults_Indefinite.m - Extracts the classification results generated for each kernel according to the sectral modification and matrix modification applied to indefinite kernel matrices
 * A4_AnalyzeResults_psd.m - Extracts the classification results generated for each kernel according to the matrix modification applied to psd matrices
 * A5_Extract_ALl_Results_NSD.m	- Takes the stacked outcome from A4_AnalyzeResults_Indefinite.m and extracts the optimum performance by spectral modification, C regularization parameter and matrix manipulation for indefinite kernels
 * A5_Extract_ALl_Results_PSD.m	- Used to extract the best results from the psd kernels
 * B1_PeptideDevelopKernel.m	- Loads the peptide data and executes the kernel functions
## Acknowledgements

## Contact
 * email: NN133@live.mdx.ac.uk
