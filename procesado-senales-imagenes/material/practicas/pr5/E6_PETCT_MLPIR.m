% ===============================================================================
% Example for MLPIR, MultiLevel Parametric Image Registration
% (c) Jan Modersitzki 2009/04/06, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
% 
%   - data                 PETCT, Omega=(0,140)x(0,151), level=4:7, m=[128,128]
%   - viewer               viewImage2D
%   - interpolation        splineInter2D
%   - distance             MI
%   - pre-registration     affine2D
%   - optimization         Gauss-Newton
% ===============================================================================

clear, close all, help(mfilename);

% load data, set viewer
setupPETCTdata;

% set-up interpolator, distance
theta = 0; % something to play with
inter('reset','inter','splineInter2D','regularizer','moments','theta',theta);
distance('reset','distance','MI'); 

% set-up transformation, regularization 
trafo('reset','trafo','affine2D'); 
wc =  MLPIR(MLdata,'plotIter',0,'plotMLiter',0);
