function IntroductionImageProcessing
%% Toolbox Peyre
getd = @(pt)path(pt,path);
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_signal/');
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_general/');
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_signal\');
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_general\');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_signal/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_general/');

%% Image Loading and Displaying
name = 'lena';
n = 256;
M = load_image(name, []);
M = rescale(crop(M,n));

clf;
imageplot(M, 'Original', 1,2,1);
imageplot(crop(M,50), 'Zoom', 1,2,2);
pause;

%% An image is a 2D array, that can be modified as a matrix.
clf;
imageplot(-M, '-M', 1,2,1);
imageplot(M(n:-1:1,:), 'Flipped', 1,2,2);
pause;

%% compute the low pass kernel
k = 9;
h = ones(k,k);
h = h/sum(h(:));
% compute the convolution
Mh = perform_convolution(M,h);
% display
clf;
imageplot(M, 'Image', 1,2,1);
imageplot(Mh, 'Blurred', 1,2,2);
pause;
%% Several differential and convolution operators are implemented.
G = grad(M);
clf;
imageplot(G(:,:,1), 'd/dx', 1,2,1);
imageplot(G(:,:,2), 'd/dy', 1,2,2);
pause;

%% FFT2
Mf = fft2(M);
Lf = fftshift(log( abs(Mf)+1e-1 ));
clf;
imageplot(M, 'Image', 1,2,1);
imageplot(Lf, 'Fourier transform', 1,2,2);
pause;

e_Mf= sum(abs(Mf(:)).^2)./size(Mf,1)./size(Mf,2);
e_M= sum(abs(M(:)).^2);
fprintf('Image energy %.0f, spectrum energy %.0f\n',e_M,e_Mf);
pause;
%% Exercise 1 
% To avoid boundary artifacts and estimate really the frequency content of
% the image (and not of the artifacts!), one needs to multiply M by a 
% smooth windowing function h and compute fft2(M.*h). 
% Use a sine windowing function. 
% Can you interpret the resulting filter ?
% compute kernel h
t = linspace(-pi(),pi(),n);
h = (cos(t)+1)/2;
h = h'*h;
% compute FFT
Mf = fft2(M.*h);
Lf = fftshift(log( abs(Mf)+1e-1 ));
% display
clf;
imageplot(M.*h, 'Image', 1,2,1);
imageplot(Lf, 'Fourier transform', 1,2,2);
pause;
%% Exercice 2 
% Perform low pass filtering by removing the high frequencies of the spectrum.
% What do you oberve ?
% k = round(.8*n); k = round(k/2)*2; % even number
% Mf = fft2(M);
% Mf(n/2-k/2+2:n/2+k/2, n/2-k/2+2:n/2+k/2) = 0;
% Mh = real( ifft2(Mf) );
Mh = real( ifft2(fftshift(fftshift(Mf).*h)) );
% display
clf;
imageplot( crop(M), 'Image', 1,2,1);
imageplot(clamp( crop(Mh)), 'Low pass filtered', 1,2,2);
pause;
%% Interpolation
% It is possible to do image interpolating by adding highfrequencies
p = 64;
n = p*4;
M = load_image('boat', 2*p); M = crop(M,p);
Mf = fftshift(fft2(M));
MF = zeros(n,n);
sel = n/2-p/2+1:n/2+p/2;
% sel = sel;
MF(sel, sel) = Mf;
MF = fftshift(MF);
Mpad = real(ifft2(MF));
clf;
imageplot( crop(M), 'Image', 1,2,1);
imageplot( crop(Mpad), 'Interpolated', 1,2,2);
pause;

% A better way to do interpolation is to use cubic-splines.
% It avoid ringing artifact because the spline kernel has a smaller support with less oscillations.

Mspline = image_resize(M,n,n);
clf;
imageplot( crop(Mpad), 'Fourier (sinc)', 1,2,1);
imageplot( crop(Mspline), 'Spline', 1,2,2);
pause;