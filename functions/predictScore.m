%@Nanomsky

function B = predictScore(H,ytr, H1,ytes, para)
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
    model_precomputed = svmtrain(ytr, [(1:m)', H], ['-s 0 -t 4 -c ', num2str(C)]);
    [predict_label_P, acc, prob_estimates] = svmpredict(ytes, [(1:n)', H1], model_precomputed);
    [X,Y,T,AUC] = perfcurve(ytes,prob_estimates,1);
    
    B{1,1}   = 'C Parameter';
    B{1,2}   = 'Accuracy';
    B{1,3}   = 'Model';
    B{1,4}   = 'pred_label';
    B{1,5}   = 'prob_est';
    B{1,6}   = 'AUC';
    B{1,7}   = 'X-FPR';
    B{1,8}   = 'Y-TPR';
    B{1,9}   = 'Threshold';
    
    B{i+1,1}   = C;
    B{i+1,2}   = acc(1);
    B{i+1,3}   = model_precomputed;
    B{i+1,4}   = predict_label_P;
    B{i+1,5}   = prob_estimates;
    B{i+1,6}   = AUC;
    B{i+1,7}   = X;
    B{i+1,8}   = Y;
    B{i+1,9}   = T;
    
    fig=figure;
    plot(X,Y)
    hold on
    plot([0 1],[0 1], '--r');
    title(sprintf('ROC plot with AUC = %.2f and C = %3.6f',AUC, C))
    xlabel('1 - Specificity (FPR)')
    ylabel('Sensitivity (TPR)')
    
    filename = sprintf('plot%d',i);
    %saveas(fig,filename,'epsc')
    saveas(fig,filename,'jpg')
    close(fig)
    
    %Clear and reset variaables to initial state
    model_precomputed =[];
    predict_label_P=[];  acc =[]; prob_estimates =[];
    X=[]; Y=[]; T=[];AUC =[];
end


