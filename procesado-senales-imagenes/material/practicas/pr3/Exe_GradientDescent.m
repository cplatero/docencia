
%% Exercice 1: Perform the gradient descent using a fixed step size ?k=?. 
%Display the decay of the energy f(x(k)) through the iteration. 
%Save the iterates so that X(:,k) corresponds to x(k).
Gradf = @(x)[x(1); eta*x(2)];
f = @(x)( x(1)^2 + eta*x(2)^2 ) /2; %coste
tau = 1.5/eta;
x= [.5;.5];
X=[];
Cost=[];
niter = 10;
for i=1:niter
    x = x - tau*Gradf(x);
    X = [X,x];
    Cost=[Cost;f(x)];   
end
clf;
% plot(1:length(Cost),log10(Cost(:)));
plot(1:length(Cost),Cost);
pause;

%% Exercice 2:  Display the iteration for several different step sizes.
eta = 1;
GradDescent(eta,1.5/eta,niter);
pause;
eta = 4;
GradDescent(eta,2.01/eta,niter);
pause;
GradDescent(eta,1.8/eta,niter);


%% Exercice 3: Implement the gradient descent. Monitor the decay of f through the iterations.
niter = 350;
u = y;
energy=[];
for i=1:niter
    u = u - tau*Gradf(u);
    energy=[energy;f(u)];
end

plot(energy);
pause;

clf;
imageplot(u);
    
    





%% Auxiliar functions
function GradDescent(eta,tau,niter)
t = linspace(-.7,.7,101);
[v,u] = meshgrid(t,t);
F = ( u.^2 + eta*v.^2 )/2 ;

%Display the function as a 2-D image.
clf; hold on;
imagesc(t,t,F); colormap jet(256);
contour(t,t,F, 20, 'k');
axis off; axis equal;

Gradf = @(x)[x(1); eta*x(2)];

x= [.5;.5];
X=[];
Cost=[];
for i=1:niter
    x = x - tau*Gradf(x);
    X = [X,x];
end
clf;

%% Visualizar
clf; hold on;
imagesc(t,t,F); colormap jet(256);
contour(t,t,F, 20, 'k');
h = plot(X(1,:), X(2,:), 'k.-');
set(h, 'LineWidth', 2);
set(h, 'MarkerSize', 15);
hold off;
axis off; axis equal;
