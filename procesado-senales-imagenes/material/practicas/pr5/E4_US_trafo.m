% Tutorial for FAIR: 2D interpolation and transformations
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% - load data ('USfair.jpg')
% - set-up  viewer          (viewImage2D), 
%           interpolator    (linearInter2D), 
%           transformation  (rotation2D)
% - rotate image
%
% a non-trivial example for interpolation, transformtion, and visualization
% for a loop over transformation parameters (rotation angles), 
%   computes the transformed grid, transformed image, and visualizes these
clear, close all, help(mfilename)

fprintf('%s\n','load data')
dataT = double(imread('USfair.jpg'));
m     = floor(size(dataT)/4);
omega = [0,size(dataT,1),0,size(dataT,2)];
xc    = getCenteredGrid(omega,m);

fprintf('%s\n','set-up image viewer')
viewImage('reset','viewImage','viewImage2D','colormap',gray(256));

fprintf('%s\n','set-up interpolator')
inter('reset','inter','linearInter2D');

fprintf('%s\n','set-up transformation model')
center = (omega(2:2:end)-omega(1:2:end))'/2;
trafo('reset','trafo','rotation2D','c',center);

fprintf('%s\n','start rotation')

% rotation angle wc shortcut for plots
wc  = sin(linspace(0,2*pi,201));
str = @(wc) sprintf('wc=%s',num2str(wc));
for j=1:length(wc),              % run over all angles
  yc = trafo(wc(j),xc);          % compute the transformed grid
  Tc = inter(dataT,omega,yc);   % interpolate T on the grid

  if j == 1,                    % visualize the results
    FAIRfigure(1,'figname',mfilename);
    vh = viewImage(Tc,omega,m);
    th = title(str(wc(j)),'fontsize',20);
    set(gca,'fontsize',20);
    FAIRpause;
  else
    set(vh,'cdata',reshape(Tc,m)')
    set(th,'string',str(wc(j)))
    FAIRpause(1/2000)
  end;
  fprintf('.');
  if rem(j,50) == 0, fprintf('\n'); end;
end;
fprintf('\n');
