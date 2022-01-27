clear;
clc;
% @Nanomsky
%This script extracts the results generated for each kernel. It takes a
%file that stores its data in cells as inut. It then extracts the results according to
%the spec modification (Clip, flip, square, shift) and data orientation 
%'raw - Unchanged', 'normalised', and 'normalised+centralised')
%This scripts analyses the results from
% /Users/osita/Dropbox/placeHolder/SantosPresentation/Universal_Script_PSD_DeskTop2.m
%which is designed to capture all these aspects
%==========================================================================

% mkdir ../BreakDown
% FilePath = '../BreakDown/'; 

% load('/Volumes/Store/Proj1_Extra/K1_PatRefer_1/ARawFileName.mat') 
% FilePath = '/Volumes/Matlab/Proj1/ValidateRaw/PatRefer/ker1/';

% load('/Volumes/Store/Proj1_Extra/K5_PatRefer_exp/ARawFileName.mat') 
% FilePath = '/Volumes/Matlab/Proj1/ValidateRaw/PatRefer/ker5/';

% load('/Volumes/Matlab/Proj1/K6_PatRefer_exp/ARawFileName.mat') 
% FilePath = '/Volumes/Matlab/Proj1/ValidateRaw/PatRefer/ker6/';

% load('/Volumes/Matlab/Proj1/K7_PatRefer_exp/ARawFileName.mat')
% FilePath = '/Volumes/Matlab/Proj1/ValidateRaw/PatRefer/ker7/';

% load('/Volumes/Matlab/Proj1/K1_PRefer_1/ARawFileName.mat') 
% FilePath = '/Volumes/Matlab/Proj1/ValidateRaw/PRefer/ker1/';
% load('/Volumes/Store/Proj1_Extra/K5_PRefer_exp/ARawFileName.mat') 
% FilePath = '/Volumes/Matlab/Proj1/ValidateRaw/PRefer/ker5/';
load('/Volumes/Matlab/Proj1/K6_PRefer_exp/ARawFileName.mat') 
FilePath = '/Volumes/Matlab/Proj1/ValidateRaw/PRefer/ker6/';
% % load('/Volumes/Matlab/Proj1/K7_PRefer_exp/ARawFileName.mat') 
% % FilePath = '/Volumes/Matlab/Proj1/ValidateRaw/PRefer/ker7/';



[~, ~, ext] = fileparts('Anythin.mat');


for i=1:size(rawFileName,1)
    SpecName{i,1} = sprintf('Raw_Result%s',rawFileName{i});
end


for i=1: 1
    fname = sprintf(SpecName{i,1}, ext);
    sname = fullfile(FilePath, fname);
    load(sname)
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
    
    RawContainer1 = RawContainer1Bac;
    RawContainer2 = RawContainer2Bac;
    RawContainer3 = RawContainer3Bac;
    RawContainer4 = RawContainer4Bac;
    
    NormContainer1 = NormContainer1Bac;
    NormContainer2 = NormContainer2Bac;
    NormContainer3 = NormContainer3Bac;
    NormContainer4 = NormContainer4Bac;
    
    CenContainer1 = CenContainer1Bac;
    CenContainer2 = CenContainer2Bac;
    CenContainer3 = CenContainer3Bac;
    CenContainer4 = CenContainer4Bac;
    
    
    for i=1:length(SpecName)
        fname = sprintf(SpecName{i,1}, ext);
        sname = fullfile(FilePath, fname);
        load(sname)
        
        RawContainer1 = [RawContainer1 SpecM2{1, 1}{k, 1}{1, 3}(:,2)];
        RawContainer2 = [RawContainer2 SpecM2{1, 1}{k, 1}{1, 3}(:,3)];
        RawContainer3 = [RawContainer3 SpecM2{1, 1}{k, 1}{1, 3}(:,4)];
        RawContainer4 = [RawContainer4 SpecM2{1, 1}{k, 1}{1, 3}(:,5)];
        
        NormContainer1 = [NormContainer1 SpecM2{1, 1}{k, 1}{2, 3}(:,2)];
        NormContainer2 = [NormContainer2 SpecM2{1, 1}{k, 1}{2, 3}(:,3)];
        NormContainer3 = [NormContainer3 SpecM2{1, 1}{k, 1}{2, 3}(:,4)];
        NormContainer4 = [NormContainer4 SpecM2{1, 1}{k, 1}{2, 3}(:,5)];
        
        CenContainer1 = [CenContainer1 SpecM2{1, 1}{k, 1}{3, 3}(:,2)];
        CenContainer2 = [CenContainer2 SpecM2{1, 1}{k, 1}{3, 3}(:,3)];
        CenContainer3 = [CenContainer3 SpecM2{1, 1}{k, 1}{3, 3}(:,4)];
        CenContainer4 = [CenContainer4 SpecM2{1, 1}{k, 1}{3, 3}(:,5)];
        
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
    
    Xname = sprintf('RES_Raw_%s');
    breakDown = fullfile(FilePath,Xname);
    save(breakDown,'A')
    Xname=[]; A={};
    
    RawContainer1=[];  RawContainer2=[];  RawContainer3=[]; RawContainer4=[];
    NormContainer1=[]; NormContainer2=[]; NormContainer3=[];NormContainer4=[];
    CenContainer1=[]; CenContainer2=[]; CenContainer3=[]; CenContainer4=[];
end

