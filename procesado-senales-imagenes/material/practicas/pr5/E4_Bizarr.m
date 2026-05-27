%$ a bizarr transformation of an US image
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book  
                            
setupUSData; 
box = (omega(2:2:end)-omega(1:2:end));
xc = reshape(getCenteredGrid(omega,m),[],2);
yc = [(box(1)*((1 - 0.9*xc(:,2)/box(2)).*cos(pi*(1-xc(:,1)/box(1)))/2 + 0.5))
  (box(2)*(1-(1 - 0.9*xc(:,2)/box(2)).*sin(pi*(1-xc(:,1)/box(1)))))];

Tc = linearInter2D(dataT,omega,yc);
figure(2); viewImage2D(Tc,omega,m,'colormap','gray(256)'); 