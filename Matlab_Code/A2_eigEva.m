
clc;
clear;
%This script checks the validity of the generated kernel matrices. It
%will extract a list of psd, invalid and valid indefinite kernel matrices.
%The output from the script determines if spectral modification is
%required.
%==========================================================================
% Load File to be Analysed and list with names of file to analyse

load('./Exp_K1_all/FileName.mat') %files to combine
file = './Exp_K1_all/Kernel_Therapy_k_ed1_1.mat'; %needed to get the file path
[filepath,name,ext] = fileparts(file); %Split into constituent parts
%==========================================================================
EigFileName = cell(length(FileName),1);

%==========================================================================
for k=1:length(FileName) %iterate through list of files
    fname =  sprintf('%s/%s%s',filepath,FileName{k},ext); 
    load(char(fname)) %loads file
    
    Kernel = U{1,2}; %Extract kernel matrix
    m      = size(Kernel,1);
    
    %Check if kernel is psd
    if find(isnan(Kernel) | isinf(Kernel))
        L = Inf;
        sprintf(' No Eigen Decomposition. Kernel has a nan or Inf \n')
    else
        L = (sum(eig(Kernel) < 0)/m)*100;
        sprintf(' %d percent of eignevalues are less than zero \n', round(L))
    end
   
    EigFileName{k,1} = L; %store the percentage number of -ve eigen values
    
end

%Extract the kernels that are Psd
ind1 = find(cell2mat(EigFileName(:,:))==0); %Psd kernels
ind2 = find(cell2mat(EigFileName(:,:))==inf); %Invalid kernels with either NaN or Inf
ind3 = find(cell2mat(EigFileName(:,:))>0); %Indefinite kernels
ind4 = find(cell2mat(EigFileName(:,:))>0 & (cell2mat(EigFileName(:,:))~=inf));

%Create a list of filenames for Psd, invalid and Indefinite kernels
PsdKernels       = FileName(ind1,:);
InvalidKernels   = FileName(ind2,:);
IndKernels       = FileName(ind3,:);
validIndeKernels = FileName(ind4,:);

%store the files with respective list of kernels
fpath = fullfile(filepath, 'kernelEva'); %concatenate filepath and filename
save(fpath,'PsdKernels','InvalidKernels','IndKernels','validIndeKernels')