
function [ACC, F1] = ExtractSpecResults(A)

Raw_Acc = {};
Raw_F1_score={};

for i = 1:4
    Raw          = A{i, 1}; %Extract the Raw data results
    indexname    = Raw(:,1); %Extract the first column
    Raw          = Raw(:,2:end); %Extract all results for the Raw data
    %RR           = Raw(:,FileIdx); %Filter out the indefinite kernels from 1:158
    Raw_Acc      = [Raw_Acc; Raw(7,:)]; % Append the accuracy extract
    Raw_F1_score = [Raw_F1_score; Raw(8,:)]; % Append the F1 score extract
    clear Raw 
end

Norm_Acc = {};
Norm_F1_score={};

for i = 1:4
    Norm =A{i, 2}; %Extract the Normalised data results
    indexname = Norm(:,1); %Extract the first column
    Norm = Norm(:,2:end); %Extract all results for the Raw data
    %RR = Norm(:,FileIdx); %Filter out the indefinite kernels from 1:158
    Norm_Acc = [Norm_Acc; Norm(7,:)]; % Append the accuracy extract
    Norm_F1_score = [Norm_F1_score; Norm(8,:)]; % Append the F1 score extract
    clear Norm 
end

Cen_Acc = {};
Cen_F1_score={};

for i = 1:4
    Cen =A{i, 3}; %Extract the Centralised data results
    indexname = Cen(:,1); %Extract the first column
    Cen = Cen(:,2:end); %Extract all results for the Raw data
    %RR = Cen(:,FileIdx); %Filter out the indefinite kernels from 1:158
    Cen_Acc = [Cen_Acc; Cen(7,:)]; % Append the accuracy extract
    Cen_F1_score = [Cen_F1_score; Cen(8,:)]; % Append the F1 score extract
    clear Cen 
end

ACC = [Raw_Acc; Norm_Acc; Cen_Acc]; %Append 
F1  = [Raw_F1_score; Norm_F1_score;Cen_F1_score];

% ACC_Cell{1,1} = 'Raw';
% ACC_Cell{1,2} = 'Norm';
% ACC_Cell{1,3} = 'Cen';
% ACC_Cell{2,1} = Raw_Acc;
% ACC_Cell{2,2} = Norm_Acc;
% ACC_Cell{2,3} = Cen_Acc;
% ACC_Cell{3,1} = Raw_F1_score;
% ACC_Cell{3,2} = Norm_F1_score;
% ACC_Cell{3,3} = Cen_F1_score;

%[maxRaw, IndRaw] = max(cell2mat(Raw_F1_score));

end