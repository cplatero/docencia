%$ Example for Parametric Image Registration
%$ HNSP data, spline transformation, level=5
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupHNSPData; 
inter('set','inter','splineInter2D'); 
level = 5; omega = MLdata{level}.omega; m = MLdata{level}.m; 
[T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega);
xc = getCenteredGrid(omega,m); 
Rc = inter(R,omega,xc);

distance('set','distance','SSD');       % initialize distance measure

center = (omega(2:2:end)-omega(1:2:end))'/2;
trafo('reset','trafo','rotation2D','c',center);

% initialize transformation and starting guess; 
% here: spline with 2 times [4,5] coefficients
trafo('reset','trafo','splineTransformation2D','omega',omega,'m',m,'p',[4,5]);
w0 = trafo('w0'); 

FAIRplots('set','mode','PIR-spline','omega',omega,'m',m,'fig',1,'plots',1);
FAIRplots('init',struct('Tc',T,'Rc',R,'omega',omega,'m',m)); 

% ----- call Gaus-Newton ------------------------------------
GNoptn = {'maxIter',50,'Plots',@FAIRplots};
fctn  = @(wc) PIRobjFctn(T,Rc,omega,m,0,[],[],xc,wc);
[wc,his] = GaussNewtonArmijo(fctn,w0,GNoptn{:});

figure(1); clf
viewImage(inter(T,omega,xc),omega,m,'axis','off'); hold on
ph = plotGrid(trafo(wc,xc),omega,m,'spacing',1,'linewidth',1,'color','w');
