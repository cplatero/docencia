function DeconvVariational
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
n = 256;
name = 'lena';
name = 'mri';
name = 'boat';

f0 = load_image(name);
f0 = rescale(crop(f0,n));

%% Mascara de convolución
s = 3;
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
if using_matlab()
    Phi = @(x,h)real(ifft2(fft2(x).*fft2(h)));
end

y0 = Phi(f0,h);

clf;
imageplot(f0, 'Image f0', 1,2,1);
imageplot(y0, 'Observation without noise', 1,2,2);
pause;
%% Contaminar con ruido
sigma = .02;
y = y0 + randn(n)*sigma;

clf;
imageplot(y0, 'Observation without noise', 1,2,1);
imageplot(clamp(y), 'Observation with noise', 1,2,2);
pause;
%% Deconvolución L2
yF = fft2(y);
lambda = 0.02;
fL2 = real( ifft2( yF .* hF ./ ( abs(hF).^2 + lambda) ) );
clf;
imageplot(y, ['Observation, SNR=' num2str(snr(f0,y),3) 'dB'], 1,2,1);
imageplot(clamp(fL2), ['L2 deconvolution, SNR=' num2str(snr(f0,fL2),3) 'dB'], 1,2,2);
pause;

%% Exercice 1: Find the optimal solution fL2 by testing several value of lambda.
eps_list = linspace(.001, .03, 40);
err = [];
for i=1:length(eps_list)
    epsilon = eps_list(i);
    M1 = real( ifft2( yF .* hF ./ ( abs(hF).^2 + epsilon) ) );
    err(i) = snr(f0,M1);
end
clf;
hp = plot(eps_list, err); axis tight;
set_label('epsilon', 'SNR');
set(hp, 'LineWidth', 2);
pause;


[tmp,i] = max(err);
epsilon = eps_list(i);
fL2 = real( ifft2( yF .* hF ./ ( abs(hF).^2 + epsilon) ) );

%Display optimal result.

clf;
imageplot(y, ['Observation, SNR=' num2str(snr(f0,y),3) 'dB'], 1,2,1);
imageplot(clamp(fL2), ['L2 deconvolution, SNR=' num2str(snr(f0,fL2),3) 'dB'], 1,2,2);
pause;
%% Deconvolution by Sobolev Regularization
S = (X.^2 + Y.^2)*(2/n)^2;
lambda = 0.2;

fSob = real( ifft2( yF .* hF ./ ( abs(hF).^2 + lambda*S) ) );

clf;
imageplot(y, ['Observation, SNR=' num2str(snr(f0,y),3) 'dB'], 1,2,1);
imageplot(clamp(fSob), ['Sobolev deconvolution, SNR=' num2str(snr(f0,fSob),3) 'dB'], 1,2,2);
pause;
%% Exercice 2: Find the optimal solution fSob by testing several value of lambda.
lambda_list = linspace(.05, .4, 40);
err = [];
for i=1:length(lambda_list)
    lambda = lambda_list(i);
    M2 = real( ifft2( yF .* hF ./ ( abs(hF).^2 + lambda*S) ) );
    err(i) = snr(f0,M2);
end
clf;
hp = plot(lambda_list, err); axis tight;
set_label('lambda', 'SNR');
set(hp, 'LineWidth', 2);
pause;
[tmp,i] = max(err);
lambda = lambda_list(i);
fSob = real( ifft2( yF .* hF ./ ( abs(hF).^2 + lambda*S) ) );

clf;
imageplot(y, ['Observation, SNR=' num2str(snr(f0,y),3) 'dB'], 1,2,1);
imageplot(clamp(fSob), ['Sobolev deconvolution, SNR=' num2str(snr(f0,fSob),3) 'dB'], 1,2,2);
pause;
%% Deconvolution by Total Variation Regularization
%% Exercice 3:  Perform the deblurring by a gradient descent. Keep track of the function being minimized.
epsilon = 0.4*1e-2;
lambda = 0.06;
tau = 1.9 / ( 1 + lambda * 8 / epsilon);

