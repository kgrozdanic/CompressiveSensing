%% podsjetimo se kako su izgledale apsolutne vrijednosti A
N = 512*8;

Had = sqrt(N) * fwht(eye(N), N, 'sequency');

Cosin = dctmtx(N);
Haar = generate_wavelet(N, 'haar');%generate_haar(512);
DB4 = generate_wavelet(N, 'db4');

mats = {Cosin, DB4};
names = {'$U_{Had}U_{DCT}^*$', '$U_{Had}U_{db4}^*$'};
f = figure();
f.Position = [798.3333  444.3333  880.0000  396.0000];

for i = 1:length(mats)
    subaxis(1, length(mats), i, 1, 'Spacing', 0.015, 'Padding', 0, 'Margin', 0.06);
    imagesc(abs(Had * mats{i}'), [0 1]);
    title(names{i}, 'interpreter', 'latex', 'FontSize', 16, 'FontWeight', 'Normal');
    set(gca,'xticklabel',[]);
    set(gca,'yticklabel',[]);
    
    if i == length(mats)
        colorbar;
    end
end

% saveas(gcf, 'data/coh.png');