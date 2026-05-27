% Initializing data to be used in FAIR.
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
%
% This file creates an the following data (which can then be saved): 
% dataT     template  image, a d-array of size m, 
% dataR     reference image, a d-array of size m, 
% omega     domain description 
% m         initial discretization 
% ML        multi-level representation of the data
%
% viewOptn  options for image viewer
% interOptn options for image interpolation

% do whatever needed to be done to get your data here
% note: imread gets the data
%       flipud()' converts ij to xy coordinates
%       double    converts from uint to double
%       rgb2gray  converts from rgb to gray scale
image = @(str) double(flipud(imread(str))'); 

% (c) Jan Modersitzki 2008/05/02, see FAIR and FAIRcopyright.m.
% Template for FAIR registration

% load 3D data
load brain3D

viewOptn  = {'viewImage','imgmontage'};  viewImage('reset',viewOptn{:});
interOptn = {'inter','linearInter3D'};   inter('reset',interOptn{:});
MLdata    = getMultilevel({dataT,dataR},omega,m);
save brain3DML.mat dataT dataR omega m MLdata viewOptn interOptn

