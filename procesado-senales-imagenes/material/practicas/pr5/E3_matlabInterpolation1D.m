%$ example for MATLAB's linear interpolation in 1D, 
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

omega = [0,4]; T = [1,2,3,3]'; m = length(T);
xc = getCenteredGrid(omega,m);
Tc = linearMatlab1D(T,omega,xc);
xf = linspace(omega(1)-1,omega(2)+1,201);
Tf = linearMatlab1D(T,omega,xf);
clf; ph = plot(xc,0*Tc,'b+',xc,Tc,'ro',xf,Tf,'k-');

fctn = @(x) linearMatlab1D(T,omega,x);
fig = checkDerivative(fctn,xc+1e-2); pause(2); close(fig);
