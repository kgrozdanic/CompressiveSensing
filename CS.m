function [s] = CS(x, opA, Phi, idx, epsilon)
    n = size(x, 1);
    
    y = Phi(x);
    y = y(idx);
    y = y(:);

    
    s = spg_bpdn(opA, y, epsilon); 
end