% ===============================================================================
% Example for MLIR, MultiLevel Image Registration
% (c) Jan Modersitzki 2009/04/06, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
% 
%   - data                 Hands, Omega=(0,20)x(0,25), level=3:7, m=[128,128]
%   - viewer               viewImage2D
%   - interpolation        splineInter2D
%   - distance             SSD
%   - pre-registration     affine2D
%   - regularizer          mbElastic
%   - optimization         Gauss-Newton
% ===============================================================================

close all, help(mfilename)

setupHandData
viewImage('reset','viewImage','viewImage2D','colormap',bone(256),'axis','off');
inter('reset','inter','splineInter2D','regularizer','moments','theta',1e-2);
trafo('reset','trafo','affine2D');
distance('reset','distance','SSD');
regularizer('reset','regularizer','mfElastic','alpha',1e3,'mu',1,'lambda',0);

[yc,wc,his] = MLIR(MLdata);
