
function [ACC, F1,para, file] = ExtractSpecResults(A, n)

%This function takes A cell containing the results obtained from
%experiments with additional kernel manipulations - Centering and
%normalization. 
%input
%-----
% A - A cell containing the classification performance results
% n - The number of C parameters used in the exeriment
%
%output
%------
% Acc - A cell contianing the stacked accuracy achieved 
% F   - A cell 
Raw_Acc = {};
Raw_F1_score={};

for i = 1:n
    
    Raw          = A{i, 1}; %Extract the Raw data results
    indexname    = Raw(:,1); %Extract the first column
    Raw          = Raw(:,2:end); %Extract all results for the Raw data
    Raw_Acc      = [Raw_Acc; Raw(7,:)]; % Append the accuracy extract
    Raw_F1_score = [Raw_F1_score; Raw(8,:)]; % Append the F1 score extract

    clear Raw
end

Norm_Acc = {};
Norm_F1_score={};

for i = 1:n
    Norm =A{i, 2}; %Extract the Normalised data results
    indexname = Norm(:,1); %Extract the first column
    Norm = Norm(:,2:end); %Extract all results for the Raw data
    Norm_Acc = [Norm_Acc; Norm(7,:)]; % Append the accuracy extract
    Norm_F1_score = [Norm_F1_score; Norm(8,:)]; % Append the F1 score extract
    clear Norm
end

Cen_Acc = {};
Cen_F1_score={};

for i = 1:n
    Cen =A{i, 3}; %Extract the Centralised data results
    indexname = Cen(:,1); %Extract the first column
    Cen = Cen(:,2:end); %Extract all results for the Raw data
    Cen_Acc = [Cen_Acc; Cen(7,:)]; % Append the accuracy extract
    Cen_F1_score = [Cen_F1_score; Cen(8,:)]; % Append the F1 score extract
    clear Cen
end

ACC = [Raw_Acc; Norm_Acc; Cen_Acc]; %Append
F1  = [Raw_F1_score; Norm_F1_score;Cen_F1_score];

ACC= [ACC; A{1, 1}(end,2:end)]; %append the file names
F1 = [F1;  A{1, 1}(end,2:end)]; %append the file names


for i=1:n
    para{i,1} = A{i,1}{end-1,2}; %Extract the C parameter
    file{i,1} = A{i,1}{end,2};   %Extract the file names
end

end