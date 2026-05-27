%$ translation of the US image
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupUSData;  fprintf('trafo=%s\n',translation2D);
wc = [-50;0]; 
xc = getCenteredGrid(omega,m);  
yc = translation2D(wc,xc);
Tc = linearInter2D(dataT,omega,yc);
figure(2); viewImage2D(Tc,omega,m,'colormap','gray(256)'); 
