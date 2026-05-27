% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
% Initializing data to be used in FAIR.
% Original data from 
%@article{ShekharEtAl2005,
% author = {Raj Shekhar and Vivek Walimbe and Shanker Raja and Vladimir Zagrodsky
%           and Mangesh Kanvinde and Guiyun Wu and Bohdan Bybel},
% title = {Automated 3-Dimensional Elastic Registration of Whole-Body {PET}
%          and {CT} from Separate or Combined Scanners},
% journal = {J. of Nuclear Medicine},
% volume = {46},
% number = {9},
% year = {2005},
% pages = {1488--1496},
%}
%(c) Jan Modersitzki 2007/07/03, see FAIR.
%
% This file creates outfile.mat where the following data is to be stored: 
% dataT      interpolation data for template
% dataR      interpolation data for reference
% omegaT     = [left,right,bottom,top] template domain
% omegaR     = [left,right,bottom,top] reference domain
% m          size for finest representation, 
% MLdata     multilevel representation of data, see getMultilevel for details
% viewOptn   options for image viewer
% interOptn  options for image interpolation

txt = {
  'creates '
  ' - dataT:    data for templateimage, d-array of size p'
  ' - dataR:    data for reference image, d-array of size q'
  ' - omegaT:   coding domain = [omega(1),omega(2)]x...x[omega(2*d-1),omega(2*d)]'
  ' - omegaR:   coding domain = [omega(1),omega(2)]x...x[omega(2*d-1),omega(2*d)]'
  ' - m:        size of the finest interpolation grid'
  ' - MLdata:   MLdata representation of the data'
  };
fprintf('%s\n',txt{:});

outfile = [mfilename('fullpath'),'.mat'];
example = 'PET-CT';


% do whatever needed to be done to get your data here
image = @(str) double(flipud(imread(str))'); % reads and converts

% load the original data, set domain, initial discretization, and grid
dataT = image('PET-CT-PET.jpg');
dataR = image('PET-CT-CT.jpg');
omega = [0,50,0,50]; % [left,right,bottom,top]
m     = [128,128];

% set view options and interpolation options
viewOptn = {'viewImage','viewImage2D','colormap','bone(256)'};
viewImage('reset',viewOptn{:});

interOptn = {'inter','linearInter2D'};
inter('reset',interOptn{:});

% some plot
xc = getCenteredGrid(omega,m);
viewData  = @(I,omega) viewImage(inter(I,omega,xc),omega,m);

FAIRfigure(1,'figname',mfilename); clf;
subplot(1,2,1); viewData(dataT,omega); title('template');
subplot(1,2,2); viewData(dataR,omega); title('reference');


% create multilevel representation of the data
MLdata = getMultilevel({dataT,dataR},omega,m,'fig',2);

% save to outfile
save(outfile,'dataT','dataR','omega','m','MLdata','viewOptn','interOptn');