%@Nanomsy
%Function used to extract the best F1 score from results obtained from the
%spectral modifications made

function C = maxF1scorey(clip_F1,shift_F1,flip_F1,square_F1,fpath)

%=========================================================================
%converst the cell to matrices and changes the Nan to o
clip_F1   = cell2mat(clip_F1); clip_F1(isnan(clip_F1))=0;
shift_F1  = cell2mat(shift_F1); shift_F1(isnan(shift_F1))=0;
flip_F1   = cell2mat(flip_F1); flip_F1(isnan(flip_F1))=0;
square_F1 = cell2mat(square_F1); square_F1(isnan(square_F1))=0;
%Psd_F1    = cell2mat(Psd_F1); Psd_F1(isnan(Psd_F1))=0;
%=========================================================================
%compute the maximum and index for each column according to the raw, norm
%and cen data processing. This is done for all 4 types of spectral
%modification

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

% [maxRawPsd,RawPsdIndex]    = max(Psd_F1(1:4,:),[],1);
% [maxNormPsd,NormPsdIndex]  = max(Psd_F1(5:8,:),[],1);
% [maxCenPsd,CenPsdIndex]    = max(Psd_F1(9:12,:),[],1);

%=========================================================================
%Create a subplot for results

% figure(1)
% plot(maxRawPsd, 'r')
% hold on
% plot(maxNormPsd, 'b')
% hold on
% plot(maxCenPsd, 'k')
% title('PSD')
% ylabel('F1 Score')
% xlabel('Models')
% legend('Raw', 'Norm', 'Cen')
% 
% filename0 = sprintf('%s_0',fpath(3:end));
% sname = fullfile(fpath, filename0);
% %saveas(figure(1),sname,'epsc')
% saveas(figure(1),sname,'jpg')



figure(1)
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

filename1 = sprintf('%s_1',fpath(3:end));
sname1 = fullfile(fpath, filename1);
%saveas(figure(1),sname1,'epsc')
saveas(figure(1),sname1,'jpg')
%close(fig)


[Maxclip,clipindex]     = max(clip_F1,[],1);  %Max F1 from Raw, Norm and Cen data - clip
[Maxshift,shiftindex]   = max(shift_F1,[],1); %Max F1 from Raw, Norm and Cen data - shift
[Maxflip,flipindex]     = max(flip_F1,[],1);  %Max F1 from Raw, Norm and Cen data - flip
[Maxsquare,squareindex] = max(square_F1,[],1);%Max F1 from Raw, Norm and Cen data - square
%[MaxPsd,Psdindex]       = max(Psd_F1,[],1);   %Max F1 from Raw, Norm and Cen data - Psd

figure(2)

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
filename2 = sprintf('%s_2',fpath(3:end));
sname2 = fullfile(fpath, filename2);
%saveas(fig,filename,'epsc')
saveas(figure(2),sname2,'jpg')
%close(fig)
%=========================================================================

C{2,1} = 'clip';
C{3,1} = 'shift';
C{4,1} = 'flip';
C{5,1} = 'square';
%C{6,1} = 'psd';

C{1,2} = 'Max F1 Raw'; %Max F1 score obtained for Raw
C{1,4} = 'Max F1 Norm'; %Max F1 score obtained for Norm
C{1,6} = 'Max F1 Cen'; %Max F1 score obtained for Cen

C{1,3} = 'Raw Index'; %Index to be used to obtain the corresponding C parameter
C{1,5} = 'Norm Index'; %Index to be used to obtain the corresponding C parameter
C{1,7} = 'Cen Index'; %Index to be used to obtain the corresponding C parameter
C{1,8} = 'Full Set Max'; %Max F1 score for all data combined (Raw + Norm + Cen) 
C{1,9} = 'Full Set Index'; %Index of max from all data. Corresponds to C parameter 

C{2,2} = maxRawclip;
C{3,2} = maxRawshift;
C{4,2} = maxRawflip;
C{5,2} = maxRawsquare;
%C{6,2} = maxRawPsd;

C{2,3} = RawclipIndex;
C{3,3} = RawshiftIndex;
C{4,3} = RawflipIndex;
C{5,3} = RawsquareIndex;
%C{6,3} = RawPsdIndex;

C{2,4} = maxNormclip;
C{3,4} = maxNormshift;
C{4,4} = maxNormflip;
C{5,4} = maxNormsquare;
%C{6,4} = maxNormPsd;

C{2,5} = NormclipIndex;
C{3,5} = NormshiftIndex;
C{4,5} = NormflipIndex;
C{5,5} = NormsquareIndex;
%C{6,5} = NormPsdIndex;

C{2,6} = maxCenclip;
C{3,6} = maxCenshift;
C{4,6} = maxCenflip;
C{5,6} = maxCensquare;
%C{6,6} = maxCenPsd;

C{2,7} = CenclipIndex;
C{3,7} = CenshiftIndex;
C{4,7} = CenflipIndex;
C{5,7} = CensquareIndex;
%C{6,7} = CenPsdIndex;

C{2,8} = Maxclip;    
C{3,8} = Maxshift;  
C{4,8} = Maxflip;   
C{5,8} = Maxsquare;
%C{6,8} = MaxPsd;

C{2,9} = clipindex;     
C{3,9} = shiftindex;   
C{4,9} = flipindex;     
C{5,9} = squareindex; 
%C{6,9} = Psdindex; 

end 

% 
% [maxRawclip,RawclipIndex]    = max(clip_F1(1:4,:),[],1);
% [maxNormclip,NormclipIndex]  = max(clip_F1(5:8,:),[],1);
% [maxCenclip,CenclipIndex]    = max(clip_F1(9:12,:),[],1);
% 
% [maxRawshift,RawshiftIndex]    = max(shift_F1(1:4,:),[],1);
% [maxNormshift,NormshiftIndex]  = max(shift_F1(5:8,:),[],1);
% [maxCenshift,CenshiftIndex]    = max(shift_F1(9:12,:),[],1);
% 
% [maxRawflip,RawflipIndex]    = max(flip_F1(1:4,:),[],1);
% [maxNormflip,NormflipIndex]  = max(flip_F1(5:8,:),[],1);
% [maxCenflip,CenflipIndex]    = max(flip_F1(9:12,:),[],1);
% 
% [maxRawsquare,RawsquareIndex]    = max(square_F1(1:4,:),[],1);
% [maxNormsquare,NormsquareIndex]  = max(square_F1(5:8,:),[],1);
% [maxCensquare,CensquareIndex]    = max(square_F1(9:12,:),[],1);
% 


% [Maxclip,clipindex]     = max(clip_F1,[],1);  %Max F1 from Raw, Norm and Cen data - clip
% [Maxshift,shiftindex]   = max(shift_F1,[],1); %Max F1 from Raw, Norm and Cen data - shift
% [Maxflip,flipindex]     = max(flip_F1,[],1);  %Max F1 from Raw, Norm and Cen data - flip
% [Maxsquare,squareindex] = max(square_F1,[],1);%Max F1 from Raw, Norm and Cen data - square
% %=========================================================================







%=========================================================================



