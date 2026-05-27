%$ Example for SSD and translations
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupHNSPData; 
level = 4; m = MLdata{level}.m; 
inter('set','inter','linearInter2D'); 
[T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega);
xc = getCenteredGrid(omega,m); Rc = inter(R,omega,xc);

trafo('set','trafo','translation2D');
figure(1); clf;
[w1,w2] = ndgrid(0.2*linspace(-1,1,21),0.2*linspace(-1,1,21));
dc  = zeros(size(w1));
for j=1:numel(dc),
  yc = trafo([w1(j);w2(j)],xc);
  Tc = inter(T,omega,yc);
  dc(j) = SSD(Tc,Rc,omega,m);
  viewImage(Tc,omega,m); pause(1/100)
end;
figure(1); clf; surf(w1,w2,dc); hold on; grid off; contour(w1,w2,dc)
title(sprintf('translation, m=[%d,%d]',m)); view(-135,33);
