function [ConfusionTable, A] = EvaluTest2(ylabel, Pred)
% Function for computing predictive performance
%
% input:
%-------
% ylabel = True label
% Pred   = Predicted label

% Output:
%-------
% Confusion table = A confusion table detailing the predictive performance
% in terms of True Positives, False Postives, True Negative, False Negative
% A   = A cell containing several performance evaluation measures


if nargin < 2
    error('Too few input arguments');
else
    
    
    z1 = (ylabel==1) &  (Pred==1); % Label true and prediction also true - True positive
    z2 = (ylabel==1) &  (Pred~=1); % Label true but prediction says false - False negative
    z3 = (ylabel~=1) &  (Pred~=1); % Label false and prediction also false  - True negative
    z4 = (ylabel~=1) &  (Pred==1); % Label false but prediction says true  - False positive
    
    TP         = sum(z1); %number of true positives
    FN         = sum(z2); %number of false negatives
    TN         = sum(z3); %mumber of true negatives
    FP         = sum(z4); %number of false positives
    Pos        = TP+FP;                % sum of TP and FP
    Neg        = TN+FN;
    accu       = round(((TP+TN)/(TP+FN+FP+TN)*100),2); % accuracy
    sen        = TP/(TP+FN);            % true positive rate,sensitivity,recall
    spec       = TN/(TN+FP);            % true negative rate, specificity
    RPP        = (TP+FP)/(TP+FN+FP+TN); % rate of positive predictions
    RNP        = (TN+FN)/(TP+FN+FP+TN); % rate of negative predictions
    miss       = FN/(TP+FN);            % false negative rate, miss
    fall       = FP/(TN+FP);            % false positive rate, fallout
    NPV        = TN/(TN+FN);            % negative predictive value
    recall     = round(TP/(TP+FN),2);   % Recall describes the completeness of the classification
    precision  = round(TP/(TP+FP),2);   % precision measures the actual accuracy of the classification
    Fscore     = round(2 * ((precision * recall) / (precision + recall)),2);
    % FScore is a single measure that combines recall and precision
    % Having precision  closer to 1 is ideal.
    % With Recall, it means we didn't predict something as false when it is
    % actually meant to be true. With Precision, it means we haven't said something is
    % positive when it is actually meant to be negative. It tells us how accurate our predcition is.
    
    A{1,1}  = 'True Positive';
    A{1,2}  = TP;
    A{2,1}  = 'False Positive';
    A{2,2}  = FP;
    A{3,1}  = 'True Negative';
    A{3,2}  = TN;
    A{4,1}  = 'False Negative';
    A{4,2}  = FN;
    A{5,1}  = 'Total Positives';
    A{5,2}  = Pos;
    A{6,1}  = 'Total Negatives';
    A{6,2}  = Neg;
    A{7,1}  = 'Accuracy';
    A{7,2}  = accu;
    A{8,1}  = 'F-score';
    A{8,2}  = Fscore;
    A{9,1}  = 'Recall';
    A{9,2}  = recall;
    A{10,1} = 'Precision';
    A{10,2} = precision;
    A{11,1} = 'Sensitivity';
    A{11,2} = sen;
    A{12,1} = 'Specificity';
    A{12,2} = spec;
    A{13,1} = 'Rate of Positive Predictions';
    A{13,2} = RPP;
    A{14,1} = 'Rate of Negative Predictions';
    A{14,2} = RNP;
    A{15,1} = 'Miss - False Nagative Rate';
    A{15,2} = miss;
    A{16,1} = 'Fallout - False Positive Rate';
    A{16,2} = fall;
    A{17,1} = 'Negative Predictive Value';
    A{17,2} = NPV;
    
    
    RowsNames={'NumberPredicted'};
    Varname = {'TruePos','FalsePos','TrueNeg','FalseNeg'};
    Perf_1 =[ TP FP TN FN];
    ConfusionTable = array2table(Perf_1,'VariableNames', Varname, 'RowNames',RowsNames);
    
end