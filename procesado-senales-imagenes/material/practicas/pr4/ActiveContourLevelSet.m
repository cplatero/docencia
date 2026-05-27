function ActiveContourLevelSet

getd = @(p)path(p,path);
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_signal\');
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_general\');
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_graph\');

% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_signal/');
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_general/');
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_graph/');

% getd('D:/compartido/cplatero/misce/wavelets/fuentes/peyre/toolbox_signal/');
% getd('D:/compartido/cplatero/misce/wavelets/fuentes/peyre/toolbox_general/');
% getd('D:/compartido/cplatero/misce/wavelets/fuentes/peyre/toolbox_graph/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_signal/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_general/');

%% Formas mediante level set
% Función distancia con signo
n = 200;
[Y,X] = meshgrid(1:n,1:n);

% radius
r = n/3;
% center
c = [r r] + 10;
% shape
Dcirc = sqrt( (X-c(1)).^2 + (Y-c(2)).^2 ) - r;

%% Exercice 1: Load a square shape Dsq at a different position for the center,
% e.g. n - 10 - [r r].
% radius
r = n/3;
% center
c = n  - 10 - [r r];
% shape
Dsq = max( abs(X-c(1)), abs(Y-c(2)) ) - r;

% Visualizar
clf;
subplot(1,2,1);
plot_levelset(Dcirc);
subplot(1,2,2);
plot_levelset(Dsq);
pause;

%% Exercice 2:  Compute the intersection and the
% union of the two shapes. Store the union in D0, that we will use in the remaining part of the tour.
% Unión e intersección de formas
clf;
subplot(1,2,1);
plot_levelset(min(Dcirc,Dsq));
title('Union');
subplot(1,2,2);
plot_levelset(max(Dcirc,Dsq));
title('Intersection');
pause;

%% Exercice 3: Implement the mean curvature motion.
% maximum time of evolution
Tmax = 200;
% time step (should be small)
tau = .5;
% number of iterations
niter = round(Tmax/tau);
% use centered differences
options.order = 2;
D0 = min(Dcirc,Dsq);

D = D0; % initialization
clf;
k = 0;
for i=1:niter
    g0 = grad(D,options);
    d = max(eps, sqrt(sum(g0.^2,3)) );
    g = g0 ./ repmat( d, [1 1 2] );
    K = d .* div( g,options );
    D = D + tau*K;
    % redistance the function from time to time
    if mod(i,30)==0
        % D = perform_redistancing(D);
    end
    if mod(i, floor(niter/4))==0
        k = k+1;
        subplot(2,2,k);
        plot_levelset(D);
        drawnow;
    end
end
pause;
%% Levelset Re-distancing
% D = D0.^3;
% % We compute the distance function.
% 
% D1 = perform_redistancing(D0);
% % Display the level sets.
% 
% clf;
% subplot(1,2,1);
% plot_levelset(D);
% title('Before redistancing');
% subplot(1,2,2);
% plot_levelset(D1);
% title('After redistancing');
%% Edge-based Segmentation with Geodesic Active Contour
n = 200;
name = 'cortex';
M = rescale( sum( load_image(name, n), 3) );

%% Exercice 4: Compute an edge-stopping function E by smoothing the 
% inversed magnitude of the gradient 1./(epsilon+norm(grad(M)). 
% Rescale E so that it ranges [.1,1].Geodesia de la imagen
alpha = 1;
epsilon = 1e-1;
options.order = 2;
G = grad(M,options);
d = perform_blurring( sqrt(sum(G.^2,3)),5 );
E = (epsilon+d).^(-alpha);
E = rescale(-d,.1,1);
clf;
imageplot(M,'Image to segment',1,2,1);
imageplot(E,'Energy',1,2,2);
pause;
%% Exercice 5: Compute an initial shape, for instance a square centered at [n n]/2.
%  Curva inicial
[Y,X] = meshgrid(1:n,1:n);
r = n/3;
c = [n n]/2;
D0 = max( abs(X-c(1)), abs(Y-c(2)) ) - r;
%% Evolución
% final time
Tmax = 1500;
% time step
tau = .4;
% number of steps
niter = round(Tmax/tau);

%% Exercice 6: Compute this gradient G (right hand side of the PDE) 
% using the current value of the distance function D.

D = D0;
k = 0;
gE = grad(E,options);
for i=1:niter
    gD = grad(D,options);
    d = max(eps, sqrt(sum(gD.^2,3)) );
    g = gD ./ repmat( d, [1 1 2] );
    G = E .* d .* div( g,options ) + sum(gE.*gD,3);
    D = D + tau*G;
    if mod(i,30)==0
        D = perform_redistancing(D);
    end
    if mod(i, floor(niter/4))==0
        k = k+1;
        subplot(2,2,k);
        plot_levelset(D,0,M);
        drawnow;
    end
        
end
pause;

%% Region-based Segmentation with Chan-Vese
%% Exercice 8:  Compute an initial shape, for instance many small circles.
[Y,X] = meshgrid(1:n,1:n);
k = 4; %number of circles
r = .3*n/k;
D0 = zeros(n,n)+Inf;
for i=1:k
    for j=1:k
        c = ([i j]-1)*(n/k)+(n/k)*.5;
        D0 = min( D0, sqrt( (X-c(1)).^2 + (Y-c(2)).^2 ) - r );
    end
end
clf;
subplot(1,2,1);
plot_levelset(D0);
subplot(1,2,2);
plot_levelset(D0,0,M);
pause;

%We set parameters for the energy.
lambda = 0.8;
c1 = 0.7; % black
c2 = 0; % gray
%We set parameters for the descent.
% final time
Tmax = 100;
% time step
tau = .4;
% number of steps
niter = round(Tmax/tau);
% initial distance function
D = D0;
%% Exercice 9: (the solution is exo9.m) Compute this gradient G using the
% current value of the distance function D.
% gD = grad(D,options);
% d = max(eps, sqrt(sum(gD.^2,3)) );
% g = gD ./ repmat( d, [1 1 2] );
% % gradient
% G = d .* div( g,options ) - lambda*(M-c1).^2 + lambda*(M-c2).^2;
% D = D0; 
%% Exercice 10: Implement this gradient descent, with c1 and c2 are known in advance.
k = 0;
clf;
for i=1:niter
    gD = grad(D,options);
    d = max(eps, sqrt(sum(gD.^2,3)) );
    g = gD ./ repmat( d, [1 1 2] );
    G = d .* div( g,options ) - lambda*(M-c1).^2 + lambda*(M-c2).^2;
    D = D + tau*G;
    if mod(i,30)==0
        D = perform_redistancing(D);
    end
    if mod(i, floor(niter/4))==0
        k = k+1;
        subplot(2,2,k);
        plot_levelset(D,0,M);
        drawnow;
    end
end
%% Exercice 11: In the case that one does not
%% know precisely the constants c1 and c2, how to update them automatically during the evolution ? Implement this method.