clc;
clear;
StartTime=cputime;

%This script is used to execute kernel functions

addpath('./functions')

% =========================================================================
%create directory to store files
mkdir Exp_K1_all
FilePath = './Exp_K1_all/';
% =========================================================================
% %Load Data
load('./data/KF_Data.mat')

ytrFull   = cell2mat(data(2:end, 9));
colNames  = data(1,:); %for reference
data(1,:) = [];        %delete the header col;
% =========================================================================
%Select a table to use
table = 2; %Select tables between 2 - 7.
% 2 - clinical table
% 3 - recall table
% 4 - refer table
% 5 - repeat table
% 6 - test table
% 7 - therapy table
% =========================================================================
% Select the table for the experiment
Proj    = colNames{table}; %
Alldata = data(1:158,[1,table]); %select data
n=2;
% =========================================================================
%Test Model. Used for testing the script. Comment out to run on full
%complement of the data.

ytrFull = ytrFull(1:5);
Alldata = Alldata(1:5,:);
% =========================================================================
%Create backUp
AlldataRestore = Alldata; %create a back up
ytrFullRestore = ytrFull;
% =========================================================================
%Restore back up
% Alldata = AlldataRestore;
% ytrFull = ytrFullRestore;
% =========================================================================


num1=0; % Used for creating a list of filesnames for kernels created

%Default Kernels
kernel= {'k_ed1','k_ed5','k_ed6','k_ed7'};

t = length(kernel);


%AT=cell(numel(para)+1,2);
%nm = length(para);
% =========================================================================
Test = cell(size(ytrFull,1),1);

for q=1:size(ytrFull,1)
    zeroVector = Alldata(q,:);
    Alldata(q,:) = [];
    ytrFull(q)= [];
    Test{q,1} = zeroVector; %Test to make sure every example serves as the zero vector

    ker = kernel{1};
    % =======================================================================
    %Initialise the kernel matrices
    m  = size(Alldata,1);
    H1 = zeros(m,m);
    V1 = zeros(m,m);
    % =========================================================================
    kernConStartTime = tic;
    for i=1:m
        for k=1:i
            u = Alldata{i, 2}(:,n);  %extract sequence 1
            v = Alldata{k, 2}(:,n);   %Extract sequence 2
            p2 = zeroVector{1,2}(:,n); %zero vector

            %tstart1 = tic; %Start the clock
            a = stringKerA(ker,u,p2);
            b = stringKerA(ker,p2,v);
            c = stringKerA(ker,u,v);
            % ==============================================

            kcon =  0.5 * (a + b - c);
            % ==============================================
            H1(i,k) = ytrFull(i)*ytrFull(k)*kcon;
            V1(i,k) = kcon;
            %AT{1,1}   = 'NoParameter';

        end
        fprintf('%s_%d of %d of %d \n',ker,q,i,m)
    end

    %======================================================================

    %         H0 = H1;
    %         V0 = V1;
    % Flip the Triangular matrix
    H             =   H1+H1';
    V             =   V1+V1';
    H(1:m+1:end)  =   diag(H1);
    V(1:m+1:end)  =   diag(V1);

    kernConEndTime=toc(kernConStartTime);

    % Store Kernel Matrix
    U{1,2} = H;
    U{1,1} = 'Training Kernel Matrix';
    U{2,2} = V;
    U{2,1} = 'Test Kernel Matrix';
    U{3,1} = 'label';
    U{3,2} = ytrFull;
    U{4,1} = 'Kernel construction';
    U{4,2} = kernConEndTime;
    U{5,1} = 'Kernel';
    U{5,2} = ker;
    U{6,1} = 'Zero Vector';
    U{6,2} = p2;

    num1=num1+1;

    filename = sprintf('Kernel_%s_%s_%d',Proj, ker,q);
    FileName{num1,1} = filename; %filename to be used for reference for prediction

    fname = sprintf('%s',filename);
    fpath = fullfile(FilePath, fname);
    save(fpath,'U')

    U=[]; H=[]; V=[]; H0=[]; V0=[];

    Alldata = AlldataRestore; %restore from the backUp
    ytrFull = ytrFullRestore;
end

F1=cputime-StartTime;
sname = fullfile(FilePath, sprintf('FileName'));
save(sname,'FileName','F1');
