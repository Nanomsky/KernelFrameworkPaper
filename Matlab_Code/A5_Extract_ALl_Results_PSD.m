
clc
clear
%==========================================================================
%File to extract the best performing zero vector sequence for the psd kernels. 
%==========================================================================
%specify location of files and load the valid kernels list
load('./Exp_K1_All/PsdspecFilename')
file = './Exp_K1_All/k_ed3_1_1.mat';
[fpath,fname,~] = fileparts(file); %Split file to parts
%==========================================================================
numofFiles = length(specFilename);

for i=1:numofFiles %number of files
    Kernels{i,1} = specFilename{i,1};
    Results{i,1} = specFilename{i,1};
end
%=========================================================================
% Extract and append the percentage eigenvalues

kernelEva = 'kernelEva.mat'; 
kernelEva_Name = fullfile(fpath, kernelEva);
load(kernelEva_Name)

ind1 = 1:length(PsdKernels);
numOfPara = 4; %number of C regularization parameter
%==========================================================================
% Extract the results 


ResPsd = 'RES_Psd_.mat';
ResPsd_name = fullfile(fpath, ResPsd);
load(ResPsd_name)

[Psd_Acc, Psd_F1, para, File] = ExtractSpecResults(A,numOfPara); 
clear A

%=========================================================================
%Extract results and plot 
C = maxF1score(Psd_F1,fpath, para, File);

rawindex    = C{2,12};
%=========================================================================
for i=1:size(rawindex,2)
    raw_Acc_max{1,i}    = cell2mat(Psd_Acc(rawindex(i),i));      %Extracts rawaccuracy 
end

%Concatenates the accuracy into a collection of vectors
Acc = [cell2mat(raw_Acc_max)]';

%=========================================================================
CompareResult = cell(size(ind1,1),1); %initialise new container
ParaResult    = cell(size(ind1,1),1); %initialise new container

for k = 1:length(ind1)
    
    Results{ind1(k),3}  = C{2, 9}(1,k);
    Results{ind1(k),4}  = C{2, 8}(1,k);
    Results{ind1(k),5}  = raw_Acc_max{1,k};
   
    CompareResult{k,1}  = C{2, 8}(1,k);  
    ParaResult{k,1}     = C{2, 9}(1,k);
    
end
%==========================================================================
[F1Value,F1Index2] = max(cell2mat(CompareResult), [],2); % computes maximum F1 score


REAL = Results(:,[1,2]);

for k = 1:length(ind1)
    REAL{ind1(k),3}   = F1Value(k);                %Extracts the F1 Score
    REAL{ind1(k),4}   = Acc(k);                    %Extract the accuracy
    REAL{ind1(k),5}   = ParaResult(k,F1Index2(k)); %extracts the corresponding C parameter
end

%==========================================================================
%Make some plots
figure(5)
bar(cell2mat(REAL(:,3)))
title(sprintf('F1 score for Model %s %s',fpath(3:5),fpath(6:end)))
xlabel('Model')
ylabel('F1 Score')

filenamev = sprintf('%s_3',fpath(3:end));
sname = fullfile(fpath, filenamev);
%saveas(figure(1),sname,'epsc')
saveas(figure(4),sname,'jpg')

figure(6)
bar(cell2mat(REAL(:,4)))
title(sprintf('Accuracy for Model %s %s',fpath(3:5),fpath(6:end)))
xlabel('Model')
ylabel('Accuracy')

filenamep = sprintf('%s_4',fpath(3:end));
sname = fullfile(fpath, filenamep);
%saveas(figure(1),sname,'epsc')
saveas(figure(5),sname,'jpg')

%Find the best performing zero vector kernel
[KerValue, indKer] = max(cell2mat(REAL(:,3)));

fprintf('--> Project - %s',fpath(3:end))
fprintf('\n')
fprintf('--> Best zero Vector, example %d \n', indKer)
fprintf('\n')
fprintf('--> Best F1 Score %2.2f and Accuracy %2.2f', KerValue, cell2mat(REAL(indKer,4)))
fprintf('\n')
fprintf('--> With C Parameter %2.9f',  cell2mat(REAL{indKer,5}))
fprintf('\n')
%==========================================================================
%save file
specname  = sprintf('Analysis_%s',fpath(3:end));
specname2 = fullfile(fpath,specname);
save(specname2,'REAL','CompareResult','Results','-v7.3')
