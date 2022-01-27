%@Nanomsky
%Performance evaluation analysis of prediction made with kernels of various
%sizes. The input is the cell with the prediction results made with the
%methods applied to make the kernels PSD

function [PerfEval, PerfEvalFull] = analyseOnevAll4(G,s,L)
v = size(G{s, 1},1); %Establish size of the kernels used

TrueLabel=cell2mat(G{s, 2}(2:end,1)); %Extract the true labels
Pred_Raw=cell2mat(G{s, 2}(2:end, 2)); %Extract the predicted label without 
%any modification to make the kernel PSD

TrueLabelclip  =TrueLabel;
TrueLabelshift =TrueLabel;
TrueLabelflip  =TrueLabel;
TrueLabelsquare=TrueLabel;
TrueLabeltri   =TrueLabel;

if L > 0 %Key to indicate if there are any negative eigenvalues
    %=================================
    %Extract the predicted lables
    F = G{1,2}; 
    clip    = (F(2:v,3));
      
    xn1   =zeros(size(clip,1),1);

    for i=1:size(clip,1)
        if isempty(clip{i,1})
            xn1(i) = 1;
        end
    end

    M1 = find(xn1==1);
    if sum(xn1)~= 158
        for n=1:size(M1,1)
            ind1 = M1(n);
            TrueLabelclip(ind1) = [];
        end
    end
    %=================================
    
     shift   = (F(2:v,4));
       xn2   = zeros(size(shift,1),1);

    for i=1:size(shift,1)
        if isempty(shift{i,1})
            xn2(i) = 1;
        end
    end

    M2 = find(xn2==1);
    if sum(xn2)~= 158
        for n=1:size(M2,1)
            ind2 = M2(n);
            TrueLabelshift(ind2) = [];
        end
    end
     %=================================
    flip    = (F(2:v,5));
    xn3     = zeros(size(flip,1),1);

    for i=1:size(flip,1)
        if isempty(flip{i,1})
            xn3(i) = 1;
        end
    end

    M3 = find(xn3==1);
    if sum(xn3)~= 158
        for n=1:size(M3,1)
            ind3 = M3(n);
            TrueLabelflip(ind3) = [];
        end
    end
   
     %=================================
    square  = (F(2:v,6));
    
    xn4   =zeros(size(square ,1),1);

    for i=1:size(square ,1)
        if isempty(square{i,1})
            xn4(i) = 1;
        end
    end

    M4 = find(xn4==1);
    if sum(xn4)~= 158
        for n=1:size(M4,1)
            ind4 = M4(n);
            TrueLabelsquare(ind4) = [];
        end
    end
     %=================================
    tri     = (F(2:v,7));
    xn5     = zeros(size(tri,1),1);

    for i=1:size(tri,1)
        if isempty(tri{i,1})
            xn5(i) = 1;
        end
    end

    M5 = find(xn5==1);
    if sum(xn5)~= 158
        for n=1:size(M5,1)
            ind5 = M5(n);
            TrueLabeltri(ind5) = [];
        end
    end
    %=================================
    clip    = cell2mat(F(2:v,3));
    shift   = cell2mat(F(2:v,4));
    flip    = cell2mat(F(2:v,5));
    square  = cell2mat(F(2:v,6));
    tri     = cell2mat(F(2:v,7));
    %=================================
    %Calculate accuracy of prediction
    a1=sum(TrueLabelclip==clip)/(size(clip,1))*100;
    a2=sum(TrueLabelshift==shift)/(size(shift,1))*100; 
    a3=sum(TrueLabelflip==flip)/(size(flip,1))*100;
    a4=sum(TrueLabelsquare==square)/(size(square,1))*100;
    a5=sum(TrueLabeltri==tri)/(size(tri,1))*100;
    a6=sum(TrueLabel==Pred_Raw)/(size(Pred_Raw,1))*100;
    
    %=================================
    %Assign Rownames to PerfEval Cell  
    PerfEval{1,1} = 'clip';
    PerfEval{2,1} = 'shift';
    PerfEval{3,1} = 'flip';
    PerfEval{4,1} = 'square';
    PerfEval{5,1} = 'tri';
    PerfEval{6,1} = 'Raw';
    
    %=================================
    %Assign accuarcy values to col 2
    PerfEval{1,2} = a1;
    PerfEval{2,2} = a2;
    PerfEval{3,2} = a3;
    PerfEval{4,2} = a4;
    PerfEval{5,2} = a5;
    PerfEval{6,2} = a6;
    
    %=================================
    %Run performance Evaluation function
    [PerfEval{1,3}, PerfEval{1,4}] = EvaluTest2(TrueLabelclip, clip);
    [PerfEval{2,3}, PerfEval{2,4}] = EvaluTest2(TrueLabelshift, shift);
    [PerfEval{3,3}, PerfEval{3,4}] = EvaluTest2(TrueLabelflip, flip);
    [PerfEval{4,3}, PerfEval{4,4}] = EvaluTest2(TrueLabelsquare, square);
    [PerfEval{5,3}, PerfEval{5,4}] = EvaluTest2(TrueLabeltri, tri);
    [PerfEval{6,3}, PerfEval{6,4}] = EvaluTest2(TrueLabel, Pred_Raw);
    
    %=================================
    %Extract the performance results
    PerfEval{1,5} = PerfEval{1, 4}{8,2};
    PerfEval{2,5} = PerfEval{2, 4}{8,2};
    PerfEval{3,5} = PerfEval{3, 4}{8,2};
    PerfEval{4,5} = PerfEval{4, 4}{8,2};
    PerfEval{5,5} = PerfEval{5, 4}{8,2};
    PerfEval{6,5} = PerfEval{6, 4}{8,2};
end

if L==0  %Check if the kernel is PSD by having positive eigenvalues
    %=================================
    %Performance evaluation for PSD kernel
    a6=sum(TrueLabel==Pred_Raw)/(v-1)*100;
    PerfEval{1,1} = 'Raw';
    PerfEval{1,2} = a6;
    [PerfEval{1,3}, PerfEval{1,4}] = EvaluTest2(TrueLabel, Pred_Raw);
    PerfEval{1,5} = PerfEval{1, 4}{8,2};
end

%======================================================================
%Run performance Evaluation and extract all performance indices for all 
%modes used to convert to PSD

%==========================================================
%Add the column names for the alternative performance table
PerfEvalFull= {'True Positive','False Positive','True Negative','False Negative',...
    'Total Positives','Total Negatives','Accuracy','F-score',...
    'Recall','Precision','Sensitivity','Specificity',...
    'Rate of Positive Predictions','Rate of Negative Predictions',...
    'Miss - False Nagative Rate','Fallout - False Positive Rate',...
    'Negative Predictive Value'};

%===================================
%Extract rownames from PerfEval cell
RowHeader = PerfEval(:,1);

%===================================================================
%Iterate through perfEval and extract perfoamce values for all modes
for i=1:size(PerfEval,1)
    PerfEvalFull = [PerfEvalFull ; (PerfEval{i,4}(:,2))'];
end


AC           = cell(1,1);      %Create place holder for 1st cell
RowHeader    = [AC; RowHeader];%Add empty cell above the rowheaders 
PerfEvalFull = [RowHeader PerfEvalFull]; %Append to the PerfEvalFull Cell
end
