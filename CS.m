function [s] = CS(x, opA, Phi, idx, epsilon)
    n = size(x, 1);
    size(x)
    
    
    if idx ~= -1
        y = Phi(x, 1);
        y = y(idx);
    end
    
    y = Phi(x, 1);
    
    y = y(:);   
    
    opts = spgSetParms('iterations', 2000);
    s = spg_bpdn(opA, y, epsilon, opts); 
end