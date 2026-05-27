%$ Example for midpoint quadrature rule for 2D SSD
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupHNSPData; clf; h = []; Q = [];
inter('reset','inter','splineInter2D');
[T,R] = inter('coefficients',dataT,dataR,omega,'out',0);
for j=1:10,
  m    = 2^j*[1,1]; 
  h(j) = prod((omega(2:2:end)-omega(1:2:end))./m); 
  xc   = getCenteredGrid(omega,m); 
  res  = inter(T,omega,xc) - inter(R,omega,xc);
  psi  = 0.5*h(j)*res'*res;
  Q(j) = psi;
end;
figure(1); clf; p1=semilogx(h/h(1),Q+eps,'kx',h/h(1),Q,'k-');
