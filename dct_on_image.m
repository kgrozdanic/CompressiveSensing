im = rescale(rgb2gray(imread('data/lenna.png')));
x = reshape(im, [], 1);

y = dct(x);

figure();
%subplot(1, 3, 1);
imshow(im);

figure()
ax2 = subplot(1, 2, 1);
plot(y);
xlim([-3000 3*1e5]);
ylim([-40 40]);

xlabel('DCT')

[a, d] = haart(x);
y = cat(1, d{size(d, 2):-1:1}); % konkateniraj dobivene koeficijente u vektor
ax3 = subplot(1, 2, 2);
plot(y);
xlim([-3000 1*1e5]);
ylim([-20 20]);
xlabel('DWT')

linkaxes([ax2 ax3], 'x'); 
% linkaxes([ax2 ax3], 'y');