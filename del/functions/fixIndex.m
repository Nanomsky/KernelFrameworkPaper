
%File to fix problem where the some of the 158 files are indefinte and others
%are psd. We distribute the index to the exact position in a list of 158 

function [clipmax_C, clip_Acc_C] = fixIndex(clipmax,clip_Acc,FileIdx1)



clipmax_C  = zeros(1,158); %Create empty array 
clip_Acc_C = zeros(158,1); %Create empty array


clipmax_C(FileIdx1~=0) = clipmax; %index
clip_Acc_C(FileIdx1~=0) = clip_Acc;
