% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
% demo for 2D data set-up and visualization
% load the data, convert ij->xy, uint8 -> double, rbg->gray
clear, close all, help(mfilename)

Tij = imread('hands-T.jpg'); Tdata = double(flipud(Tij))';
Rij = imread('hands-R.jpg'); Rdata = double(flipud(Rij))';

% specify domain Omega = [omega(1),omega(2)]x[omega(3),omega(3)];
omega = [0,20,0,25];
m     = size(Tdata);

% set-up image viewer
viewImage('reset','viewImage','viewImage2D','colormap','gray(256)');

% visualize
FAIRfigure(1); colormap(gray(256));
subplot(2,2,1); imagesc(Tij);              title('original T data, uint8, ij');
subplot(2,2,2); viewImage(Tdata,omega,m);  title('FAIR T data on \Omega, xy');
subplot(2,2,3); imagesc(Rij);              title('original R data, uint8, ij');
subplot(2,2,4); viewImage(Rdata,omega,m);  title('FAIR R data on \Omega, xy');

% create multi-level representaion
MLdata = getMultilevel({Tdata,Rdata},omega,m,'fig',2);
