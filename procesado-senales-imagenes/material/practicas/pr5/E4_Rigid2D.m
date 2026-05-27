%$ rotation of the US image
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupUSData; fprintf('trafo=%s\n',rigid2D);
alpha = pi/6; R = [cos(alpha),-sin(alpha);sin(alpha),cos(alpha)];
center = (omega(2:2:end)-omega(1:2:end))'/2;
wc = [alpha;(eye(2)-R)*center]; 
xc = getCenteredGrid(omega,m);
yc = rigid2D(wc,xc);
Tc = linearInter2D(dataT,omega,yc);
figure(2); viewImage2D(Tc,omega,m,'colormap','gray(256)'); 
