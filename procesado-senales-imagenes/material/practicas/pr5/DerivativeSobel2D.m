function [DroSx, DroSy]=DerivativeSobel2D(imagen2D,orden)
%        [DroSx, DroSy]=DerivativeSobel2D(imagen2D,orden)
% Esta función realiza el cálculo de las derivadas de Sobel de la imagen.
% Los parámetros de entrada son:
% 
%   imagen2D        - Imagen de entrada.
%   orden           - Orden de la derivada.
% 
% Los parámetros de salida son:
%
%   DroSx           - Derivada en x de la imagen.
%   DroSy           - Derivada en y de la imagen.

% Comprobamos que el orden de derivación introducido por el usuario está
% dentro de los límites
if orden<0 || orden>2
    error('Ha introducido un orden no permitido');
end

% Máscaras de suavizado
sobY=[1 2 1]/4;
sobX=sobY';

% Si el usuario ha solicitado el suavizado
if orden==0
    DroSx=imfilter(imfilter(imagen2D, sobX,'conv','replicate'),...
        sobY,'conv','replicate');
    DroSy=imfilter(imfilter(imagen2D, sobY,'conv','replicate'),...
        sobX,'conv','replicate');
    return;

% Si el usuario ha solicitado las derivadas de orden 1
elseif orden==1
    dsobY=[1 0 -1];
    dsobX=dsobY';

    DroSx=imfilter(imfilter(imagen2D, dsobX,'conv','replicate'),...
        sobY,'conv','replicate');
    DroSy=imfilter(imfilter(imagen2D, dsobY,'conv','replicate'),...
        sobX,'conv','replicate');
    return;
    
% Si el usuario ha solicitado las derivadas de orden 2
else
    d2sobY=[1 -2 1];
    d2sobX=d2sobY';
    
    DroSx=imfilter(imfilter(imagen2D, d2sobX,'conv','replicate'),...
        sobY,'conv','replicate');
    DroSy=imfilter(imfilter(imagen2D, d2sobY,'conv','replicate'),...
        sobX,'conv','replicate');
end