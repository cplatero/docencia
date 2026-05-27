% Tutorial for FAIR: INTERPOLATION
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
%
% E3_1D_basics:            1D basic interpolation example
% E3_1D_scale:             1D multi-scale example
% E3_1D_derivatives:       1D check the derivative example
%
% E3_2D_basics:            2D basic interpolation example
% E3_Hands_ij2xy:          2D data example, ij <-> xy, multi-level
% E3_viewImage:            2D visualize data
% E3_setupHandData:        load data (with landmarks) and visualize
% E3_2D_scale:             2D multi-scale example
% E3_2D_generic:           2D high-res and low-res representation
% E3_2D_US_trafo:          2D US, rotate image
% E3_2D_derivative:        2D check the derivative example

clc, clear, close all, help(mfilename);

runThis('E3_1D_basics','1D basic interpolation example');
runThis('E3_1D_scale','1D multi-scale example');
runThis('E3_1D_derivatives','1D check the derivative example');

runThis('E3_2D_basics','2D basic interpolation example');
runThis('E3_Hands_ij2xy','2D data example, ij <-> xy, multi-level');
runThis('E2_viewImage','2D visualize data');
runThis('E2_setupHandData','load data (with landmarks) and visualize');

runThis('E3_2D_scale','2D multi-scale example');
runThis('E3_2D_generic','2D high-res and low-res representation');
runThis('E4_US_trafo','2D US, rotate image');
runThis('E3_2D_derivative','2D check the derivative example');

fprintf('\n<%s> done!\n',mfilename); 
