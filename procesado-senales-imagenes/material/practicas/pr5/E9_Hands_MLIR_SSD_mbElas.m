% ===============================================================================
% Example for Non-Parametric Image Registration with lBFGS scheme
% (c) Jan Modersitzki 2009/04/06, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
% 
%   - data                 Hand, Omega=(0,20)x(0,25), 
%   - viewer               viewImage2D
%   - interpolation        splineInter2D
%   - distance             SSD
%   - regularizer          mbElastic
%   - optimizer            Gauss-Newton
% ===============================================================================

close all, help(mfilename)

% load data, initialize image viewer, interpolator, transformation, distance
setupHandData
viewImage('reset','viewImage','viewImage2D','colormap',bone(256),'axis','off');
inter('reset','inter','splineInter2D','regularizer','moments','theta',1e-2);
trafo('reset','trafo','affine2D');
distance('reset','distance','SSD');
regularizer('reset','regularizer','mbElastic','alpha',1e3,'mu',1,'lambda',0);

[yc,wc,his] = MLIR(MLdata);
