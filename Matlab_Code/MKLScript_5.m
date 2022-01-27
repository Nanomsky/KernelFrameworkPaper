clc;
clear;


addpath('/Volumes/Matlab/Proj1/functions')
addpath('/Users/osita/Dropbox/NanoToolBox')
nano_addPath('desktop')

Proj = 'PRefer';
mkdir ./MKL_PRefer_Result
FilePath = './MKL_PRefer_Result/';

Test = {};
for p=1:158
    
    tic
    % % File 1
    file1 = '/Volumes/Matlab/Proj1/K1_PRefer_1/PRefer_K1_notsquaredk_ed1_1_1.mat';
    
    [fpath1, fname1, ext] = fileparts(file1); %Extract the file parts
    newName1 = fname1(1:end-1); % Shorten the file name
    fname1   = sprintf('%s%d%s',newName1,p,ext); %Dynamically generate filename
    sname1   = (fullfile(fpath1,fname1)); % Concatenate full file name with path
    load(sname1) % load file
    KernelMatrix_1 = U{1,2}; %Extract kernel matrix
    label1 = U{3,2}; %extract the label
    U=[]; %delete the file
    file1 = []; fname1=[]; sname1=[]; newName1=[];
    
    
    % File 2
    file2 = '/Volumes/Store/Proj1_Extra/K5_PRefer_exp/PRefer_K5_normedk_ed1_1_1';
    
    [fpath2, fname2, ext] = fileparts(file2); %Extract the file parts
    newName2 = fname2(1:end-1); % Shorten the file name
    fname2   = sprintf('%s%d%s',newName2,p,ext); %Dynamically generate filename
    sname2   = (fullfile(fpath2,fname2)); % Concatenate full file name with path
    load(sname2) % load file
    KernelMatrix_2 = U{1,2}; %Extract kernel matrix
    label2 = U{3,2}; %extract the label
    U=[]; %delete the file
    clear file2 fname2 sname2 newName2
    
    
    % File 3
    file3 = '/Volumes/Matlab/Proj1/K6_PRefer_exp/PRefer_K6_normedk_ed1_1_1.mat';
    
    [fpath3, fname3, ext] = fileparts(file3); %Extract the file parts
    newName3 = fname3(1:end-1); % Shorten the file name
    fname3   = sprintf('%s%d%s',newName3,p,ext); %Dynamically generate filename
    sname3   = (fullfile(fpath3,fname3)); % Concatenate full file name with path
    load(sname3) % load file
    KernelMatrix_3 = U{1,2}; %Extract kernel matrix
    label3 = U{3,2}; %extract the label
    U=[]; %delete the file
    clear file3 fname3 sname3 newName3
    
    
    % File 4
    file4 = '/Volumes/Matlab/Proj1/K7_PRefer_exp/PRefer_K7_normedk_ed1_1_1.mat';
    
    [fpath4, fname4, ext] = fileparts(file4); %Extract the file parts
    newName4 = fname4(1:end-1); % Shorten the file name
    fname4   = sprintf('%s%d%s',newName4,p,ext); %Dynamically generate filename
    sname4   = (fullfile(fpath4,fname4)); % Concatenate full file name with path
    load(sname4) % load file
    KernelMatrix_4 = U{1,2}; %Extract kernel matrix
    label4 = U{3,2}; %extract the label
    U=[]; %delete the file
    clear file4 fname4 sname4 newName4
    
    % Check the labels of files to combine are equal
    if (label1==label2) & (label3==label4)
        Y = label1;
    else
        disp('Labels not the same')
    end
    
    clear label1 label2 label3 lable4
    
    K = zeros(157,157,4);
    
    K(:,:,1) = normalise(KernelMatrix_1);
    K(:,:,2) = normalise(KernelMatrix_2);
    K(:,:,3) = normalise(KernelMatrix_3);
    K(:,:,4) = normalise(KernelMatrix_4);
    
    L = K;
    [m,n,g] = size(K);
    
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
    C1 = -10:5:10;
    
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
        
        clear Z error C ZPred Zytes ConfusionTable An
        
    end
    
    colName = {'MKLData','% Error','C Parameter','Accuracy','F-Score','Confusion Mat','PerfEval'};
    B = [colName; B];
    
    Test{p,1} = B;
    Test{p,2} = KKA;
    Test{p,3} = KAT;
    Test{p,4} = toc;
    
    clear B KKA KAT toc tic colName
    sprintf('%d of 158 done',p)
end

filename = sprintf('MKL_%s%s',Proj,ext);
loc = fullfile(FilePath,filename);
save(loc, 'Test','-v7.3')


