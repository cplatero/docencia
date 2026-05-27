function eliminar_ruido_tec_clasicas
%% Filtros paso bajos

h1=fspecial('average')
h2=conv2([1 2 1],[1 2 1]')/16
h3=fspecial('gaussian',[9 9],1)
imagen= imnoise(imread('cameraman.tif'));
imagen1=imfilter(imagen,h1,'replicate');
imagen2=imfilter(imagen,h2, 'replicate');
imagen3=imfilter(imagen,h3, 'replicate');
imshow([imagen,imagen1,imagen2,imagen3]);
pause;

%% Mediana
h=fspecial('gaussian',[9 9],1)
imagen= imnoise(imread('circuit.tif'),'salt & pepper');
imagen1=imfilter(imagen,h,'replicate');
imagen2=medfilt2(imagen);
imshow([imagen,imagen1,imagen2])
pause;

%% demo
nrfiltdemo;