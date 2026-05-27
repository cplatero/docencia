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
