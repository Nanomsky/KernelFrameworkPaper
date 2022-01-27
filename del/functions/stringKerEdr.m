function k = stringKerEdr(ker,u,Tu,v,Tv,p2,p1)

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
             
        case 'dtwker'
            
             addpath('/Users/Nanomsky/Documents/MATLAB/02-CodeFromInternet/dtw')
            [h,~,~,~]=dtw(u,v);
             k = exp(-p1*h);
                       
        case 'edr1'
            k =  edr(u,v,p1);
        case 'edr2'
            k =  edr(Tu,Tv,p1);
        case 'edr3'
            k = edr(Tu,Tv,p1) + edr(u,v,p1);
        case 'edr4'
            k = edr(Tu,Tv,p1)*p2 + edr(u,v,p1);
        case 'edr5'
            k = edr(Tu,Tv,p1) + edr(u,v,p1)*p2;
        case 'edr6'
            h = edr(u,v,p1);
            k = (h+1)^p2; 
        case 'edr7'
            h = edr(Tu,Tv,p1);
            k = (h+1)^p2; 
        case 'edr8'
            h = edr(u,v,p1) + edr(Tu,Tv,p1);
            k = (h+1)^p2; 
         
        case 'edr9'
            h = edr(u,v,p1);
            k = exp(-p2*h+1); 
        case 'edr10'
            h = edr(Tu,Tv,p1);
            k = exp(-p2*h+1); 
        case 'edr11'
            h = edr(u,v,p1) + edr(Tu,Tv,p1);
            k = exp(-p2*h+1);     
                   
        case 'twedker'
            %addpath('/Users/ositanwegbu/Dropbox/NanoToolBox/twed')
            [k,~] = twed(u,Tu,v,Tv,p2,p1);
                    
        otherwise
            k = edist_w(u,v,del,ins,rep);
    end
    
end
