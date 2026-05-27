%$ spline transformation of the US image
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupUSData; p = [5,4]; 
xc = getCenteredGrid(omega,m);  
splineTransformation2D([],xc,'omega',omega,'m',m,'p',p);  
w1 = zeros(p); w2 = zeros(p);  w2(3,2) = 3; 
wc = [w1(:);w2(:)]; 
yc = splineTransformation2D(wc,xc);
Tc = linearInter2D(dataT,omega,yc);
figure(2); viewImage2D(Tc,omega,m,'colormap','gray(256)'); 
