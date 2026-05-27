function demoLevelSet(M)
n=size(M,1);
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
