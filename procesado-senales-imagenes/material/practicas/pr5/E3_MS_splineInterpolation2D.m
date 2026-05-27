%$ example for multiscale spline interpolation in 2D
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupUSData; m = 128*[3,2]; xc = getCenteredGrid(omega,m);
T = getSplineCoefficients(dataT,'dim',2,'regularizer','gradient','theta',50);
T2= splineInter2D(T,omega,xc);
figure(2); clf; viewImage2D(T2,omega,m); 
colormap(gray(256));
