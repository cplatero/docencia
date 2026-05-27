% ===============================================================================
% Example for MLIR, MultiLevel Image Registration
% (c) Jan Modersitzki 2009/04/06, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
% 
%   - data                 HNSP, Omega=(0,2)x(0,1), level=3:6, m=[512,256]
%   - viewer               viewImage2D
%   - interpolation        splineInter2D
%   - distance             SSD
%   - pre-registration     affine2D
%   - regularizer          mbElastic
%   - optimization         TrustRegion
% ===============================================================================


clear; close all; help(mfilename)

setupHNSPData
inter('reset','inter','splineInter2D','regularizer','moments','theta',0.01);
distance('reset','distance','SSD');
trafo('reset','trafo','affine2D');
regularizer('reset','regularizer','mfElastic','alpha',1000,'mu',1,'lambda',0);

yc = MLIR(MLdata,'maxLevel',6,'NPIR',@TrustRegion,'pfun',@MGsolver);