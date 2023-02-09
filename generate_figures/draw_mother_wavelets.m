
wnames = {'haar', 'db4', 'sym4', 'mexh'};
names = {'Haar', 'Daubechies-4', 'symlet-3', 'meksièki šešir (eng. mexican hat)'};

f = figure();
f.Position = 1.0e+03 * [1.0003    0.7423    0.8740    0.5960];
for i = 1:4
    ax = subplot(2, 2, i);
    if i == 4
        [psi,xval] = wavefun(wnames{i}, 14);    
    else
        [~,psi,xval] = wavefun(wnames{i}, 14);    
    end
    
    plot(xval, psi, 'LineWidth', 1); grid();
    ylim([-1.7 1.7]);
    xlim(xlim * 1.1 - mean(xlim) * 0.25);
    title([names{i}])    
end