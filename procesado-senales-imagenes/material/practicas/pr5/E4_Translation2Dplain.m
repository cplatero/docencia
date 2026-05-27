%$ translation of an US image
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupUSData; 
wc = [-50;0]; 
xc = reshape(getCenteredGrid(omega,m),[],2);  
yc = [(xc(:,1) + wc(1));(xc(:,2) + wc(2))];
Tc = linearInter2D(dataT,omega,yc);
figure(2); clf; viewImage2D(Tc,omega,m,'colormap','gray(256)'); 
  