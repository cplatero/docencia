% Tutorial for FAIR: MultiLevel Image Registration
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% - load data (see setupHandData)
% - set-up  viewer          ('USfair.jpg'), 
%           interpolator    (splineInter2D), 
%           transformation  (various)
clear, close all, help(mfilename)


% load some data
Tdata = double(imread('USfair.jpg'));
omega  = [0,size(Tdata,1),0,size(Tdata,2)];
m     = [192,128] ;
xc    = getCenteredGrid(omega,m);
T     = Tdata; % linear interpolation

% set-up interpolation scheme and image viewer
inter('reset','inter','linearInter2D');
viewImage('reset','viewImage','viewImage2D','colormap',gray(256),'axis','off');
fprintf('%20s : %s\n','viewImage',viewImage);
fprintf('%20s : %s\n','inter',inter);

% shortcuts for plotting stuff
Grid   = @(xc)  plotGrid(xc,omega,m,'spacing',8,'color','w');
dimstr = @(m)   sprintf('%s=[%s]',inputname(1),sprintf(' %d',m));
Title  = @(s,t) title([s,sprintf(', t=%s',num2str(t))],'fontsize',fontsize);

% display initial image
figure(1); clf; subplot(1,2,1); %colordef(gcf,'black'); 
viewImage(inter(T,omega,xc),omega,m); hold on; gh = Grid(xc);
title(sprintf('%s, %s','interpolated data',dimstr(m)),'fontsize',20);

trafos = {
  'translation-x1',...
  'translation-x2',...
  'translation',...
  'rotation',...
  'scale',...
  'non-linear',...
  'spline'};

% pick a particular transformation, 
theTrafo = trafos{7};
fprintf(' --- transformation model = %s -----\n',theTrafo);

domega = (omega(2:2:end)-omega(1:2:end));
% set-up transformation model and parameter wc(t)
clear trafo; % just in case ...
switch theTrafo,
  case 'translation-x1',              % translation in x1 direction
    trafo('set','trafo','translation2D');
    wc = @(t) [t*domega(1)/4;0];
  case 'translation-x2',              % translation in x2 direction
    trafo('set','trafo','translation2D');
    wc = @(t) [0;t*domega(2)/4];
  case 'translation',                 % translation in both directions
    trafo('set','trafo','translation2D');
    wc = @(t) [-t*domega(1)/4;t*domega(2)/6];
  case 'rotation',                    % rotation about the domain center
    trafo('set','trafo','rigid2D');
    S = @(t) t/6;
    wc = @(t) [S(t);(eye(2)-[ cos(S(t)),-sin(S(t));sin(S(t)),cos(S(t))])*domega'/2];
  case 'scale',                        % scale about the domain center
    trafo('set','trafo','affine2D');
    S = @(t) diag([1-t/4,1-t/6]);
    wc = @(t) reshape([S(t),(eye(2)-S(t))*domega'/2]',[],1);
  case 'non-linear',                   % a non-linear transformation
    % map omega to (-1,1) x (-1,1) and use a conformal map
    z  = (reshape(xc,[],2) - ones(prod(m),1)*domega/2)*diag(1./domega);
    z2 = [z.^2*[1;-1],2*z(:,1).*z(:,2)];
    trafo = @(t,xc) xc - 0.5*t*reshape(z2*diag(domega),[],1);
    wc  = @(t) t;
  case 'spline',                   % a non-linear transformation
    p = [5,4];
    trafo('set','trafo','splineTransformation2D','p',p,'omega',omega','m',m);
    w1 = zeros(p); w2 = zeros(p);  w2(3,2) = 10;
    wc  = @(t) [w1(:);t*w2(:)];
  otherwise, error('nyi')
end;

  
%=======================================================================================
% the loop over time
%=======================================================================================
% discretize time t, to be used in the later for loop
t = sin(linspace(0,2.5*pi,201));

for j=1:length(t),
  yc = trafo(wc(t(j)),xc);   % compute the transformed points
  Tc = inter(T,omega,yc);  % compute the transformed image

  if j == 1,              % initialize visualization
    figure(1); subplot(1,2,1); %colordef(gcf,'black');
    set(gh,'visible','off'); gh = Grid(yc);
    title(sprintf('%s, %s','interpolated data',dimstr(m)),'fontsize',fontsize);
    subplot(1,2,2); vh = viewImage(Tc,omega,m); Title(theTrafo,t(j));
    FAIRpause;
  else,                   % continue plots
    subplot(1,2,1); set(gh,'visible','off');        gh = Grid(yc);
    subplot(1,2,2); set(vh,'cdata',reshape(Tc,m)'); Title(theTrafo,t(j));
    FAIRpause(1/2000)
  end;
  drawnow; fprintf('.'); if rem(j,50) == 0, fprintf('\n'); end;
end;
fprintf('\n')
%=======================================================================================
