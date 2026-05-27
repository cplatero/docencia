function demoGeoSnake(M,W)
n=size(M,1);
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
title('Demo Geodesic Snake');
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
pause;
