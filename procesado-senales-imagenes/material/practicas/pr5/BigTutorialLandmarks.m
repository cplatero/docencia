% Tutorial for FAIR: LANDMARKS
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
%
% E5_2D_affine:            use affine     transformation
% E5_2D_quadratic:         use quadratic  transformation
% E5_2D_TPS:               use TPS  transformation
% E5_Hands_TPS:            TPS in short

clc, clear, close all, help(mfilename);

runThis('E5_2D_affine',    'use affine     transformation');
runThis('E5_2D_quadratic', 'use quadratic  transformation');
runThis('E5_2D_TPS',       'use TPS  transformation');
runThis('E5_Hands_TPS',   'TPS in short');

fprintf('\n<%s> done!\n',mfilename); 
