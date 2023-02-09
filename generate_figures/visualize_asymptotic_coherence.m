im = rescale(rgb2gray(imread('data/coco1.png')));
n = size(im, 1);
y = dct2(im);

figure();
imshow(im);

f = figure();
f.Position = 1.0e+03 * [1.0003    0.9483    1.08    0.3900];
ax2 = subplot(1, 2, 1);
plot(y(:), 'LineWidth', 1); grid(); box();
xlim([-3000 2.7*1e5]);
ylim([-50 50]);

xlabel('DCT')

wave_name = 'haar';
nres = wmaxlev(n, wave_name);
[y, s] = wavedec2(im, nres, wave_name);
ax3 = subplot(1, 2, 2);
plot(y, 'LineWidth', 1); grid(); box();
xlim([-3000 2.7*1e5]);
ylim([-50 50]);
xlabel('DWT')

linkaxes([ax2 ax3], 'x'); 