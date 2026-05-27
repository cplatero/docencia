% ===============================================================================
% Example for NPIR, Non-Parametric Image Registration
% (c) Jan Modersitzki 2009/04/06, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
% 
%   - data                 HNSP, Omega=(0,2)x(0,1), level=4, m=[32,16]
%   - viewer               viewImage2D
%   - interpolation        linearInter2D
%   - distance             SSD
%   - regularizer          mbElastic
%   - optimizer            Gauss-Newton
% ===============================================================================

%% Set up
%pre-registration
R_BW =im2bw(imread('Avion/avion1.jpg'));R_BW([1,end],:)=false;
T_BW =im2bw(imread('Avion/avion2.jpg'));T_BW([1,end],:)=false;
Tc_BW = mom2DBWAfin(R_BW,T_BW,0);


%initialize image viewer
viewOptn = {'viewImage','viewImage2D','colormap','gray(256)'};
viewImage('reset',viewOptn{:});

% initialize the interpolation scheme and coefficients
inter('reset','inter','splineInter2D');
level = 4; omega = [0 size(R_BW,1) 0 size(R_BW,2)]; m = size(R_BW); 
[T,R] = inter('coefficients',double(Tc_BW*255),double(R_BW*255),omega,'out',0);
% [T,R] = inter('coefficients',convertSmoothModel(Tc_BW),...
%                 convertSmoothModel(R_BW),omega,'out',0);

xc    = getCenteredGrid(omega,m); 
Rc    = inter(R,omega,xc);

% initialize distance measure
distance('set','distance','SSD');       

% initialize regularization, note: yc-yRef is regularized, elastic is staggered 
regularizer('reset','regularizer','mbElastic','alpha',1e4,'mu',1,'lambda',0);
y0   = getStaggeredGrid(omega,m); yRef = y0; yStop = y0;


% set-up and initialize plots 
FAIRplots('reset','mode','NPIR-Gauss-Newton','omega',omega,'m',m,'fig',1,'plots',1);
FAIRplots('init',struct('Tc',T,'Rc',R,'omega',omega,'m',m)); 

%% Optimization
% build objective function, note: T coefficients of template, Rc sampled reference
fctn = @(yc) NPIRobjFctn(T,Rc,omega,m,yRef,yc); fctn([]); % report status

% -- solve the optimization problem -------------------------------------------
[yc,his] = GaussNewtonArmijo(fctn,y0,'maxIter',500,'Plots',@FAIRplots,'yStop',yStop);
% report results
iter = size(his.his,1)-2; reduction = 100*fctn(yc)/fctn(y0);
fprintf('reduction = %s%% after %d iterations\n',num2str(reduction),iter);
%diary off

%% Visualization
T_NPIR = inter(T,omega,center(yc,m));
T_NPIR_BW = reshape(T_NPIR>128,m);
figure;imshow([R_BW,T_BW;Tc_BW,T_NPIR_BW]);
MSE = sum((R_BW(:)-T_NPIR_BW(:)).^2)/m(1)/m(2)

