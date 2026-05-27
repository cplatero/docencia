% Tutorial for FAIR: 2D interpolation: DERIVATIVES
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%
% set-up data
% compute interpolants and check derivative
%
% the tutorial explores the derivative of the interpolant 
% for 'linearMatlab2D', 'linearInter2D', 'splineInter2D'
clear, close all, help(mfilename);

% exploring the derivatives of different interpolants for data given by USfair.jpg
fprintf('%s\n','load data')
dataT = double(imread('USfair.jpg'));
m     = floor(size(dataT)/4);
omega = [0,size(dataT,1),0,size(dataT,2)];
xc    = getCenteredGrid(omega,m);

% these are the methods to be compared
methods = {'linearMatlab2D','linearInter2D','splineInter2D'};
for j=1:length(methods),
  
  % reset the interpolation scheme and compute coefficients (if necessary)
  inter('reset','inter',methods{j});
  T  = inter('coefficients',dataT,[],omega,'out',0);
  Tc = @(x) inter(T,omega,x);

  fprintf('testing %s, using regular x\n',inter)
  [f,ph,th] = checkDerivative(Tc,xc);

  % make plots nice
  set(gca,'fontsize',20,'YAxisLocation','right');
  set(ph,'linewidth',2); set(th,'fontsize',20);
  ylabel(sprintf('[%s], based on x',inter))
  FAIRpause;

  fprintf('test %s, using X+randn(size(X))\n',inter)
  [f,ph,th] = checkDerivative(Tc,xc+randn(size(xc)));

  % make plots nice
  set(gca,'fontsize',20,'YAxisLocation','right');
  set(ph,'linewidth',2); set(th,'fontsize',20);
  ylabel(sprintf('[%s], based on X+noise',inter));
  FAIRpause;
end;
