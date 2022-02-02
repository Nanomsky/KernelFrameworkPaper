
clc;
clear;
StartTime=cputime;
%Script to train an SVM classifier and make predictions using psd kernels
%Also applies kernel normalization and centering
% =========================================================================
% add the functions directory to path
addpath('.\functions')
% =========================================================================
%Load file generated from eigEva script
load('./Exp_K1_all/kernelEva.mat') % list of files
file = './Exp_K1_all/Kernel_Therapy_k_ed1_1.mat'; %Sample needed to get the file path
[filepath,name,ext] = fileparts(file); %Split into constituent parts
%==========================================================================
%Set a range of SVM C parameter
c = -20:09:15;
para=2.^c;
%==========================================================================
%Kernel is centered with 'cen'. This tests if the zeror vector used in
%computing the similarity between a pair of sequences relative to their
%distance to the center is the true origin of the vector space.
%'norm' normalizes the kernel values to between 0 and 1

typeNames = {'Raw','norm','cen'}; %Specifies Kernel normalization and centering
%==========================================================================
%initialise empty cell containers
vIND          = cell(length(typeNames),6); %Create empty cell
SpecM         = cell(1,1); %Create empty cell
specFilename  = cell(size(PsdKernels,1),1);
%==========================================================================
mode = 'Psd';

for i=1:size(PsdKernels,1) %Iterate through the list of files

    %load files
    fname =  sprintf('%s/%s%s',filepath,PsdKernels{i},ext);
    load(char(fname)) %loads file

    
    A = U(1:3,2); %extract kernel matrix

    for j=1:length(typeNames) 

        type = typeNames{j};
       
        %==================================================================
        %Carry out classification using leave one out Cross validation
        [Out, KerAnalysis] = LOOCVclassify(A, para, 1,2,3,type);
        
        vIND{j,1} = Out; %ci
        vIND{j,2} = KerAnalysis;
        Z{j,1} = type;
       
        %==================================================================
        %Analyse and breakdown the results
        ytes = A{3,1}; %Extract the label from the cell U
        [evaluateResults,B] =  performanceEvaluation(ytes, para, Out,i,type,mode);
        vIND{j,3} = evaluateResults;
        vIND{j,4} = B;
        LL = evaluateResults;
        GG = B;
        %======================================================================
        Kernel = A{1,1};
        %vIND{j,5} = sum(sum(Kernel==0));
        %vIND{j,6} = sum(sum(Kernel~=0));
        vIND{j,5} = type;
        vIND{j,6} = mode;
        %delete to reset variables
        Out=[]; KerAnalysis=[]; evaluateResults=[]; B =[];

       
    end
    %cols = {'Result','Analysis','Perf1','Perf2','ZeroTest','NonzeroTest','Type','Mode'};
    cols = {'Result','Analysis','Perf1','Perf2','Type','Mode'};
    vIND = [vIND; cols];

    SpecM{1,1} = vIND;
    SpecM{1,2} = mode;

    vIND = []; 

    SpecM2{1,1} = SpecM;
    SpecM2{1,2} = fname; A=[]; U=[];
    
    specname  = sprintf('Result_%s',PsdKernels{i});
    specname2 = fullfile(filepath,specname);
    save(specname2,'SpecM2','-v7.3')
    specFilename{i,1} = specname2;
   % SpecM=[];  fname=[];  SpecM2={};

end

fpath = fullfile(filepath, 'PsdspecFilename'); %concatenate filepath and filename
save(fpath,'specFilename')


% specname1 = sprintf('%s_specFilename',mode);
% specname3 = fullfile(filepath,specname1);
% save(specname3,'specFilename')
%==========================================================================
% fname1 = sprintf('SpecMResults_%s_%s',mode, type);
% fpath = fullfile(filepath, fname1); %concatenate filepath and filename
% save(fpath,'SpecM2','-v7.3')



