% Initializing data to be used in FAIR.
% Original data: http://www.mothercareultrasound.com/2d_ultrasound.jpg
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%
% This file creates outfile.mat where the following data is to be stored: 
% dataT      interpolation data for template
% omegaT     = [left,right,bottom,top] template domain
% m          size for finest representation, 
% MLdata     multilevel representation of data, see getMultilevel for details
% viewOptn   options for image viewer
% interOptn  options for image interpolation
% -----------------------------------------------------------------------------

outfile = [mfilename('fullpath'),'.mat'];
example = 'US';

if exist(outfile,'file'),
  fprintf('load(%s)\n  initialize inter and viewImage\n',outfile);
  load(outfile);
  viewImage('reset',viewOptn{:});
  inter('reset',interOptn{:});
  return
end;

txt = {
  'creates '
  ' - dataT:    data for templateimage, d-array of size p'
  ' - omega:    coding domain = [omega(1),omega(2)]x...x[omega(2*d-1),omega(2*d)]'
  ' - m:        size of the finest interpolation grid'
  ' - MLdata:   MLdata representation of the data'
  };
fprintf('%s\n',txt{:});

% do whatever needed to be done to get your data here
image = @(str) double(flipud(imread(str))'); % reads and converts

% load the original data, set domain, initial discretization, and grid
dataT = image('data/US.jpg');
omega = [0,size(dataT,1),0,size(dataT,2)];
m     = 128*[3,2];

% set view options and interpolation options
viewOptn = {'viewImage','viewImage2D','colormap','bone(256)'};
viewImage('reset',viewOptn{:});

interOptn = {'inter','linearInter2D'};
inter('reset',interOptn{:});

str = 'http://www.mothercareultrasound.com/2d_ultrasound.jpg';
viewData  = @(I) viewImage(inter(I,omega,getCenteredGrid(omega,m)),omega,m);

FAIRfigure(1,'figname',mfilename); clf;
viewData(dataT); title(str,'interpreter','none');

MLdata = getMultilevel({dataT},omega,m,'fig',2);

% save to outfile
save(outfile,'dataT','omega','m','MLdata','viewOptn','interOptn');
