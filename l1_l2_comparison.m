%% load image
im = rescale(imread('data/kg_.png'));
im((im > 0.3) & (im < 0.7)) = 0;
x = im(:);

n = numel(x);

%% eksperiment - uspješnost rekonstrukcije s razlièitim uvjetima
f = figure();
start = 400; w = 120; h = 200;
f.Position = [1.0063e+03 226.3333 578 926];

A_ = randn(n, n);
idx = randperm(n);
perc = [0.12, 0.2, 0.3, 0.8];
for row=1:4
    m = round(n * perc(row));
    A = A_(idx(1:m), :);
    y = A * x;
    
    for epsilon=-1:1:1    
        if epsilon == -1
            s = lsqr(A, y);
        else
            s = spg_bpdn(A, y, epsilon); 
        end
        
        subaxis(4, 3, epsilon+2, row, 'Spacing', 0.06, 'Padding', 0, 'Margin', 0.05);
        imshow(reshape(s, size(im)));
        
        label_v = xlabel(sprintf('SSIM = %.2f', round(ssim(reshape(s, size(im)), reshape(x, size(im))), 2)), 'FontSize', 12);
        label_v.Position(2) = label_v.Position(2) - 12;
            
        if row == 1
            if epsilon == -1
                title('$l_{2}$ minimizacija', 'FontSize', 14, 'FontWeight', 'Normal', 'interpreter', 'latex');
            else
                title(sprintf('%c = %d', char(949), round(epsilon)), 'FontSize', 14, 'FontWeight', 'Normal');
            end
        end
                
        if epsilon == -1
            label_h = ylabel(sprintf('%d%% oèitano', round(perc(row) * 100)), 'FontSize', 12);
            label_h.Position(1) = label_h.Position(1) + 15;
        end     
    end
end

saveas(gcf, 'plots/l1_l2.png');