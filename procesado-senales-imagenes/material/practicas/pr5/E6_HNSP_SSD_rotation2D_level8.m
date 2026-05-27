%$ Example for SSD and rotations
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupHNSPData; 
inter('set','inter','linearInter2D'); 
level = 8; omega = MLdata{level}.omega; m = MLdata{level}.m; 
[T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega);
xc = getCenteredGrid(omega,m); 
Rc = inter(R,omega,xc);

center = (omega(2:2:end)-omega(1:2:end))'/2;
trafo('set','trafo','rotation2D','c',center);

wc = pi/2*linspace(-1,1,101);  dc = zeros(size(wc));
figure(1); clf;
for j=1:length(wc),
  yc = trafo(wc(j),xc);
  Tc = inter(T,omega,yc);
  dc(j) = SSD(Tc,Rc,omega,m);
  viewImage(255-abs(Tc-Rc),omega,m); drawnow; pause(1/60)
end;
figure(2); clf; p1 = plot(wc,dc); 
