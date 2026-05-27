% ===============================================================================
% Tutorial for FAIR: distances, PETCT, SSD versus rotation
% (c) Jan Modersitzki 2009/04/06, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
% 
%   - data                 PETCT, Omega=(0,140)x(0,151), level=4:7, m=[128,128]
%   - viewer               viewImage2D
%   - interpolation        splineInter2D
%   - distance             MI
%   - transformation       rotation2D
% ===============================================================================

clear, close all, help(mfilename);

% set-up data, interpolation, transformation, regularization
setupPETCTdata; level = 6; omega = MLdata{level}.omega; m = MLdata{level}.m;

viewImage('reset',viewOptn{:},'axis','off');
inter('reset','inter','splineInter2D','regularizer','moments','theta',1e0);
[T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega,'out',0);
distance('reset','distance','MI');
center = (omega(2:2:end)-omega(1:2:end))'/2;
trafo('reset','trafo','rotation2D','c',center);
fprintf('%20s : %s\n','viewImage',viewImage);
fprintf('%20s : %s\n','inter',inter);
fprintf('%20s : %s\n','distance',distance);
fprintf('%20s : %s\n','trafo',trafo);

xc = getCenteredGrid(omega,m);
Rc = inter(R,omega,xc);

% diffImage = @(Tc) viewImage(128+(Tc-Rc)/2,omega,m);
wc = linspace(-pi/2,pi/2,51);
Dc = zeros(size(wc));

% run the loop over all rotations
for j = 1:length(wc),
  yc = trafo(wc(j),xc);                 % compute transformed grid
  Tc = inter(T,omega,yc);               % compute transformed image
  [Dc(j),rc] = distance(Tc,Rc,omega,m); % compute distance
  
  % visualize
  if j == 1,
    FAIRfigure(1,'figname',mfilename); clf;
    subplot(1,3,1);  viewImage(Rc,omega,m);            th(1) = title('R');
    subplot(1,3,2);  vh = viewImage(Tc,omega,m);       th(2) = title('T(yc)');
    subplot(1,3,3);  ph = plot(wc(1),Dc(1),'r.','markersize',markersize);
    th(3) = title(sprintf('%s versus rotation',distance));
    axis([wc(1),wc(end),-inf,inf]); hold on;
    set(th,'fontsize',fontsize);
    FAIRpause;
  else
    set(vh,'cdata',reshape(Tc,m)')
    subplot(1,3,3); set(ph,'visible','off');
    plot(wc(1:j),Dc(1:j),'k-','linewidth',2);
    ph = plot(wc(j),Dc(j),'r.','markersize',markersize);
    drawnow, FAIRpause(1/100)
  end;
  fprintf('.'); if ~rem(j,50) || j == length(wc), fprintf('\n'); end;
end;
