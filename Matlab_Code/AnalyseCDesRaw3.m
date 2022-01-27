function [evaluateResults,B] = AnalyseCDesRaw3(ytes, para, Out,ii,type,mode,FilePath)

% mkdir ./rawpath Raw_NSD_er
% FilePath = './K6_Therapy_exp/Raw_NSD_er/'; 

% Functionto extract 

%Ectract the results obtained for each C parameter 
for j=1:length(para)
    
    ExtractContainer = cell(1,5);
    ExtractContainer(1,:) = Out{1,1}(1,:);
    
    for k=1:size(Out,1)
        ExtractContainer = [ExtractContainer; Out{k,1}(j+1,:)];
    end
    
    ExtractResults{j,1} = para(j);
    ExtractResults{j,2} = ExtractContainer;
    ExtractContainer=[];
end

%==========================================================================
%Carry out performance evaluation for results obtained with each C
%parameter
pred = cell2mat(ExtractResults{1,2}(2:end,4)); %Extract an example result
[~, evaResultContainer] = EvaluTest2(ytes, pred); %Carry out evaluation Tests

evaluateResults = evaResultContainer(:,1); %Extract Row index names

for i =1:size(ExtractResults,1)
    pred = cell2mat(ExtractResults{i,2}(2:end,4)); %Extract result for each test
    [~, evaResultContainer] = EvaluTest2(ytes, pred); %Carry out performance evaluation
    evaluateResults = [evaluateResults evaResultContainer(:,2)]; %Append the results to file
end

%==========================================================================
%plot and display the results

% figure(1)
% bar(cell2mat(evaluateResults(7,2:end)), 'r') %plots the accuracy
% title(sprintf('%s %s Accuracy',mode,type))
% xlabel('Models specified by C Parameter')
% fname1 = sprintf('%s_%s_Acc_%d',mode,type,ii); %Generates the file name
% sname1 = fullfile(FilePath, fname1); %Concatenates the filepath/folder with file name
% saveas(figure(1),sname1,'jpg') 
% close(figure(1))


% figure(2)
% bar(cell2mat(evaluateResults(8,2:end))) %plots the F1 Score
% title(sprintf('%s %s F1-Score', mode,type))
% xlabel('Models specified by C Parameter')
% fname2 = sprintf('%s_%s_F1_%d',mode,type,ii);
% sname2 = fullfile(FilePath, fname2);
% saveas(figure(2),sname2,'jpg')
% close(figure(2))


%Plot sensitvity and specificity
% figure(3)
% plot(cell2mat(evaluateResults(11,2:end)),'r-^') %plot the sensitivity
% hold on
% plot(cell2mat(evaluateResults(12,2:end)),'b-*') %plot the specificity
% legend('Sensitivity','Specifity')
% 
% title(sprintf('%s %s Sensitivity Vs Specificity',mode,type))
% xlabel('Models specified by C Parameter')
% fname3 = sprintf('%s_%s_SenSpec_%d',mode,type,ii);
% sname3 = fullfile(FilePath, fname3);
% saveas(figure(3),sname3,'jpg')
% close(figure(3))
%==========================================================================
%Compute the AUC for each C parameter

B=[];
set(0,'DefaultFigureVisible','off') %set the display off/on
for i =1:size(ExtractResults,1)
    C = para(i);
    prob_estimates = cell2mat(ExtractResults{i,2}(2:end,5)); %Extract the probability estimates
    [FPR,TPR,T,AUC] = perfcurve(ytes,prob_estimates,1); %Compute AUC
    %===========================================================
    B{i,1}   = AUC; %store AUC values
    B{i,2}   = FPR; %Store the false positve rate
    B{i,3}   = TPR; %Store the True positive rate
    B{i,4}   = T;   %Store the threshold
%     A{i,1}   = prob_estimates; %for carrying out tests
%     A{i,2}   = ytes;
%     A{i,3}   = ExtractResults;
%     A{i,4}   = B;
    %===========================================================
    %Plot the AUC against C
    fig=figure;
    plot(FPR,TPR) %Plots FPR (X) vs TPR (Y)
    hold on
    plot([0 1],[0 1], '--r'); %diagonal line indicates result from chance i.e. 50%
    title(sprintf('%s %s ROC AUC = %.2f and C = %3.6f',mode,type,AUC, C))
    xlabel('1 - Specificity (FPR)')
    ylabel('Sensitivity (TPR)')
    
    %===========================================================
    %Save the plot
    fname4 = sprintf('%s_%s_plot%d_%d',mode,type,i,ii);
    sname4 = fullfile(FilePath, fname4);
    %saveas(fig,filename,'epsc')
    saveas(fig,sname4,'jpg')
    close(fig)
    prob_estimates = []; AUC=[]; FPR=[]; TPR=[];T=[];
end
% nano= fullfile(FilePath, 'nano');
% save(nano,'A');