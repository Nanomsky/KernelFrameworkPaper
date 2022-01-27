
% example = 5;
% cvalue =4;
% 
% C1 = -10:5:10; %C parameters used by MKL
% C  = 2.^C1; 

function Container = mklrough2610(Test,example,cvalue,C,fnameSV, ind2)
%==========================================================================
Container = cell(7,2);

[a1,a2] = size(Test{1,2});
F = zeros(a1,a2);
for i=1:158
    
    F = F + Test{i, 2};
end

F(isnan(F)) = 0 ;
MeanF = round(F/158,4);

%==========================================================================
%Extract kernel alignment
%For each model, prior to computing the 0ne vs all, the kernel to kernel
%alignment score is determinedand stored in the second column of the Test
%result cell. Computes the alignment of the 4 kernel functions combined in
%the MKL model. Note the kernel alignment with itself is equal to 1

%varnames = {'Ker1','Ker5','Ker6','Ker7'}; 
%varnames = {'Ker1','Ker5'};
varnames = {'Test1','Test5','Test6','Test7','Repeat1','Repeat5','Repeat6','Repeat7','Clinical1','Clinical5','Clinical6'...
,'Clinical7','Therapy1','Therapy5','Therapy6','Therapy7','PRefer1','PRefer5','PRefer6','PRefer7'...
,'PatRefer1','PatRefer5','PatRefer6','PatRefer7'};
Tab1 = array2table(MeanF, 'VariableNames',varnames,'RowNames',varnames);
Container{1,1} = 'kernel kernel Alignment';
Container{1,2} = Tab1;
disp(Tab1) %Display the result

fprintf('Mean kernel alignment computation.')
fprintf('\n')
fprintf('This shows how close or distant the kernels are relative to each other ')
fprintf('\n')
fprintf('Values closer to 1 indicates how similar the kernels are')
fprintf('\n')
fprintf('\n')
%==================================================================
%This finds the alignment score for a specific example rather than the
%mean. Used to find the corresponding alignment scores for the example with
%the best F1 Score

BestExample = Test{example,2};

Tab1a = array2table(BestExample, 'VariableNames',varnames,'RowNames',varnames);
Container{2,1} = 'Single Example KKA';
Container{2,2} = Tab1a;

disp(Tab1a) %Display the result
fprintf('Mean kernel alignment computation of the best example. ')
fprintf('\n')
fprintf('\n')
%==================================================================
%This finds the mean kernel target alignment
[b1,b2] = size(Test{1, 3});

D=zeros(b1,b2);
for k=1:158
D= D + Test{k, 3}; 
end
D(isnan(D))=0;
MeanD = round(D/158,4);

%==================================================================
%Places the mean target alignemnt into a table
varnames2 = {'KAT'}; 
Tab2 = array2table(MeanD, 'VariableNames',varnames2,'RowNames',varnames);
Container{3,1} = 'Kernel Target Alignment';
Container{3,2} = Tab2;

disp(Tab2) 
fprintf('Mean kernel Target alignment computation. ')
fprintf('\n')
fprintf('This shows how close or distant the kernels are to the label. ')
fprintf('\n')
fprintf('Higher values indicates how close the kernel approximates the target - Y')
fprintf('\n')
fprintf('\n')
%==================================================================
BestexampleKAT = round(cell2mat(Test(example, 3)),4);
Tab2a = array2table(BestexampleKAT, 'VariableNames',varnames2,'RowNames',varnames);
Container{4,1} = 'Single example KAT';
Container{4,2} = Tab2a;

disp(Tab2a) 
fprintf('Mean kernel Target alignment computation for best example. ')
fprintf('\n')
fprintf('\n-->')
%==========================================================================
%Extract the number of 
A  = zeros(157,1); %Since 1 v all, we initialize container for 157 examples
c1 = size(Test{1, 1},1)-1; %For each test we had c1 parameter (5)
SigmaAll = cell(158,1);
MeanSigma = cell(158,1);
AllSV = cell(158,1);

xx=size(Test{1,1}{1+1,1}{1+1, 1},2); %Get size for Sigma
for i=1:158
    
    for n=1:c1 %iterate through the 5 C values
        B=zeros(1,xx); %initalize container for Sigma
        A = zeros(157,1); %Initialise a container for number os support vectors
        for k=1:157 %iterate thru 157 test examples. One example is the zero vector
            A(k,1) = size(Test{i,1}{n+1,1}{k+1, 4},1); %Extract number of SV
            B = [B; Test{i,1}{n+1,1}{k+1, 1}]; %append the sigma for each model
        end
        
        AllSV{i,n} = round(mean(A));
        SigmaAll{i,n} = B(2:end,:);
        MeanSigma{i,n} = mean(B(2:end,:));
        
        clear A B
    end
end

%Find Sigma and SVs for the given example
TabSig = array2table(round(cell2mat(MeanSigma(example,cvalue)),4), 'VariableNames',varnames, 'RowNames',{'Sigma'} );
Container{5,1} = 'Sigma for single example';
Container{5,2} = TabSig;

disp(TabSig)
fprintf('\n')
fprintf('Displays the sigma for the four kernels combined for a given example')
fprintf('\n')
fprintf('\n')
fprintf('\n')
TabSV = array2table(round(mean(cell2mat(AllSV(example,cvalue)))),'VariableNames',{'NumOfSV'});
Container{6,1} = 'Mean num of SVs for given example';
Container{6,2} = TabSV;

disp(TabSV)
fprintf('Displays the mean number of support vectors a given example')
fprintf('\n')
fprintf('\n')


SVnum = diag(cell2mat(AllSV(ind2, 1:size(ind2,1)))); % Returns the Num SV returned for 
% best the performing kernel for the 5 C values 


%==========================================================================
%mean number of SVs for all C parameters
rownames= string(1:size(C,1));

TabSVall = round(mean(cell2mat(AllSV(:,:))));
Tab3 = array2table([C TabSVall'], 'VariableNames',{'C','NumofSV'}, 'RowNames',rownames );
Container{7,1} = 'SV for all C';
Container{7,2} = Tab3;

disp(Tab3)
fprintf('Table displaying the mean number of Support Vectors obtained \n')
fprintf('\n')

Container{8,1} = 'SV for best kernel per  C';
Container{8,2} = SVnum;

Container{9,1} = 'SV for all ker/C';
Container{9,2} = AllSV;

%plot
figure(3)
bar(TabSVall)
title('Mean number of Support vectors','fontsize',20)
xlabel('C parameter', 'fontsize',18)
ylabel('Number of Support Vectors', 'fontsize',18)

saveas(figure(3),fnameSV,'epsc')

end
