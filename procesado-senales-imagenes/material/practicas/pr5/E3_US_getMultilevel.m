% Tutorial for FAIR: creating a multilevel representation
% (C) 2008/05/01, Jan Modersitzki, see FAIR and FAIRcopyright.m.
% load USfair.jpg
% creating a multilevel representation using getMultilevel.m
clear, close all, help(mfilename)

% load some data, define a doman and an initial discretization
dataT  = double(imread('USfair.jpg'));
omega  = [0,size(dataT,1),0,size(dataT,2)];
m      = [128,128];

% set-up image viewer
viewImage('reset','viewImage','viewImage2D','colormap','gray(256)');

MLdata = getMultilevel(dataT,omega,m);
disp('MLdata{3}=')
disp(MLdata{3})
