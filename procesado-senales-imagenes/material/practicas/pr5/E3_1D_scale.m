% Tutorial for FAIR: 1D interpolation: SCALE
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%
% set-up data
% display and visualize data
% compute approximations (spline, various theta's) and visualize
%
% the tutorial explores the scale-space idea for 1D data
% the spline based model is based on the minimization of
% D(T)+theta S(T)!= min, 
% where D(T) is a data fitting term and S(T) is the linearized bending energy
clear, close all, help(mfilename);

% set-up data 
fprintf('%s\n','generate some noisy data ');

omega = [0,10]; p = 21;
dataX = getCenteredGrid(omega,p);
dataT  = rand(p,1); dataT([1,end]) = 0; % T should be compactly supported

% visualize the data
figure(2); clf;
ph = plot(dataX,0*dataT,'k.',dataX,dataT,'b.','markersize',30); hold on; 
title('1D multiscale','fontsize',20);
axis([omega(1)-1,omega(2)+1,min(dataT)-1,max(dataT)+1]);
lstr = {'location','data'}; legend(ph,lstr,1);
FAIRpause;

% discretization for the model  -----------------------------------------------
m  = 101; % discretization for the model, h=omega./m
xc = getCenteredGrid(omega,m);

% the coefficients depend on the scale-parameter theta
T = @(theta) getSplineCoefficients(dataT,...
  'regularizer','moments','theta',theta,'dim',1,'out',0);

% the continuous model
Tc = @(theta) splineInter1D(T(theta),omega,xc);

% show results for various theta's: fine to coarse scale
fprintf('%s\n','show results for various theta''s');
theta = [0,logspace(-3,3,51)];
for j=1:length(theta),
  fprintf('.');
  if j>1, 
    set(qh,'visible','off');  
  end;
  qh = plot(xc,Tc(theta(j)),'g-','linewidth',3);
  ylabel(sprintf('\\theta=%s',num2str(theta(j))),'fontsize',20); FAIRpause(1/10)
  if j==1,  lstr{3} = 'spline';  legend([ph;qh],lstr,1); FAIRpause; end;
end;
fprintf('\n'); FAIRpause;

% show results for various theta's: coarse to fine scale
for j=length(theta):-1:1,
  fprintf('.');
  set(qh,'visible','off');
  qh = plot(xc,Tc(theta(j)),'g-','linewidth',3);
  ylabel(sprintf('\\theta=%s',num2str(theta(j))),'fontsize',20); FAIRpause(1/10)
  if j==1, FAIRpause; end;
end;
fprintf('\n'); 
