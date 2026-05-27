%$ affine linear transformation of the US image
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupUSData;  
wc = [1 -0.2 50, 0, 0.75 50]'; 
xc = getCenteredGrid(omega,m);  
yc = affine2D(wc,xc);
Tc = linearInter2D(dataT,omega,yc);
figure(2); viewImage2D(Tc,omega,m,'colormap','gray(256)'); 
