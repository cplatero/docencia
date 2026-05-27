
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
