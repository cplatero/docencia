% Test distances
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.

FAIRdiary

% tset syntax
distance('clear');
distance('disp');
distance('reset','distance','MIcc',...
  'tol',1e-7,'minT',0,'maxT',256,'nT',60,'minR',0,'maxR',256,'nR',60);
distance('disp');
[a,b] = distance

fprintf(' ... %s\n','generate hand data and setup transformation model:')
setupHandData
inter('reset','inter','splineInter2D','regularizer','moments','theta',1e0);
level = 4; omega = MLdata{level}.omega; m = MLdata{level}.m;
[T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega(1,:),'out',0);
xc  = getCenteredGrid(omega(1,:),m);
Rc  = inter(R,omega(end,:),xc);

distances = {'SSD','NCC','MIspline','MIcc','NGFdot'};

clear fig; l = 0;
% ------------------- RUN over all distance measures -------------------------------------
for k=1:length(distances);

  distance('reset','distance',distances{k});
  switch distance,
    case {'SSD','NCC'},
    case 'MIcc',
      %set-up default parameter
      distance('set','tol',1e-7,'minT',0,'maxT',256,'nT',60,'minR',0,'maxR',256,'nR',40);
      distance('disp');
    case 'NGFdot',
      %set-up default parameter
      distance('set','edge',100);
      distance('disp');
  end;


  for type = 1:2,
    fctn = @(x) parseDistance(type,T,Rc,omega(end,:),m,x);
    l = l+1;
    fig(l)=checkDerivative(fctn,xc);
    ylabel([distance,'-',int2str(type)])
    pause(2);
  end;
end;
diary off
% =========================================================================
% clean up
fprintf('%s%s\n',mfilename,' testing done! .... ');
pause(2); close all; clc
% =========================================================================
