im = rescale(rgb2gray(imread('data/lenna.png')));

N = 128 ;

% Hada = sqrt(N) * fwht(eye(N), N, 'dyadic');
Hada2 = sqrt(N) * fwht(eye(N), N, 'sequency');
% Hada3 = sqrt(N) * fwht(eye(N), N, 'hadamard');
Four = (1 / sqrt(N)) * dftmtx(N);
Cosin = dctmtx(N);
Haar = generate_wavelet(N, 'haar');%generate_haar(512);
DB1 = generate_wavelet(N, 'db10');

% figure();
U1 = Four * DB1';
% imshow(abs(U1)); colormap parula; colorbar;
% 
% figure();
U2 = Cosin * DB1';
% imshow(abs(U2)); colormap parula; colorbar;


% figure();* 
U4 = Cosin * DB1';
% imagesc(abs(U4)); colormap parula; colorbar;

% figure()
U3 = Hada * DB1';
% imshow(abs(U3)); colormap parula; colorbar;


% haar, dmey, sym4, coif4, fk6

Psi = {Hada2, Four, Cosin, "haar", "db4"};%  "db8", "db12", "dmey", "sym4", "sym10", "sym22"};%    "bior1.1", "bior2.8", "bior5.5",     "rbio1.1", "rbio2.8", "rbio5.5", "coif1", "coif4", "fk6", "fk22"};
% Psi = {Hada, Cosin, "dmey", "sym4"};

figure();
colormap(jet);
m = size(Psi, 2);

nrows = 3;% * 3;
ncols = m;

for i = 1:m
    for j = i:m
        
%         if i >= 4 && j >= 4
%             continue;
%         end
        
        if isstring(Psi{i})
            U1 = generate_wavelet(N, char(Psi{i}));
        else
            U1 = Psi{i};
        end
            
       if isstring(Psi{j})
            U2 = generate_wavelet(N, char(Psi{j}));
        else
            U2 = Psi{j};
       end
           
%         caxis manual
%         caxis([0 1]);
        subaxis(nrows, ncols, j, i, 1, 1, 'Spacing', 0, 'Padding', 0.01, 'Margin', 0);
        imagesc(abs(U1 * U2')); 
        set(gca,'xtick',[]); set(gca,'ytick',[]);
        
%         caxis manual
%         caxis([0 1]);
        %subaxis(nrows, ncols, i, j * 3, 1, 1, 'Spacing', 0, 'Padding', 0.03, 'Margin', 0);
        %imagesc(mean(abs(U1 * U2'), 1)); 
        %set(gca,'xtick',[]); set(gca,'ytick',[]);
    end
    set(gca,'xticklabel',[]); set(gca,'yticklabel',[]);
end

