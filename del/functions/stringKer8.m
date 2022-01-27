
%function k = stringKerTLP(ker,u,v,del,ins,rep,w_del,w_ins,w_rep,p1)
%function k = stringKerTLP(ker,u,v,Tu, Tv,Th,del,ins,rep,p1)
function k = stringKer8(ker,u,v,Tu, Tv,Th,del,ins,rep)


%  Usage: k = stringKer(ker,u,v,del,ins,rep, p1,p2)
%
%  Parameters: ker - kernel type
%              u,v - kernel string arguments
%      del,ins,rep - weights for delete, insert and replace
%              p1  - Template (An example from the data)
%              p2  - weighting for RBF versions

%p2=0.0025;

if (nargin < 1) % check correct number of arguments
    help svkernel
else
    
    switch lower(ker)
        case 'k_ed8'
            k = edist_wT(u,v,Tu,Tv,Th); %Considers the date field is within a certain threshold
            
%         case 'tempker'
%             k=edist_w3(u,v,del,ins,rep,w_del,w_ins,w_rep,p1);
%             
%         case 'edistance1e'
%             h = edist_wT2(u,v,Tu,Tv,Th,del,ins,rep);
%             k = exp(-p1*h);
%             
%         case 'edistance2a'
%             h = edist_wT2(u,v,Tu,Tv,Th,Su,Sv);
%             k = exp(-p1*h);
%             
%         case 'twedker'
%             addpath('/Users/Nanomsky/Documents/MATLAB/02-CodeFromInternet/twed/twed.m')
%             [k,~] = twed(u,Tu,v,Tv,1,p1);
%             
        otherwise
            k = edist_w(u,v,del,ins,rep);
    end
    
end
