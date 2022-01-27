%function takes a list of F1 and Accuracy and obtains the maximum value

function [REScl, FinVal,AllMaxF1_index,Accuracy] = ExtractMaxF1andAcc(clipmax, clip_Acc)

REScl = [clipmax' clip_Acc]; %Concatenate F1 and Accuracy

[maxF1, ~] = max(clipmax); %find maximum F1 score 
AllMaxF1_index = find(clipmax==maxF1); %Find number all F1 values that are equal to the max F1
Accuracy = clip_Acc(AllMaxF1_index) ;% Apply F1 Score max index to find corresponding accuracy
[~, ind4] = max(Accuracy); %Find the maximum accuracy and its index
finalIndex = AllMaxF1_index(ind4); %Select index with highest corresponding Accuracy

FinVal = REScl(finalIndex,:); %Obtain final F1 and Accuracy 
