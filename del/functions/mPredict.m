%@Nanomsky
%Function to make predictions


function [G] = mPredict(A)

%input
%-----
% A - A cell container that has the kernel matrix, test kernel, Training label
% Hessian = Y(i)*kernel*Y(j)
% 
%output
%


addpath('/Volumes/My Book/libsvm-3.21/matlab');
%n=size(A,2)-1; %Previously used for


for s=1:1 
    
    % =========================================================================
    H    = A{1,s+1}; % Kernel Matrix for training
    H1   = A{2,s+1}; % Extract Kernel Test matrix
    Y    = A{3,s+1}; % Extract label
    H2   = A{2,s+1}; % Extract Kernel not the Hessian
    num  = size(H,1); %establish the size of the kernel
    % =========================================================================
    %Create backUp files
    
    H_Restore  = H;
    H1_Restore = H1;
    Y_Restore  = Y;
    H2_Restore = H2;
    
    % =========================================================================
    %PSD kernel conversion types
    
    Mode={'clip','shift','flip','square'};
    %numofmodes=numel(Mode)+1;
    numofmodes = 1;
    % =========================================================================
    %Delete placeHolders
    
    perNegEig=[]; predLabels=[]; specLabels=[]; TrueLabel=[]; KerAnalysis=[]; allModel =[];
    Prob = []; ACC=[];
    % =========================================================================
    %Set the test amd training datasets for LOOCV
    
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
        size(ytr)
        % =========================================================================
        %Avoid the problem where Hessian is badly conditioned
        
        xtr = xtr + 1e-10*eye(size(xtr));
        Z{ii,1} = xtr;
        % =========================================================================
        m  = size(xtr,1);
        nm = size(xtes,1);    %Leave One out means this size will always be 1
        %==========================================================================
        %Test for PSD kernel. Test the kernel rather than the Hessian
        
        if find(isnan(H2) | isinf(H2))
            L = Inf;
            sprintf(' No Eigen Decomposition. Kernel has a nan or Inf \n')
        else
            L = (sum(eig(H2) < 0)/m)*100;
            sprintf(' %d percent of eignevalues are less than zero \n', round(L))
        end
        
        perNegEig{1,1} ='percentage of eignevalues < 0';
        perNegEig{ii+1,1} = L;
        % =========================================================================
        % We train a model on the kernel matrix. If it is indefinite, we then
        % carry out spectrum modification to make the kernels psd
        fprintf(' ---> %d of %d \n',ii,num)
        
        for o=1:numofmodes
            if o==1
                
                model_precomputed = svmtrain(ytr, [(1:m)', H],'-t 4');
                
                [predict_label_P, acc, prob_estimates] = svmpredict(ytes, [(1:nm)', xtes], model_precomputed);
                
                specLabels{ii+1,1} = predict_label_P;
                specLabels{1,1} = 'Raw';
                
                Prob{ii+1,1} = prob_estimates;
                ACC{ii+1,1}  = acc;
                
                Prob{1,1} = 'prob_Raw';
                ACC{1,1}  = 'acc_Raw';
                
                MODEL{o,1} = 'Raw';
                MODEL{o,2} = model_precomputed;
                
            elseif o > 1 && L~=0
                
                mode=Mode{o-1};
                Hx = specmod(H, mode);
                
                model_precomputed = svmtrain(ytr, [(1:m)', Hx],'-t 4');
                [predict_label_P, acc, prob_estimates] = svmpredict(ytes, [(1:nm)', xtes], model_precomputed);
                
                specLabels{ii+1,o} = predict_label_P; %predicted label
                specLabels{1,o} = mode;
                
                Prob{ii+1,o} = prob_estimates; % SVM probability estimates
                Prob{1,o}    = mode;
                
                ACC{ii+1,o}  = acc; % Accuracy
                ACC{1,o}     = mode;
                
                MODEL{o+1,1}   = mode;
                MODEL{o+1,2}   = model_precomputed; % Model
            end
        end
        
        %==========================================================================
        allModel{ii,1}    = MODEL; MODEL = []; %Store LKO then delete the copy
        TrueLabel{ii+1,1} = ytes;
        TrueLabel{1,1}    = 'True labels';
        
        predLabels = [TrueLabel specLabels];
        
        %==========================================================================
        %Compute kernel evaluation
        Ky          = ytr*ytr';
        size(H2)
        size(ytr)
        KerAnalysis{1,1}    = 'Kernel Target Alignment';
        KerAnalysis{ii+1,1} = kernelAlignment(H2, Ky);
        
        KerAnalysis{1,2}    = 'Kernel Spec Ratio';
        KerAnalysis{ii+1,2} = specRatio(H2);
        
        %==========================================================================
        %Delete and Restore Backed up files
        H  = [];        H1 =[];          Y = [];        H2 = []; ytr=[];
        H  = H_Restore; H1 = H1_Restore; Y = Y_Restore; H2 = H2_Restore;
        
        
    end
    %==========================================================================
    %Assign files to cell G
    G{s,1} = perNegEig; G{s,2} = predLabels; G{s,3} = KerAnalysis; G{s,4} = allModel;
    G{s,5} = Prob;  G{s,6} = ACC;
    %B{s,1} = G4; B{s,2} = xn; B{s,3} = MM;
    
    %==========================================================================
    %Carry out performance evaluation of models used
   
    [~ ,T]  = analyseOnevAll3(G,s,L);
    T       = AnalyseStuff2(T,G,s);
    G{s,7}  = T;
    
    
end

%==========================================================================
%Add Column Names
ColNames={'Percentage EigenValues', 'Predicted Labels', 'Kernel Evaluation',...
    'Training model','Probabilities','Accuracy','Performance Eval'};
G = [ColNames;G];