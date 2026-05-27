% Tutorial for FAIR:  2D interpolation and visualization
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
% - load data ('USfair.jpg')
% - set-up  viewer          (viewImage2D)
% - view image in high res and low res
clear, close all, help(mfilename);

% generic example for usage of interpolation and visualization
% loads some data, initializes viewer and interpolator, shows some results

fprintf('%s\n','generic interpolation and visualization')

fprintf('%s\n','load data, set-up image viewer')
dataT = double(imread('USfair.jpg'));
m     = size(dataT);
omega = [0,size(dataT,1),0,size(dataT,2)];

% set-up image viewer
viewImage('reset','viewImage','viewImage2D','colormap',gray(256));

% shortcuts for labeling off plots
dimstr  = @(m) sprintf('%s=[%s]',inputname(1),sprintf(' %d',m));
lbl = @(str,m) sprintf('%s, %s',str,dimstr(m));

fprintf('%s\n','visualize original data')
FAIRfigure(1,'figname',mfilename); clf; 
viewImage(dataT,omega,m);
title(lbl('highres',m),'fontsize',20); set(gca,'fontsize',20); FAIRpause;

fprintf('%s\n','set-up interpolater')
inter('reset','inter','splineInter2D','regularizer','moments','theta',1e-2);
T = getSplineCoefficients(dataT,'out',0);

fprintf('%s\n','generate some points and interpolate')
m  = [256,128];
xc = getCenteredGrid(omega,m);
Tc = inter(T,omega,xc);

FAIRfigure(2,'figname',mfilename); clf; 
viewImage(Tc,omega,m);
title(lbl('lowres',m),'fontsize',20);  set(gca,'fontsize',20);
