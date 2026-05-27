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

%% Exercice 2: Compute the total variation of f0.
Gr = grad(f0);
d = (Gr(:,:,1).^2 + Gr(:,:,2).^2).^.5;
TV = sum (d(:));
clf;
imshow(f0);
title(sprintf('TV = %.0f',TV));
pause;

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

