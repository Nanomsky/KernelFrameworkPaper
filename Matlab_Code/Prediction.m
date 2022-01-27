clc;
clear;

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%load file with the list of file names to test
file = '/Users/osita/Documents/GitHub/AntiCancer_Peptides/Pep_K1_squ/Ker_Peptide_squ_k_ed1_1.mat'; %needed to get the file path
[filepath,name,ext] = fileparts(file); %Split into constituent parts
load('/Users/osita/Documents/GitHub/AntiCancer_Peptides/Pep_K1_squ/FileName')
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%Create new folder to store the plots
mkdir ./plots
FilePath = './plots/';
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%Set C parameter to use
c = -20:05:15;
para=2.^c;

%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
for k=1:length(FileName)
    fname =  sprintf('%s/%s%s',filepath,FileName{k},ext); %Rearrange to suite the filenames
    
    load(char(fname)) %loads file
    
    %=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    Hess = U{1,2}; % Kernel Matrix for training
    kern = U{1,3}; % Extract raw kernel matrix
    Test = U{2,2}; % Extract Kernel Test matrix
    ytr  = U{3,2}; % Extract label
    yte  = U{3,4}; % Extract test label
    %=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    %Set size of the matrix
    m = size(Hess,1);
    n = size(Test,1);
    
    for i =1:length(para)
        
        C = para(i);
        fprintf('------> \n ')
        fprintf('--> %3.2f C parameter applied',C)
        fprintf(' \n ')
        model_precomputed = svmtrain(ytr, [(1:m)', Hess], ['-s 0 -t 4 -c ', num2str(C)]);
        [predict_label_P, acc, prob_estimates] = svmpredict(yte, [(1:n)', Test], model_precomputed);
        
        [X,Y,T,AUC] = perfcurve(yte,prob_estimates,1);
        
        B{1,1}   = 'C Parameter';
        B{1,2}   = 'Accuracy';
        B{1,3}   = 'Model';
        B{1,4}   = 'pred_label';
        B{1,5}   = 'prob_est';
        B{1,6}   = 'AUC';
        B{1,7}   = 'X-FPR';
        B{1,8}   = 'Y-TPR';
        B{1,9}   = 'Threshold';
        B{1,10}  = 'Kernel Target Alignment';
        B{1,11}  = 'Kernel Spec Ratio';
        B{1,12}  = 'Evaluation';
        B{1,13}  = 'ACC';
        B{1,14}  = 'F1';
        B{1,15}  = 'Sensitivity';
        B{1,16}  = 'Specificity';
        B{1,17}  = 'Filename';
        B{1,18}  = 'Eig';
        
        B{i+1,1}   = C;
        B{i+1,2}   = acc(1);
        B{i+1,3}   = model_precomputed;
        B{i+1,4}   = predict_label_P;
        B{i+1,5}   = prob_estimates;
        B{i+1,6}   = AUC;
        B{i+1,7}   = X;
        B{i+1,8}   = Y;
        B{i+1,9}   = T;
        B{i+1,10}  = kernelAlignment(kern, (ytr * ytr'));
        B{i+1,11}  = specRatio(kern);
        [~, Eva]   = EvaluTest2(yte, predict_label_P);
        B{i+1,12}  = Eva;
        B{i+1,13}  = Eva{7,2};
        B{i+1,14}  = Eva{8,2};
        B{i+1,15}  = Eva{11,2};
        B{i+1,16}  = Eva{12,2};
        B{i+1,17}  = fname;
        
        
        if find(isnan(kern) | isinf(kern))
            L = Inf;
            sprintf(' No Eigen Decomposition. Kernel has a nan or Inf \n')
        else
            L = (sum(eig(kern) < 0)/m)*100;
            sprintf(' %d percent of eignevalues are less than zero \n', round(L))
        end
        
        B{i+1,18}  = L;
        
        fig=figure;
        plot(X,Y)
        hold on
        plot([0 1],[0 1], '--r');
        title(sprintf('ROC plot with AUC = %.2f and C = %3.6f',AUC, C))
        xlabel('1 - Specificity (FPR)')
        ylabel('Sensitivity (TPR)')
        
        filename = sprintf('%s/%s_plot_%d',filepath,fname(78:end-4),i);
        %saveas(fig,filename,'epsc')
        saveas(fig,filename,'jpg')
        close(fig)
        
        %Clear and reset variaables to initial state
        model_precomputed =[];
        predict_label_P=[];  acc =[]; prob_estimates =[];
        X=[]; Y=[]; T=[];AUC =[];
        
    end
    %=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    %Save Result
    filename2 = sprintf('%s/RES_%s',filepath,FileName{k});
    save(filename2, 'B')
    RESFilename{k,1} = filename2;
    
    D{1,1}  = 'C Parameter';
    D{1,2}  = 'ACC';
    D{1,3}  = 'F1';
    D{1,4}  = 'Sensitivity';
    D{1,5}  = 'Specificity';
    D{1,6}  = 'Filename';
    D{1,7}  = '%-ve Eig';
    D   = [D; B(2:end,[1,13,14,15,16,17, 18])];
    
end
filename3 = sprintf('%s/RESFilename', filepath);
save(filename3, 'RESFilename', 'D')
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


