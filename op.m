function y = op(x, mode, idx, n)
    if mode == 1
         z = idct2(reshape(x, [n, n]));
         y = z(idx);
         y = y(:);
    else
        z = zeros(n, n);
        z(idx) = x;
        z = dct2(z);
        y = reshape(z, [n*n, 1]);
end