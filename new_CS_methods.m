% load image
im = rescale(rgb2gray(imread('data/inisherin2.png')));
n = size(im, 1);
perc = 0.5;
m = round(numel(im) * perc);
epsilon = 1;

% settings
dwtmode('per', 'nodisp');
shearlet_system = SLgetShearletSystem2D(0, size(im, 1), size(im, 2), 4);

% sensing matrix
Had = sqrt(n) * fwht(eye(n), n, 'sequency');
opHad = @(x, mode)  fastwht(fastwht(x, [], 'sequency')', [], 'sequency')' * size(x, 1);

% transformation matrices
opI = @(x, mode) x;
opDCT = @(x, mode) dct2_(x, mode, n);
opHaar = @(x, mode) dwt2_(x, mode, 'haar', n);
opDaub = @(x, mode) dwt2_(x, mode, 'db4', n);
opShear = @(x, mode) dst2_(x, mode, shearlet_system, n);


% sampling pattern
idx = randi(n*n, m, 1);

% experiment
Phi = opHad;
Psi = opDaub;

% 


%

opA = @(x, mode) op_(x, mode, Phi, Psi, idx, n);
s = CS(im, opA, Phi, idx, epsilon);
im_rec = Psi(reshape(s, size(im)), 2);
im_rec = (im_rec - min(im_rec(:)))/(max(im_rec(:)) - min(im_rec(:)));

ssim(im_rec, im)

imshow(im_rec);



function [y] = op_(x, mode, Phi, Psi, idx, n)
    if mode == 1
        z = Psi(x, 2);
        imshow(z);
        y = Phi(z, 1);
        y = y(idx);
        y = y(:);
    else
        z = zeros(n, n);
        z(idx) = x(:);
        z = Phi(z, 2);
        y = Psi(z, 1);
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