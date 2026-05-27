% Tutorial for FAIR: Initializing  data to be used in FAIR.
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
%
% This file creates an the following data (which can then be saved): 
% Tdata     data for template  image, a d-array of size m, 
% Rdata     data for reference image, a d-array of size m, 
% Tomega    domain description 
% Romega    domain description 
% m         initial discretization 
% ML        multi-level representation of the data
% LM        landmarks
%
% viewOptn  options for image viewer
% interOptn options for image interpolation
clear, close all, help(mfilename)

% do whatever needed to be done to get your data here
% note: imread gets the data
%       flipud()' converts ij to xy coordinates
%       double    converts from uint to double
%       rgb2gray  converts from rgb to gray scale

Tdata = double(flipud(imread('hands-T.jpg'))'); 
Rdata = double(flipud(imread('hands-R.jpg'))'); 
omega = [0,20,0,25];
m     =  128*[1,1];

% for this data landmarks (LM) have been identified
% note: LM are physical in the Omega domain
LM = [
  5.5841   17.2664    2.6807   12.7797
  10.7243   21.6121    7.2028   19.6795
  13.2477   21.6121   10.1865   20.8916
  15.2570   19.2290   12.5175   20.0991
  15.8645   15.1636   14.3357   16.7424
  5.3972    8.1075    7.9953    6.3462
  7.5000    5.9579   11.8648    5.6469
  ];

% set view options and interpolation options
viewOptn = {'viewImage','viewImage2D','colormap','gray(256)'};
viewImage('reset',viewOptn{:});

interOptn = {'inter','linearInter2D'};
inter('reset',interOptn{:});

% create multilevel representation of the data
MLdata = getMultilevel({Tdata,Rdata},omega,m);

% visualize
xc = getCenteredGrid(omega,m);
viewData = @(I) viewImage(inter(I,omega,xc),omega,m);

FAIRfigure(1,'figname',mfilename); clf;
subplot(1,2,1); viewData(Tdata); hold on;
ph = plotLM(LM(:,1:2),'numbering','on','color','r');
set(ph,'linewidth',2,'markersize',20);
title(sprintf('%s','template&LM'),'fontsize',20);
subplot(1,2,2); viewData(Rdata); hold on;
ph = plotLM(LM(:,3:4),'numbering','on','color','g','marker','+');
set(ph,'linewidth',2,'markersize',20);
title(sprintf('%s','reference&LM'),'fontsize',20);

