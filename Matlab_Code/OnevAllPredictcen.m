%@Nanomsky
%Function to make predictions


function [Out, KerAnalysis] = OnevAllPredictcen(A, para, Train, Test, Label)



addpath('/Volumes/My Book/libsvm-3.21/matlab');


% =========================================================================
%Extract the Training, Test and Label from the input File
H    = A{Train, 2}; % Kernel Matrix for training
H1   = A{Test,  2}; % Extract Kernel Test matrix
Y    = A{Label, 2}; % Extract label
H2   = A{Test,  2}; % Extract Kernel not the Hessian
num  = size(H,1); %establish the size of the kernel
% =========================================================================
%Normalise
H  = centerKernel(normaliseKernel(H));
H1 = centerKernel(normaliseKernel(H1));
H2 = centerKernel(normaliseKernel(H2));
% =========================================================================
%Create backUp files
H_Restore  = H;
H1_Restore = H1;
Y_Restore  = Y;
H2_Restore = H2;
Out=cell(num,1);
% =========================================================================
%Delete placeHolders
perNegEig=[]; predLabels=[]; specLabels=[]; TrueLabel=[]; KerAnalysis=[]; allModel =[];
Prob = []; ACC=[];
% =========================================================================
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


