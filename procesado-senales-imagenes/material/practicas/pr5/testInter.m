% Test interpolation schemes
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
% ----------------------------------------------------------------------------------------

FAIRdiary

% test syntax
inter('clear');
inter('disp');
inter('reset','inter','linearMatlab1D','regularizer','none','theta',1);
inter('disp');
[a,b] = inter


% test schemes
for dim=1:3,
  switch dim,
    case 1,
      % case dim = 1
      T = [0 0 1 1 0 0]';
      omega = [0,length(T)]; m = length(T);
      X = getCenteredGrid(omega,m);
      m = 3*m;
      Xf = getCenteredGrid(omega,m);
    case 2,
      omega = [0,1,0,2]; m = [13,16];
      X = getCenteredGrid(omega,m);
      Y = reshape(X,[m,dim]);
      T = (Y(:,:,1)-0.5).^2 + (Y(:,:,2)-0.75).^2 <= 0.15;
      Xf = getCenteredGrid(omega,4*m);
      Yf = reshape(Xf,[4*m,dim]);
    case 3,
      omega = [0,1,0,2,0,1]; m = [13,16,7];
      X = getCenteredGrid(omega,m);
      Y = reshape(X,[m,dim]);
      T = (Y(:,:,:,1)-0.5).^2 + (Y(:,:,:,2)-0.75).^2 + (Y(:,:,:,3)-0.5).^2 <= 0.15;
      Xf = getCenteredGrid(omega,4*m);
      Yf = reshape(Xf,[4*m,dim]);
  end;

  files = getFiles(fullfile(fairPath,'interpolation'),['*',int2str(dim),'D*']);
  
  for k = 1:length(files),
    fprintf('test [%s]\n',files{k})
    inter('reset','inter',files{k});
    Tc = inter('coefficients',T,[],omega);
    Tf = inter(Tc,omega,Xf);
    Z  = X + 1e-4*randn(size(X));
    fctn = @(Y) inter(Tc,omega,Y);
    
    switch dim, 
      case 1,
        figure(k); clf;
        plot(getCenteredGrid(omega,length(T)),T,'ro',Xf,Tf,'g-');
        title(files{k});
        f = checkDerivative(fctn,Z);
        ylabel(files{k});
        pause(2); close(f);
      case 2,
        figure(k); clf;
        plot3(Y(:,:,1),Y(:,:,2),T,'ro'); hold on;
        sh = surf(Yf(:,:,1),Yf(:,:,2),reshape(Tf,4*m));
        set(sh,'faceAlpha',0.5);
        title(files{k});
        f = checkDerivative(fctn,Z);
        ylabel(files{k});
        pause(2); close(f);
      case 3,
        figure(k); clf;
        subplot(1,2,1);
        imgmontage(Tc,omega,m);
        subplot(1,2,2);
        imgmontage(Tf,omega,4*m);
        title(files{k});
        f = checkDerivative(fctn,Z);
        ylabel(files{k});
        pause(2); close(f);
    end;
    
  end;
end;
diary off
% =========================================================================
% clean up
fprintf('%s%s\n',mfilename,' testing done! .... ');
pause(2); close all; clc
% =========================================================================
