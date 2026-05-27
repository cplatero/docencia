%$  example for linear interpolation in 1D
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

T  = [1,2,3,3]; m = length(T); omega = [0,4]; T = reshape(T,m,1);
xc = getCenteredGrid(omega,m);
Tc = book_linearInter1D(T,omega,xc);
xf = linspace(omega(1)-1,omega(2)+1,201);
Tf = book_linearInter1D(T,omega,xf);
clf; ph = plot(xc,T,'b+',xc,Tc,'ro',xf,Tf,'k-');
