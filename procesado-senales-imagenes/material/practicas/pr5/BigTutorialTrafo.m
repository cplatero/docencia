% Tutorial for FAIR: TRANSFORMATIONS
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
%
% E4_US_trafo:          plain rotation of 2D US image
% E4_US_trafos:         transformations of 2D US image
% E4_US_rotation:       rotate 2D US image, (+grid)
% E4_US:                various transformations for 2D US image

clc, clear, close all, help(mfilename);

runThis('E4_US_trafo','plain rotation of 2D US image');
runThis('E4_US_rotation','rotate 2D US image, (+grid)');
runThis('E4_US_trafos','various transformations for 2D US image');
runThis('E4_US','various transformations for 2D US image');

fprintf('\n<%s> done!\n',mfilename);
