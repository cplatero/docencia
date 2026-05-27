function DeconvSparse
%% Toolbox Peyre
getd = @(pt)path(pt,path);

getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_signal\');
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_general\');

% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_signal/');
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_general/');
% getd('D:/compartido/cplatero/misce/wavelets/fuentes/peyre/toolbox_signal/');
% getd('D:/compartido/cplatero/misce/wavelets/fuentes/peyre/toolbox_general/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_signal/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_general/');

%% Cargar la imagen
setting = 1;
switch setting
    case 1
        % difficult
        s = 3;
        sigma = .02;
    case 2
        % easy
        s = 1.2;
        sigma = .02;
end

n = 256;
name = 'lena';
name = 'boat';
name = 'mri';

f0 = load_image(name);
f0 = rescale(crop(f0,n));

%% Mascara de convolución
x = [0:n/2-1, -n/2:-1];
[Y,X] = meshgrid(x,x);
h = exp( (-X.^2-Y.^2)/(2*s^2) );
h = h/sum(h(:));


hF = real(fft2(h));

clf;
imageplot(fftshift(h), 'Filter', 1,2,1);
imageplot(fftshift(hF), 'Fourier transform', 1,2,2);
pause;

%% Construir imagen desenfocada
Phi = @(x)real(ifft2(fft2(x).*hF));
y0 = Phi(f0);

clf;
imageplot(f0, 'Image f0', 1,2,1);
imageplot(y0, 'Observation without noise', 1,2,2);
pause;
%% Contaminar con ruido
y = y0 + randn(n)*sigma;

clf;
imageplot(y0, 'Observation without noise', 1,2,1);
imageplot(clamp(y), 'Observation with noise', 1,2,2);
pause;

%% Soft rule
SoftThresh = @(x,T)x.*max( 0, 1-T./max(abs(x),1e-10) );
clf;
T = linspace(-1,1,1000);
plot( T, SoftThresh(T,.5) );
axis('equal');
pause;

%% Deconvolution sparse step

Jmax = log2(n)-1;
Jmin = Jmax-3;
options.ti = 0; % use orthogonality.
Psi = @(a)perform_wavelet_transf(a, Jmin, -1,options);
PsiS = @(f)perform_wavelet_transf(f, Jmin, +1,options);
SoftThreshPsi = @(f,T)Psi(SoftThresh(PsiS(f),T));

clf;
imageplot( clamp(SoftThreshPsi(f0,.1)) );
pause;

%% Deconvolution using Orthogonal Wavelet Sparsity
%% Exercice 1:  Perform the iterative soft thresholding. Monitor the decay of the energy E you are minimizing.
lambda = .02;
tau = 1.5;
niter = 100;
energy = [];
fSpars = y;
for i=1:niter
    fSpars = fSpars + tau * Phi( y-Phi(fSpars) );
    fSpars = SoftThreshPsi( fSpars, lambda*tau );
    fW1 = perform_wavelet_transf(fSpars, Jmin, +1,options);
    energy(i) = 1/2 * norm(y-Phi(fSpars), 'fro')^2 +...
        lambda * sum(abs(fW1(:)));
end
clf;
hp = plot(energy); axis([1,niter,min(energy)*1.05+max(energy)*(-.05) max(energy)]);
set_label('Iteration', 'Energia');
set(hp, 'LineWidth', 2);
pause;
clf;
imageplot(clamp(fSpars), ['Sparsity deconvolution, SNR=' num2str(snr(f0,fSpars),3) 'dB']);
pause;
%% Exercice 2:  Try to find the best threshold ?.
%% To this end, perform a lot of iterations, and progressively decay the threshold ? during the iterations. Record the best result in fBestOrtho.
lambda_max = .002;
fSpars = y;
% warm up session
lambda = lambda_max;
for i=1:100
    fSpars = fSpars + tau * Phi( y-Phi(fSpars) );
    % thresholding 
    fW1 = perform_wavelet_transf(fSpars, Jmin, +1,options);
    fW = perform_thresholding( fW1, lambda*tau, 'soft' );
    fW(1:2^Jmin,1:2^Jmin) = fW1(1:2^Jmin,1:2^Jmin);
    fSpars = perform_wavelet_transf(fW, Jmin, -1,options);
end

fBestOrtho = fSpars;

% niter = 1000;
% lambda_list = linspace(lambda_max,0,niter);
% err = [];
% for i=1:niter
%     fSpars = fSpars + tau * Phi( y-Phi(fSpars) );
%     % thresholding
%     lambda = lambda_list(i); 
%     fW1 = perform_wavelet_transf(fSpars, Jmin, +1,options);
%     fW = perform_thresholding( fW1, lambda*tau, 'soft' );
%     fW(1:2^Jmin,1:2^Jmin) = fW1(1:2^Jmin,1:2^Jmin);
%     fSpars = perform_wavelet_transf(fW, Jmin, -1,options);
%     % record the error
%     err(i) = snr(f0,fSpars);
%     if i>1 && err(i)>max(err(1:i-1))
%         fBestOrtho = fSpars;
%     end
% end
% clf;
% h = plot(lambda_list,err); 
% axis tight;
% set_label('lambda', 'SNR');
% set(h, 'LineWidth', 2);
% pause;

clf;
imageplot(clamp(fBestOrtho), ['Sparsity deconvolution, SNR=' num2str(snr(f0,fBestOrtho),3) 'dB']);
pause;

%% Deconvolution using Translation Invariant Wavelet Sparsity
%% Exercice 3: Perform the iterative soft thresholding. Monitor the decay of the energy.


J = Jmax-Jmin+1;
u = [4^(-J) 4.^(-floor(J+2/3:-1/3:1)) ];
U = repmat( reshape(u,[1 1 length(u)]), [n n 1] );
lambda = .003;
options.ti = 1; % use translation invariance
Psi = @(a)perform_wavelet_transf(a, Jmin, -1,options);
PsiS = @(f)perform_wavelet_transf(f, Jmin, +1,options);

a = PsiS(y);
tau = 1.5;
energy=[];
for i=1:100
    a = a + tau * PsiS( Phi( y-Phi(Psi(a)) ) );
    a = SoftThresh( a, lambda*tau );
    energy(i) = 1/2 * norm(y-Phi(Psi(a)), 'fro')^2 +...
        lambda * sum(sum(sum( abs(a.*U) )));    
end
plot(energy);
pause;

fBestTI= Psi(a);
clf;
imageplot(clamp(fBestTI), ['Sparsity deconvolution TI, SNR=' num2str(snr(f0,fBestTI),3) 'dB']);
