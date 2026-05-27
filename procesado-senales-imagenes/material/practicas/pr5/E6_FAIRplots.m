% Tutorial for FAIR: How to use FAIRplots
% (C) 2008/08/14, Jan Modersitzki, see FAIR and FAIRcopyright.m.
% Explains how to use FAIRplots

clear; clearFAIR;

% load data, initialize image viewer, interpolator, transformation
load tutFAIRplots.mat
viewImage('reset','viewImage','viewImage2D','colormap','gray(256)');
inter('reset','inter','linearInter2D');
trafo('reset','trafo','affine2D');


% shortcurs for transformed image
Rc = inter(RD,omega,X);
Tc = @(Y)  inter(TD,omega,Y);
Dc = @(Tc) SSD(Tc,Rc,omega,m);

% compute the stopping, starting and final values
wStop = trafo('w0'); 
Ystop = trafo(wStop,X); 
Tstop = Tc(Ystop);
Y0    = trafo(wOpt,X); 
T0    = Tc(Y0);
Topt  = Tc(Yopt); 


% reset FAIRplots to have a fresh start
FAIRplots('clear'); 

% setup the plotting functionality, no plots yet
FAIRplots('set','mode',mfilename);

% initialize the plots, show T and R
FAIRplots('init',struct('Tc',TD,'Rc',RD,'omega',omega,'m',m)); Pause;

% show the stopping values
para  = struct('Tc',Tstop,'Rc',Rc,'omega',omega,'m',m,'Yc',Ystop,'Jc',Dc(Tstop));
FAIRplots('stop',para); Pause;

% show the starting values
para.Tc = T0; para.Yc = Y0; para.Jstop = para.Jc; para.Jc = Dc(T0);
FAIRplots('start',para);   Pause;

% show the final values
para.Tc = Topt; para.Yc = Yopt; para.Jc = Dc(Topt);
para.normdY = norm(Yopt-Y0)/norm(Ystop);
FAIRplots(1,para);
