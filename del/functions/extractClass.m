function Data = extractClass(ind,class,classdistrib,DgCell,num)
%Function used to extract even number of data from each class of a
%multicall data. Used to avoid the problem of class imbalance. For this
%experiment we want to select 43 items form each of the six classes
rng(ind) %Set the default random number generator so we can reproduce this
%input
%========
% class - numerical class label we want to extract
% classdistrib - The class distribution. Col 1 has the class and col 2
% number of examples with the class
% DgCell - Data we want to extract the classes from
% num - num of examples we wish to extract from each class
% label = the label from the data
%========---------==========---------=========---------=========--------===
label = cell2mat(DgCell(:,2));
classsize_1 = classdistrib(class+1,2); %extract the size of the class
randindex_1 = randperm(classsize_1); %Generate random index the length of the class
class_1_ind = randindex_1(1:num); %index to select 43 items of the class
class_1_Data = DgCell((label==class),:); %selects 43 data items of the same class

%Checks to see if the data we extracted has the class we want
if sum(cell2mat(class_1_Data(:,2))~= class) == 0
    disp('--> Correect class data extracted')
else
    disp('--> Check the code')
end

%Extract 43 examples from the data with the same class
Data = class_1_Data(class_1_ind,:);

end