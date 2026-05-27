% ===============================================================================
% Tutorial for FAIR: MLPIR, MultiLevel Parametric Image Registration
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
% 
%   - data                 Hand, Omega=(0,20)x(0,25), level=3:7, m=[128,128]
%   - viewer               viewImage2D
%   - interpolation        splineInter2D
%   - distance             SSD
%   - pre-registration     affine2D, not regularized
%   - optimization         Gauss-Newton
% ===============================================================================

clear, close all, help(mfilename);

% load data, initialize image viewer, interpolator, transformation, distance
setupHandData
inter('reset','inter','splineInter2D','regularizer','moments','theta',1e-1);
distance('reset','distance','SSD');
trafo('reset','trafo','affine2D');

% run Multilevel Parametric Image Registration 
wc = MLPIR(MLdata,'plotIter',0,'plotMLiter',1);
