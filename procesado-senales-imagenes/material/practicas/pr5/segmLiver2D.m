function segmLiver2D

%% Lectura de image
bwManual=im2bw(imread('S07_10_90.jpg'));
imgEnt = im2double(imread('W07_10_90.jpg'));


%% p=3 con regularización en el denominador
p= 3; ee = 1e-3; iter =10;
alpha = .5;
dt = (alpha^p)/(5*iter); 
imgPro =TV2Dv09(imgEnt,dt,iter,[p ee]); %Semi Difusión 2D

%% Solución inicial
bwRegion = im2bw(imgPro);
strelDil = strel('disk',1);
bwBordes = imdilate(edge(imgPro,'canny'),strelDil);

bwHig = imfill(bwareaopen(bwRegion & (bwBordes==0),2e4),'holes');

%% Definiciones y medidas
numGrises = 50; %Número de particiones en grises [0 1]
limMediaLiverHU = [50,225]; %Valores extremos del nivel medio de gris del hígado procesado
regla60HU = [70,50]; %Valores para obtener los valores medio fuera del hígado
limStdLiverHU = [3,30];%Valores extremos del nivel medio de gris del hígado procesado
limInfHU = -50; %Valor que coincide con el nivel de gris nulo
ventanaHU = 350; %Ventana de niveles de grises a visualizar
%% Análisis histograma
%Estimación de los umbrales mediante el histograma de la imagen procesada
mediaLiverApriori = (limMediaLiverHU-limInfHU)./ventanaHU;
regla60 = (regla60HU-limInfHU)./ventanaHU;
[mediaGrisLiver,minSupLiver,minInfLiver,histograma,mediasOut]=...
         psfLiverv003(imgPro,numGrises,mediaLiverApriori,regla60);


% Fusión de histograma y semilla para estimar N(med,std)
limStdLiver = limStdLiverHU./ventanaHU;

[paramLiver,paramOutOsc,paramOutClaros] = fusionUmbralizacionv001...
        (mediaGrisLiver,minSupLiver,minInfLiver,limStdLiver,...
         histograma,numGrises,mediasOut);

mediasCT=[paramOutOsc(1);paramLiver(1);paramOutClaros(1)];
stdCT = [paramOutOsc(2);paramLiver(2);paramOutClaros(2)];
PComp = [paramOutOsc(3);paramLiver(3);paramOutClaros(3)];

tablaBayes = errorBayes(mediasCT,stdCT,PComp,numGrises);
imgBayes = lut2D(tablaBayes,imgPro);
%% Alineamiento de bordes y geodesia
dx(1:2)=1;
Iee = alineamientoBordes2D(imgPro,dx);
%% Demon region & edges
% [Sx,Sy]=gradient(imresize(imgBayes,.1));
factor = 0.5;
[Sx,Sy]=gradient(imresize(Iee,factor));

tic;
dt =10;
Sx =aosiso(Sx,ones(size(Sx)),dt);
Sy =aosiso(Sy,ones(size(Sy)),dt);
toc

modGrad = (Sx.^2 +Sy.^2).^.5;
Dx=Sx./modGrad;
Dy=Sy./modGrad;
Dx(isnan(Dx))=0; Dy(isnan(Dy))=0;

figure(3);
imshow(imresize(imgEnt,.1));hold on;
quiver(Dx,Dy);hold off;pause;

bwHigFin = demonThirion(imresize(bwHig,factor),imresize(imgBayes>=0,factor),Dx,Dy);
figure(4);
imshow([imresize(bwHigFin,1/factor),bwHig]);

%% Resultados
figure(1);
imgAux=imgPro;imgAux(bwperim(bwHig))=1;
imshow([imgEnt,imgPro,imgAux]);

figure(2);
imshow([bwManual,bwHig]);



%% Medidas
% medidas = medidasSegm2D(bwManual,bwHig)


