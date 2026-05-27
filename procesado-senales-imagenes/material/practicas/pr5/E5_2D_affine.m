% Tutorial for FAIR: Landmark Based Registration, affine transformation
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% - load data (see setupHandData)
% - set-up  viewer (viewImage2D), interpolator (splineInter2D), 
% - set-up landmarks (LM)
% - run affine
clear, close all, help(mfilename)

% set-up hand data
setupHandData

if runThis('','set new landmarks ? ','tests',0 ),
  [LM,fig] = getLandmarks(dataT,dataR,omega,m);
  close(fig);
end;

omegaT = omega(1,:)
omegaR = omega(end,:)
xT = getCenteredGrid(omegaT,m);
xR = getCenteredGrid(omegaR,m);
Tc = inter(dataT,omegaT,xT);
Rc = inter(dataR,omegaR,xR);

FAIRfigure(1,'figname',mfilename); clf; 
subplot(1,3,1); viewImage(Tc,omegaT,m); hold on;
ph = plotLM(LM(:,1:2),'numbering','on','color','r');
set(ph,'linewidth',2,'markersize',20);
title(sprintf('%s','T&LM'),'fontsize',20);

subplot(1,3,2); viewImage(Rc,omegaR,m); hold on;
ph = plotLM(LM(:,3:4),'numbering','on','color','g','marker','+');
set(ph,'linewidth',2,'markersize',20);
title(sprintf('%s','R&LM'),'fontsize',20);

[yc,LM] = LMreg('linear',LM(:,1:4),xR);
TLM = inter(dataT,omegaT,yc);

subplot(1,3,3); cla; viewImage(TLM,omegaR,m); hold on;
ph = plotLM(LM(:,3:4),'numbering','off','color','g','marker','+');
qh = plotLM(LM(:,7:8),'numbering','off','color','m','marker','x');
rh = plot(LM(:,[3,7])',LM(:,[4,8])','m-','linewidth',3);
set([ph;qh;rh],'linewidth',2,'markersize',20);
title(sprintf('%s','T(y^{affine})&LM'),'fontsize',20);
FAIRpause;
