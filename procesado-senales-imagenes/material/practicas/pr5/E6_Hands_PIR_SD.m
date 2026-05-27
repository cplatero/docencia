% ===============================================================================
% Tutorial for FAIR: PIR,  Parametric Image Registration
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
% 
%   - data                 Hand, Omega=(0,20)x(0,25), level=5, m=[32,32]
%   - viewer               viewImage2D
%   - interpolation        splineInter2D
%   - distance             SSD
%   - pre-registration     rotation2D, not regularized
%   - optimization         Steepest Descent
% ===============================================================================

clear, close all, help(mfilename);

% set-up data, interpolation, transformation, distance, 
% extract data from a particular level amd compute coefficients for interpolation
setupHandData;
inter('reset','inter','splineInter2D','regularizer','moments','theta',1e-2);
level = 5; omega = MLdata{level}.omega; m = MLdata{level}.m;
[T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega,'out',0);
distance('reset','distance','SSD');
trafo('reset','trafo','affine2D'); 
w0 = trafo('w0'); beta = 0; M =[]; wRef = []; % disable regularization

% initialize plots
FAIRplots('set','mode','PIR-SD','fig',1);
FAIRplots('init',struct('Tc',T,'Rc',R,'omega',omega,'m',m)); 


xc = getCenteredGrid(omega,m); 
Rc = inter(R,omega,xc);
fctn = @(wc) PIRobjFctn(T,Rc,omega,m,beta,M,wRef,xc,wc);

% run STEEPEST DESCENT with an initial stepLength
[Jc,para,dJ] = fctn(w0); stepLength = 0.5/norm(dJ);
optn = {'stepLength',stepLength,'maxIter',50,'Plots',@FAIRplots};
wc =  SteepestDescent(fctn,w0,optn{:});