niter = 100;
fTV = y;
tv=[];
for i=1:niter
    Gr = grad(fTV);
    d = sqrt( epsilon^2 + sum3(Gr.^2,3) );
    G = -div( Gr./repmat(d, [1 1 2])  );
    
    e = Phi(fTV,h)-y;
    fTV = fTV - tau*( Phi(e,h) + lambda*G);
    tv = [tv;1/2*norm(e,'fro')^2+lambda*sum(d(:))];
end
clf;
plot(tv);
pause;
clf;
imageplot(clamp(fTV));
pause;

clf;
imageplot(clamp(M2), strcat(['Sobolev, SNR=' num2str(snr(f0,M2),3) 'dB']), 1,2,1);
imageplot(clamp(fTV), strcat(['TV, SNR=' num2str(snr(f0,fTV),3) 'dB']), 1,2,2);
pause;
%% Exercice 4:  Explore the different values of lambda to find the optimal solution. Display the SNR as a function of lambda.
lambda_list = linspace(.0001, .005, 10);
err = [];

for i=1:length(lambda_list)
    lambda = lambda_list(i);
    tau = 1.9 / ( 1 + lambda * 8 / epsilon);
    fTV = y;
    for j=i:niter
        Gr = grad(fTV);
        d = sqrt( epsilon^2 + sum3(Gr.^2,3) );
        G = -div( Gr./repmat(d, [1 1 2])  );

        e = Phi(fTV,h)-y;
        fTV = fTV - tau*( Phi(e,h) + lambda*G);
    end
    err(i) = snr(f0,fTV);
end
clf;
hp = plot(lambda_list, err); axis tight;
set_label('lambda', 'SNR');
set(hp, 'LineWidth', 2);
pause;
[tmp,i] = max(err);
lambda = lambda_list(i);
tau = 1.9 / ( 1 + lambda * 8 / epsilon);
fTV = y;
for i=1:niter
    Gr = grad(fTV);
    d = sqrt( epsilon^2 + sum3(Gr.^2,3) );
    G = -div( Gr./repmat(d, [1 1 2])  );

    e = Phi(fTV,h)-y;
    fTV = fTV - tau*( Phi(e,h) + lambda*G);
end

clf;
imageplot(clamp(fSob), strcat(['Sobolev, SNR=' num2str(snr(f0,fSob),3) 'dB']), 1,2,1);
imageplot(clamp(fTV), strcat(['TV, SNR=' num2str(snr(f0,fTV),3) 'dB']), 1,2,2);

%% Exercice 5: (the solution is exo5.m) Compare sparsity, Sobolev and TV deblurring.
Jmax = log2(n)-1;
Jmin = Jmax-3;
%Shortcut for ? and ?? in the orthogonal case.
SoftThresh = @(x,T)x.*max( 0, 1-T./max(abs(x),1e-10) );
options.ti = 0; % use orthogonality.
Psi = @(a)perform_wavelet_transf(a, Jmin, -1,options);
PsiS = @(f)perform_wavelet_transf(f, Jmin, +1,options);
SoftThreshPsi = @(f,T)Psi(SoftThresh(PsiS(f),T));

% clf;
% imageplot( clamp(SoftThreshPsi(y,.1)) );
% pause;

%% Deconvolution using Orthogonal Wavelet Sparsity
lambda = .0025;
tau = 1.5;
niter = 100;
energy = [];
fSpars = y;
for i=1:niter
    fSpars = fSpars + tau * Phi( y-Phi(fSpars,h),h );
    fSpars = SoftThreshPsi( fSpars, lambda*tau );
    fW1 = perform_wavelet_transf(fSpars, Jmin, +1,options);
    energy(i) = 1/2 * norm(y-Phi(fSpars,h), 'fro')^2 +...
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
