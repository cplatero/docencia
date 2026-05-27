function [mediaGrisLiver,minSupLiver,minInfLiver,histoTotal,mediasOut]=...
                    psfLiverv003(imgPro4D,numGrises,limMediaLiver,regla60HU)

% Histograma
maxGris = max(imgPro4D(:));
grises=0:(maxGris/numGrises):maxGris;
histoTotal = hist(imgPro4D(:),grises);

% Determinar máximos y mínimos
his_mx = histoTotal-histoTotal([1 1:end-1]);
his_px = histoTotal([2:end end])-histoTotal;

maximos = (his_mx > 0) & (his_px <0);    
minimos = (his_mx < 0) & (his_px >0);
     
%Seleccionar la media del nivel del gris del hígado
[nivel_gris,indice] = sort(histoTotal(maximos),'descend');
grises_maximos = grises(maximos);
i = 1;
%Límites de la media
while((grises_maximos(indice(i))<limMediaLiver(1)) ||... 
      (grises_maximos(indice(i))>limMediaLiver(2)))
     if(i<=size(indice,2))
         i=i+1;
     else
         warning('Matlab:psfLiverv003','The liver gray mean value is not between limits');
         limMediaLiver(1)= 1/maxGris;
         limMediaLiver(2)= 1-(1/maxGris);
         i=1;
     end
end
mediaGrisLiver = grises_maximos(indice(i));

% Seleccionar los mínimos
grises_minimos = grises(minimos);
[valorMin,indice]=sort(abs(grises_minimos-mediaGrisLiver),'ascend');

if(grises_minimos(indice(1)) > mediaGrisLiver)
     minSupLiver = grises_minimos(indice(1));
     i=2;
     while(grises_minimos(indice(i))> mediaGrisLiver)
         if(i<=size(indice,2))
             i=i+1;
         else
             warning('Matlab:psfLiverv003','There is not minimun at the left of the liver gray mean value');
             %Valores estimados a priori
             minInfLiver= (2*mediaGrisLiver)- minSupLiver;
         end
     end
     if(i<=size(indice,2))
         minInfLiver = grises_minimos(indice(i));
     end
else
     minInfLiver = grises_minimos(indice(1));
     i=2;
     while(grises_minimos(indice(i))< mediaGrisLiver)
         if(i<=size(indice,2))
             i=i+1;
         else
             warning('Matlab:psfLiverv003','There is not minimun at the rigth of the maximun');
             %Valores estimados a priori
             minSupLiver= (2*mediaGrisLiver)- minInfLiver;           
         end
     end
     if(i<=size(indice,2))
         minSupLiver = grises_minimos(indice(i));
     end
end


%% PSFs fuera del hígado
% Más claro que el hígado
limSupMediasClaros = mediaGrisLiver + regla60HU(1);
if(limSupMediasClaros < minSupLiver)
    limSupMediasClaros = minSupLiver + regla60HU(1);
    if(limSupMediasClaros>=1)
        limSupMediasClaros = 0.99;
    end      
end
grises_maximos_claros=[];
while((size(grises_maximos_claros,1)==0) && (limSupMediasClaros<1))
    grises_maximos_claros = grises(maximos & (grises>minSupLiver) & (grises<limSupMediasClaros));
    limSupMediasClaros = limSupMediasClaros + 0.1;
end
if(size(grises_maximos_claros,2)>0)
    [nivel_gris,indice] = sort(histoTotal(maximos & (grises>minSupLiver) & (grises<(limSupMediasClaros-.1))),'descend');
    mediaOutClaro = grises_maximos_claros(indice(1));
else
    warning('Matlab:psfLiverv003','It does not get the kidney mean value');
    %Valores estimados a priori
    mediaOutClaro= (1+minSupLiver)/2;
end

% Más oscuro que el hígado
limInfMediasOscuros = mediaGrisLiver - regla60HU(2);
if(limInfMediasOscuros > minInfLiver)
    limInfMediasOscuros = minInfLiver - regla60HU(2);
    if(limInfMediasOscuros<=0)
        limInfMediasOscuros = 0.01;
    end      
end
grises_maximos_oscuros=[];
while((size(grises_maximos_oscuros,2)==0) && (limInfMediasOscuros>0))
    grises_maximos_oscuros = grises(maximos & (grises<minInfLiver) & (grises>limInfMediasOscuros));
    limInfMediasOscuros = limInfMediasOscuros - 0.1;
end
if(size(grises_maximos_oscuros,1)>0)
    [nivel_gris,indice] = sort(histoTotal(maximos & (grises<minInfLiver) & (grises>(limInfMediasOscuros+.1))),'descend');
    mediaOutOscuro = grises_maximos_oscuros(indice(1));
else
    warning('Matlab:psfLiverv003','It does not get the dark mean value');
    %Valores estimados a priori
    mediaOutOscuro= minInfLiver/2;
end

mediasOut=[mediaOutClaro;mediaOutOscuro];
    
 
 
