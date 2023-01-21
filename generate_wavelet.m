function [W] = generate_wavelet(N, wname)
    dim = log2(N);
    nres = wmaxlev(N, wname);
    if strcmp(wname, 'haar')
        nres = nres - 1;
    end
    s = 2.^[dim-nres, (dim-nres):dim]';
    
    W = zeros(N);
    e_i = zeros(N, 1);
    for i=1:N
        e_i(i) = 1;
        W(i, :) = waverec(e_i, s, wname);
        e_i(i) = 0;
    end