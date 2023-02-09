im = rescale(rgb2gray(imread('data/lenna.png')));

n = 1024 * 4;

% Hada = sqrt(n) * fwht(eye(n), n, 'dyadic');
Hada2 = sqrt(n) * fwht(eye(n), n, 'sequency');
% Hada3 = sqrt(n) * fwht(eye(n), n, 'hadamard');
Four = (1 / sqrt(n)) * dftmtx(n);
Cosin = dctmtx(n);
Haar = generate_wavelet(n, 'haar');%generate_haar(512);
DB1 = generate_wavelet(n, 'db4');


% haar, dmey, sym4, coif4, fk6

Psi = {Cosin, Four, "haar", "db4"};%  "db8", "db12", "dmey", "sym4", "sym10", "sym22"};%    "bior1.1", "bior2.8", "bior5.5",     "rbio1.1", "rbio2.8", "rbio5.5", "coif1", "coif4", "fk6", "fk22"};
names = {'DCT', 'DFT', 'Haar', 'db4'};

f = figure();
f.Position =    1.0e+03 * [1.0003    0.5630    0.8580    0.7753];
colormap(jet);

for i = 1:length(Psi)
   if isstring(Psi{i})
        U2 = generate_wavelet(n, char(Psi{i}));
    else
        U2 = Psi{i};
   end
   
   if i == 4
       U1 = Four;
       U1_name = '$U_{DFT}U_{';
   elseif i == 2
       U1 = normc(randn(n, n));
       U1_name = '$U_{gauss}U_{';
       mutual_coherence(U1)
   else
       U1 = Hada2;
       U1_name = '$U_{Had}U_{';
   end
   
   max(max(abs(U1 * U2')))

    subaxis(2, 2, mod(i, 2) + 1,  ceil(i / 2), 'Spacing', 0.05, 'Padding', 0.01, 'Margin', 0.09);
    imagesc(abs(U1 * U2'), [0, 1]); 
    
    title([ U1_name, names{i}, '}^*$' ], 'interpreter', 'latex', 'FontSize', 15);
    
    set(gca, 'xtick', []); set(gca, 'ytick', []);
    set(gca, 'xticklabel', []); set(gca, 'yticklabel', []);
end

h = axes(f, 'visible', 'off'); 
colorbar(h,'Position',[0.93 0.168 0.022 0.7]);

% saveas(gcf, 'data/coherence.png');