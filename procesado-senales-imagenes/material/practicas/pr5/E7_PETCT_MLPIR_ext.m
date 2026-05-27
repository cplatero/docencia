%$ (c) Jan Modersitzki 2009/03/25, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              
%$ ==  CALL MLPIR with different distance measures  ========================

setupPETCTData; %close all;                    % load data
% setupHandData; %close all;                    % load data


FAIRprint('reset','folder',fullfile(fairPath,'temp','PETCT'),...
  'pause',1,'obj','gca','format','jpg','draft','off');
% FAIRprint('disp');

mname = mfilename;
File = @(str) sprintf('%s-%s',mname,str);
Write = @(T,str) imwrite(uint8(flipud(reshape(T,m)')),...
  fullfile(fairPath,'temp','PETCT',[File(str),'.jpg']));


DM = {'SSD','NCC','MIcc','NGFdot'};


for dm = 1:length(DM),

  inter('reset','inter','splineInter2D','regularizer','moments','theta',1e0);
  level = 5; omega = MLdata{level}.omega; m = MLdata{level}.m;
  [T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega);
  trafo('reset','trafo','affine2D');  % initialize transformation
  wStop = trafo('w0');
  wOpt = wStop;

  distance('reset','distance',DM{dm});
  distance('disp')
  
  if 1,  
    wSmooth =  MLPIR(MLdata,'minLevel',5,'plotIter',0,'plotMLiter',0);

    inter('reset','inter','splineInter2D','regularizer','moments','theta',1e-3);
    level = length(MLdata); omega = MLdata{level}.omega; m = MLdata{level}.m;
    [T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega);
    xc = getCenteredGrid(omega,m);
    Rc = inter(R,omega,xc);
    fctn = @(wc) PIRobjFctn(T,Rc,omega,m,0,[],[],xc,wc);
    wOpt = GaussNewtonArmijo(fctn,wSmooth,'yStop',wStop);
  end;

  omega = MLdata{end}.omega; m = MLdata{end}.m;
  xc = getCenteredGrid(omega,m);
  R0 = inter(R,omega,xc);
  T0 = inter(T,omega,xc);

  if dm == 1,
    FAIRfigure(10)
    str = 'R0'; var = R0;
    viewImage(var,omega,m,'axis','off','title',File(str));  Write(var,str);

    FAIRfigure(11)
    str = 'T0'; var = T0;
    viewImage(var,omega,m,'axis','off','title',File(str));  Write(var,str);

    FAIRfigure(12); clf;
    overlayImage2D(T0,R0,omega,m); axis off
    set(gca,'position',[0 0 1 1]);
    FAIRprint(File(['D0']));
  end;

  Yopt = trafo(wOpt,xc);
  Tc = inter(T,omega,Yopt);

  FAIRfigure(2); clf;
  str = ['G-',distance];  var = T0;
  viewImage(var,omega,m,'axis','off'); hold on;
  plotGrid(grid2grid(Yopt,m,'centered','nodal'),omega,m,...
    'spacing',ceil(m/32),'linewidth',2,'color','w');
  set(gca,'position',[0 0 1 1]);
  FAIRprint(File(['G-',distance]));

  FAIRfigure(3); clf;
  str = ['T-',distance], var = Tc;
  ViewImage(var,omega,m,'axis','off','title',File(str));  Write(var,str);

  FAIRfigure(4); clf;
  overlayImage2D(Tc,R0,omega,m); axis off
  set(gca,'position',[0 0 1 1]);
  FAIRprint(File(['D-',distance]));
end;

FAIRpause(5); close all
