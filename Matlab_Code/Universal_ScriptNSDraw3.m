clear                                                                                                                        
clc
tic
%==========================================================================
% Desktop

addpath('/Users/osita/Dropbox/placeHolder/SantosPresentation')
addpath('/Users/osita/Dropbox/NanoToolBox')
nano_addPath('desktop')
addpath('/Volumes/Matlab/Proj1/functions')
rawpath = '/Volumes/Matlab/Proj1/ValidateRaw/Clinical/ker5';

mkdir /Volumes/Matlab/Proj1/ValidateRaw/Clinical/ker5/ Raw_NSD_er
FilePath = '/Volumes/Matlab/Proj1/ValidateRaw/Clinical/ker5/Raw_NSD_er'; 

% Laptop 2
% addpath('C:\Users\NN133\Dropbox\NanoToolBox')
% addpath('C:\Users\NN133\Dropbox\placeHolder\SantosPresentation');
% nano_addPath('laptop2')
% =========================================================================
%Load file
load('./K5_Clinical_exp/ARawFileName.mat') %files to combine
file = './K5_Clinical_exp/Anything.mat'; %needed to get the file path
[filepath,name,ext] = fileparts(file); %Split into constituent parts
%==========================================================================
%Set C parameter to use
c = -20:09:15;
para=2.^c;
%==========================================================================
%types of modifications
%specmode  = {'clip','shift', 'flip','square'};
specmode  = {'raw'};
typeNames = {'Raw','norm','cen'};
%==========================================================================
%initialise empty cell containers
vIND         = cell(length(typeNames),8); %Create empty cell
SpecM        = cell(length(specmode),1); %Create empty cell
specFilename = cell(size(rawFileName,1),1);
%==========================================================================

for i=1:size(rawFileName,1)
    
    %==================================================================
    %load files
    fname =  sprintf('%s/%s%s',filepath,rawFileName{i},ext); %Rearrange to suite the filenames
    load(char(fname)) %loads file
    %==================================================================
    %Perform spectrum modification
    %A = PerfromSpecMod(U);
    %==================================================================
    %rename and store the file
    specname  = sprintf('SpecM_%s',rawFileName{i});
    specname2 = fullfile(filepath,specname);
%     save(specname2, 'A')
%     specFilename{i,1} = specname2;
    %======================================================================
    for k=2:size(U,2)
        mode = specmode{k-1};
        U = U(1:3,k);
      
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
            [evaluateResults,B] =  AnalyseCDesRaw3(ytes, para, Out,i,type,mode,FilePath);
            vIND{j,3} = evaluateResults;
            vIND{j,4} = B;
            
            %======================================================================
            Kernel = U{1,1};
            vIND{j,5} = sum(sum(Kernel==0));
            vIND{j,6} = sum(sum(Kernel~=0));
            vIND{j,7} = type;
            vIND{j,8} = mode;
            
            vIND{5,1} = 'Result';
            vIND{5,2} = 'Kernel Analysis';
            vIND{5,3} = 'PerfEva';
            vIND{5,4} = 'AUC/ROC';
                        
            vIND{5,5} = 'sum(sum(Kernel==0))';
            vIND{5,6} = 'sum(sum(Kernel~=0))';
            vIND{5,7} = 'type';
            vIND{5,8} = 'mode';
            %delete to reset variables
            Out=[]; KerAnalysis=[]; evaluateResults=[]; B =[];
            
        end
        SpecM{k-1,1} = vIND;
        SpecM{k-1,2} = mode;
       
        vIND = [];
    end
    SpecM2{1,1} = SpecM;
    SpecM2{1,2} = fname;
    %SpecM2{1,3} = U;
    
    specname  = sprintf('Raw_Result%s',rawFileName{i});
    specname2 = fullfile(rawpath ,specname);
    save(specname2,'SpecM2','-v7.3')
    specFilename{i,1} = specname2;
    SpecM=[]; A =[]; fname=[]; SpecM2={};
end
T=toc;
save('specFilename','specFilename','T')

%==========================================================================
% fname1 = sprintf('SpecMResults_%s_%s',mode, type);
% fpath = fullfile(filepath, fname1); %concatenate filepath and filename
% save(fpath,'SpecM2','-v7.3')



