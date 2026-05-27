%$ example for a derivative check
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

E3_splineInterpolation2D;
fctn = @(x) splineInter2D(T,omega,x);
[fig,ph,th] = checkDerivative(fctn,xf(:));
