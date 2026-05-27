
%% Flujo del calor
% Exercice 1: Compute niter iterations of the Heat diffusion. 
% Keep track of err(i)=snr(f0,fHeat). Keep track of the optimal denoising result fHeat0.
tau = .05;
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
%% Exercice 2: Compute the total variation of f0.Norma TV
Norma TV
norTV = sum(sum((Gr(:,:,1).^2 + Gr(:,:,2).^2).^.5));
clf;
imshow(f0);title(sprintf('TV norm: %d',norTV));
pause;
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

