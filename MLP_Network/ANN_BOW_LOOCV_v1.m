clc;
clear;

%Script to run MLP on the EHR bag-of-words features
%==================================================================
%Add location of functions to matlab path
addpath('./functions')
%==================================================================
load('./data/Nano_Layer_Desk1.mat') %load the network layers
load('./data/EHR_BOW_Data.mat') %load the EHR bow features. This contains
% both regular and binary bag-of-words features and the target label

%select the dataset to use
BOW2  = SBagofwords;
%BOW2 = SBinaryCount;

%select the target and set to categorical variable
Ylabel(Ylabel==-1)=0;
Y=Ylabel;
Y = categorical(Ylabel);

%Set the training options
options = trainingOptions('adam', ...
    'MaxEpochs',1000,...
    'InitialLearnRate',1e-4, ...
    'Verbose',false);

numFeatures = 3054;
numHiddenUnits = 150;
numClasses = 2;

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%Define the cross validation partition
c = cvpartition(Y,'LeaveOut');

for i =1: c.NumObservations
    
    %Extract train and test examples
    x_train = BOW2(training(c,i),:);
    y_train = Y(training(c,i),:);
    x_test = BOW2(test(c,i),:);
    y_test = Y(test(c,i),:);

    %==================================================================
    x_train = x_train';
    y_train = y_train';
    x_test  = x_test';
    y_test  = y_test';
    %==================================================================
    %Train the network
    net = trainNetwork(x_train, y_train,layers_1,options);
    %==================================================================
    %Predict target
    YPred = predict(net,x_test); 
    Yp = YPred>=0.5 ;%Find the values greater than 0.5
    YPred1=double(Yp(2,:)); %covert to double

    YTest1 = double(string(y_test)); %covert categorical test label to double

    % Store Results
    Result{i,1} = sum(YPred1 == YTest1)/numel(YTest1); %checks to see if the 
    %predicted value is the same as the true label

    [A, B] = EvaluTest2(YPred1, YTest1);
    Result{i,2} = A;
    Result{i,3} = B;
    Result{i,4} = YPred1; %store each predicted value
    Result{i,5} = YTest1; %Store corresponding true value
    
    clear A B
end

Res = sum(cell2mat(Result(:,1)))/size(Result(:,1),1);
fname = sprintf('RES_ANN_EHR_Bow_%d',1);
save(fname, 'options','Res','Result', 'layers_1','net','-v7.3')

