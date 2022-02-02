function A = PerfromSpecMod(U)

%This takes an indefinite kernel and applies 4 spectral modifications in an
%attempt to transform the indefinite kernel matrix to positive semi definite
%==========================================================================
% input
%------
% U - A cell that contains the kernel matrices (Hessian) and label
%
% Output
%--------
% A - A cell containing variations of spectral changes to the kernel matrix
%==========================================================================
%Extract kernel Matrix
Kernel  = U{1,2};
Kernel2 = U{2,2};
%==========================================================================
m = size(Kernel,1);
A = cell(4,1);

specmode = {'clip','shift', 'flip','square'}; %4 spectral modes to apply
%==========================================================================
%Check if kernel is badly formed with nan or inf values
if find(isnan(Kernel) | isinf(Kernel))
    L = Inf;
    sprintf(' No Eigen Decomposition. Kernel has a nan or Inf \n')
else
    L = (sum(eig(Kernel) < 0)/m)*100;
    sprintf(' %d percent of eignevalues are less than zero \n', round(L))
    %======================================================================
    for i =1:length(specmode) %iterate through the list of spectral modes

        A{1,1} = U{1,2}; % Store the unmodified indefinite kernel
        A{2,1} = U{2,2};
        A{3,1} = U{3,2};
        A{4,1} = 'raw';
        A{5,1} = L; %store percentage negative eigenvalues

        mode = specmode{i}; % Select mode

        A{1,i+1} = specmod(Kernel, mode); %apply spectral mode to the kernels
        A{2,i+1} = specmod(Kernel2, mode);
        A{3,i+1} = U{3,2};
        A{4,i+1} = mode;
        A{5,i+1} = L;

    end
end
rowNames = {'Hessian', 'Kernel','Label','Mode', '%-ve Eig'};
A = [A rowNames'];