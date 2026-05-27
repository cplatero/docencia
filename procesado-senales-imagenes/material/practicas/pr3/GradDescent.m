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