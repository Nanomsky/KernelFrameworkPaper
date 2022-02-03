# KernelFrameworkPaper
Contains the data and scripts used for Nature paper 

## Table of contents]
* [General info](#general-info)
* [Technologies](#technologies)
* [Prerequisite](#Prerequisite)
* [Setup](#setup)
* [List of Files](#Files)
* [Contact](#Contact)

## General info
This project contains matlab, python scripts and dataset used in conducting experiments for the Nature paper titled - <b> A Novel Kernel-Based Approach For Uneven length
Symbolic Data: A Case Study for Establishing Type 2 Diabetes Risk </b>.
	
## Technologies
Project is created with:

* Python 3.7
* IPython 7.8.0
* Jupyter Notebook 1.0.0
* scikit-learn 0.24.1
* Matlab R2021b
* Matlab deep learning toolbox 14.3
* Libsvm - 3.21
* SimpleMKL

## Prerequisite
* Add the libsvm and SimpleMKL location to Matlab search path 


## Setup
To run this project, retain the file structure and run the matlab scripts from matlab. :

## Files
<b>Matlab Scripts</b>
 * [A1_Develop kernel.m](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Matlab_Code/A1_DevelopKernel.m) - Script for executing the kernel functions and generating the kernel matrices
 * [A1_DevelopKernel_All_Tables.m](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Matlab_Code/A1_DevelopKernel_All_Tables.m) - Script for selecting individual data tables and executing kernel functions.  
 * [A2_eigEval.m](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Matlab_Code/A2_eigEva.m) - Provides a list of kernels matrices that are positive semi definite, indefinite and invalid.
 * [A3_Universal_Script_NSD.m](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Matlab_Code/A3_Universal_Script_NSD.m) - Script for training an SVM classifier with indefinite kernel matrices
 * [A3_Universal_Script_Psd.m](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Matlab_Code/A3_Universal_Script_PSD.m) - Script for training an SVM classifier with psd kernel matrices
 * [A4_AnalyzeResults_Indefinite.m](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Matlab_Code/A4_AnalyzeResults_Indefinite.m) - Extracts the classification results generated for each kernel according to the sectral modification and matrix modification applied to indefinite kernel matrices
 * [A4_AnalyzeResults_psd.m](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Matlab_Code/A4_AnalyzeResults_psd.m) - Extracts the classification results generated for each kernel according to the matrix modification applied to psd matrices
 * [A5_Extract_ALl_Results_NSD.m](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Matlab_Code/A5_Extract_ALl_Results_NSD.m)	- Takes the stacked outcome from A4_AnalyzeResults_Indefinite.m and extracts the optimum performance by spectral modification, C regularization parameter and matrix manipulation for indefinite kernels
 * [A5_Extract_ALl_Results_PSD.m](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Matlab_Code/A5_Extract_ALl_Results_PSD.m)	- Used to extract the best results from the psd kernels
 * [B1_PeptideDevelopKernel.m](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Matlab_Code/B1_PeptideDevelopKernel.m)	- Loads the peptide data and executes the kernel functions
 
 <b>Deep Learning Scripts</b>
 * [LSTM_BIN_LOOCV_PEP_v1.m](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/LSTM_Network/LSTM_BIN_LOOCV_PEP_v1.m) - LSTM script applied to EHR binary bag-of-words dataset
 * [LSTM_BOW_LOOCV_v3.m](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/LSTM_Network/LSTM_BOW_LOOCV_v3.m) - LSTM script applied to EHR bag-of-words dataset
 * [ANN_BIN_LOOCV_PEP_v1.m](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/MLP_Network/ANN_BIN_LOOCV_PEP_v1.m) - Multi-Layer Perceptron script applied to EHR binary bag-of-words dataset
 * [ANN_BOW_LOOCV_v1.m](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/MLP_Network/ANN_BOW_LOOCV_v1.m) - Multi-Layer Perceptron script applied to EHR bag-of-words dataset

<b>Python Scripts</b>
 * [EHR_LOOCV_LogisticRegression.ipynb](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Python_Code/EHR_LOOCV_LogisticRegression.ipynb) - Logistic Regression Jupyter notebook for the EHR bag-of-words features
 * [EHR_LOOCV_SVM.ipynb](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Python_Code/EHR_LOOCV_SVM.ipynb) - Support Vector Machine (SVM) Jupyter notebook for the EHR bag-of-words features
 * [Peptide_Data_Extract-V2.ipynb](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Python_Code/Peptide_Data_Extract-V2.ipynb) - Script (Jupyter notebook) used to extract and process the peptide data into bag-of-words features
 * [Peptide_LOOCV_LogisticRegression.ipynb](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Python_Code/Peptide_LOOCV_LogisticRegression.ipynb) - Logistic Regression Jupyter notebook for the peptide bag-of-words features
 * [Peptide_LOOCV_SVM.ipynb](https://github.com/Nanomsky/KernelFrameworkPaper/blob/main/Python_Code/Peptide_LOOCV_SVM.ipynb) - Support Vector Machine (SVM) Jupyter notebook for the peptide bag-of-words features

## Contact
 * email: NN133@live.mdx.ac.uk
