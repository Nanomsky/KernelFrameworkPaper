function C = maxF1scorex(raw_F1,clip_F1,shift_F1,flip_F1,square_F1,fpath, para, File)

%=========================================================================
%Function used to extract the best F1 score from results obtained from the
%spectral modifications made
%input
%-----
% raw_F1    - The cell containing the F1-scores obtained for all the kernels
% clip_F1   - The F1 score obtained with clip spec modification
% shift_F1  - The F1 score obtained with the shift spec modification
% flip_F1   - The F1 score obtained with the flip  ''      ''
% square_F1 - The F1 score obtained with the square ''     ''
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
raw_F1    = cell2mat(raw_F1(1:end-1,:)); raw_F1(isnan(raw_F1))=0;
clip_F1   = cell2mat(clip_F1(1:end-1,:)); clip_F1(isnan(clip_F1))=0;
shift_F1  = cell2mat(shift_F1(1:end-1,:)); shift_F1(isnan(shift_F1))=0;
flip_F1   = cell2mat(flip_F1(1:end-1,:)); flip_F1(isnan(flip_F1))=0;
square_F1 = cell2mat(square_F1(1:end-1,:)); square_F1(isnan(square_F1))=0;

%=========================================================================
%compute the maximum and index for each column according to the raw, norm
%and cen data processing. This is done for all 4 types of spectral
%modification including unmodified indefiinite kernel
%The index indicates the C parameter to yield the maximum result.

[maxRawraw,RawrawIndex]    = max(raw_F1(1:4,:),[],1);
[maxNormraw,NormrawIndex]  = max(raw_F1(5:8,:),[],1);
[maxCenraw,CenrawIndex]    = max(raw_F1(9:12,:),[],1);

[maxRawclip,RawclipIndex]    = max(clip_F1(1:4,:),[],1);
[maxNormclip,NormclipIndex]  = max(clip_F1(5:8,:),[],1);
[maxCenclip,CenclipIndex]    = max(clip_F1(9:12,:),[],1);

[maxRawshift,RawshiftIndex]    = max(shift_F1(1:4,:),[],1);
[maxNormshift,NormshiftIndex]  = max(shift_F1(5:8,:),[],1);
[maxCenshift,CenshiftIndex]    = max(shift_F1(9:12,:),[],1);

[maxRawflip,RawflipIndex]    = max(flip_F1(1:4,:),[],1);
[maxNormflip,NormflipIndex]  = max(flip_F1(5:8,:),[],1);
[maxCenflip,CenflipIndex]    = max(flip_F1(9:12,:),[],1);

[maxRawsquare,RawsquareIndex]    = max(square_F1(1:4,:),[],1);
[maxNormsquare,NormsquareIndex]  = max(square_F1(5:8,:),[],1);
[maxCensquare,CensquareIndex]    = max(square_F1(9:12,:),[],1);

%==========================================================================
%make some plots
figure(1)
plot(maxRawraw, 'r')
hold on
plot(maxNormraw, 'b')
hold on
plot(maxCenraw, 'k')
title('F1 Score - Indefinite Kernel','fontsize',14)
legend('raw','Norm','center')


filename1 = sprintf('%s_1',fpath(3:end));
sname1 = fullfile(fpath, filename1);
%saveas(figure(1),sname1,'epsc')
saveas(figure(1),sname1,'jpg')
%close(fig)

figure(2)
subplot(2,2,1)
plot(maxRawclip, 'r')
hold on
plot(maxNormclip, 'b')
hold on
plot(maxCenclip, 'k')
title('Clip','fontsize',12)

subplot(2,2,2)
plot(maxRawshift, 'r')
hold on
plot(maxNormshift, 'b')
hold on
plot(maxCenshift, 'k')
title('shift','fontsize',12)

subplot(2,2,3)
plot(maxRawflip, 'r')
hold on
plot(maxNormflip, 'b')
hold on
plot(maxCenflip, 'k')
title('flip','fontsize',12)

subplot(2,2,4)
plot(maxRawsquare, 'r')
hold on
plot(maxNormsquare, 'b')
hold on
plot(maxCensquare, 'k')
title('square','fontsize',12)
sgtitle('Master','fontsize',15)

filename2 = sprintf('%s_1',fpath(3:end));
sname2 = fullfile(fpath, filename2);
%saveas(figure(2),sname2,'epsc')
saveas(figure(2),sname2,'jpg')
%close(fig)

%==========================================================================
%Extract the maximum F1 score
[Maxraw,rawindex]       = max(raw_F1,[],1);   %Max F1 from Raw, Norm and Cen data - raw
[Maxclip,clipindex]     = max(clip_F1,[],1);  %Max F1 from Raw, Norm and Cen data - clip
[Maxshift,shiftindex]   = max(shift_F1,[],1); %Max F1 from Raw, Norm and Cen data - shift
[Maxflip,flipindex]     = max(flip_F1,[],1);  %Max F1 from Raw, Norm and Cen data - flip
[Maxsquare,squareindex] = max(square_F1,[],1);%Max F1 from Raw, Norm and Cen data - square

