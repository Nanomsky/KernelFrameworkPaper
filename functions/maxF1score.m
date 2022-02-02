function C = maxF1score(Psd_F1,fpath, para, File)

%=========================================================================
%Function used to extract the best F1 score from results obtained from the
%spectral modifications made.
%input
%-----
% Psd_F1    - The cell containing the F1-scores obtained for all PSD kernels
% fpath     - The file path where the kernels are stored
% para      - The C regularization parameters
% File      - The list of files indicating the kernel matrix
%
%output
%------
% C - A cell containing the results
%=========================================================================
newIndex = [1 2 3 4 1 2 3 4 1 2 3 4]; %necessary since we stacked the
%results for 'raw,'centering' and 'normalization'. Index 1:4 required
%=========================================================================
%convert the cell to matrices and changes the Nan to 0
Psd_F1    = cell2mat(Psd_F1(1:end-1,:)); Psd_F1(isnan(Psd_F1))=0;
%=========================================================================
%compute the maximum and index for each column according to the raw, norm
%and cen data processing. 
%The index indicates the C parameter to yield the maximum result.

[maxRawraw,RawrawIndex]    = max(Psd_F1(1:4,:),[],1);
[maxNormraw,NormrawIndex]  = max(Psd_F1(5:8,:),[],1);
[maxCenraw,CenrawIndex]    = max(Psd_F1(9:12,:),[],1);

%==========================================================================
%make some plots
figure(1)
plot(maxRawraw, 'r')
hold on
plot(maxNormraw, 'b')
hold on
plot(maxCenraw, 'k')
title('F1 Score - Psd Kernel','fontsize',14)
legend('raw','Norm','center')
xlabel('zero vector model','fontsize',12)
ylabel('F1 score','fontsize',12)

filename1 = sprintf('%s_1',fpath(3:end));
sname1 = fullfile(fpath, filename1);
%saveas(figure(1),sname1,'epsc')
saveas(figure(1),sname1,'jpg')
%close(fig)


%==========================================================================
%Extract the maximum F1 score
[Maxraw,rawindex]          = max(Psd_F1,[],1);   %Max F1 from Raw, Norm and Cen data - raw
[MaxrawFile,rawindexFile]  = max(Psd_F1,[],2);   %Max F1 from Raw, Norm and Cen data - raw

figure(2)

plot(Maxraw, '-o')

title('Plot of Maximum F1 sorce attained','fontsize',13)
xlabel('zero vector model','fontsize',12)
ylabel('F1 score','fontsize',12)

%Save plot
filename2 = sprintf('%s_2',fpath(3:end));
sname2 = fullfile(fpath, filename2);
%saveas(figure(2),sname2,'epsc')
saveas(figure(2),sname2,'jpg')
%close(fig)

figure(3)
bar(Maxraw)
title('Plot of Maximum F1 sorce attained','fontsize',13)
xlabel('zero vector model','fontsize',12)
ylabel('F1 score','fontsize',12)

%Save plot
filename3 = sprintf('%s_3',fpath(3:end));
sname3 = fullfile(fpath, filename3);
%saveas(figure(3),sname3,'epsc')
saveas(figure(3),sname3,'jpg')
%close(fig)
%=========================================================================

C{2,1} = 'psd';

C{1,2} = 'Max F1 Raw';  %Max F1 score obtained for Raw
C{1,4} = 'Max F1 Norm'; %Max F1 score obtained for Norm
C{1,6} = 'Max F1 Cen';  %Max F1 score obtained for Cen

C{1,3} = 'Raw C para';      % C parameter
C{1,5} = 'Norm C para';     % C parameter
C{1,7} = 'Cen C para';      % C parameter
C{1,8} = 'Full Set Max';    % Max F1 score for all data combined (Raw + Norm + Cen)
C{1,9} = 'Full Set C para'; % C parameter

C{2,2}  = maxRawraw;
C{2,3}  = [para{RawrawIndex}];
C{2,4}  = maxNormraw;
C{2,5}  = [para{NormrawIndex}];
C{2,6}  = maxCenraw;
C{2,7}  = [para{CenrawIndex}];
C{2,8}  = Maxraw;
C{2,9}  = [para{newIndex(rawindex)}];
C{2,10} = MaxrawFile;
C{2,11} = [File{rawindexFile}];
C{2,12} = rawindex; %index for the maximum F1 values

%make some plots
figure(4)
bar([maxRawraw' maxNormraw' maxCenraw'],'grouped')
title('F1 Score - Psd Kernel','fontsize',14)
legend('raw','Norm','center')
xlabel('zero vector model','fontsize',12)
ylabel('F1 score','fontsize',12)

filename4 = sprintf('%s_4',fpath(3:end));
sname4 = fullfile(fpath, filename4);
%saveas(figure(4),sname4,'epsc')
saveas(figure(4),sname4,'jpg')
%close(fig)


end

%=========================================================================



