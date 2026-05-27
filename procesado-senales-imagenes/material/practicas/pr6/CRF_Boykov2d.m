function CRF_Boykov2d()

%% Toolbox Peyre
getd = @(pt)path(pt,path);
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_signal\');
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_general\');
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_graph\');


%% Imagen médica
M = im2double(imread('cortex.jpg'));
clf;
figure(1);
imageplot(M);
pause;
%% Exercice 3:  Compute an edge attracting criterion W, 
% that is small in area of strong gradient. You can use, among other, the function grad, perform_blurring, and threshold too large gradients.
% Crear geometria riemanniana
options.order = 2;
G = grad(M,options);
G = sqrt(sum(G.^2,3));
G = perform_blurring(G,3);
G = min(G,.4);
W = rescale(-G,.8,1);
clf;
imageplot(W);
title('Reimann metric');
pause;
%% Geodesic snake demo
demoGeoSnake(M,W);
%% Leve Set demo
% demoLevelSet(M);
%% Geo cut demo
t_MRF=5;typeN=4;lambda_min=0;lambda_max=2;lambda_incr=5;
% t_MRF=1;typeN=4;lambda_min=0;lambda_max=2;lambda_incr=5;
demoGeoCut(M,t_MRF,typeN,lambda_min, lambda_max, lambda_incr);