[MaxrawFile,rawindexFile]       = max(raw_F1,[],2);   %Max F1 from Raw, Norm and Cen data - raw
[MaxclipFile,clipindexFile]     = max(clip_F1,[],2);  %Max F1 from Raw, Norm and Cen data - clip
[MaxshiftFile,shiftindexFile]   = max(shift_F1,[],2); %Max F1 from Raw, Norm and Cen data - shift
[MaxflipFile,flipindexFile]     = max(flip_F1,[],2);  %Max F1 from Raw, Norm and Cen data - flip
[MaxsquareFile,squareindexFile] = max(square_F1,[],2);%Max F1 from Raw, Norm and Cen data - square

figure(3)

plot(Maxraw, '-o')
hold on
plot(Maxclip, '-r')
hold on
plot(Maxshift, 'b^')
hold on
plot(Maxflip, 'g*')
hold on
plot(Maxsquare, 'm+')
title('Plot of Maximum F1 sorce attained','fontsize',15)
xlabel('zero vector model','fontsize',12)
ylabel('F1 score','fontsize',12)
legend('clip','shift','flip','square')

%Save plot
filename3 = sprintf('%s_3',fpath(3:end));
sname3 = fullfile(fpath, filename3);
%saveas(figure(3),sname3,'epsc')
saveas(figure(3),sname3,'jpg')
%close(fig)

figure(4)
bar([Maxraw;Maxclip;Maxshift;Maxflip;Maxsquare],'grouped')
%=========================================================================

C{2,1} = 'raw';
C{3,1} = 'clip';
C{4,1} = 'shift';
C{5,1} = 'flip';
C{6,1} = 'square';

C{1,2} = 'Max F1 Raw';  %Max F1 score obtained for Raw
C{1,4} = 'Max F1 Norm'; %Max F1 score obtained for Norm
C{1,6} = 'Max F1 Cen';  %Max F1 score obtained for Cen

C{1,3} = 'Raw C para';      % C parameter
C{1,5} = 'Norm C para';     % C parameter
C{1,7} = 'Cen C para';      % C parameter
C{1,8} = 'Full Set Max';    % Max F1 score for all data combined (Raw + Norm + Cen)
C{1,9} = 'Full Set C para'; % C parameter

C{2,2} = maxRawraw;
C{3,2} = maxRawclip;
C{4,2} = maxRawshift;
C{5,2} = maxRawflip;
C{6,2} = maxRawsquare;

C{2,3} = [para{RawrawIndex}];
C{3,3} = [para{RawclipIndex}];
C{4,3} = [para{RawshiftIndex}];
C{5,3} = [para{RawflipIndex}];
C{6,3} = [para{RawsquareIndex}];

C{2,4} = maxNormraw;
C{3,4} = maxNormclip;
C{4,4} = maxNormshift;
C{5,4} = maxNormflip;
C{6,4} = maxNormsquare;

C{2,5} = [para{NormrawIndex}];
C{3,5} = [para{NormclipIndex}];
C{4,5} = [para{NormshiftIndex}];
C{5,5} = [para{NormflipIndex}];
C{6,5} = [para{NormsquareIndex}];

C{2,6} = maxCenraw;
C{3,6} = maxCenclip;
C{4,6} = maxCenshift;
C{5,6} = maxCenflip;
C{6,6} = maxCensquare;

C{2,7} = [para{CenrawIndex}];
C{3,7} = [para{CenclipIndex}];
C{4,7} = [para{CenshiftIndex}];
C{5,7} = [para{CenflipIndex}];
C{6,7} = [para{CensquareIndex}];

C{2,8} = Maxraw;
C{3,8} = Maxclip;
C{4,8} = Maxshift;
C{5,8} = Maxflip;
C{6,8} = Maxsquare;

C{2,9} = [para{newIndex(rawindex)}];
C{3,9} = [para{newIndex(clipindex)}];
C{4,9} = [para{newIndex(shiftindex)}];
C{5,9} = [para{newIndex(flipindex)}];
C{6,9} = [para{newIndex(squareindex)}];

C{2,10} = MaxrawFile;
C{3,10} = MaxclipFile;
C{4,10} = MaxshiftFile;
C{5,10} = MaxflipFile;
C{6,10} = MaxsquareFile;

C{2,11} = [File{rawindexFile}];
C{3,11} = [File{clipindexFile}];
C{4,11} = [File{shiftindexFile}];
C{5,11} = [File{flipindexFile}];
C{6,11} = [File{squareindexFile}];

%index for the maximum F1 values
C{2,12} = rawindex;
C{3,12} = clipindex;
C{4,12} = shiftindex;
C{5,12} = flipindex;
C{6,12} = squareindex;

end

%=========================================================================



