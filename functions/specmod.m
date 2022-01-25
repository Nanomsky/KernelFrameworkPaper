function H = specmod(K, mode)

%Converting indefinitie kernels to PSD by spectrum modification
%From - paper by Loosli2016
%@Nanomsky
%
%How to use this function
%------------------------
%H = specmod(K, mode)
%where mode can be clip,shift, flip or square
%K = kernel matrix
%
%======================================================================
%clip    : neg part is simply removed (negative eigenvalues cut to 0)
%shift   : the complete spectrum is shifted till the least eigenvalue is 0
%flip    : the absolute value of the spectrum is used (the negative part
%          becomes positive)
%square  : eigenvalues are squared
%======================================================================

%Set values with nan or inf to 0
K(isnan(K)) = 0;
K(isinf(K)) = 0;

%Eigenvalue decomposotion
[x,y,z] = eig(K);
[m, ~]=size(K);
if y>0
    disp('all ok')
    
end
if (nargin < 1) % check correct number of arguments
    help specmod
    
else
    switch lower(mode)
        
        case 'clip'
            y=diag(y);
            for i=1:m
                if y(i)<0
                    y(i)=0;
                end
            end
            H = x*diag(y)*z'; %matrix reconstruction
            
        case 'shift'
            y=diag(y);
            for i=1:m
                if y(i)<0
                    y=y+y(i);
                end
            end
            H = x*diag(y)*z'; %matrix reconstruction
            
        case 'flip'
            y=diag(y);
            for i=1:m
                if y(i)<0
                    y(i) = abs(y(i));
                end
            end
            H = x*diag(y)*z'; %matrix reconstruction
            
        case 'square'
            y=diag(y);
            for i=1:m
                if y(i)<0
                    y(i) = (y(i)^2);
                end
            end
            H = x*diag(y)*z'; %matrix reconstruction
            
        case 'tri'
            y=diag(y);
            for i=1:m
                if y(i)<0
                    y(i) = (y(i)^4);
                end
            end
            H = x*diag(y)*z'; %matrix reconstruction
            
        otherwise
            H = x*y*z';%matrix reconstruction
    end
end
end