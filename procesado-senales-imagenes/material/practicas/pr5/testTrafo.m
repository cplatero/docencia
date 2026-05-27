% Test transformations
% (C) 2007/04/25, Jan Modersitzki, see FAIR.

FAIRdiary

clear trafo
trafo('clear');
trafo('disp');
trafo('reset','trafo','splineTransformation2D',...
  'p',[4,5],'omega',[1,1],'m',[6,40]);
trafo('disp');
[a,b] = trafo


% test 2D cases
clc
omega = [0,1,0,2]; m = [6,7]; X = getCenteredGrid(omega,m);
center = (omega(2:2:end)-omega(1:2:end))'/2;
trafos = {'affine2D','rigid2D','rotation2D','translation2D',...
  'splineTransformation2D','splineTransformation2Dsparse'}
para = {{},{},{'c',center},{},{'p',[4,5],'omega',omega,'m',m},{'p',[4,5],'omega',omega,'m',m}};

for k=1:length(trafos),
  fprintf('\n\n\n%s\n',trafos{k})
  optn = para{k}
  trafo('reset','trafo',trafos{k},'debug','on',optn{:});
  w = trafo('w0');
  fctn = @(w) trafo(w,X);
  checkDerivative(fctn,w+randn(size(w)));
  title(trafo)
  pause(2); close;
end;


%% test 3D cases
clc
omega = [0,1,0,2,0,3]; m = [6,7,8]; X = getCenteredGrid(omega,m);
trafos = {'affine3D','affine3Dsparse','rigid3D','splineTransformation3Dsparse'}
para = {{},{},{},{'p',[4,5,6],'omega',omega,'m',m}};

for k=1:length(trafos),
  fprintf('------------------------   %s\n',trafos{k})
  optn = para{k}
  trafo('reset','trafo',trafos{k},'debug','on',optn{:});
  w = trafo('w0');
  fctn = @(w) trafo(w,X);
  checkDerivative(fctn,w+randn(size(w)));
  title(trafo)
  pause(2); close;
end;
diary off
% =========================================================================
% clean up
fprintf('%s%s\n',mfilename,' testing done! .... ');
pause(2); close all; clc
% =========================================================================
