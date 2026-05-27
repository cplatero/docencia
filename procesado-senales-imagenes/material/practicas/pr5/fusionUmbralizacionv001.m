function [paramLiver,paramOutOsc,paramOutClaros] = fusionUmbralizacionv001...
        (medioGrisLiver,minSupLiver,minInfLiver,limStdLiver,...
         histograma,numGrises,mediasOut)

%% PSF Liver
stdLiver = (minSupLiver-minInfLiver)/6;
asimetria = (minSupLiver - (2*medioGrisLiver) + minInfLiver);

if(stdLiver > limStdLiver(2)) % Supera Std a priori 
    warning('fusionUmbralizacionv001:Liver Std is more than 30HU');
    stdLiver = limStdLiver(2);
end

if(asimetria > stdLiver)
    stdLiver = (medioGrisLiver - minInfLiver)/3;      
end

grises = 0:1/numGrises:1;
numVoxelLiver = sum(histograma((grises>=minInfLiver) & (grises<=minSupLiver)));

%% PSFs fuera del hígado
% Más claro que el hígado
stdClaro = (mediasOut(1)-minSupLiver)/3;
numVoxelOutClaro = sum(histograma((grises>minSupLiver) & (grises<=(mediasOut(1)+(3*stdClaro)))));

% Más oscuro que el hígado
stdOscuro = (minInfLiver-mediasOut(2))/3;
numVoxelOutOscuro = sum(histograma((grises<minInfLiver) & (grises>=(mediasOut(2)-(3*stdOscuro)))));

voxelesTotales = numVoxelLiver+numVoxelOutClaro+numVoxelOutOscuro;

%% Parámetros
paramLiver=[medioGrisLiver;stdLiver;numVoxelLiver/voxelesTotales];
paramOutClaros=[mediasOut(1);stdClaro;numVoxelOutClaro/voxelesTotales];
paramOutOsc=[mediasOut(2);stdOscuro;numVoxelOutOscuro/voxelesTotales];




        
        
    
        