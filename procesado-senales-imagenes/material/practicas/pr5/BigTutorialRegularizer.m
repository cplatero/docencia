% Tutorial for FAIR: REGULARIZER
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
%
% E8_forces:           elastic responce to a force field
% E8_matrices:         creating B, matrix based an matrix free version
% E8_setup:            regularizarion setup
% E8_checkOperations:  regularizer: multigrid example

clc, clear, close all, help(mfilename);

runThis('E8_forces',   'elastic response to a force field');
runThis('E8_matrices', 'creating B, matrix based an matrix free version');
runThis('E8_setup',    'regularizer setup');
runThis('E8_checkOperations',    'regularizer: multigrid example');

fprintf('\n<%s> done!\n',mfilename); 