clc;
clear;
StartTime=cputime;
%Script to train an SVM classifier and make predictions using indefinite kernels
%Also applies spectrum modifications , kernel normalization and centering
% Note: Two changes are required in order to use this script for the
% peptide experiment. Change the c parameter and  A = PerfromSpecModPep(U)
% =========================================================================
% add the functions directory to path
addpath('.\functions')
% =========================================================================
%Load file
load('./Exp_K1_dist/kernelEva.mat') % list of files
file = './Exp_K1_dist/Kernel_k_ed1_1.mat'; %needed to get the file path
[filepath,name,ext] = fileparts(file); %Split into constituent parts
%==========================================================================
%Set a range of SVM C parameter 
c = -20:09:15;
%c = -20:05:15; %Use this for the peptide data
para=2.^c;
%==========================================================================
%types of spectral modifications to be made
specmode  = {'Raw','clip','shift', 'flip','square'};
%Raw -Use the indefinte kernel as it is. i.e no modification
%==========================================================================
%Kernel is centered with 'cen'. This tests if the zeror vector used in
%computing the similarity between a pair of sequences relative to their
%distance to the center is the true origin of the vector space.
%'norm' normalizes the kernel values to between 0 and 1
typeNames = {'Raw','norm','cen'}; %Kernel normalization and centering
%'Raw' - no kernel manipulation 
%==========================================================================
%initialise empty cell containers
vIND         = cell(length(typeNames),8); %Create empty cell
SpecM        = cell(length(specmode),1); %Create empty cell
specFilename = cell(size(validIndeKernels,1),1);
%==========================================================================
%Iterate through the list of valid indefinite kernels
for i=1:size(validIndeKernels,1)
    
    %==================================================================
    %load files
    fname =  sprintf('%s/%s%s',filepath,validIndeKernels{i},ext); 
    load(char(fname)) %loads file
    %==================================================================
    %Perform spectrum modification to make the kernels PSD
    A = PerfromSpecMod(U);
    %A = PerfromSpecModPep(U); %Use this for the peptide experiment
    %==================================================================
    %rename and store the file
    specname  = sprintf('SpecM_%s',validIndeKernels{i});
    specname2 = fullfile(filepath,specname);
    %save(specname2, 'A')
    %specFilename{i,1} = specname2;
    %======================================================================
    for k=1:size(A,2)-1 % iterate through the various reconstructed kernels 
                        % -1 for the extra column for row names

        mode = specmode{k};
        U = A(1:3,k);
        
        for j=1:length(typeNames)
            
            type = typeNames{j};
            %======================================================================
            %Carry out classification using leave one out Cross validation
            [Out, KerAnalysis] = LOOCVclassify(U, para, 1,2,3,type);
                                   
            vIND{j,1} = Out;
            vIND{j,2} = KerAnalysis;
            %============================================================
            %Analyse and breakdown the results
            ytes                = U{3,1}; %Extract the label from the cell U
            [evaluateResults,B] = performanceEvaluation(ytes, para, Out,i,type,mode);
            vIND{j,3}           = evaluateResults;
            vIND{j,4}           = B;
            LL = evaluateResults;
            GG = B;
            %============================================================
            Kernel = U{1,1};
            vIND{j,5} = sum(sum(Kernel==0)); %Used to test the matrix is not all zeros
            vIND{j,6} = sum(sum(Kernel~=0)); %Relevant to spot exp computation resulting in all zero values
            vIND{j,7} = type;
            vIND{j,8} = mode;

            %delete to reset variables
            Out=[]; KerAnalysis=[]; evaluateResults=[]; B =[];
            
        end
        cols = {'Result','Analysis','Perf1','Perf2','ZeroTest','NonzeroTest','Type','Mode'};
        vIND = [vIND; cols];
        SpecM{k,1} = vIND;
        SpecM{k,2} = mode;
       
        vIND = [];
    end
    SpecM2{1,1} = SpecM;
    SpecM2{1,2} = fname;
    
    
    specname  = sprintf('Result_%s',validIndeKernels{i});
    specname2 = fullfile(filepath,specname);
    save(specname2,'SpecM2','-v7.3')
    specFilename{i,1} = specname2;
    %SpecM=[]; A =[]; fname=[]; SpecM2={};
end

fpath = fullfile(filepath, 'NsdspecFileName'); %concatenate filepath and filename
save(fpath,'specFilename')
%==========================================================================




