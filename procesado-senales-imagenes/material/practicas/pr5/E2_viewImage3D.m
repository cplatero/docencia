% Tutorial for FAIR: visualize 3D data
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
clc, clear, close all

fprintf('=============================================================================\n');
fprintf('FAIR: (JM: 2008/04/16) Tutorial on 2D interpolation: BASICS\n')
fprintf('FAIR: <%s>\n',mfilename('fullpath'))
fprintf('%s\n','load and visualize 3D MRI data')
fprintf('=============================================================================\n');

% basic example for 3D visualization

% set-up data -----------------------------------------------------------------
fprintf('%s\n','generate some data (MRI)');
load mri;
omega = [0,20,0,20,0,10];
T     = double(squeeze(D));
m     = size(T);

fprintf('%s\n','use image montage')
FAIRfigure(1); clf; %colordef(gcf,'black');
imgmontage(T,omega,m,'colormap',gray(100));
title('visualization of 3D data - imgmontage','fontsize',30)
Pause;

fprintf('%s\n','use a volumetric view')
FAIRfigure(2); clf; %colordef(gcf,'black');
volView(T,omega,m,'facecolor',[240,140,100]/256,'facealpha',0.75); hold on;
colormap(gray(100))
X = reshape(getCenteredGrid(omega,m),[m,3]);
Pause;

fprintf('%s\n','use a volumetric view + slices')
vh = viewSlides(T,omega,m);
Pause;

figure(3); clf; colordef(gcf,'black');
volView(T,omega,m,'facecolor',[240,140,100]/256,'facealpha',0.75); hold on;
colormap(gray(100))
vh = viewSlides(T,omega,m);
ah = viewSlides(T,omega,m,'s1',64,'s2',64,'s3',[]);
Pause; 


for j=1:m(3);
  set(vh,'visible','off');
  vh = viewSlides(T,omega,m,'s1',[],'s2',[],'s3',[j]);
  Pause(1/10)
end;

fprintf('<%s> done!\n',mfilename); Pause;
