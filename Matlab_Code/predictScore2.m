%@Nanomsky

function B = predictScore2(H,ytr, H1,ytes, para)
% Function used to classify data with the LibSVM algorithm. 

% input
% H - Training Kernel Matrix
% H1 - Test Kernel Matrix
% ytr - Training labels
% ytes - Test labels
% para  - A set of numeric C values 

% Output
% B - A Cell file containing the predicted values, AUC, and Accuracy.

m = size(H,1);
n = size(H1,1);

for i =1:length(para)
    
    C = para(i);
    fprintf('------> \n ')
    fprintf('--> %3.2f C parameter applied',C)
    fprintf(' \n ')
    model_precomputed = svmtrain(ytr, [(1:m)', H], ['-s 0 -t 4 -q -c ', num2str(C)]);
    [predict_label_P, acc, prob_estimates] = svmpredict(ytes, [(1:n)', H1], model_precomputed);
        
    
    B{1,1}   = 'C Parameter';
    B{1,2}   = 'Accuracy';
    B{1,3}   = 'Model';
    B{1,4}   = 'pred_label';
    B{1,5}   = 'prob_est';
    
    B{i+1,1}   = C;
    B{i+1,2}   = acc(1);
    B{i+1,3}   = model_precomputed;
    B{i+1,4}   = predict_label_P;
    B{i+1,5}   = prob_estimates;

    %Clear and reset variables to initial state
    model_precomputed =[];
    predict_label_P=[];  acc =[]; prob_estimates =[];

end


