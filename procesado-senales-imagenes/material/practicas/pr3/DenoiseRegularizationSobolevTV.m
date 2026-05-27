function DenoiseRegularizationSobolevTV
%% Toolbox Peyre
getd = @(pt)path(pt,path);

getd('D:\compartido\cplatero\Hipocampo\fuentes\old\AP\NLMeans\toolbox_signal\');
getd('D:\compartido\cplatero\Hipocampo\fuentes\old\AP\NLMeans\toolbox_general\');

% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_signal/');
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_general/');
% getd('D:/compartido/cplatero/misce/wavelets/fuentes/peyre/toolbox_signal/');
% getd('D:/compartido/cplatero/misce/wavelets/fuentes/peyre/toolbox_general/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_signal/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_general/');

%% Cargar imagen
n = 256;
name = 'hibiscus';
f0 = load_image(name,n);
f0 = rescale( sum(f0,3) );

Gr = grad(f0);

d = sqrt(sum3(Gr.^2,3));

clf;
imageplot(Gr, strcat(['grad']), 1,2,1);
imageplot(d, strcat(['|grad|']), 1,2,2);
pause;

sigma = .1;
y = f0 + randn(n,n)*sigma;

%% Computar a priori Sobolev
yF = fft2(y);

x = [0:n/2-1, -n/2:-1];
[Y,X] = meshgrid(x,x);
S = (X.^2 + Y.^2)*(2/n)^2;

figure;
imshow(S/max(S(:)));
pause;

lambda = 20;

fSob = real( ifft2( yF ./ ( 1 + lambda*S) ) );

clf;
imageplot(clamp(fSob));
pause;

%% Exercice 1: Compute the solution for several value of  and choose the optimal lambda and the corresponding optimal denoising fSob0. You can increase progressively lambda and reduce considerably the number of iterations.
M=f0;
lambda_list = linspace(.05, 40, 40);
err = [];
for i=1:length(lambda_list)
    lambda = lambda_list(i);
    % M1 = real( ifft2( yF .* hF ./ ( abs(hF).^2 + lambda*S) ) );
    M1 = real( ifft2( yF ./ ( 1 + lambda*S) ) );
    err(i) = snr(M,M1);
end
clf;
h = plot(lambda_list, err); axis tight;
set_label('lambda', 'SNR');
set(h, 'LineWidth', 2);
[tmp,i] = max(err);
lambda = lambda_list(i);
pause;

%M1 = real( ifft2( yF .* hF ./ ( abs(hF).^2 + lambda*S) ) );
M1 = real( ifft2( yF ./ ( 1 + lambda*S) ) );
esob = snr(f0,M1);  enoisy = snr(f0,y);
clf;
imageplot(clamp(y), strcat(['Noisy ' num2str(enoisy,3) 'dB']), 1,2,1);
imageplot(clamp(M1), strcat(['Sobolev regularization ' num2str(esob,3) 'dB']), 1,2,2);
pause;
%% Exercice 2: Compute the total variation of f0.
Gr = grad(f0);
d = (Gr(:,:,1).^2 + Gr(:,:,2).^2).^.5;
TV = sum (d(:));
clf;
imshow(f0);
title(sprintf('TV = %.0f',TV));
pause;

%% e->0
u = linspace(-5,5)';
clf;
subplot(2,1,1); hold('on');
plot(u, abs(u), 'b');
plot(u, sqrt(.5^2+u.^2), 'r');
title('\epsilon=1/2'); axis('square');
subplot(2,1,2); hold('on');
plot(u, abs(u), 'b');
plot(u, sqrt(1^2+u.^2), 'r');
title('\epsilon=1'); axis('square');
pause;

%% When  increases, the smoothed TV gradient approaches the Laplacian (normalized by 1).
epsilon_list = [1e-9 1e-2 1e-1 .5];
clf;
for i=1:length(epsilon_list)
    G = div( Gr ./ repmat( sqrt( epsilon_list(i)^2 + d.^2 ) , [1 1 2]) );
    imageplot(G, strcat(['epsilon=' num2str(epsilon_list(i))]), 2,2,i);
end
pause;
%% Total Variation Regulariation for Denoising
%% Exercice 3: Compute the gradient descent and monitor the minimized energy.
epsilon = 1e-2;
lambda = .1;
tau = 2 / ( 1 + lambda * 8 / epsilon);
niter=200;
fTV = y;

energy=[];

for i=1:niter
    Gr = grad(fTV);
    d = sqrt(sum3(Gr.^2,3));
    G0 = -div( Gr ./ repmat( sqrt( epsilon^2 + d.^2 ) , [1 1 2]) );
    G = fTV-y+lambda*G0;
    deps = sqrt( epsilon^2 + d.^2 );
    energy(i) = 1/2*norm( y-fTV,'fro' )^2 + lambda*sum(deps(:));
    fTV = fTV - tau*G;
end
clf;
plot(energy);
pause;

%% Exercice 4: Compute the solution for several value of  and choose the 
% optimal  and the corresponding optimal denoising fSob0. 
% You can increase progressively  and reduce considerably the number of iterations.
niter = 400;
lambda_list = linspace(0,1,niter);
M=y;M0=f0;
Mtvr = M;
energy = [];
for i=1:niter
    lambda = lambda_list(i);    
    Gr = grad(Mtvr);
    d = sqrt(sum3(Gr.^2,3));
    G0 = -div( Gr ./ repmat( sqrt( epsilon^2 + d.^2 ) , [1 1 2]) );
    G = Mtvr-M+lambda*G0;
    deps = sqrt( epsilon^2 + d.^2 );
    Mtvr = Mtvr - tau*G;
    err(i) = snr(M0,Mtvr);
    if i>1
        if err(i) > max(err(1:i-1))
            Mtvr0 = Mtvr;
        end
    end
end
clf;
plot(lambda_list, err); axis('tight');
set_label('lambda', 'SNR');
pause;

%%
clf;
imageplot(clamp(y), strcat(['Noisy ' num2str(snr(f0,y),3) 'dB']), 1,2,1);
imageplot(clamp(fTV), strcat(['TV regularization ' num2str(snr(f0,fTV),3) 'dB']), 1,2,2);
pause;
%% Exercice 5: Compare the TV denoising with a hard thresholding in a translation invariant tight frame of wavelets.
extend_stack_size(4);
Jmin = 4;
options.ti = 1;
MW = perform_wavelet_transf(M, Jmin, +1, options);
MWT = perform_thresholding(MW, 3*sigma, 'hard');
Mwav = perform_wavelet_transf(MWT, Jmin, -1, options);
ewav = snr(M0,Mwav); 
clf;
imageplot(clamp(M), strcat(['Noisy ' num2str(snr(f0,M)) 'dB']), 1,2,1);
imageplot(clamp(Mwav), strcat(['Wavelets TI ' num2str(ewav) 'dB']), 1,2,2);

