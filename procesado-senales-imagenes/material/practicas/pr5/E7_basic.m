% ===============================================================================
% Tutorial for FAIR: distances, hands, SSD versus rotation (short version of E7_extended.m)
% (c) Jan Modersitzki 2009/03/25, see FAIR.2 and FAIRcopyright.m.
% note: '%$' is used so hide comments in the book                              
%
%   - data                 PETCT, Omega=(0,140)x(0,151), level=4:7, m=[128,128]
%   - viewer               viewImage2D
%   - interpolation        splineInter2D
%   - distance             'SSD','NCC','MI','NGF'
%   - transformation       rotation2D
% ===============================================================================

clear, close all, help(mfilename);

fprintf('%s\n','set-up data, viewer, interpolator, transformation model, distance')
setupPETCTdata; level = 6; omega = MLdata{level}.omega; m = MLdata{level}.m;

viewImage('reset',viewOptn{:},'axis','off');
inter('reset','inter','splineInter2D','regularizer','moments','theta',1e0);
[T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega,'out',0);
center = (omega(2:2:end)-omega(1:2:end))'/2;
trafo('reset','trafo','rotation2D','c',center);
distance('reset','distance','SSD');
fprintf('%20s : %s\n','viewImage',viewImage);
fprintf('%20s : %s\n','inter',inter);
fprintf('%20s : %s\n','trafo',trafo);

xc  = getCenteredGrid(omega,m);
Rc = inter(R,omega,xc);


distances = {'SSD','NCC','MI','NGF'};

for k=1:length(distances),
  distance('reset','distance',distances{k});
  fprintf('%20s : %s\n','distance',distance);
  wc = linspace(-pi/2,pi/2,49);
  Dc = zeros(size(wc));
  
  % run the loop over all rotations
  for j = 1:length(wc),
    yc    = trafo(wc(j),xc);         % compute transformed grid
    Tc    = inter(T,omega,yc);       % compute transformed image
    Dc(j) = distance(Tc,Rc,omega,m); % compute distance

    % visualize
    if j == 1,
      FAIRfigure(k,'figname',mfilename); clf;
      subplot(1,3,1);  viewImage(Rc,omega,m);            th(1) = title('R');
      subplot(1,3,2);  vh = viewImage(Tc,omega,m);       th(2) = title('T(yc)');
      subplot(1,3,3);  ph = plot(wc(1),Dc(1),'r.','markersize',markersize);
      th(3) = title(sprintf('%s versus rotation',distance));
      axis([wc(1),wc(end),-inf,inf]); hold on; set(th,'fontsize',fontsize);
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
  FAIRpause;
end;
