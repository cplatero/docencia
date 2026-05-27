function Haar1DWavelets
%% Toolbox Peyre
getd = @(pt)path(pt,path);
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_signal/');
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_general/');
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_signal\');
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_general\');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_signal/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_general/');


%% Cargar la se�al
name = 'piece-regular';
n = 512;
f =  rescale(load_signal(name, n)) ;
plot(f);
% x =0:1/1023:1;
% n = length(x);
% f = ((20*x.^2).*((1-x).^4).*cos(12*pi*x))';


%% Descomposici�n en apariencia y detalle de nivel 1
fw = f;
j = log2(n)-1;

haar = @(a)[   a(1:2:length(a)) + a(2:2:length(a));
                    a(1:2:length(a)) - a(2:2:length(a)) ]/sqrt(2);
% A = fw(1:2^(j+1));
% 
% Coarse = ( A(1:2:length(A)) + A(2:2:length(A)) )/sqrt(2);
% Detail = ( A(1:2:length(A)) - A(2:2:length(A)) )/sqrt(2);
% 
% A = [Coarse; Detail];
A = haar(f);

clf;
subplot(2,1,1);
plot(f); axis('tight'); title('Signal');
subplot(2,1,2);
plot(A); axis('tight'); title('Transformed');
pause;

% % Wavelets toolbox
% scaling_nivel = 1;
% %C vector de tendencia y fluctuaci�n
% [C,L]=wavedec(signal, scaling_nivel ,'haar');
% cA1 = appcoef(C,L,'haar',1); %vector de tendencia/aproximacion nivel 1
% cD1 = detcoef(C,L,1); % coeficientes de detalle nivel 1
% 
% %Visualizacion
% figure(1);
% subplot(1,2,1);plot(cA1);axis([1 length(cA1) -1 1]);
% subplot(1,2,2);plot(cD1);axis([1 length(cD1) -1 1]);
% pause;

%% Descomposici�n en varios niveles
Jmax = log2(n)-1;
Jmin = 6;
fw = f;
clf;
subplot(4,1,1);
plot(f); axis('tight'); title('Signal');
for j=Jmax:-1:Jmin
%     A = fw(1:2^(j+1));
%     Coarse = ( A(1:2:length(A)) + A(2:2:length(A)) )/sqrt(2);
%     Detail = ( A(1:2:length(A)) - A(2:2:length(A)) )/sqrt(2);
%     A = cat(1, Coarse, Detail );
%     fw(1:2^(j+1)) = A;
    fw(1:2^(j+1)) = haar(fw(1:2^(j+1)));
    j1 = Jmax-j;
    if j1<3
        subplot(4,1,j1+2);
        Detail= fw(2^j+1:2^(j+1));
        plot(1:2^(j1+1):n,Detail);  axis('tight');
        title( strcat(['Details, j=' num2str(j)]) );
    end    
end
pause;
%% Energ�a se�al y transformada
disp(strcat(['Energy of the signal       = ' num2str(norm(f).^2,3)]));
disp(strcat(['Energy of the coefficients = ' num2str(norm(fw).^2,3)]));
%% Visualizaci�n
clf;
plot_wavelet(fw,Jmin);
axis([1 n -2 2]);
%% Transformaci�n inversa
Jmax = log2(n)-1;
%Jmin = 0;
f1 = fw;
clf;
% ihaar = @(a,d)assign( zeros(2*length(a),1), ...
%         [1:2:2*length(a), 2:2:2*length(a)], [a+d; a-d]/sqrt(2) );
    
for j=Jmin:Jmax
    Coarse = f1(1:2^j);
    Detail = f1(2^j+1:2^(j+1));
    f1(1:2:2^(j+1)) = ( Coarse + Detail )/sqrt(2);
    f1(2:2:2^(j+1)) = ( Coarse - Detail )/sqrt(2);
%     f1(1:2^(j+1)) = ihaar(f1(1:2^j), f1(2^j+1:2^(j+1)));
    j1 = Jmax-j;
    if j1<3
        subplot(4,1,j1+1);
        plot(1:2^j1:n,f1(1:2^(j+1)),'.-'); axis('tight');
        title( strcat(['Partial reconstruction, j=' num2str(j)]) );
    end
end
pause;
%% Filtrado
fw = perform_haar_transf(f,1,1);
T = .5;

fwT = fw .* (abs(fw)>T);

clf;
subplot(2,1,1);
plot_wavelet(fw,1); axis('tight'); title('Original coefficients');
subplot(2,1,2);
plot_wavelet(fwT,1); axis('tight'); title('Thresholded coefficients');
pause;

f0 = perform_haar_transf(fw,1,-1);
f1 = perform_haar_transf(fwT,1,-1);
subplot(3,1,1);plot(1:n,f);title('Original');axis('tight');
subplot(3,1,2);plot(1:n,f0);title('Reconstruida');axis('tight');
subplot(3,1,3);plot(1:n,f1);title('Filtrada');axis('tight');
pause;

%% Exercice 3: 
% Find the threshold T so that the number of remaining coefficients in fwT 
% are a fixzd number m. Use this threshold to compute fwT and then display
% the corresponding approximation f1 of f. Try for an increasing number m of coeffiients.
% compute the threshold T
m_list = round([.05 .1 .2]*n); % number of kept coefficients
fw = perform_haar_transf(f,1,+1);
clf;
for i=1:length(m_list)
    m = m_list(i);
    % select threshold
    v = sort(abs(fw(:)));
    if v(1)<v(n)
        v = reverse(v);
    end
    T = v(m);
    fwT = fw .* (abs(fw)>=T);
    % inverse
    f1 = perform_haar_transf(fwT,1,-1);
    % display
    subplot(length(m_list),1,i);
    hh = plot(f1); axis('tight');
    if using_matlab()
        set_linewidth(hh,2);
    end
    title( strcat(['m=' num2str(m) ', SNR=' num2str(snr(f,f1)) 'dB']) );
end
pause;    

%% Exercice 4
Jmax = log2(n)-1;
selj = ( Jmax-2:Jmax )-3;
pos = [0 .5];
f = [];
clf;
k = 0;
for j=selj
    k = k+1;
    for q=1:length(pos)
        fw = zeros(n,1);
        p = 1 + (1+pos(q))*2^j;
        fw(p) = 1;
        f(:,q) = perform_haar_transf(fw,1,-1);
        f(:,q) = circshift(f(:,q),n/4);
    end
    f(1:n/2-1,2) = nan(); f(n/2+1:n,1) = nan();
    subplot(3,1,k);
    hh = plot(f); axis('tight');
    axis([1 n min(f(:))*1.05 max(f(:))*1.05]);
    if using_matlab()
        set_linewidth(hh,2);
    end
end