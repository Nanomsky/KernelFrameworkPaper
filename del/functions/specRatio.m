
function CR=specRatio(K)

    % Kernel test script
    % This function is used to compute the spectral Ratio of a kernel matric
    % This value is use to compare the complexity and expressiveness of two
    % kernel functions
    % See Paper {Donini2017}

    % The spectral ratio (SR) for a positive semi-definite matrix K is defined 
    % as the ratio between the 1-norm and the 2-norm of its eigenvalues, or 
    % equivalently, as the ratio between its trace norm ||K||T and its 
    % Frobenius norm ||K||F

    % Let k_i, k_j be two kernel functions. We say that k_i is more general 
    % (or less expressive) than k_j specRatio(k_i > k_j ) or equivalently that k_j is more 
    % specific (or more expressive) than k_i specRatio(k_j < k_i) whenever for any 
    % possible dataset X, we have specRatio(K_i) < specRatio(K_j) with K_i
    % the kernel matrix evaluated on data X using the kernel function k_i .

    %The higher the Spectral ratio the better

if nargin>1 
    error('Input one kernel matrix');
else
   CR = trace(K)/norm(K);
end


    