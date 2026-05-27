function SobolevTV_flow
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

%% Cargar la imagen
n = 256;
name = 'hibiscus';
f0 = load_image(name,n);
f0 = rescale( sum(f0,3) );

%% Calcular el gradiente
Gr = grad(f0);
d = sqrt(sum3(Gr.^2,3));

clf;
imageplot(Gr, strcat(['grad']), 1,2,1);
imageplot(d, strcat(['|grad|']), 1,2,2);
pause;

%% Norma Sobolev .
sob = sum(d(:).^2);
fprintf('Sobolev norm: %d\n',sob);

%Ruido blanco
sigma = .14;
y = f0 + randn(n,n)*sigma;


% Laplaciana
fHeat = y;
L = div(grad(fHeat));

imageplot(fHeat, 'Image', 1,2,1);
imageplot(L, 'Laplacian', 1,2,2);
pause;

%% Flujo del calor
% Exercice 1: Compute niter iterations of the Heat diffusion. 
% Keep track of err(i)=snr(f0,fHeat). Keep track of the optimal denoising result fHeat0.
tau = .24;
T = 3;
niter = ceil(T/tau);

err = [];
fheat = y;
clf; k = 0;
for i=1:niter
    lap = -div(grad(fheat));
    fheat = fheat - tau*lap;
    if mod(i,floor(niter/4))==0
        k = k+1;
        imageplot(clamp(fheat), strcat(['T=' num2str(T*k/4,3)]), 2,2,k );
    end
    err(i) = snr(f0,fheat);
    if i>1
        if err(i) > max(err(1:i-1))
            fHeat0 = fheat;
        end
    end
end
pause;
%% plot SNR
clf;
plot( linspace(0,T,niter), err ); axis tight;
set_label('t', 'SNR');
pause;
%% Resultados del óptimo
eheat = max(err); enoisy = snr(f0,y);
% clf;
figure;
imageplot(clamp(y), strcat(['Noisy ' num2str(enoisy) 'dB']), 1,2,1);
imageplot(clamp(fHeat0), strcat(['Heat diffusion ' num2str(eheat) 'dB']), 1,2,2);
pause;
%% Exercice 2: Compute the total variation of f0.Norma TV
norTV = sum(sum((Gr(:,:,1).^2 + Gr(:,:,2).^2).^.5));
clf;
imshow(f0);title(sprintf('TV norm: %d',norTV));
pause;
%% Regularización TV
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

epsilon_list = [1e-9 1e-2 1e-1 .5];
clf;
for i=1:length(epsilon_list)
    G = div( Gr ./ repmat( sqrt( epsilon_list(i)^2 + d.^2 ) , [1 1 2]) );
    imageplot(G, strcat(['epsilon=' num2str(epsilon_list(i))]), 2,2,i);
end
pause;

%% Exercice 3: Compute niter iterations of the smoothed TV diffusion. 
% Keep track of err(i)=snr(f0,fTV). Keep track of the optimal denoising result fTV0.

epsilon = 1e-2;
T = 1/4;
tau = epsilon/4;
niter = ceil(T/tau);
fTV = y;
err = [];

clf; k = 0;
for i=1:niter
    Gr = grad(fTV);
    d = sqrt(sum3(Gr.^2,3));
    G = -div( Gr ./ repmat( sqrt( epsilon^2 + d.^2 ) , [1 1 2]) );
    fTV = fTV - tau*G;
    if mod(i,floor(niter/4))==0
        k = k+1;
        imageplot(clamp(fTV), strcat(['T=' num2str(T*k/4,3)]), 2,2,k );
    end
    err(i) = snr(f0,fTV);
    if i>1
        if err(i) > max(err(1:i-1))
            fTV0 = fTV;
        end
    end
end
pause;

%Visualización
clf;
plot( linspace(0,T,niter), err ); axis tight;
set_label('t', 'SNR');
pause;

%Display best "oracle" denoising result.
etv = max(err);
enoisy = snr(f0,y);
clf;
imageplot(clamp(y), strcat(['Noisy ' num2str(enoisy) 'dB']), 1,2,1);
imageplot(clamp(fTV0), strcat(['TV diffusion ' num2str(etv) 'dB']), 1,2,2);
