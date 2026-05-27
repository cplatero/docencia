%$ Example for Parametric Image Registration
%$ HNSP data, affine, level=4
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

% set-up data (MultiLevel based) and initialize image viewer
setupHNSPData; 

% initialize the interpolation scheme and coefficients
inter('set','inter','splineInter2D'); 
level = 4; omega = MLdata{level}.omega; m = MLdata{level}.m; 
[T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega);
xc = getCenteredGrid(omega,m); 
Rc = inter(R,omega,xc);

% initialize distance measure
distance('set','distance','SSD');       

% initialize the transformation and a starting guess
trafo('reset','trafo','affine2D');
w0 = trafo('w0'); 

% set-up plots and initialize
FAIRplots('set','mode','PIR-Gauss-Newton','omega',omega,'m',m,'fig',1,'plots',1);
FAIRplots('init',struct('Tc',T,'Rc',R,'omega',omega,'m',m)); 

% build objective function
% note: T  is template image
%       Rc is sampled reference
%       optional Tichonov-regularization is disabled by setting m = [], wRef = []
%       beta = 0 disables regularization of Hessian approximation
beta = 0; M = []; wRef = [];
fctn = @(wc) PIRobjFctn(T,Rc,omega,m,beta,M,wRef,xc,wc); 
fctn([]);   % report status

% -- solve the optimization problem -------------------------------------------
[wc,his] = GaussNewtonArmijo(fctn,w0,'Plots',@FAIRplots,'solver',[],'maxIter',100);
plotIterationHistory(his,'J',[1,2,5],'fig',20+level); 
