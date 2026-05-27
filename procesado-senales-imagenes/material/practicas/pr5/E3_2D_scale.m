% Tutorial for FAIR: 2D interpolation: SCALE
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%
% set-up data
% display and visualize data
% compute approximations (spline, various theta's) and visualize
%
% the tutorial explores the scale-space idea for 2D data
% the spline based model is based on the minimization of
% D(T)+theta S(T)!= min, 
% where D(T) is a data fitting term and S(T) is the linearized bending energy
clear, close all, help(mfilename);

% load some data, define a doman and an initial discretization
dataT = double(imread('USfair.jpg'));
omega = [0,size(dataT,1),0,size(dataT,2)];
m     = [128,128]/2;
xc    = getCenteredGrid(omega,m);

% set-up image viewer
viewImage('reset','viewImage','viewImage2D','colormap','gray(256)');

% set-up spline interpolation
inter('reset','inter','splineInter2D','regularizer','moments');
inter('disp');

scaleParameter = [logspace(3,-2,23),0];
titleStr = @(j) title(sprintf('scale-space, \\theta=%s',num2str(scaleParameter(j))),...
  'fontsize',30);

for j=1:length(scaleParameter);
  % set scale parameter and compute spline coefficients
  inter('set','theta',scaleParameter(j));
  T = inter('coefficients',dataT,[],omega,'out',0);
  
  % interpolate image
  Tc = inter(T,omega,xc);
  
  if j==1, % set-up figure
    figure(1); clf;
    vh = viewImage(Tc,omega,m); titleStr(j);
    FAIRpause;
  else
    set(vh,'cdata',reshape(Tc,m)'); titleStr(j);
    FAIRpause(1/500);
  end;
end;
  
