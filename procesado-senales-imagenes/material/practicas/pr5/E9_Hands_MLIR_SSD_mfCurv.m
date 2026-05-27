% ===============================================================================
% Example for MultiLevel Image Registration
% (c) Jan Modersitzki 2009/04/06, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
% 
%   - data                 Hand, Omega=(0,20)x(0,25), 
%   - viewer               viewImage2D
%   - interpolation        splineInter2D
%   - distance             SSD
%   - regularizer          mfCurvature
%   - optimizer            Gauss-Newton
% ===============================================================================

clear; close all; help(mfilename)

setupHandData
inter('reset','inter','splineInter2D','regularizer','moments','theta',0.01);
distance('reset','distance','SSD');
trafo('reset','trafo','affine2D');
regularizer('reset','regularizer','mfCurvature','alpha',1000);

yc = MLIR(MLdata);
showResults(MLdata,yc);
