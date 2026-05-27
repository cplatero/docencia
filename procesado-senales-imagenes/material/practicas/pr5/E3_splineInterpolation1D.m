%$ example for spline interpolation in 1D
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

dataT = [0,2,2,2,1]; m = length(dataT); omega = [0,m];  
xc = getCenteredGrid(omega,m);
B  = spdiags(ones(m,1)*[1,4,1],[-1:1],m,m);
T  = B\reshape(dataT,m,1);
xf = linspace(-1,6,101);             
Tf = book_splineInter1D(T,omega,xf);
figure(1); clf; ph = plot(xc,dataT,'.',xf,Tf,'g-','markersize',30); 
