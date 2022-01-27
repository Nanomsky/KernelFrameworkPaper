
%This script is used to extract and plot the AUC/Roc curve 
function PlotAOCpsd(fpath,example,specMtype,modetype,cv,ker,table)
%files = '/Volumes/Matlab/Proj1/K1_PRefer_1/Result_PRefer_K1_notsquaredk_ed1_1_48'
% m=3
% modelist = {'Raw';'norm';'cen'};
% specmodelist = {'clip';'shift';'flip';'square'};
% CV = {'9.54', '4.88','2.50','1.28'}
% 
% fpath,example,specMtype,modetype,cv
%==========================================================================
%Load fileNames List
fname1 = 'ARawFileName.mat';
filenameList = fullfile(fpath, fname1);
load(filenameList)
%==========================================================================
File = rawFileName{example,1};
File2 = sprintf('Result_%s',File);

sprintf('File to analyse --> %s',File2)
FileToAnalyse = fullfile(fpath,File2);
load(FileToAnalyse)
%==========================================================================
%Set the SpecMode Type
if strcmp(specMtype,'clip')
    specMod = 1;

elseif strcmp(specMtype,'shift')
    specMod = 2;

elseif strcmp(specMtype,'flip')
    specMod = 3;
    
elseif strcmp(specMtype,'square')
    specMod = 4;
    
elseif strcmp(specMtype,'psd')
    specMod = 1;
    
else   
     disp('Number exceeds the index')
end  


%==========================================================================
%Set the Data Process Type    

if strcmp(modetype,'Raw')
    mode = 1;
elseif strcmp(modetype,'norm')
    mode = 2;
    elseif strcmp(modetype,'cen')
    mode = 3;
else
    disp('Number exceeds the index')
end

%==========================================================================
% $ 9.54 \times 10^-7$
% $ 4.88 \times 10^-4$
% $ 2.50 \times 10^-1$
% $ 1.28 \times 10^2 $
% B{i,2}   = FPR; %Store the false positve rate
% B{i,3}   = TPR; %Store the True positive rate

a = cell2mat(SpecM2{1, 1}{specMod, 1}{mode, 4}(cv, 2));
b = cell2mat(SpecM2{1, 1}{specMod, 1}{mode, 4}(cv, 3));
c = cell2mat(SpecM2{1, 1}{specMod, 1}{mode, 4}(cv, 1));

figure(1)
l1 = plot(a,b,'LineWidth',2);
title(sprintf('%s',table))
xlabel('False Positive Rate')
ylabel('True Positve Rate')
legend({sprintf('%s AUC = %2.2f',ker, c),''},'Location','SouthEast')
hold on
l2 = plot([0,1],[0,1], 'r--','LineWidth',2);
hleg = legend(l1,'location','SouthEast');
set(gca,'FontSize',20)
hleg.FontName = 'Ariel';
hleg.FontSize = 14;
hleg.FontWeight = 'bold';



plotname = sprintf('AUC%s_%d',fpath(3:end-1),example);
plotdata = sprintf('AUC_data_%s_%d',fpath(3:end-1),example);
saveplot = fullfile(fpath, plotname);
savedata = fullfile(fpath, plotdata);

saveas(figure(1),saveplot,'png')
saveas(figure(1),saveplot,'epsc')

% saveas(figure(1), 'AUC','epsc')
% saveas(figure(1), 'AUC','epsc')

%==========================================================================
data{1,1} = 'FileName';
data{1,2} = 'Example';
data{1,3} = 'specMode';
data{1,4} = 'DataProcess';
data{1,5} = 'C para';
data{1,6} = 'FPR';
data{1,7} = 'TPR';
data{1,8} = 'AUC';
data{1,9} = 'table';
data{1,10}= 'kernel';

data{2,1} = File;
data{2,2} = example;
data{2,3} = specMtype;
data{2,4} = modetype;
data{2,5} = cv;
data{2,6} = a;
data{2,7} = b;
data{2,8} = c;
data{1,9} = table;
data{1,10}= ker;

save(savedata,'data')