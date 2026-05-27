function forma_C
[S,M]= generation_C(64,0);
S=S>0;
M=M>0;

%% Demon region & edges
% Coche estático y Avión dinámic

[Sx,Sy]=gradient(double(S));

tic;
dt =10;
Sx =aosiso(Sx,ones(size(Sx)),dt);
Sy =aosiso(Sy,ones(size(Sy)),dt);
toc

modGrad = (Sx.^2 +Sy.^2).^.5;
Dx=Sx./modGrad;
Dy=Sy./modGrad;
Dx(isnan(Dx))=0; Dy(isnan(Dy))=0;

figure(1);
imshow(S==0);hold on;
quiver(Dx,Dy);hold off;pause;

M_Fin = demonThirion(M,S,Dx,Dy);

%% Resultados
figure(2);
imshow([S,M,M_Fin]);




%% Medidas
medidas = [medidasSegm2D(M,S);medidasSegm2D(M_Fin,S)]

