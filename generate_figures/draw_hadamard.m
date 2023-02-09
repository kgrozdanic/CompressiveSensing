n = 128; 
U_Had = sqrt(n) * fwht(eye(n), n, 'sequency'); 

f = figure();
f.Position = 1.0e+03 *  [  1.4263    0.5737    0.5333    0.4613];
colormap bone;
imagesc(U_Had, [-0.16, 0.0884]);
set(gca, 'xtick', []); set(gca, 'ytick', []);
set(gca, 'xticklabel', []); set(gca, 'yticklabel', []);

title('$U_{Had}$', 'interpreter', 'latex', 'FontSize', 15);

saveas(gcf, 'plots/hadamard.png');