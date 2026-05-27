
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

[tmp,i] = max(err);
lambda = lambda_list(i);
fSob = real( ifft2( yF .* hF ./ ( abs(hF).^2 + lambda*S) ) );
pause;

%% Exercice 3:  Perform the deblurring by a gradient descent. Keep track of the function being minimized.
epsilon = 0.4*1e-2;
lambda = 0.06;
tau = 1.9 / ( 1 + lambda * 8 / epsilon);

niter = 50;
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
%% Exercice 4:  Explore the different values of lambda to find the optimal solution. Display the SNR as a function of lambda.
lambda_list = linspace(.001, .01, 5);
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
