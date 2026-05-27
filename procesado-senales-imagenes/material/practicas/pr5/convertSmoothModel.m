function imgSmooth = convertSmoothModel(BWModel)

imgSmooth = (bwdist(BWModel==0)+128);
maximo = max(imgSmooth(:));
if(maximo> 255)
    imgSmooth(imgSmooth>255)=255;
else
    imgSmooth = ((imgSmooth-128)*(255/maximo))+128;
end
    
imgAux=128-bwdist(BWModel);

minimo = min(imgAux(BWModel==0));
if(minimo< 0)
    imgAux(imgAux<0)=0;
else
    imgAux = (imgAux-minimo)*(128/(128-minimo));
end

imgSmooth(BWModel==0)=imgAux(BWModel==0);

