%$ Example for Parametric Image Registration
%$ HNSP data, affine, level=5, using multi-scales
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupHNSPData; 
inter('set','inter','splineInter2D'); 
level = 5; omega = MLdata{level}.omega; m = MLdata{level}.m; 
[T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega);
xc = getCenteredGrid(omega,m); 
Rc = inter(R,omega,xc);

distance('set','distance','SSD');       % initialize distance measure

trafo('reset','trafo','affine2D');
w0 = trafo('w0'); 

FAIRplots('set','mode','PIR-affine','omega',omega,'m',m,'fig',1,'plots',1);
FAIRplots('init',struct('Tc',T,'Rc',R,'omega',omega,'m',m)); 

% -- solve the optimization problem on different scales -----------------------

wStop = w0;             % use one GLOBAL stopping criterion
theta = [1e2,1e1,1,0];  % the different scales: smooth to detailed
for j=1:length(theta),
  % initilaize the data for scale theta(j)
  inter('reset','inter','splineInter2D','regularizer','moments','theta',theta(j));
  [T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega);
  
  % set-up plots and initialize it
  FAIRplots('set','mode','PIR-Gscale','fig',j,'plots',1);
  FAIRplots('init',struct('Tc',T,'Rc',R,'omega',omega,'m',m));
  
  % initialize optimizer
  Rc   = inter(R,omega,xc); % note Rc depends on the scale as well
  fctn = @(wc) PIRobjFctn(T,Rc,omega,m,0,[],[],xc,wc); 
  if j ==1, fctn([]); end;  % report status
  
  % solve problem for this scale 
  [wc,his] = GaussNewtonArmijo(fctn,w0,'yStop',wStop,'Plots',@FAIRplots);
  % and use solutions as starting guess for next scale  
  w0 = wc;
end;
