function ActiveContourParametric

getd = @(p)path(p,path);

getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_signal\');
getd('D:\compartido\cplatero\Hipocampo\fuentes\AP\NLMeans\toolbox_general\');

% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_signal/');
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_general/');
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_graph/');

% getd('D:/compartido/cplatero/misce/wavelets/fuentes/peyre/toolbox_signal/');
% getd('D:/compartido/cplatero/misce/wavelets/fuentes/peyre/toolbox_general/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_signal/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_general/');


%% Construir el polinomio
%We compute an initial curve by performing subdivision of a control polygon.

c0 = [0.78 0.14 0.42 0.18 0.32 0.16 0.75 0.83 0.57 0.68 0.46 0.40 0.72 0.79 0.91 0.90]' + ...
 1i* [0.87 0.82 0.75 0.63 0.34 0.17 0.08 0.46 0.50 0.25 0.27 0.57 0.73 0.57 0.75 0.79]';

%Interpolate the curve.
p = 256;
c1 = c0;
c1(end+1) = c1(1);
d = abs(c1(1:end-1)-c1(2:end)); d = [0;cumsum(d)];
c1 = interp1(d/d(end),c1,(0:p-1)'/p, 'linear');
%Display the initial curve.
clf;
h = plot(c1([1:end 1]), 'k');
set(h, 'LineWidth', 2); axis('tight'); axis('off');
pause;

%% Compute the normal to the curve. This is obtained by rotating by pi/2 the tangent.
tgt = c1([2:end 1]) - c1([end 1:end-1]); % diferencias centradas
normal = (1i*tgt)./abs(tgt); %por rotación de 90º (-y, x)

%Move the curve in the normal direction.

h = .03;
c2 = c1 + normal*h;
c3 = c1 - normal*h;
%Display the curves.
clf;
hold on;
h = plot(c1([1:end 1]), 'k'); set(h, 'LineWidth', 2);
h = plot(c2([1:end 1]), 'r--'); set(h, 'LineWidth', 2);
h = plot(c3([1:end 1]), 'b--'); set(h, 'LineWidth', 2);
axis('tight'); axis('off');
pause;

%% Evolución de la curvatura media
% %Evolution by Mean Curvature
% dt = 0.001;
% 
% %Initialize the curve.
% c = c1;
% %Compute the tangent using forward derivatives.
% e1 = c([2:end 1]) - c;
% e1 = e1 ./ abs(e1);
% 
% %Compute the normal time curvature using backward derivatives.
% e2 = e1 - e1([end 1:end-1]);
% %Evolution of the curve.
% c = c + dt * e2;
% %To stabilize the evolution, it is important to re-sample the curve so that it is unit-speed parametrized. You do not need to do it every time step though (to speed up).
% c(end+1) = c(1);
% d = abs(c(1:end-1)-c(2:end)); d = [0;cumsum(d)];
% c = interp1(d/d(end),c,(0:p-1)'/p);

%% Exercice 1: Perform the curve evolution, for a time of Tmax=2. You need to resample it a few times.

Tmax = 2;
dt = 0.001;
niter = round(Tmax/dt);
c = c1;
displist = round(linspace(1,niter,10));
k = 1;
clf; hold on;
for i=1:niter
    e1 = c([2:end 1]) - c;
    e1 = e1 ./ abs(e1);
    e2 = e1 - e1([end 1:end-1]);
    c = c + dt * e2;
    if mod(i,50)==1
        % resample
        c(end+1) = c(1);
        d = abs(c(1:end-1)-c(2:end)); d = [0;cumsum(d)];
        c = interp1(d/d(end),c,(0:p-1)'/p);
    end
    if i==displist(k)
        % display
        h = plot(c([1:end 1]), 'r');
        if i==1 || i==niter
            set(h, 'LineWidth', 2);
        end
        k = k+1;
        drawnow;
        axis('tight');  axis('off');
    end
end
pause;

%% Geodesic Active Contours
% Geodesic active contours minimize a weighted length, where the weight is measured according to some image.
% Create a synthetic image with some dots.

n = 200;
nbumps = 40;
theta = rand(nbumps,1)*2*pi;
r = .6*n/2; a = [.62*n .6*n];
x = round( a(1) + r*cos(theta) );
y = round( a(2) + r*sin(theta) );
W = zeros(n); W( x + (y-1)*n ) = 1;
W = perform_blurring(W,10);
W = rescale( -min(W,.05), .3,1);
%Display the metric.

clf;
imageplot(W);
pause;

%Pre-compute the derivatives.
options.order = 2;
G = grad(W, options);
G = G(:,:,1) + 1i*G(:,:,2);
%Initialize the curve with a circle.
r = .98*n/2;
p = 128; % number of points on the curve
theta = linspace(0,2*pi,p+1)'; theta(end) = [];
c0 = n/2*(1+1i) +  r*(cos(theta) + 1i*sin(theta));
c = c0;
%For this experiment, the time step should be larger (because the curve is in [1,n] x [1,n])
% dt = .8;
%Display the curve on the back ground;

lw = 2;
clf; hold on;
imageplot(W);
h = plot(imag(c([1:end 1])),real(c([1:end 1])), 'r');
set(h, 'LineWidth', lw);
axis('ij');
pause;
%% Algoritmo geodésico
% %Evaluate the gradient.
% g = interp2(1:n,1:n, G, imag(c), real(c));
% %Evaluate the potential.
% w = interp2(1:n,1:n, W, imag(c), real(c));
% %Compute the tangent using forward derivatives.
% 
% e1 = c([2:end 1]) - c;
% d1 = abs(e1);
% e1 = e1 ./ d1;
% %Compute the normal time curvature using backward derivatives.
% 
% e2 = w.*e1 - w([end 1:end-1]).*e1([end 1:end-1]);
% %Evolution of the curve.
% 
% c = c + dt * ( - g .* d1 + e2 );

%% Exercice 2: Perform the curve evolution, for a time of Tmax=1150. 
% Remeber to re-sample the curve several time during the evolution.
Tmax = 1150;
dt = .8; 
niter = round(Tmax/dt);
c = c0;
displist = round(linspace(1,niter,10));
k = 1;
clf; hold on;
imageplot(W);
for i=1:niter
    g = interp2(1:n,1:n, G, imag(c), real(c));
    % Evaluate the potential.
    w = interp2(1:n,1:n, W, imag(c), real(c));
    % Compute the tangent using forward derivatives.
    e1 = c([2:end 1]) - c;
    d1 = abs(e1); e1 = e1 ./ d1;
    e2 = w.*e1 - w([end 1:end-1]).*e1([end 1:end-1]);
    c = c + dt * ( - g .* d1 + e2 );
    if mod(i,50)==1
        % Re-sample it
        c(end+1) = c(1);
        d = abs(c(1:end-1)-c(2:end)); d = [0;cumsum(d)];
        c = interp1(d/d(end),c,(0:p-1)'/p);
    end  
    if 0
        clf; hold on;
        imageplot(W);
        h = plot(imag(c([1:end 1])),real(c([1:end 1])), 'r');
        set(h, 'LineWidth', lw);
        axis('ij');
        drawnow;
    end
    if i==displist(k)       
        h = plot(imag(c([1:end 1])),real(c([1:end 1])), 'r');
        if i==1 || i==niter
            set(h, 'LineWidth', 2);
        end
        k = k+1;
        drawnow;
        axis('ij'); axis('off');
    end
end
pause;
%% Imagen médica
n = 256;
M = rescale( sum(load_image('cortex', n), 3 ) );

clf;
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
pause;
%% Exercice 4:  Create an initial circle c0 of p=128 points.
% Curva inicial
r = .95*n/2;
p = 128; % number of points on the curve
theta = linspace(0,2*pi,p+1)'; theta(end) = [];
c0 = n/2*(1+1i) +  r*(cos(theta) + 1i*sin(theta));
c = c0;
clf; hold on;
imageplot(M);
h = plot(imag(c([1:end 1])),real(c([1:end 1])), 'r');
set(h, 'LineWidth', 2);
pause;
%% Exercice 5:Perform the curve evolution, for a time of Tmax=1150. 
% Remeber to re-sample the curve several time during the evolution. Try with different dynamics for the W scaling so that you capture the contour you are interested in.
% Evolución del snake
options.order = 2;
G = grad(W, options);
G = G(:,:,1) + 1i*G(:,:,2);
Tmax = 1150*1.6;
dt = .8; 
niter = round(Tmax/dt);
c = c0;
displist = round(linspace(1,niter,10));
k = 1;
clf; hold on;
imageplot(M);
for i=1:niter
    g = interp2(1:n,1:n, G, imag(c), real(c));
    % Evaluate the potential.
    w = interp2(1:n,1:n, W, imag(c), real(c));
    % Compute the tangent using forward derivatives.
    e1 = c([2:end 1]) - c;
    d1 = abs(e1); e1 = e1 ./ d1;
    e2 = w.*e1 - w([end 1:end-1]).*e1([end 1:end-1]);
    c = c + dt * ( - g .* d1 + e2 );
    if mod(i,50)==1
        % Re-sample it
        c(end+1) = c(1);
        d = abs(c(1:end-1)-c(2:end)); d = [0;cumsum(d)];
        c = interp1(d/d(end),c,(0:p-1)'/p);
    end  
    if i==displist(k)       
        h = plot(imag(c([1:end 1])),real(c([1:end 1])), 'r');
        if i==1 || i==niter
            set(h, 'LineWidth', 2);
        end
        k = k+1;
        drawnow;
        axis('ij'); axis('off');
    end
end



