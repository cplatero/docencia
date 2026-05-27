% ===============================================================================
% Example for MLIR, MultiLevel Image Registration
% (c) Jan Modersitzki 2009/04/04, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
% 
%   - data                 HNSP, Omega=(0,2)x(0,1), m=[ 512 256]
%   - viewer               viewImage2D
%   - interpolation        splineInter2D
%   - distance             SSD
%   - pre-registration     affine2D
%   - regularizer          mbElastic
% ===============================================================================

close all, help(mfilename);

setupHNSPData
inter('reset','inter','splineInter2D','regularizer','moments','theta',1e-2);
distance('reset','distance','SSD');
trafo('reset','trafo','affine2D');
regularizer('reset','regularizer','mbElastic','alpha',5e2,'mu',1,'lambda',0);

[yc,wc,his] = MLIR(MLdata,'maxLevel',8);
