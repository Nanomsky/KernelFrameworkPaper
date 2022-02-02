%@Nanomsky

function [Out, KerAnalysis] = LOOCVclassify(A, para, Train, Test, Label, type)
%Function to train the data and make predictions. This takes a cell
%containing the kernel matrices, the C regularization parameter, the
%location (cell references) for the train, test and label. It also takes in
%the type of matrix modification to be made. It partitions the data by
%retaining each example as the test example while the rest are used for
%training. It also evaluates the suitability of the kernel matrix by computing 
%the kernel target alignment and spectral ratio
%
%input
%-----
% A      -  A cell (output from PerfromSpecMod function) that contains the
%           matrices as input into the SVM classifier
% para   -  An arry of C regularization parameters for learning process
% Train  -  Number indicating the cell location for the kernel matrix
% Test   -  Number indicating the cell location for the test matrix
% Label  -  Number indicating the cell location for the target label
% type   -  The type of matix modification (centering or normalization)
%
%Output
%------
% Out         - Outcome from the prediction for each partition
% KerAnalysis - The outcome of the kernel evaluation with spectral ratio
%               and kernel target alignment

% =========================================================================
%Extract the Training, Test and Label from the input File
H    = A{Train, 1}; % Kernel Matrix for training
H1   = A{Test,  1}; % Extract Kernel Test matrix
Y    = A{Label, 1}; % Extract label
H2   = A{Test,  1}; % Extract Kernel not the Hessian
num  = size(H,1); %establish the size of the kernel

% =========================================================================
if strcmp(type,'norm')

    H  = normaliseKernel(H);
    H1 = normaliseKernel(H1);
    H2 = normaliseKernel(H2);
    fprintf('Kernel normalised')
end

if strcmp(type,'cen')
    H  = centerKernel(normaliseKernel(H));
    H1 = centerKernel(normaliseKernel(H1));
    H2 = centerKernel(normaliseKernel(H2));
    fprintf('Kernel normalised and centralised')
end
if strcmp(type,'raw')
    fprintf('no modification made')
end
% =========================================================================
%Create backUp files
H_Restore  = H;
H1_Restore = H1;
Y_Restore  = Y;
H2_Restore = H2;
% =========================================================================
Out=cell(num,1); %initialize empty cell container

%Set the test amd training datasets
for ii=1:num
    xtes       = H1(ii,:); %Select row for test kernel
    xtes(:,ii) = [];       %Delete corresponding column
    ytes       = Y(ii);    %Set single label for testing point
    Y(ii)      = [];       %Delete single test label from the label set
    H(ii,:)    = [];       %Delete test example Row from the kernel (Hessian) training set
    H(:,ii)    = [];       %Delete corresponding Row
    H2(ii,:)   = [];       %Delete test example Row from the kernel (Non Hessian) training set
    H2(:,ii)   = [];       %Delete corresponding Row
    xtr        = H;        %Set training kernel
    ytr        = Y;        %Set training label

    % =========================================================================
    %Avoid the problem where Hessian is badly conditioned
    xtr = xtr + 1e-10*eye(size(xtr));
    %Z{ii,1} = xtr;
    % =========================================================================
    m  = size(xtr,1);
    nm = size(xtes,1);    %Leave One out means this will always be 1

    %==========================================================================
    % Run Classifier
    Out{ii,1} = predictScore2(xtr,ytr, xtes,ytes, para);
    fprintf(' ---> %d of %d \n',ii,num)

    %==========================================================================
    %Compute kernel evaluation
    Ky          = ytr*ytr';

    KerAnalysis{1,1}    = 'Kernel Target Alignment';
    KerAnalysis{ii+1,1} = kernelAlignment(H2, Ky);

    KerAnalysis{1,2}    = 'Kernel Spec Ratio';
    KerAnalysis{ii+1,2} = specRatio(H2);

    %==========================================================================
    %Delete and Restore Backed up files
    H  = [];  H1 =[];  Y = [];  H2 = [];
    xtr = [];xtes=[]; ytr=[];  ytes=[];

    H  = H_Restore; H1 = H1_Restore; Y = Y_Restore; H2 = H2_Restore;

end


