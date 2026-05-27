%$ Example for Parametric Image Registration
%$ HNSP data, rigid, level=7
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupHNSPData; 
inter('set','inter','splineInter2D'); 
level = 7; omega = MLdata{level}.omega; m = MLdata{level}.m; 
[T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega);
xc = getCenteredGrid(omega,m); 
Rc = inter(R,omega,xc);

distance('set','distance','SSD');       % initialize distance measure

trafo('reset','trafo','rigid2D');
w0 = trafo('w0'); 

FAIRplots('set','mode','PIR-rigid','omega',omega,'m',m,'fig',1,'plots',1);
FAIRplots('init',struct('Tc',T,'Rc',R,'omega',omega,'m',m)); 

% ----- call Gaus-Newton ------------------------------------
GNoptn = {'maxIter',500,'Plots',@FAIRplots};
fctn  = @(wc) PIRobjFctn(T,Rc,omega,m,0,[],[],xc,wc);
[wc,his] = GaussNewtonArmijo(fctn,w0,GNoptn{:});

figure(1); clf
viewImage(inter(T,omega,xc),omega,m,'axis','off'); hold on
ph = plotGrid(trafo(wc,xc),omega,m,'spacing',1,'linewidth',1,'color','w');

% plot iteration history
his.str{1} = sprintf('iteration history PIR: distance=%s, y=%s',distance,trafo);
[ph,th] = plotIterationHistory(his,'J',1:4,'fig',2);