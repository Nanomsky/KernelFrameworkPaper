
clc
clear
%==========================================================================
%File to extract the best performing zero vector sequence. This goes
%through all the results achieved with the spectral modifications clip,
%flip, shift and square and selects the best result achieved
%==========================================================================
%specify location of files and load the valid kernels list
load('./Exp_K1_dist_NSD/NsdspecFileName')
file = './Exp_K1_dist_NSD/k_ed3_1_1.mat';
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

ind1 = 1:length(IndKernels);
numOfPara = 4; 
%numOfPara = 8; %Used for the peptide experiment
%==========================================================================
% Extract the results 
%load the results extracted for spectral modifications made to the kernels

specModes = {'raw','clip','shift','flip','square'}; %list of spectral modifucation

%Extract results for indefinite kernel with no modification
Resraw = 'RES_raw.mat'; %state filename
Resraw_name = fullfile(fpath, Resraw); %concatenate filename with file path
load(Resraw_name) %load files

[raw_Acc, raw_F1, para, File] = ExtractSpecResults(A, numOfPara); 
clear A

%Extract results for clip spectral modification
Resclip = 'RES_clip.mat'; %state filename
Resclip_name = fullfile(fpath, Resclip); %concatenate filename and file path
load(Resclip_name) %load files

[clip_Acc, clip_F1, ~, ~] = ExtractSpecResults(A, numOfPara); 
clear A

%Extract results for shift spectral modification
Resshift = 'RES_shift.mat';
Resshift_name = fullfile(fpath, Resshift);
load(Resshift_name)

[shift_Acc, shift_F1, ~, ~] = ExtractSpecResults(A, numOfPara);
clear A

%Extract results for flip spectral modification
Resflip = 'RES_flip.mat';
Resflip_name = fullfile(fpath, Resflip);
load(Resflip_name)

[flip_Acc, flip_F1, ~, ~] = ExtractSpecResults(A, numOfPara);
clear A

%Extract results for square spectral modification
Ressquare = 'RES_square.mat';
Ressquare_name = fullfile(fpath, Ressquare);
load(Ressquare_name)

[square_Acc, square_F1, ~, ~] = ExtractSpecResults(A, numOfPara);
clear A

%=========================================================================
%Extract results and plot 
C = maxF1scorex(raw_F1,clip_F1,shift_F1,flip_F1,square_F1,fpath, para, File);

rawindex    = C{2,12};
clipindex   = C{3,12};     
shiftindex  = C{4,12};   
flipindex   = C{5,12};     
squareindex = C{6,12};  
%=========================================================================
for i=1:size(clipindex,2)

    raw_Acc_max{1,i}    = cell2mat(raw_Acc(rawindex(i),i));      %Extracts rawaccuracy 
    clip_Acc_max{1,i}   = cell2mat(clip_Acc(clipindex(i),i));    %Extracts clip accuracy 
    shift_Acc_max{1,i}  = cell2mat(shift_Acc(shiftindex(i),i));  %Extracts shift accuracy
    flip_Acc_max{1,i}   = cell2mat(shift_Acc(flipindex(i),i));   %Extracts flip accuracy
    square_Acc_max{1,i} = cell2mat(square_Acc(shiftindex(i),i)); %Extracts square accuracy
end

%Concatenates the accuracy into a collection of vectors
Acc = [cell2mat(raw_Acc_max); cell2mat(clip_Acc_max); cell2mat(shift_Acc_max); ...
    cell2mat(flip_Acc_max); cell2mat(square_Acc_max)]';

%=========================================================================
CompareResult = cell(size(ind1,1),5); %initialise new container
ParaResult    = cell(size(ind1,1),5); %initialise new container

for k = 1:length(ind1)
    
    Results{ind1(k),3}    = C{2, 9}(1,k);
    Results{ind1(k),4}    = C{2, 8}(1,k);
    Results{ind1(k),5}    = raw_Acc_max{1,k};
    Results{ind1(k),6}    = C{3, 9}(1,k);
    Results{ind1(k),7}    = C{3, 8}(1,k);
    Results{ind1(k),8}    = clip_Acc_max{1,k};
    Results{ind1(k),9}    = C{4, 9}(1,k);  
    Results{ind1(k),10}   = C{4, 8}(1,k);
    Results{ind1(k),11}   = shift_Acc_max{1,k};
    Results{ind1(k),12}   = C{5, 9}(1,k);
    Results{ind1(k),13}   = C{5, 8}(1,k);
    Results{ind1(k),14}   = flip_Acc_max{1,k};
    Results{ind1(k),15}   = C{6, 9}(1,k);
    Results{ind1(k),16}   = C{6, 8}(1,k);
    Results{ind1(k),17}   = square_Acc_max{1,k};
    Results{ind1(k),18}   = k;
    CompareResult{k,1}  =    C{2, 8}(1,k);
    CompareResult{k,2}  =    C{3, 8}(1,k);
    CompareResult{k,3}  =    C{4, 8}(1,k);
    CompareResult{k,4}  =    C{5, 8}(1,k);
    CompareResult{k,5}  =    C{6, 8}(1,k);    

    ParaResult{k,1}  =    C{2, 9}(1,k);
    ParaResult{k,2}  =    C{3, 9}(1,k);
    ParaResult{k,3}  =    C{4, 9}(1,k);
    ParaResult{k,4}  =    C{5, 9}(1,k);
    ParaResult{k,5}  =    C{6, 9}(1,k);
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
%fprintf('--> %s spectral modification applied',specModes{F1Index2(KeyIndex)})
%==========================================================================
%save file
specname  = sprintf('Analysis_%s',fpath(3:end));
specname2 = fullfile(fpath,specname);
save(specname2,'REAL','CompareResult','ParaResult','Results','-v7.3')
