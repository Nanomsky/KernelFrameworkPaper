clc;
clear;

tic
load('/Volumes/Store/Proj1_Extra/K1_Test_1/Test_K1_notsquaredk_ed1_1_14.mat')
f1 = U{1,2};
label = U{3,2}; U=[];
load('/Volumes/Matlab/Proj1/K5_Test_exp/Test_K5_normedk_ed1_1_14.mat')
f2 = U{1,2};
U=[];
load('/Volumes/Matlab/Proj1/K6_Test_exp/Test_K6_normedk_ed1_1_14.mat')
f3 = U{1,2};
U=[];
load('/Volumes/Matlab/Proj1/K7_Test_exp/Test_K7_normedk_ed1_1_14.mat')
f4 = U{1,2};
U=[];


K = zeros(157,157,4);

K(:,:,1) = normalise(f1);
K(:,:,2) = normalise(f2);
K(:,:,3) = normalise(f3);
K(:,:,4) = normalise(f4);

L = K;

Y = label;
[m,n,g] = size(K); %extract

%========================================================================

KKA=zeros(g,g);
KAT=zeros(g,1);

for r=1:g
    for b=1:g
       KKA(r,b) =  kernelAlignment(L(:,:,r), L(:,:,b));
    end
       KAT(r,1) =  kernelAlignment(L(:,:,r),Y*Y');
end

%% BackUp Data

K_Restore  = K;
L_Restore  = L;
Y_Restore  = Y;

% =========================================================================
%% Initalise parameters 
%C1={0.000000869, 0.0000325, 0.000105, 0.007051,2,15,125};
C1 = -10:0.5:10;
for l=1:length(C1)
%C=C1{l};
C = 2.^C1(l);
%% Initalise MKL parameters 
verbose=0;

options.algo='svmclass'; % Choice of algorithm in mklsvm can be either
                         % 'svmclass' or 'svmreg'
%------------------------------------------------------
% choosing the stopping criterion
%------------------------------------------------------
options.stopvariation=1;  % use variation of weights for stopping criterion 
options.stopKKT=0;        % set to 1 if you use KKTcondition for stopping criterion    
options.stopdualitygap=0; % set to 1 for using duality gap for stopping criterion

%------------------------------------------------------
% choosing the stopping criterion value
%------------------------------------------------------
options.seuildiffsigma=1e-2;        % stopping criterion for weight variation 
options.seuildiffconstraint=0.1;    % stopping criterion for KKT
options.seuildualitygap=0.01;      % stopping criterion for duality gap

%------------------------------------------------------
% Setting some numerical parameters 
%------------------------------------------------------
options.goldensearch_deltmax=1e-1; % initial precision of golden section search
options.numericalprecision=1e-8;   % numerical precision weights below this value
                                   % are set to zero 
options.lambdareg = 1e-8;          % ridge added to kernel matrix 

%------------------------------------------------------
% some algorithms paramaters
%------------------------------------------------------
options.firstbasevariable='first'; % tie breaking method for choosing the base 
                                   % variable in the reduced gradient method 
options.nbitermax=1000;            % maximal number of iteration  
options.seuil = 1e-32;              % forcing to zero weights lower than this 
options.seuilitermax=0;           % value, for iterations lower than this one 

options.miniter=0;                 % minimal number of iterations 
options.verbosesvm=0;              % verbosity of inner svm algorithm 
options.efficientkernel=0;         % use efficient storage of kernels 

%==========================================================================
%% MKL  - Leave one out

for ii=1:m
    R=L(ii,:,:);          % Select the test kernel array. Leave one out point
    R(:,ii,:)  = [];      % Delete the col computed with the LOO data
    ytes       = Y(ii);   % LOO test lable
    Y(ii)      = [];      % Delete LOO from the training label
    K(ii,:,:)  = [];      % Delete LOO from training dataset
    K(:,ii,:)  = [];      % Delete corresponding col
    ytr        = Y;       % Set
    
    %Store the test data for further analysis
    An{1,1}    = R;
    An{1,2}    = K;
    An{1,3}    = ytes;
    An{1,4}    = Y;
    
    %% Run MKL
    % Outputs
    % =======
    % Sigma         : the weigths
    % Alpsup        : the weigthed lagrangian of the support vectors
    % w0            : the bias
    % pos           : the indices of SV
    % history       : history of the weigths
    % obj           : objective value
    % status        : output status (sucessful or max iter)
    
    [Sigma,Alpsup,w0,pos,history,obj,status] = mklsvm(K,ytr,C,options,verbose);
    
    %fprintf('The Sigma value of %2.2f was obtained \n',Sigma)
    
    %Store results
     Z{1,1}      = 'Sigma';
     Z{1,2}      = 'Alpsup';
     Z{1,3}      = 'w0';
     Z{1,4}      = 'pos';
     Z{1,5}      = 'history';
     Z{1,6}      = 'obj';
     Z{1,7}      = 'status';
     
     Z{ii+1,1}   = Sigma;
     Z{ii+1,2}   = Alpsup;
     Z{ii+1,3}   = w0;
     Z{ii+1,4}   = pos;
     Z{ii+1,5}   = history;
     Z{ii+1,6}   = obj;
     Z{ii+1,7}   = status;
    %==========================================================================
    %% Extract test LOO kernel 
    [m3, n3, l3] = size(R);
    
    M=zeros(m3,m3); %Initialise test matrice array
    for i=1:l3
        M=M+ R(:,:,i).*Sigma(i); %Compute weighted combination of test kernels
    end
    
    M1=M(:,pos); % Reduce the input test kernel with the Support Vectors
    
    %Store test kernel matrix
    Z{1,8}     = 'Test_Mat'; 
    Z{ii+1,8}  = M1; % dont know why IO had removed this
   
    %==========================================================================
    %% Make Prediction
    YPred      = sign(M1 * (Alpsup.* ytes) + w0); %To be deleted
    Z{ii+1,9}  = sign(M1 * (Alpsup.* ytes) + w0);
    Z{1,9}     = 'Predicted Label';
    
    Z{1,10}      = 'True Label';
    Z{ii+1,10}    = ytes;
    %==========================================================================
    %% Error Analysis
   
    error(ii)   = sum(ytes~=YPred)/length(ytes) *100; 
    Z{ii+1,11}  = sum(ytes~=YPred)/length(ytes) *100;
    Z{1,11}     = 'error';
    
    % Store test data
    %Z{1,12}     = 'Test Data';
    %Z{ii+1,12}  = A;
    
    %Restore the data for the next iteration
    K    = K_Restore;
    L    = L_Restore;
    Y    = Y_Restore;
    ytes = [];
    An    = [];
    YPred= []; 
end

%Store the data
B{l,1} = Z;
B{l,2} = sum(error)/(m); %Show percentage error obtained
B{l,3} = C;
ZPred = cell2mat(Z(2:end,9));
Zytes = cell2mat(Z(2:end,10));
[ConfusionTable, An] = EvaluTest2(Zytes, ZPred);
B{l,4} = An{7,2};
B{l,5} = An{8,2};
B{l,6} = ConfusionTable;
B{l,7} = An;
Z=[]; error=[]; C=[]; ZPred=[]; Zytes=[]; ConfusionTable=[]; An =[];

end
T=toc;
colName = {'MKLData','% Error','C Parameter','Accuracy','F-Score','Confusion Mat','PerfEval'};
B = [colName; B];
%filename = sprintf('%s_%d_MKL_%d',newname,j,m);
save('Test1', 'B','KKA','KAT','T','-v7.3')
B =[]; KKA = []; KAT=[]; K = []; L=[]; Y=[];

