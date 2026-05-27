%% Información de los contornos (alineamiento a los bordes y geodesia)
% function [Iee,g,gx,gy] = alineamientoBordes2D(img2D,dx)
function Iee = alineamientoBordes2D(img2D,dx)

tipo ='Sobel';
alpha = 1;
[modGrad,Ix,Iy] = calcularModuloGradiente(img2D,tipo,alpha,dx);
% maxModGrad = max(modGrad(:));
% modGradNor = modGrad./maxModGrad;
% g = ((1./(1+modGradNor))-.5)*2;
% [modg,gx,gy] = calcularModuloGradiente(g,tipo,alpha,dx);

Iee = segundaDerivadaGrad(modGrad,Ix,Iy,dx,tipo,alpha);




%% Cálculo del módulo del gradiente 4D y las primeras derivadas
function [modGrad,Gradx,Grady] = calcularModuloGradiente(img2D,tipo,sigma,dx)

if(tipo == 'Gauss')
    if(isempty(sigma))
        sigma = 0.25;
    end
    [Gradx,Grady,]=DerivativeGauss2D(img2D,1,sigma);
    
elseif(tipo == 'Derch')
    if(isempty(sigma))
        sigma = 1;
    end
    [Gradx,Grady]=DerivativeDeriche2D(img2D,1,sigma);
else
    [Gradx,Grady]=DerivativeSobel2D(img2D,1);
end

Gradx=Gradx/dx(1);Grady=Grady/dx(2);
modGrad=sqrt((Gradx.*Gradx)+(Grady.*Grady));

%% Calcular la segunda derivada en la dirección del gradiente
function Iee = segundaDerivadaGrad(modGrad,Ix,Iy,dx,tipo,sigma)

if(tipo == 'Gauss')
    if(isempty(sigma))
        sigma = 0.25;
    end
    [Ixx,Ixy]=DerivativeGauss2D(Ix,1,sigma);
    [Iyx,Iyy]=DerivativeGauss2D(Iy,1,sigma);
       
elseif(tipo == 'Derch')
    if(isempty(sigma))
        sigma = 1;
    end
    [Ixx,Ixy]=DerivativeDeriche2D(Ix,1,sigma);
    [Iyx,Iyy]=DerivativeDeriche2D(Iy,1,sigma);

else
    [Ixx,Ixy]=DerivativeSobel2D(Ix,1);
    [Iyx,Iyy]=DerivativeSobel2D(Iy,1);

end
Ixx=Ixx/dx(1);Ixy=Ixy/dx(2);
Iyx=Iyx/dx(1);Iyy=Iyy/dx(2);

Iee = (Ix.*Ix.*Ixx) + (Iy.*Iy.*Iyy) +  (2*Ix.*Iy.*Ixy);

Iee = Iee./((modGrad.*modGrad)+eps);



