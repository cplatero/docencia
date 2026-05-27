% Tutorial for FAIR:  2D visualization
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
% - load data ('USfair.jpg')
% - setup  viewer          (viewImage2D)
% - view image
clear, close all, help(mfilename);

% load data
dataT = double(imread('USfair.jpg'));
m     = size(dataT);
omega = [0,m(1),0,m(2)];

% set-up image viewer
viewImage('reset','viewImage','viewImage2D','colormap','gray(256)','axis','off');

% view data
viewImage(dataT,omega,m,'title','my first image');
