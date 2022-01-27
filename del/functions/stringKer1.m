
function k = stringKer1(ker,u,v,del,ins,rep,p2)


%
%  Usage: k = stringKer(ker,u,v,del,ins,rep, p1,p2)
%
%  Parameters: ker - kernel type
%              u,v - kernel string arguments
%      del,ins,rep - weights for delete, insert and replace
%              p1  - Template (An example from the data)
%              p2  - weighting for RBF versions
%
%  Values for ker: 'linear'  -


if (nargin < 1) % check correct number of arguments
    help svkernel
else
    
    switch lower(ker)
        
        case 'k_ed1'
            k = edist_w(u,v,del,ins,rep);
            
        case 'k_ed2'
            k = (exp(-p1*edist_w(u,v,del,ins,rep)));
            
        case 'k_ed3'
            k = 0.5*((edist_w(u,p2,del,ins,rep)^2) + (edist_w(p2,v,del,ins,rep)^2) - (edist_w(u,v,del,ins,rep)^2));
            
        case 'k_ed4'
            k = edist_w(u,p1,del,ins,rep) * edist_w(p1,v,del,ins,rep);
            
        case 'k_ed5'
            k = (edist_w(u,v,del,ins,rep)/max(length(u),length(v)));
            
        case 'k_ed6'
            nm=0;
            if numel(intersect(u,v))==0
                nm=nm+1;
            else
                nm = numel(intersect(u,v));
            end
            k = edist_w(u,v,del,ins,rep)/nm;
            
        case 'k_ed7'
            k = edist_w(u,v,del,ins,rep)/2^numel(intersect(u,v));
            
        case 'k_ed9'
            M   =  numel(setdiff(v,u)); %Number of unmatched points
            UM  =  numel(intersect(u,v));%matched points
            k   =  p2^M * (edist_w(u,v,del,ins,rep))/2^UM;
            
        case 'polyedit'
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
            addpath('/Users/ositanwegbu/Documents/MATLAB/02_Sample_code_from_internet/dtw')
            %addpath('/Users/Nanomsky/Documents/MATLAB/02-CodeFromInternet/dtw')
            [h,~,~,~]=dtw(u,v);
            k = exp(-p1*h);
            
        otherwise
            k = edist_w(u,v,del,ins,rep);
    end
    
end