function ImageDenoisingWavelets

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
n = 256;
name = 'hibiscus';
f0 = rescale( load_image(name,n) );
if using_matlab()
    f0 = rescale( sum(f0,3) );
end

sigma = .08; % noise level
f = f0 + sigma*randn(size(f0));

clf;
imageplot(f0, 'Original', 1,2,1);
imageplot(clamp(f), 'Noisy', 1,2,2);
pause;
%% Hard versus soft
% threshold value
T = 1;
v = -linspace(-3,3,2000);
% hard thresholding of the t values
v_hard = v.*(abs(v)>T);
% soft thresholding of the t values
v_soft = max(1-T./abs(v), 0).*v;


clf;
hold('on');
h = plot(v, v_hard);
if using_matlab()
    set(h, 'LineWidth', 2);
end
h = plot(v, v_soft, 'r--');
if using_matlab()
    set(h, 'LineWidth', 2);
end
axis('equal'); axis('tight');
legend('Hard thresholding', 'Soft thresholding');
hold('off');
pause;
%% Wavelet Denoising with Hard Thesholding
options.ti = 0;
Jmin = 4;

fW = perform_wavelet_transf(f,Jmin,+1,options);
T = 3*sigma;
fWT = fW .* (abs(fW)>T);

clf;
subplot(1,2,1);
plot_wavelet(fW,Jmin);
title('Noisy coefficients');
set_axis(0);
subplot(1,2,2);
plot_wavelet(fWT,Jmin);
title('Thresholded coefficients');
set_axis(0);
pause;

fHard = perform_wavelet_transf(fWT,Jmin,-1,options);

clf;
imageplot(clamp(f), strcat(['Noisy, SNR=' num2str(snr(f0,f),3)]), 1,2,1);
imageplot(clamp(fHard), strcat(['Hard denoising, SNR=' num2str(snr(f0,fHard),3)]), 1,2,2);
pause;
%% Wavelet Denoising with Soft Thesholding
T = 3/2*sigma;
fWT = perform_thresholding(fW,T,'soft');
%Re-inject the low frequencies.
fWT(1:2^Jmin,1:2^Jmin) = fW(1:2^Jmin,1:2^Jmin);

fSoft = perform_wavelet_transf(fWT,Jmin,-1,options);

clf;
imageplot(clamp(fHard), strcat(['Hard denoising, SNR=' num2str(snr(f0,fHard),3)]), 1,2,1);
imageplot(clamp(fSoft), strcat(['Soft denoising, SNR=' num2str(snr(f0,fSoft),3)]), 1,2,2);
pause;

%% Exercice 1: Determine the best threshold T for both hard and soft thresholding
Tlist = linspace(.8,4.5,25)*sigma;
err_soft = []; err_hard = [];

M0 = f0;
options.ti = 0;
Jmin = 4;
MW = perform_wavelet_transf(f,Jmin,+1,options);

for i=1:length(Tlist)
    MWT = perform_thresholding(MW,Tlist(i),'hard');
	Mwav = perform_wavelet_transf(MWT,Jmin,-1,options);
    err_hard(i) = snr(M0,Mwav);
    MWT = perform_thresholding(MW,Tlist(i),'soft');
    MWT(1:2^Jmin,1:2^Jmin) = MW(1:2^Jmin,1:2^Jmin);
	Mwav = perform_wavelet_transf(MWT,Jmin,-1,options);
    err_soft(i) = snr(M0,Mwav);
end
clf;
h = plot(Tlist/sigma, [err_hard(:) err_soft(:)]); axis('tight');
if using_matlab()
    set(h, 'LineWidth', 2);
end
set_label('T/\sigma', 'SNR');
legend('Hard', 'Soft');
pause;

