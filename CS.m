function [s] = CS(x, opA, idx, epsilon)
    n = size(x, 1);
    m = length(idx);
    
    y = x(idx);
    % y = opA(x, 1);
    y = reshape(y, [], 1);
    z = zeros(n);
    z(idx) = y;
    
    imshow(z);
    
    s = spg_bpdn(opA, y, epsilon); 
end