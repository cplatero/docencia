function E4_US_rotationCPD(fichImg,m)
% Tutorial for FAIR: rotating an image
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% rotate image around domain center
% fichImg = name of image file
% m     = [192,128] ;

% load some data
Tdata = im2double(imread(fichImg));
omega = [0,size(Tdata,1),0,size(Tdata,2)];
xc    = getCenteredGrid(omega,m);

% set-up interpolation scheme and image viewer
inter('reset','inter','linearInter2D');
viewImage('reset','viewImage','viewImage2D','axis','off');
fprintf('%20s : %s\n','viewImage',viewImage);
fprintf('%20s : %s\n','inter',inter);

% shortcuts for plotting stuff
Grid   = @(X)   plotGrid(X,omega,m,'spacing',8,'color','w');
dimstr = @(m)   sprintf('%s=[%s]',inputname(1),sprintf(' %d',m));
Title  = @(s,t) title([s,sprintf(', t=%s',num2str(t))],'fontsize',fontsize);


% display initial image
% FAIRfigure(1,'figname',mfilename); clf; subplot(1,2,1); 
% viewImage(inter(Tdata,omega,xc),omega,m); hold on; gh = Grid(xc);
% title(sprintf('%s, %s','data',dimstr(m)),'fontsize',20);

% % display initial image
% figure(2);
% Tnew = inter(Tdata,omega,xc);
% imshow(reshape(Tnew,m)); hold on; gh = Grid(xc); hold off;

% initialize transformation
trafo('set','trafo','rigid2D');
% S = @(t) t/6;

% y(t) = R(t)*x+(I-R(t))*c, 
%
% R(t) = [cos(t) -sin(t) ], c = [omega(1)]/2
%        [sin(w)  cos(t) ]      [omega(2)]
%
% or y(t) = rigid2D(w,x), where w = [t;(I-R(t))omega'/2].
c  = (omega(2:2:end)-omega(1:2:end))'/2;
wc = @(t) [t;(eye(2)-[ cos(t),-sin(t);sin(t),cos(t)])*c];
  
%=======================================================================================
% the loop over time t
%=======================================================================================
t = 0.35*pi*sin(linspace(0,2.5*pi,101));

for j=1:length(t),
  yc = trafo(wc(t(j)),xc);      % compute the transformed points
  Tc = inter(Tdata,omega,yc);   % compute the transformed image

  if j == 1,              % initialize visualization
    figure(1); subplot(1,2,1); %colordef(gcf,'black');
    imshow(reshape(Tc,m));hold on; gh = Grid(yc); hold off;
%     set(gh,'visible','off'); gh = Grid(yc);
%     title(sprintf('%s, %s','data',dimstr(m)),'fontsize',fontsize);
%     subplot(1,2,2); %vh = viewImage(Tc,omega,m); Title(trafo,t(j));
    
%     FAIRpause;
  else,                   % continue plots
    %subplot(1,2,1); set(gh,'visible','off');        gh = Grid(yc);
    subplot(1,2,2); %set(vh,'cdata',reshape(Tc,m)'); Title(trafo,t(j));
    imshow(reshape(Tc,m));hold on; gh = Grid(yc); hold off;
    FAIRpause(1/2000)
  end;
  drawnow; fprintf('.'); if rem(j,50) == 0, fprintf('\n'); end;
end;
fprintf('\n')
%=======================================================================================
