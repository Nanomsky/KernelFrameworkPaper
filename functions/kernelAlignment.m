function K = kernelAlignment(K1, K2)
%@Nanomsky

    %This code tests the similarity of two kernel matrices
    % The value K =  1 indicates that two matrices are equal. While K = 0 means 
    % They are orthogonal and therefore dissimilar. 
    % Kernel alignment therefore is an indication of how close/similar two kernel
    % matrices are. The value K > 0 means K1 is psd for every K2 that is Psd
    % The alignment can be viewed as the cosine of the angle between the 
    % matrices viewed as l2-dimensional vectors, it satisfies ?1 ? A(K1, K2) ? 1.


K = sum(dot(K1,K2))/((sum(dot(K1,K1)) * sum(dot(K2,K2)))^0.5); 

    
