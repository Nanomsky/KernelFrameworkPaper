clc;
clear;
StartTime=tic;
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%Script to run the kernel function on Anti Cancer peptide sequential data
%data from https://archive.ics.uci.edu/ml/datasets/Anticancer+peptides
proj = 'Peptide';
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
% Desktop
addpath('/Users/osita/Dropbox/NanoToolBox')
nano_addPath('desktop')
addpath('/Volumes/Matlab/Proj1/functions')
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%File downloaded from https://archive.ics.uci.edu/ml/datasets/Anticancer+peptides
filename='/Users/osita/Documents/GitHub/AntiCancer_Peptides/Anticancer_Peptides/ACPs_Breast_cancer.csv';

ACPsBreastcancer = importfile(filename, 2, 950);
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%load and Review data
%Data originally imported as a table
summary(ACPsBreastcancer.class)

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%Select even number of positive and negative classes
%Select all class 'inactive - virtual as the positive class
IV = ACPsBreastcancer(ACPsBreastcancer.class == 'inactive - virtual',:);
PosData = IV(1:199,:);
PosData.Y=ones(size(PosData,1),1);

%Select everything else as the positive class
NegData = ACPsBreastcancer(ACPsBreastcancer.class ~= 'inactive - virtual',:);
NegData.Y=ones(size(NegData,1),1) - 2;
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%shuffle the data
rng(0)
data    = vertcat(PosData, NegData);
randInd = randperm(size(data,1));
data    = data(randInd,{'sequence', 'Y'});
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%Split data into Train/Test/validation partitions
train = 0.8;
test = 0.2;

m = size(data,1);

tra_ind = round(m * train);
tes_ind = round(m * test);

xtr = table2cell(data(1:tra_ind,'sequence'));
ytr = cell2mat(table2cell(data(1:tra_ind,'Y')));

xte = table2cell(data((1+tra_ind): tes_ind+tra_ind,'sequence'));
yte = cell2mat(table2cell(data((1+tra_ind): tes_ind+tra_ind,'Y')));

xva = table2cell(data((1+tra_ind+ tes_ind): end,'sequence'));
yva = cell2mat(table2cell(data((1+tra_ind+ tes_ind): end,'Y')));
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%select the zero vector
size(xtr)
zeroVec = xtr(1:10,:);
xtr(1:10,:) = [];
ytr(1:10,:) = [];
%size(xtr,1) == length(ytr)
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%Check the distribution of the labels
sum(ytr==1)
sum(ytr==-1)

sum(yte==1)
sum(yte==-1)

sum(yva==1)
sum(yva==-1)

fprintf('pos train labels = %d \n',sum(ytr==1))
fprintf('neg train labels = %d \n',sum(ytr==-1))

fprintf('pos test labels = %d \n',sum(yte==1))
fprintf('neg test labels = %d \n',sum(yte==-1))

fprintf('pos val labels = %d \n',sum(yva==1))
fprintf('neg val labels = %d \n',sum(yva==-1))
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%create directory to store files
mkdir Pep_K7
FilePath = './Pep_K7/';
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%Test Model. Used for testing the script. Comment out to run on full
%dataset

% ytr = ytr(1:4);
% xtr = xtr(1:4,:);
% 
% yte = yte(1:2);
% xte = xte(1:2,:);
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%Default Kernels

num1=0; % Used for creating a list of filesnames for kernels created
kernel= {'k_ed1','k_ed5','k_ed6','k_ed7'};

selectker = 4;
nm = size(zeroVec,1);
Test = cell(size(zeroVec,1),1); %Store the zeroVec for further analysis

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%Initialise the kernel matrices
m  = size(xtr,1);
n  = size(xte,1);
H1 = zeros(m,m);
S1 = zeros(m,m);
V1 = zeros(n,m);
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%Run kernel function

for q=1:size(zeroVec,1)
    
    zeroVector = zeroVec(q,:);          %select zero sequence
    Test{q,1}  = zeroVector;            %Store the zero vector
    ker        = kernel{selectker};     %select kernel
    
    %=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    kernConStartTime = tic;
    for i=1:m
        for k=1:i
            
            u  = char(xtr{i,1});        %Extract sequence 1
            v  = char(xtr{k,1});        %Extract sequence 2
            p2 = char(zeroVector{1,1}); %zero vector
            %=-=-=-=-=-=-=-=-=-=-=-=-=-
            a = stringKerA(ker,u,p2);   %dist between seq1 and zero vec
            b = stringKerA(ker,p2,v);   %dist between seq2 and zero vec
            c = stringKerA(ker,u,v);    %dist between seq1 and seq2
            %=-=-=-=-=-=-=-=-=-=-=-=-=-
            %distance substitution method
            kcon      = 0.5 * (a + b - c); %Compute kernel function
            Hess      = ytr(i)*ytr(k)*kcon;
            H1(i,k) = Hess; %Store Hessian
            S1(i,k) = kcon; %store kernel matrix
            
        end
        fprintf('%s_%d of %d of %d \n',ker,q,i,m)
    end
    kernConEndTime=toc(kernConStartTime);
    TestStartTime = tic;
    
    %=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    %construct Test Kernel
    for ii=1:n
        for kk=1:m
            uu  = char(xte{ii,1});        %Extract sequence 1
            vv  = char(xtr{kk,1});        %Extract sequence 2
            pt  = char(zeroVector{1,1});  %zero vector
            %=-=-=-=-=-=-=-=-=-=-=-=-=-
            aa = stringKerA(ker,uu,pt);
            bb = stringKerA(ker,pt,vv);
            cc = stringKerA(ker,uu,vv);
            %=-=-=-=-=-=-=-=-=-=-=-=-=-
            %distance substitution method
            kconT       = 0.5 * (aa + bb - cc); %Compute kernel function
            V1(ii,kk) = kconT;
            
        end
        fprintf('Test_%s_%d of %d of %d \n',ker,q,kk,ii)
    end
    
    TestEndTime=toc(TestStartTime);
    
    %=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 
    % Flip the Triangular matrix
    H             =   H1+H1';
    S             =   S1+S1';
    H(1:m+1:end)  =   diag(H1);
    S(1:m+1:end)  =   diag(S1);
    %=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    % Store Kernel Matrix
    U{1,1} = 'Training Kernel Matrix';
    U{1,2} = H;
    U{1,3} = S;
    U{2,1} = 'Test Kernel Matrix';
    U{2,2} = V1;
    U{3,1} = 'label';
    U{3,2} = ytr;
    U{4,1} = 'Time';
    U{4,2} = kernConEndTime;
    U{4,3} = TestEndTime;
    U{5,1} = 'Kernel';
    U{5,2} = ker;
    U{6,1} = 'Kernel construct';
    U{6,2} = '0.5 *((k_ed7(u,p2)) + (k_ed7(p2,v)) - (k_ed7(u,v)) )' ;
    U{7,1} = 'Zero Vector';
    U{7,2} = zeroVector;
    %=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    num1=num1+1;
    filename = sprintf('Ker_%s_%s_%d',proj,ker,q);
    FileName{num1,1} = filename; %filename to be used for prediction
    %=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    fname = sprintf('%s',filename);
    fpath = fullfile(FilePath, fname);
    save(fpath,'U')
    
    U=[]; H=[]; V=[]; H0=[]; V0=[]; S=[]; S0=[];
    %=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
end
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
F1=cputime-StartTime;
sname = fullfile(FilePath, sprintf('FileName'));
save(sname,'FileName','F1', 'Test');