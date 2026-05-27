%$ Example for midpoint quadrature rule for 1D spline
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

omega = [0,6];   I = 1;  psi = @(x) spline1D(3,x); h = []; Q = [];
for j=1:10,
  m    = 2^j; 
  h(j) = diff(omega)/m; 
  xc   = getCenteredGrid(omega,m); 
  Q(j) = h(j)*sum(psi(xc));
end;
figure(1); clf; p1=semilogx(h/h(1),Q+eps,'kx',h/h(1),Q,'k-');
figure(2); clf; p2=loglog(h/h(1),abs(I-Q)+eps,'kx',h/h(1),abs(I-Q),'k-');
