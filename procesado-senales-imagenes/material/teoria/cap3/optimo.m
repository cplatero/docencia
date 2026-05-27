GradJ = @(x)[2*(x(1)-3); 2*(x(2)-1)];
J = @(x) (x(1)-3)^2 +( x(2)-1)^2; 
tau = 0.75;
x= [2;2];
X=x;
Cost=inf;
i=1;
niter_max = 10;
salir = false;
while (i<=niter_max) && (salir == false)
    x = x - tau*GradJ(x);
    X=[X,x];
    Cost=[Cost;J(x)];
    if((Cost(end)==0) || (Cost(end-1)-Cost(end))<.01)
        salir = true;
    end
    i = i+1;
        
end
fprintf('Optimo: %.2f %.2f\n', x(1),x(2));