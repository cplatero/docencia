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
%   - optimization         Gauss-Newton
% ===============================================================================

clear, close all, help(mfilename);


% set-up data, interpolation, transformation, distance, 
% extract data from a particular level amd compute coefficients for interpolation
setupHandData;
viewImage('reset','viewImage','viewImage2D','colormap',bone(256),'axis','off');
inter('reset','inter','splineInter2D','regularizer','moments','theta',1e-1);
level = 5; omega = MLdata{level}.omega; m = MLdata{level}.m;
[T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega,'out',0);
distance('reset','distance','SSD');
center = (omega(2:2:end)-omega(1:2:end))'/2;
trafo('reset','trafo','rotation2D','c',center); 
w0 = trafo('w0'); beta = 0; M =[]; wRef = []; % disable regularization

% initialize plots
FAIRplots('set','mode','PIR-GN','fig',1);
FAIRplots('init',struct('Tc',T,'Rc',R,'omega',omega,'m',m)); 

xc = getCenteredGrid(omega,m); 
Rc = inter(R,omega,xc);
fctn = @(wc) PIRobjFctn(T,Rc,omega,m,beta,M,wRef,xc,wc);

% optimize
[wc,his] = GaussNewtonArmijo(fctn,w0,'Plots',@FAIRplots,'solver','direct');
  
