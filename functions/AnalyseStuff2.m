%@Nanomsky
%Function used to extract the mean kernel evaluation parameters and append
%this to the model evaluation cell

function T = AnalyseStuff2(T,G,s)

%Extract Kernel target Alignment mean
%====================================
T{1,19}  = 'Kernel Target Alignment';
T{2,19}  = mean(cell2mat(G{s,3}(2:end,1)));

%Extract Kernel Spectral Ratio mean
%==================================
T{1,20} = 'Mean Spectral Ratio';
T{2,20} =  mean(cell2mat(G{s,3}(2:end,2)));

T{1,21}  = 'Percentage Eignevalues';
T{2,21}  = mean(cell2mat(G{s,1}(2:end,1)));

end