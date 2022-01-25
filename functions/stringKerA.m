%function k = stringKer(ker,u,v,del,ins,rep,p1)
function k = stringKerA(ker,u,v)

del=1; ins=1; rep=2; % cost is fixed 
%
%  Usage: k = stringKer(ker,u,v,del,ins,rep, p1,p2)
%
%  Parameters: ker - kernel type
%              u,v - kernel string arguments
%      del,ins,rep - weights for delete, insert and replace
%              p1  - Template (An example from the data)
%              p2  - weighting for RBF versions



if (nargin < 1) % check correct number of arguments
    help svkernel
else
    
    switch lower(ker)
        
        case 'k_ed1'
            %computes the edit distance between strings u and v
            k = edist_w(u,v,del,ins,rep);
            
        case 'k_ed2'
            %computes the edit distance between strings u and v in RBF
            %kernel function form
            k = (exp(-p1*(edist_w(u,v,del,ins,rep))));
            
       case 'edistance3'
            %computes edit distance kernel using the distance substitution
            %form
            k = 0.5*(edist_w(u,p1,del,ins,rep)^2 + (edist_w(p1,v,del,ins,rep))^2 - (edist_w(u,v,del,ins,rep)^2));
                        
        case 'k_ed4'
            %computes edit distance kernel in the form of template matching
            k = (edist_w(u,p1,del,ins,rep)) * (edist_w(p1,v,del,ins,rep));
           
        case 'k_ed5'
            %normalises the edit distance between sequences u and v with
            %the length of the longer sequence
        
            if max(length(u),length(v)) == 0
                k = 0;
            else
                k = (edist_w(u,v,del,ins,rep))/max(length(u),length(v));
            end
                
            
        case 'k_ed6'
            %normalises the edit distance between sequences u and v with
            %the number of common items
            nm=0;
            if numel(intersect(u,v))==0
                nm=nm+1;
            else
                nm = numel(intersect(u,v));
            end
            k = (edist_w(u,v,del,ins,rep))/nm;
            
        
        case 'k_ed7'
            %normalises the edit distance between sequences u and v with
            %the exponent of the number of common items
            
            k = (edist_w(u,v,del,ins,rep))/2^numel(intersect(u,v));
            
        case 'k_ed9'
            M   =  numel(setdiff(v,u)); %Number of unmatched points
            UM  =  numel(intersect(u,v));%matched points
            k   =  p2^M * (1-edist_w(u,v,del,ins,rep))/2^UM;        
            
        case 'polyedit'
            %Edit distance in a polynomial kernel form
            h = edist_w(u,v,del,ins,rep);
            k = (h + 1)^p1;
            
        case 'intersker1'
            k = numel(intersect(u,v));
            
        case 'intersker2'
            k = 2^numel(intersect(u,v));
            
        case 'intersker3'
            k = numel(intersect(u,v))/max(length(u),length(v));
            
        case 'intersker4'
            k = 2^numel(intersect(u,v))/max(length(u),length(v));
            
        case 'dtwker'
            %Computes the dynamic time warp distance
            addpath('/Users/ositanwegbu/Documents/MATLAB/02_Sample_code_from_internet/dtw')
            %addpath('/Users/Nanomsky/Documents/MATLAB/02-CodeFromInternet/dtw')
            [h,~,~,~]=dtw(u,v);
            k = exp(-p1*h);
            
        otherwise
            k = edist_w(u,v,del,ins,rep);
    end
    
end
