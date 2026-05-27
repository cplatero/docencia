
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

