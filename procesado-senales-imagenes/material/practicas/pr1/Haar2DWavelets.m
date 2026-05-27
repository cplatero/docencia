function Haar2DWavelets
%% Toolbox Peyre
getd = @(pt)path(pt,path);
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_signal/');
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_general/');
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_signal\');
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_general\');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_signal/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_general/');


%% Cargar la imagen
n = 256;
name = 'hibiscus';
M = load_image(name,n);
M = rescale( sum(M,3) );

%% Descomposici�n en apariencia y detalle de nivel 1 por filas
MW = M;
j = log2(n)-1;

% haarV = @(a)[   a(1:2:length(a),:) + a(2:2:length(a),:);
%                     a(1:2:length(a),:) - a(2:2:length(a),:) ]/sqrt(2);

A = MW(1:2^(j+1),1:2^(j+1));
Coarse = ( A(1:2:size(A,1),:) + A(2:2:size(A,1),:) )/sqrt(2);
Detail = ( A(1:2:size(A,1),:) - A(2:2:size(A,1),:) )/sqrt(2);

A = cat3(1, Coarse, Detail );
A = [Coarse;Detail];
% A=haarV(M);
clf;
imageplot(M,'Original image',1,2,1);
imageplot(A,'Vertical transform',1,2,2);
pause;
%% Descomposici�n en apariencia y detalle de nivel 1 por columnas
% haarH = @(a)haarV(a')';

Coarse = ( A(:,1:2:size(A,1)) + A(:,2:2:size(A,1)) )/sqrt(2);
Detail = ( A(:,1:2:size(A,1)) - A(:,2:2:size(A,1)) )/sqrt(2);

A = cat3(2, Coarse, Detail );
% A = [Coarse,Detail];

% A= haarH(A);
MW(1:2^(j+1),1:2^(j+1)) = A;

clf;
imageplot(M,'Original image',1,2,1);
subplot(1,2,2);
plot_wavelet(MW,log2(n)-1); title('Transformed');
pause;

%% Exercies 1
Jmax = log2(n)-1;
Jmin = 4;
MW = M;
% haar = @(a)haarH(haarV(a));
clf;
for j=Jmax:-1:Jmin
    A = MW(1:2^(j+1),1:2^(j+1));
    %
    Coarse = ( A(1:2:size(A,1),:) + A(2:2:size(A,1),:) )/sqrt(2);
    Detail = ( A(1:2:size(A,1),:) - A(2:2:size(A,1),:) )/sqrt(2);
    A = cat3(1, Coarse, Detail );
    %
    Coarse = ( A(:,1:2:size(A,1)) + A(:,2:2:size(A,1)) )/sqrt(2);
    Detail = ( A(:,1:2:size(A,1)) - A(:,2:2:size(A,1)) )/sqrt(2);
    A = cat3(2, Coarse, Detail );
    %
    MW(1:2^(j+1),1:2^(j+1)) = A;
%     MW(1:2^(j+1),1:2^(j+1)) = haar(MW(1:2^(j+1),1:2^(j+1)));
    j1 = Jmax-j;
    if j1<4
        imageplot(MW(1:2^j,2^j+1:2^(j+1)), ['Horizontal, j=' num2str(j)], 3,4, j1 + 1);
        imageplot(MW(2^j+1:2^(j+1),1:2^j), ['Vertical, j=' num2str(j)], 3,4, j1 + 5);
        imageplot(MW(2^j+1:2^(j+1),2^j+1:2^(j+1)), ['Diagonal, j=' num2str(j)], 3,4, j1 + 9);
    end
end
pause;

% Jmin = 4;
% MW = perform_haar_transf(M,Jmin,1);
%% Check for orthogonality of the transform (conservation of energy).

disp(strcat(['Energy of the signal       = ' num2str(norm(M(:)).^2)]));
disp(strcat(['Energy of the coefficients = ' num2str(norm(MW(:)).^2)]));

%% Display the wavelet coefficients.
clf;
subplot(1,2,1);
imageplot(M); title('Original');
subplot(1,2,2);
plot_wavelet(MW, Jmin); title('Transformed');
pause;

%% Inverse 2D Haar transform.
M1 = MW;
j = 4;

A = M1(1:2^(j+1),1:2^(j+1));

Coarse = A(1:2^j,:);
Detail = A(2^j+1:2^(j+1),:);

A(1:2:size(A,1),:) = ( Coarse + Detail )/sqrt(2);
A(2:2:size(A,2),:) = ( Coarse - Detail )/sqrt(2);

Coarse = A(:,1:2^j);
Detail = A(:,2^j+1:2^(j+1));

A(:,1:2:size(A,1)) = ( Coarse + Detail )/sqrt(2);
A(:,2:2:size(A,2)) = ( Coarse - Detail )/sqrt(2);
M1(1:2^(j+1),1:2^(j+1)) = A;
imageplot(A);
pause;


%% Exercise 2
M1 = MW;
clf;
for j=Jmin:Jmax
    A = M1(1:2^(j+1),1:2^(j+1));
    Coarse = A(1:2^j,:);
    Detail = A(2^j+1:2^(j+1),:);
    A(1:2:size(A,1),:) = ( Coarse + Detail )/sqrt(2);
    A(2:2:size(A,2),:) = ( Coarse - Detail )/sqrt(2);
    Coarse = A(:,1:2^j);
    Detail = A(:,2^j+1:2^(j+1));
    A(:,1:2:size(A,1)) = ( Coarse + Detail )/sqrt(2);
    A(:,2:2:size(A,2)) = ( Coarse - Detail )/sqrt(2);
    M1(1:2^(j+1),1:2^(j+1)) = A;
    %
    j1 = Jmax-j;
    if j1>0 & j1<5
        subplot(2,2,j1);
        imageplot(A, ['Partial reconstruction, j=' num2str(j)]);
    end
end
%% 2D Haar Image Approximation

T = .2;

MWT = MW .* (abs(MW)>T);
clf;
subplot(1,2,1);
plot_wavelet(MW); axis('tight'); title('Original coefficients');
subplot(1,2,2);
plot_wavelet(MWT); axis('tight'); title('Thresholded coefficients');

%% Exercice 3
% compute the threshold T
mlist = round([.05 .2]*n^2); % number of kept coefficients
MW = perform_haar_transf(M,4,1);
% plot_wavelet(MW,3);
% MR = perform_haar_transf(MW,3,-1);
% imageplot(MR);

v = sort(abs(MW(:))); 
if v(1)<v(n^2)
    v = reverse(v);
end
clf;
for i=1:length(mlist)
    m = mlist(i);
    % threshold
    T = v(m);
    MWT = MW .* (abs(MW)>=T);
    % inverse
    M1 = perform_haar_transf(MWT,4,-1);
    % display the result
    imageplot(clamp(M1), strcat(['m/n^2=' num2str(m/n^2,2) ', SNR=' num2str(snr(M,M1),3) 'dB']), 1,2,i );
end
pause;
