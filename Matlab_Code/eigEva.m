

clc;
clear;
%Use this to breakdown the contents of the experiment folder into psd,
%indefinte and invalid kernels. Help to investigate why we have nan or inf
%for some kernel values
%% Load File to be Analysed and list with names of file to analyse

load('./Exp3/FileName.mat') %files to combine
file = './Exp3/k_ed3_1_1.mat'; %needed to get the file path
%load('/Users/osita/Documents/Paper1/BP_DATA.mat')



%% Rename the files if needed
[filepath,name,ext] = fileparts(file); %Split into constituent parts

EigFileName =cell(length(FileName),1);
for k=1:length(FileName)
    fname =  sprintf('%s/%s%s',filepath,FileName{k},ext); %Rearrange to suite the filenames
    load(char(fname)) %loads file
    
    Kernel = U{1,2};
    m = size(Kernel,1);
    %Test for PSD kernel. Test the kernel rather than the Hessian
    
    if find(isnan(Kernel) | isinf(Kernel))
        L = Inf;
        sprintf(' No Eigen Decomposition. Kernel has a nan or Inf \n')
    else
        L = (sum(eig(Kernel) < 0)/m)*100;
        sprintf(' %d percent of eignevalues are less than zero \n', round(L))
    end
    
    %EigFileName{1,1} ='percentage of eignevalues < 0';
    EigFileName{k,1} = L;
    
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

fpath = fullfile(filepath, 'kernelEva'); %concatenate filepath and filename
save(fpath,'PsdKernels','InvalidKernels','IndKernels','validIndeKernels')