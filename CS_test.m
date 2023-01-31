perc = 0.1;
epsilon = 1;

im = rescale(rgb2gray(imread('data/lenna.png')));
% 
% x = dct(im(:));
% 
% n = size(x, 1);
% m = round(numel(x) * perc);
% idx = randi(numel(x), m, 1);
% 
% opA = @(x_, mode_) op(x_, mode_, idx, n);
% s = CS(x, opA, idx, epsilon);
% 
% % im_rec = reshape(op(reshape(s, [512, 51]), 2, 1:numel(im), n), [n, n]);
% % imagesc(im_rec);
% 
% imshow(reshape(idct(s), [512, 512]));
% 
% ssim(im, reshape(idct(s), [512, 512]))
% 

% x = dct2(im);
% x = x(:);
x = im;
n = size(x, 1);
m = round(numel(x) * perc);

%%% idxEXING %%%
% idx = randi(numel(x), m, 1);
% idx = round(normalize(abs(randn(m, 1)) .^ 2, 'range') * (numel(x) - 1)) + 1;
num_fully_sampled = 1;

levels = 50;
%idx = cil_sph2_exp(n, m, 2, 1, 18, 3, 2); % z = zeros(512, 512); z(idx) = 1; imshow(z);
% idx = cil_sph2_exp(n, m, 1, 1, 50, 1, 2); z = zeros(512, 512); z(idx) = 1; imshow(z);
% idx = cil_sph2_exp(n, m, 50, 1, levels, 3, 2); % z = zeros(512, 512); z(idx) = 1; imshow(z);
% idx = cil_sph2_exp(n, m, 50, 2, levels, 5, 4); z = zeros(512, 512); z(idx) = 1; imshow(z); figure();
% idx = cil_sph2_exp(n, m, 4, 2, 50, 5, 30); z = zeros(512, 512); z(idx) = 1; imshow(z); figure();
% idx = cil_sph2_exp(n, m, 2, 3, 50, 5, 30); z = zeros(512, 512); z(idx) = 1; imshow(z); figure();
% idx = cil_sph2_exp(n, m, 1, 3, 50, 2, 10); z = zeros(512, 512); z(idx) = 1; imshow(z); figure();
% idx = cil_sph2_exp(n, m, 6, 3, 50, 2, 10); z = zeros(512, 512); z(idx) = 1; imshow(z); figure();
idx = randperm(n*n); idx = idx(1:m); % 0.59
% idx = randi(n*n, m, 1); % 0.58
% idx = cil_sph2_exp(n, m, 6, 3, 50, 2, 0.2); % z = zeros(512, 512); z(idx) = 1; imshow(z); figure();
% idx = cil_sph2_exp(n, m, 6, 3, 50, 2, 0.3);
% idx = cil_spf2_radial_lines(n, m, 120, 'true');
% idx = cil_spf2_radial_lines(n, m, 50, true); idx = idx(randperm(numel(idx))); idx = idx(1:m);

% idx = cil_spf2_power_law(n, m, 0.5); % 0.58

opA = @(x, mode) op(x, mode, idx, n);
% opA = @(x, mode) cil_op_fourier_2d(x, mode, n, idx);


s = CS(x, opA, idx, epsilon);
im_ = idct2(reshape(s, [512, 512]));
figure(); imshow(im_);
ssim(im, im_)
