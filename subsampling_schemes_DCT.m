%% dijagonalna strategija oèitavanja
function [idx] = subsampling_schemes_DCT(n, m, mode)
    e = ones(n,1);
    
    idx = full(spdiags([e e e e e e e], -3:3, n, n));
    idx = idx(n:-1:1, :);
    idx = idx + full(spdiags([e e e e e e e e e], -4:4, n, n));
%     
%     
%     imshow(idx);
%     
    x = 1:n;
    levels = round([0, 0.06, 0.17, 0.225, 1] * n);
    
    remainder = m - sum(sum(idx == 1));
    percent = 1.0;
        
    for k=2:length(levels)
        new_idx = [];
        
        for i = levels(k-1):levels(k) % pravci
           x_ = x(1 : (n - i));
           new_idx = [new_idx sub2ind([n n], x_, x_ + i)];
           new_idx = [new_idx sub2ind([n n], x_ + i, x_)];
        end
        
        if mode == 1
            for i = round((levels(k-1):levels(k)) / 2) % pravci
               x_ = x(1 : (n - i));
               new_idx = [new_idx sub2ind([n n], n + 1 - x_, x_ + i)];
               new_idx = [new_idx sub2ind([n n], x_, n + 1 - x_- i)];
            end
        elseif mode == 2
            warning('off','all')
            for i = (round(levels(k-1):levels(k)) / 4) % pravci
               x_ = x(1 : (n - i));
               new_idx = [new_idx sub2ind([n n], n + 1 - x_, x_ + i)];
               new_idx = [new_idx sub2ind([n n], x_, n + 1 - x_- i)];
            end
            warning('on','all')
        end
        
        new_idx = setdiff(new_idx, find(idx == 1));
        
        remainder = m - sum(sum(idx == 1));
        n_sampled = min(length(new_idx), round(remainder * percent));
        sample = randsample(new_idx, n_sampled);
        idx(sample) = 1;
        
        remainder = m - sum(sum(idx == 1));
        percent = percent / 1.5;
    end
    
    if sum(sum(idx == 1)) ~= m
       idx(randsample(find(idx ~= 1), round(m - sum(sum(idx == 1))) )) = 1;
    end

    % imshow(idx);
    idx = find(idx == 1);
end