%% Exercice 2: Perform the cycle spinning denoising by iterating on i.
%Translation Invariant Denoising with Cycle Spinning
Mti = zeros(n,n);
m = 4;
[dY,dX] = meshgrid(0:m-1,0:m-1);
T = 3*sigma; %Hard
for i=1:m^2
    Ms = circshift(f,[dX(i) dY(i)]);
    MW = perform_wavelet_transf(Ms,Jmin,1,options);
    MWT = perform_thresholding(MW,T,'hard');    
    Ms = perform_wavelet_transf(MWT,Jmin,-1,options);
    Ms = circshift(Ms,-[dX(i) dY(i)]);
    Mti = (i-1)/i*Mti + 1/i*Ms;
end
clf;
imageplot(clamp(fHard), strcat(['Hard denoising, SNR=' num2str(snr(f0,fHard),3)]), 1,2,1);
imageplot(clamp(Mti), strcat(['Cycle spinning denoising, SNR=' num2str(snr(f0,Mti),3)]), 1,2,2);
pause;

%% Exercice 3:  Study the influence of the number m
err = [];
shift_list = 1:7;
T = 3*sigma;
for m=shift_list
    [dY,dX] = meshgrid(0:m-1,0:m-1);
    Mti = zeros(n,n);
    for i=1:m^2
        Ms = circshift(f,[dX(i) dY(i)]);
        MW = perform_wavelet_transf(Ms,Jmin,1,options);
        MWT = perform_thresholding(MW,T,'hard');
        Ms = perform_wavelet_transf(MWT,Jmin,-1,options);
        Ms = circshift(Ms,-[dX(i) dY(i)]);
        Mti = (i-1)/i*Mti + 1/i*Ms;
    end
    err(m) = snr(f0,Mti);
end
clf;
h = plot(shift_list, err, '.-');
if using_matlab()
    set(h, 'LineWidth', 2);
end
axis('tight');
set_label('m', 'SNR');
pause;
%% Translation Invariant Wavelet Transform
options.ti = 1;
fW = perform_wavelet_transf(f0,Jmin,+1,options);
%fW(:,:,1) corresponds to the low scale residual. 
%Each fW(:,:,3*j+k+1) for k=1:3 (orientation) corresponds to a scale of wavelet coefficient, and has the same size as the original image.

clf;
i = 0;
for j=1:2
    for k=1:3
        i = i+1;
        imageplot(fW(:,:,i+1), strcat(['Scale=' num2str(j) ' Orientation=' num2str(k)]), 2,3,i );
    end
end
pause;

% Denoising
options.ti = 1;
fW = perform_wavelet_transf(f,Jmin,+1,options);

T = 3.5*sigma;
fWT = perform_thresholding(fW,T,'hard');

%We can display some wavelets coefficients
J = size(fW,3)-5;
clf;
imageplot(fW(:,:,J), 'Noisy coefficients', 1,2,1);
imageplot(fWT(:,:,J), 'Thresholded coefficients', 1,2,2);
pause;


fTI = perform_wavelet_transf(fWT,Jmin,-1,options);
clf;
imageplot(clamp(fSoft), strcat(['Soft orthogonal, SNR=' num2str(snr(f0,fSoft),3)]), 1,2,1);
imageplot(clamp(fTI), strcat(['Hard invariant, SNR=' num2str(snr(f0,fTI),3)]), 1,2,2);
pause;

%% Exercice 4: Determine the best threshold T for both hard and soft thresholding,
%but now in the translation invariant case. What can you conclude ?
Tlist = linspace(.8,4.5,15)*sigma;
err_soft = []; err_hard = [];
for i=1:length(Tlist)
    MWT = perform_thresholding(fW,Tlist(i),'hard');
	Mwav = perform_wavelet_transf(MWT,Jmin,-1,options);
    err_hard(i) = snr(f0,Mwav);
    MWT = perform_thresholding(fW,Tlist(i),'soft');
    MWT(1:2^Jmin,1:2^Jmin) = MW(1:2^Jmin,1:2^Jmin);
	Mwav = perform_wavelet_transf(MWT,Jmin,-1,options);
    err_soft(i) = snr(f0,Mwav);
end
clf;
plot(Tlist(:)/sigma, [err_hard(:) err_soft(:)]); axis('tight');
set_label('T/\sigma', 'SNR');
legend('Hard', 'Soft');
