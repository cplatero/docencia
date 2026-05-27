function DenoisingLinearMethod
%% Toolbox Peyre
getd = @(pt)path(pt,path);
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_signal\');
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_general\');

% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_signal/');
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_general/');
% getd('D:/compartido/cplatero/wavelets/fuentes/peyre/toolbox_signal/');
% getd('D:/compartido/cplatero/wavelets/fuentes/peyre/toolbox_general/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_signal/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_general/');
%% We load a signal.
name = 'piece-regular';
n = 1024;
x0 = load_signal(name,n);
x0 = rescale(x0);
% We add some noise to it.
sigma = .04; % noise level
x = x0 + sigma*randn(size(x0));
clf;
subplot(2,1,1);
plot(x0); axis([1 n -.05 1.05]);
subplot(2,1,2);
plot(x); axis([1 n -.05 1.05]);
pause;

%% We load an image.
n = 256;
name = 'hibiscus';
M0 = load_image(name,n);
M0 = rescale( sum(M0,3) );
% Then we add some gaussian noise to it.
sigma = .08; % noise level
M = M0 + sigma*randn(size(M0));
clf;
imageplot(M0, 'Original', 1,2,1);
imageplot(clamp(M), 'Noisy', 1,2,2);
pause;
%% Filtro de Gauss
% width of the filter
mu = 4;
% compute a Gaussian filter of width mu
t = (-length(x)/2:length(x)/2-1)';
h = exp( -(t.^2)/(2*mu^2) );
h = h/sum(h(:));

%The Fourier transform of a Gaussian discrete filter is 
%nearly a Gaussian whose width is proportional to 1/mu.

% Fourier transform of the (centered) filter
hf = real( fft(fftshift(h)) );
hf = fftshift(hf);
% display
clf;
subplot(2,1,1);
plot( t,h  ); axis('tight');
title('Filter h');
subplot(2,1,2);
plot( t,hf  ); axis('tight');
title('Fourier transform');
pause;

%% Procesamiento 
% Fourier coefficients of the noisy signal
xf = fft(x);
% Fourier coefficients of the denoised signal
xhf = xf .* fft(fftshift(h));
% Denoised signal
xh = real( ifft(xhf) );

clf;
subplot(2,1,1);
plot( t,x  ); axis('tight');
title('Noisy');
subplot(2,1,2);
plot( t,xh  ); axis('tight');
title('Denoised');
pause;

%% Visualización del espectro
% log of Fourier transforms
epsilon = 1e-10;
L0 = log10(epsilon+abs(fftshift(fft(x0))));
L = log10(epsilon+abs(fftshift(xf)));
Lh = log10(epsilon+abs(fftshift(xhf)));
% display Fourier transforms
clf;
subplot(3,1,1);
plot( t, L0, '-' );
axis([-length(x)/2 length(x)/2 -4 max(L0)]);
title('log of Fourier coefs.');
subplot(3,1,2);
plot( t, L, '-' );
axis([-length(x)/2 length(x)/2 -4 max(L)]);
title('log of noisy Fourier coefs.');
subplot(3,1,3);
plot( t, Lh, '-' );
axis([-length(x)/2 length(x)/2 -4 max(L)]);
title('log of denoised Fourier coefs.');
pause;
%% Varios filtros de Gauss 
mulist = [.5, 1, 1.4, 2 ,2.5,3,4];%linspace(.5,4,4);
clf;
for i=1:length(mulist)
    mu = mulist(i);
    % compute the filter
    h = exp( -(t.^2)/(2*mu^2) );
    h = h/sum(h(:));
    % perform the blurring
    xh = real( ifft( fft(x) .* fft(fftshift(h)) ));
    subplot( 7,1,i );
    plot(t, clamp(xh) ); axis('tight');
    title(strcat(['\mu=' num2str(mu)]));
end
pause;
%% Exercice 1: Oracle
% display blurring for various mu
% compute the error for many mu
mulist = linspace(.1,3.5,31);
err =  [];
for i=1:length(mulist)
    mu = mulist(i);
    % compute the filter   
    h = exp( -(t.^2)/(2*mu^2) );
    h = h/sum(h(:));
    % perform blurring
    xh = real( ifft( fft(x) .* fft(fftshift(h)) ));
    err(i) = snr(x0,xh);
end
clf;
plot(mulist,err, '.-'); axis('tight');
set_label('\mu', 'SNR');
% retrieve the best denoising result
[snr_opt,I] = max(err);
muopt = mulist(I);
disp( strcat(['The optimal smoothing width is ' num2str(muopt) ' pixels, SNR=' num2str(snr_opt) 'dB.']) );
pause;
%% Display the results.

% compute the optimal filter
h = exp( -(t.^2)/(2*muopt^2) );
h = h/sum(h(:));
% perform blurring
xh = real( ifft( fft(x) .* fft(fftshift(h)) ));
% display
clf;
subplot(2,1,1);
plot(t, clamp(x)); axis('tight');
title('Noisy');
subplot(2,1,2);
plot(t, clamp(xh)); axis('tight');
title('Denoised');
pause;

%% En una función y para 2D: perform_blurring
%
% 2D
%
% we use cyclic boundary condition since it is quite faster
options.bound = 'per';
% number of pixel of the filter
mu = 10;
Mh = perform_blurring(M,mu,options);
clf;
imageplot(clamp(M), 'Noisy', 1,2,1);
imageplot(clamp(Mh), 'Blurred', 1,2,2);
pause;

mulist = linspace(3,15,6);
clf;
for i=1:length(mulist)
    mu = mulist(i);
    Mh = perform_blurring(M,mu,options);
    imageplot(clamp(Mh), strcat(['\mu=' num2str(mu)]), 2,3,i);
end
pause;

%% Exercice 2: Try for various Gaussian variance to compute the denoising Mh. Compute,
% in an oracle manner, the best variance muopt by computing the residual error snr(M0,Mh).
% now compute the error for many mu
mulist = linspace(.3,6,31);
err =  [];
for i=1:length(mulist)
    mu = mulist(i);
    Mh = perform_blurring(M,mu,options);
    err(i) = snr(M0,Mh);
end
clf;
plot(mulist,err, '.-'); axis('tight');
set_label('\mu', 'SNR');
% retrieve the best denoising result
[snr_opt,I] = max(err);
muopt = mulist(I);
disp( strcat(['The optimal smoothing width is ' num2str(muopt) ' pixels, SNR=' num2str(snr_opt) 'dB.']) );
pause;

% optimal filter
Mgauss = perform_blurring(M,muopt,options);
% display
clf;
imageplot(M, strcat(['Noisy, SNR=' num2str(snr(M0,M)) 'dB']), 1,2,1);
imageplot(Mgauss, strcat(['Gaussian denoise, SNR=' num2str(snr(M0,Mgauss)) 'dB']), 1,2,2);
pause;
%% Wiener filtering
[Mwien,Hwien] = peform_wiener_filtering(M0,M,sigma);
k = 5;
clf;
imageplot(Hwien(n/2-k+2:n/2+k,n/2-k+2:n/2+k), 'Wiener filter (zoom)');
pause;
clf;
imageplot( clamp(Mgauss), strcat(['Gaussian denoise, SNR=' num2str(snr(M0,Mgauss)) 'dB']), 1,2,1);
imageplot( clamp(Mwien), strcat(['Wiener denoise, SNR=' num2str(snr(M0,Mwien)) 'dB']), 1,2,2);

