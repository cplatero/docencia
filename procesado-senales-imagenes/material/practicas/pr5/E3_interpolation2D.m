%$ example for interpolation in 2D
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupUSData; close all; T = dataT; xc = @(m) getCenteredGrid(omega,m); 
inter('set','inter','linearInter2D');

for p=5:7,
  m = 2^p*[1,1]; 
  Tc = inter(T,omega,xc(m));
  figure(p-4); viewImage2D(Tc,omega,m); colormap(gray(256));
end;

inter('set','inter','splineInter2D');
T = getSplineCoefficients(dataT,'regularizer','moments','theta',100);
for p=5:7,
  m = 2^p*[1,1]; 
  Tc = inter(T,omega,xc(m));
  figure(p-1); viewImage2D(Tc,omega,m); colormap(gray(256));
end;
