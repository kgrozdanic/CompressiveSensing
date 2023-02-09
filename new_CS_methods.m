%% ucitaj sliku
im = rescale(rgb2gray(imread('data/coco5.png')));

% ako se koristi Bernoullijeva matrica, treba smanjiti sliku
% im = imresize(im, 0.25); 

n = size(im, 1);


%% postavke
epsilon = 1;
dwtmode('per', 'nodisp');
shearlet_system = SLgetShearletSystem2D(0, size(im, 1), size(im, 2), 4);

%% matrica ocitavanja
Had = sqrt(n) * fwht(eye(n), n, 'sequency');
opHad = @(x, mode)  fastwht(fastwht(x, [], 'sequency')', [], 'sequency')' * size(x, 1);

%% matrice transformacije
opI = @(x, mode) I_(x, mode, n);
opDCT = @(x, mode) dct2_(x, mode, n);
opHaar = @(x, mode) dwt2_(x, mode, 'haar', n);
opDaub = @(x, mode) dwt2_(x, mode, 'db4', n);
opShear = @(x, mode) dst2_(x, mode, shearlet_system, n);

%% eksperiment1 - razlicite baze i Bernoullijeva matrica
f = figure();
f.Position =  1e+03 * [1.0003    0.2043    0.9840    1.1340];

Bernoulli = randsrc(round(n*n*0.8), n*n, [0, 1]);
percents = [0.12, 0.2, 0.3, 0.5];
Psis = {opDaub, opDCT, opDaub, opShear};
Psi_names = {'I', 'DCT', 'Daubechies-4', 'Shearlet'};
idx = -1;

for i = 1:4
    perc = percents(i);
    m = round(n * n * perc);
    Phi = @(x, mode) bernoulli_(x, mode, Bernoulli(1:m, :), n);    
    for j = 1:length(Psis)
        Psi = Psis{j};
        opA = @(x, mode) op_(x, mode, Phi, Psi, idx, n);
        
        s = CS(im, opA, Phi, idx, epsilon);
        
        subaxis(length(percents), length(Psis), j, i, 'Spacing', 0.011, 'Padding', 0, 'Margin', 0.05);
        im_rec = sc(Psi(s, 2));
        imshow(im_rec);
        
        label_v = xlabel(sprintf('SSIM = %.2f', round(ssim(im_rec, im), 2)), 'FontSize', 12);
        label_v.Position(2) = label_v.Position(2) - 10;
        
        if j == 1
            label_h = ylabel(sprintf('%d%% ocitano', round(perc * 100)), 'FontSize', 13);
            label_h.Position(1) = label_h.Position(1) + 10;
        end  
        if i == 1
            title(Psi_names{j}, 'FontSize', 14, 'FontWeight', 'Normal', 'interpreter', 'latex');
        end
    end
end

saveas(gcf, 'plots/p1.png');


%% eksperiment2 - razlicite baze i Hadamardova matrica, uniformno %%

f = figure();
f.Position =  1e+03 * [1.0003    0.2043    0.9840    1.1340];

percents = [0.12, 0.2, 0.3, 0.8];
Psis = {opI, opDCT, opDaub, opShear};
Psi_names = {'I', 'DCT', 'Daubechies-4', 'Shearlet'};
Phi = opHad;

for i = 1:4
    perc = percents(i);
    m = round(numel(im) * perc);
    idx = randperm(n*n, m);
    for j = 1:length(Psis)
        Psi = Psis{j};
        opA = @(x, mode) op_(x, mode, Phi, Psi, idx, n);
        
        s = CS(im, opA, Phi, idx, epsilon);
        
        subaxis(length(percents), length(Psis), j, i, 'Spacing', 0.011, 'Padding', 0, 'Margin', 0.05);
        im_rec = sc(Psi(s, 2));
        imshow(im_rec);
        
        label_v = xlabel(sprintf('SSIM = %.2f', round(ssim(im_rec, im), 2)), 'FontSize', 12);
        label_v.Position(2) = label_v.Position(2) - 45;
        
        if j == 1
            label_h = ylabel(sprintf('%d%% ocitano', round(perc * 100)), 'FontSize', 13);
            label_h.Position(1) = label_h.Position(1) + 45;
        end  
        if i == 1
            title(Psi_names{j}, 'FontSize', 14, 'FontWeight', 'Normal', 'interpreter', 'latex');
        end
    end
end

saveas(gcf, 'plots/p2.png');


%% eksperiment 3. - hadamard, dct s posebnom strategijom ocitavanja %%
f = figure();
f.Position =  1e+03 * [1.0003    0.2043    0.8160    1.1340];

percents = [0.12, 0.2, 0.3, 0.8];
Psi = opDCT;
Phi = opHad;

for i = 1:4
    perc = percents(i);
    m = round(numel(im) * perc);
    for mode = 1:4
        switch mode
            case 1
                idx = subsampling_schemes_DCT(n, m, mode);
            case 2
                idx = cil_sph2_exp(n, m, 2, 1, 18, 3, 8);
            case 3
                idx = cil_spf2_radial_lines(n, m, 35, true); idx = idx(randperm(numel(idx))); idx = idx(1:m);
            case 4
                idx = cil_sph2_power_law(n, m, 3);
        end
                
        opA = @(x, mode) op_(x, mode, Phi, Psi, idx, n);
        s = CS(im, opA, Phi, idx, epsilon);
        
        
        subaxis(length(percents) + 1, 4, mode, i, 'Spacing', 0.011, 'Padding', 0, 'Margin', 0.05);
        im_rec = sc(Psi(s, 2));
        imshow(im_rec);
        
        label_v = xlabel(sprintf('SSIM = %.2f', round(ssim(im_rec, im), 2)), 'FontSize', 12);
        label_v.Position(2) = label_v.Position(2) - 55;
        
        if mode == 1
            label_h = ylabel(sprintf('%d%% ocitano', round(perc * 100)), 'FontSize', 13);
            label_h.Position(1) = label_h.Position(1) + 55;
        end  
        
        if i == 3
            z = zeros(n, n);
            z(idx) = 1;
            subaxis(5, 4, mode, 5, 'Spacing', 0.011, 'Padding', 0, 'Margin', 0.05);
            imshow(z);
            if mode == 1
                label_h = ylabel('strategija ocitavanja', 'FontSize', 13);
                label_h.Position(1) = label_h.Position(1) + 55;
            end
        end
    end
end

saveas(gcf, 'plots/p3.png');


%% eksperiment 4. - hadamard, dwt-db4 s posebnom strategijom ocitavanja %%
f = figure();
f.Position =  1e+03 * [1.0003    0.2043    0.8160    1.1340];

percents = [0.12, 0.2, 0.3, 0.8];
Psi = opDaub;
Phi = opHad;

for i = 1:4
    perc = percents(i);
    m = round(numel(im) * perc);
    for mode = 1:4
        switch mode
            case 1
                idx = subsampling_schemes_DCT(n, m, mode);
            case 2
                idx = cil_sph2_exp(n, m, 2, 1, 18, 3, 8);
            case 3
                idx = cil_spf2_radial_lines(n, m, 35, true); idx = idx(randperm(numel(idx))); idx = idx(1:m);
            case 4
                idx = cil_sph2_power_law(n, m, 3);
        end
        opA = @(x, mode) op_(x, mode, Phi, Psi, idx, n);
        
        s = CS(im, opA, Phi, idx, epsilon);
        
        
        subaxis(length(percents) + 1, 4, mode, i, 'Spacing', 0.011, 'Padding', 0, 'Margin', 0.05);
        im_rec = sc(Psi(s, 2));
        imshow(im_rec);
        
        label_v = xlabel(sprintf('SSIM = %.2f', round(ssim(im_rec, im), 2)), 'FontSize', 12);
        label_v.Position(2) = label_v.Position(2) - 55;
        
        if mode == 1
            label_h = ylabel(sprintf('%d%% ocitano', round(perc * 100)), 'FontSize', 13);
            label_h.Position(1) = label_h.Position(1) + 55;
        end  
        if i == 1
            title('DWT', 'FontSize', 14, 'FontWeight', 'Normal', 'interpreter', 'latex');
        end
        
        if i == 3
            z = zeros(n, n);
            z(idx) = 1;
            subaxis(5, 4, mode, 5, 'Spacing', 0.011, 'Padding', 0, 'Margin', 0.05);
            imshow(z);
            if mode == 1
                label_h = ylabel('strategija ocitavanja', 'FontSize', 13);
                label_h.Position(1) = label_h.Position(1) + 55;
            end
        end
    end
    
end

saveas(gcf, 'data/p4.png');




%% pomocne funkcije %%
function [im] = sc(im)
    im(im < 0) = 0;
    im(im > 1) = 1;
end

function [y] = op_(x, mode, Phi, Psi, idx, n)
    if mode == 1
        z = Psi(x, 2);
        
        y = Phi(z, 1);
        if idx ~= -1
            y = y(idx);
        end
        y = y(:);
    else
        if idx ~= -1
            z = zeros(n, n);
            z(idx) = x(:);
        else 
            z = x;
        end
        z = Phi(z, 2);
        y = Psi(z, 1);
    end
end


function [y] = bernoulli_(x, mode, Phi, n)
    if mode == 1
        y = Phi * x(:);
    else
        y = Phi' * x;
        y = reshape(y, [n, n]);
    end
end



function [y] = I_(x, mode, n)
    if mode == 1
        y = x(:);
    else
        y = reshape(x, [n, n]);
    end
end


function [y] = dct2_(x, mode, n)
    if mode == 1
        y = dct2(x);
        y = y(:);
    else
        x = reshape(x, [n, n]);
        y = idct2(x);
    end
end


function [y] = dwt2_(x, mode, wave_name, n)
    nres = wmaxlev(n, wave_name);
    
    if mode == 1     
        [y, ~] = wavedec2(x, nres, wave_name);
        y = y';
    else
        dim = round(log2(n));
        S = 2.^[dim-nres, (dim-nres):dim;   dim-nres, (dim-nres):dim ]';
        x = reshape(x, [], 1);
        y = waverec2(x, S, wave_name);
    end
end


function [y] = dst2_(x, mode, shearlet_system, n)
    dim3 = length(shearlet_system.RMS);
    
    if mode == 1      
        y = SLsheardec2D(x, shearlet_system);
        y = reshape(y, [n*n*dim3, 1]);
    else
        x = reshape(x, [n, n, dim3]);
        y = SLshearrec2D(x, shearlet_system);
    end
end