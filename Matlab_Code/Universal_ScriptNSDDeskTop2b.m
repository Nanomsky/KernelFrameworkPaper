clear                                                                                                                        
clc
%==========================================================================
% Desktop

addpath('/Users/osita/Documents/MATLAB/SantosPresentation')
%addpath('/Users/osita/Dropbox/placeHolder/SantosPresentation')
addpath('/Users/osita/Dropbox/NanoToolBox')
nano_addPath('desktop')
addpath('./functions')

% Laptop 2
% addpath('C:\Users\NN133\Dropbox\NanoToolBox')
% addpath('C:\Users\NN133\Dropbox\placeHolder\SantosPresentation');
% nano_addPath('laptop2')
% =========================================================================
%Load file
load('/Users/osita/Documents/GitHub/AntiCancer_Peptides/Pep_K1_nonsqu/kernelEva.mat') %files to combine
file = '/Users/osita/Documents/GitHub/AntiCancer_Peptides/Pep_K1_nonsqu/Ker_nonsquare_Peptide_squ_k_ed1_1.mat'; %needed to get the file path
[filepath,name,ext] = fileparts(file); %Split into constituent parts
%==========================================================================
%Set C parameter to use
c = -20:09:15;
para=2.^c;
%==========================================================================
%types of modifications
specmode  = {'raw','clip','shift', 'flip','square'};
typeNames = {'Raw','norm','cen'};
%==========================================================================
%initialise empty cell containers
vIND         = cell(length(typeNames),8); %Create empty cell
SpecM        = cell(length(specmode),1); %Create empty cell
specFilename = cell(size(validIndeKernels,1),1);
%==========================================================================
%for i=294:size(validIndeKernels,1)
for i=size(validIndeKernels,1)
    
    %==================================================================
    %load files
    fname =  sprintf('%s/%s%s',filepath,validIndeKernels{i},ext); %Rearrange to suite the filenames
    load(char(fname)) %loads file
    %==================================================================
    %Perform spectrum modification
    A = PerfromSpecMod(U);
    %==================================================================
    %rename and store the file
    specname  = sprintf('SpecM_%s',validIndeKernels{i});
    specname2 = fullfile(filepath,specname);
%     save(specname2, 'A')
%     specFilename{i,1} = specname2;
    %======================================================================
    for k=1:size(A,2)
        mode = specmode{k};
        U = A(1:3,k);
        
        for j=1:length(typeNames)
            
            type = typeNames{j};
            %======================================================================
            %Carry out leave one out Cross validation
            [Out, KerAnalysis] = OnevAllPredictvd(U, para, 1,2,3,type);
                                   
            vIND{j,1} = Out;
            vIND{j,2} = KerAnalysis;
            %======================================================================
            %Analyse and breakdown the results
            ytes = U{3,1}; %Extract the label from the cell U
            [evaluateResults,B] =  AnalyseCDes3c(ytes, para, Out,i,type,mode);
            vIND{j,3} = evaluateResults;
            vIND{j,4} = B;
            
            %======================================================================
            Kernel = U{1,1};
            vIND{j,5} = sum(sum(Kernel==0));
            vIND{j,6} = sum(sum(Kernel~=0));
            vIND{j,7} = type;
            vIND{j,8} = mode;
            %delete to reset variables
            Out=[]; KerAnalysis=[]; evaluateResults=[]; B =[];
            
        end
        SpecM{k,1} = vIND;
        SpecM{k,2} = mode;
       
        vIND = [];
    end
    SpecM2{1,1} = SpecM;
    SpecM2{1,2} = fname;
    SpecM2{1,3} = A;
    
    specname  = sprintf('Result_%s',validIndeKernels{i});
    specname2 = fullfile(filepath,specname);
    save(specname2,'SpecM2','-v7.3')
    specFilename{i,1} = specname2;
    SpecM=[]; A =[]; fname=[]; SpecM2={};
end
save('specFilename2','specFilename')
%==========================================================================
% fname1 = sprintf('SpecMResults_%s_%s',mode, type);
% fpath = fullfile(filepath, fname1); %concatenate filepath and filename
% save(fpath,'SpecM2','-v7.3')



