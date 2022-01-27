function TAB = AnalseZeroVector(A1, example)

 
 specModes = {'clip','shift','flip','square'}; %list of spectral modification
 
 
 for i = 1:4
     load(A1{i,2})
     TAB{1,1} = example;
     TAB{1,2} = 'F1_score';
     TAB{1,3} = 'Accuracy';
     TAB{1,4} = '% neg eigenvalues';
     TAB{1,5} = 'Spec Modification';
     TAB{1,6} = 'Data Process';
     TAB{1,7} = 'F1 Check';
     TAB{1,8} = 'Data Process Check';
         
     TAB{2,1} = 'Ker1';
     TAB{3,1} = 'Ker5';
     TAB{4,1} = 'Ker6';
     TAB{5,1} = 'Ker7';
     
     
     [maxV, indx] = max(cell2mat(CompareResult(example,:)));
     
     
     TAB{i+1,2} = cell2mat(REAL(example, 3));
     TAB{i+1,3} = cell2mat(REAL(example, 4));
     TAB{i+1,4} = cell2mat(REAL(example, 2));
     TAB{i+1,5} = specModes{indx};
     TAB{i+1,6} = REAL{example, 6};
     
          
     if maxV == cell2mat(REAL(example, 3))
     disp('--> Both F1 scores are equal')
     TAB{i+1,7} = 'Both F1 scores are equal';
     end
     
     if strcmp(REAL{example, 6}, CompareDataProc{example, indx})
         disp('--> Both Data process methods are equal')
         TAB{i+1,8} = 'Data process methods are equal';
     end
     
     clear CompareResult REAL CompareDataProc Cont Result158 maxV indx
 end
 
 end 