%This file takes the extracted MKL test file and returns values to be used
%in a plot

function [TT, mxcolAll, ind1All, mncolAll] = extractplotMKL(Test) 
C_para= Test{1, 1}(2:end,3); %Extract C parameter   

All =[]; % Create a container the length of the parameters
for i=1:size(Test,1)
All =[All cell2mat(Test{i, 1}(2:end,5))]; %extract the results
end

TT = (max(All,[],1));
[mxcolAll, ind1All] = max(max(All,[],1)); %Extract max F1 values per columns 
[mncolAll, ~] = min(max(All,[],1)); %Extract max F1 values per columns 
[~, ind2All] = max(max(All,[],2)); %Extract corresponding C value
fprintf('\n')
fprintf('Max F1 score %2.2f with C = %2.4f was achieved with kernel %d',mxcolAll,C_para{ind2All}, ind1All)
fprintf('\n')

