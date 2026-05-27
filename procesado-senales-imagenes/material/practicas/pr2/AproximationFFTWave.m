function AproximationFFTWave
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
%% Cargar imagen
n = 512;
f = rescale( load_image('lena', n) );
clf;
imageplot(f);
pause;
%% FFT es escala log
fF = fft2(f)/n;
clf;
imageplot(log(1e-5+abs(fftshift(fF))));
pause;

%% No lineal m-mejores
T = .3;
c = fF .* (abs(fF)>T);
fM = real(ifft2(c)*n);

imageplot(clamp(fM));
pause;

%% Exercice 1: Compute a best M-term approximation in the Fourier
% basis of f, for M?{N/100,N/20}. Compute the approximation using a 
% well chosen hard threshold value T.

mlist = round( [.01 .05]*n^2 );
MF = fft2(f);
clf;
for i=1:length(mlist)
    m = mlist(i);
    MFT = perform_thresholding(MF,m,'largest');
    M1 = real( ifft2(MFT) );
    imageplot( clamp(M1), ['m/n^2=' num2str(m/n^2,2) ', SNR=' num2str(snr(f,M1),3) 'dB'], 1,2,i);
end
pause;

