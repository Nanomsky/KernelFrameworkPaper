clear;
clc;
% @Nanomsky
%==========================================================================
%This script extracts the results generated for each kernel. It takes a
%file that stores its data in cells as input. It then extracts the results 
%according to the  data orientation 'raw - Unchanged', 'normalised', and
%'normalised+centralised')
%This script deals with results from kernels that are psd 
%==========================================================================

%specify location of files and load the psd kernels list
load('./Exp_K1_All/PsdspecFilename.mat') 
FilePath = './Exp_K1_All/';

[~, ~, ext] = fileparts('Anythin.mat');


for i=1: 1
    load(specFilename{i,1})
end

%Load a sample file to analyse
%Extract the vales for C
%Extract the spectral modification 
%==========================================================================
n=size(SpecM2{1, 1}{1, 1}{1, 1}{1, 1},1)-1;
C_param = SpecM2{1, 1}{1, 1}{1, 1}{1, 1}(2:5,1);
specMode = SpecM2{1, 1}(1,1);  

Sample1 = SpecM2{1, 1}{1, 1}{1, 3};  %Samples Result

%Create containers the size of C parameters
RawContainer1Bac = SpecM2{1, 1}{1, 1}{1, 3}(:,1);
RawContainer2Bac = SpecM2{1, 1}{1, 1}{1, 3}(:,1);
RawContainer3Bac = SpecM2{1, 1}{1, 1}{1, 3}(:,1);
RawContainer4Bac = SpecM2{1, 1}{1, 1}{1, 3}(:,1);

NormContainer1Bac = SpecM2{1, 1}{1, 1}{2, 3}(:,1);
NormContainer2Bac = SpecM2{1, 1}{1, 1}{2, 3}(:,1);
NormContainer3Bac = SpecM2{1, 1}{1, 1}{2, 3}(:,1);
NormContainer4Bac = SpecM2{1, 1}{1, 1}{2, 3}(:,1);

CenContainer1Bac = SpecM2{1, 1}{1, 1}{3, 3}(:,1);
CenContainer2Bac = SpecM2{1, 1}{1, 1}{3, 3}(:,1);
CenContainer3Bac = SpecM2{1, 1}{1, 1}{3, 3}(:,1);
CenContainer4Bac = SpecM2{1, 1}{1, 1}{3, 3}(:,1);
%
% for i =1:length(C_param)
%     fname=sprintf('extractC_%d',i);
%     save(fname,'ExtractContainer1')
%     extractFileName{i,1} = fname;
%     fname=[];
% end
%save('extractFileName','extractFileName')

for k=1:length(specMode)
   
    RawContainer1 = [RawContainer1Bac; 'Filename'];
    RawContainer2 = [RawContainer2Bac; 'Filename'];
    RawContainer3 = [RawContainer3Bac; 'Filename'];
    RawContainer4 = [RawContainer4Bac; 'Filename'];
    
    NormContainer1 = [NormContainer1Bac; 'Filename'];
    NormContainer2 = [NormContainer2Bac; 'Filename'];
    NormContainer3 = [NormContainer3Bac; 'Filename'];
    NormContainer4 = [NormContainer4Bac; 'Filename'];
    
    CenContainer1 = [CenContainer1Bac; 'Filename'];
    CenContainer2 = [CenContainer2Bac; 'Filename'];
    CenContainer3 = [CenContainer3Bac; 'Filename'];
    CenContainer4 = [CenContainer4Bac; 'Filename'];
    
    for i=1:length(specFilename)
       
        load(specFilename{i,1})
        
        RawContainer1 = [RawContainer1 [SpecM2{1, 1}{k, 1}{1, 3}(:,2);specFilename{i,1}]];
        RawContainer2 = [RawContainer2 [SpecM2{1, 1}{k, 1}{1, 3}(:,3);specFilename{i,1}]];
        RawContainer3 = [RawContainer3 [SpecM2{1, 1}{k, 1}{1, 3}(:,4);specFilename{i,1}]];
        RawContainer4 = [RawContainer4 [SpecM2{1, 1}{k, 1}{1, 3}(:,5);specFilename{i,1}]];
        
        NormContainer1 = [NormContainer1 [SpecM2{1, 1}{k, 1}{2, 3}(:,2);specFilename{i,1}]];
        NormContainer2 = [NormContainer2 [SpecM2{1, 1}{k, 1}{2, 3}(:,3);specFilename{i,1}]];
        NormContainer3 = [NormContainer3 [SpecM2{1, 1}{k, 1}{2, 3}(:,4);specFilename{i,1}]];
        NormContainer4 = [NormContainer4 [SpecM2{1, 1}{k, 1}{2, 3}(:,5);specFilename{i,1}]];
        
        CenContainer1 = [CenContainer1 [SpecM2{1, 1}{k, 1}{3, 3}(:,2);specFilename{i,1}]];
        CenContainer2 = [CenContainer2 [SpecM2{1, 1}{k, 1}{3, 3}(:,3);specFilename{i,1}]];
        CenContainer3 = [CenContainer3 [SpecM2{1, 1}{k, 1}{3, 3}(:,4);specFilename{i,1}]];
        CenContainer4 = [CenContainer4 [SpecM2{1, 1}{k, 1}{3, 3}(:,5);specFilename{i,1}]];
        
        sprintf('%d of %d',k,i)
    end
    A{1,1} = RawContainer1;
    A{2,1} = RawContainer2;
    A{3,1} = RawContainer3;
    A{4,1} = RawContainer4;
    A{5,1} = 'Raw';
    A{6,1} = SpecM2{1, 1}{k, 2};
    
    A{1,2} = NormContainer1;
    A{2,2} = NormContainer2;
    A{3,2} = NormContainer3;
    A{4,2} = NormContainer4;
    A{5,2} = 'Norm';
    A{6,2} = SpecM2{1, 1}{k, 2};
    
    A{1,3} = CenContainer1;
    A{2,3} = CenContainer2;
    A{3,3} = CenContainer3;
    A{4,3} = CenContainer4;
    A{5,3} = 'Cen';
    A{6,3} = SpecM2{1, 1}{k, 2};
    
    Xname = sprintf('RES_Psd_%s');
    breakDown = fullfile(FilePath,Xname);
    save(breakDown,'A')
    Xname=[]; A={};
    
    clear RawContainer1  RawContainer2  RawContainer3 RawContainer4
    clear NormContainer1 NormContainer2 NormContainer3 NormContainer4
    clear CenContainer1 CenContainer2 CenContainer3 CenContainer4
end

