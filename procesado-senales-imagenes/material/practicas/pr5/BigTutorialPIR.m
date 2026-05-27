% Tutorial for FAIR: PARAMETRIC IMAGE REGISTRATION
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
%
% E7_Hands_SSDvsRotation:  SSD versus rotation (hands)
%
% E6_Hands_PIR_SD:         PIR, hands, rotations, SSD, Steepest Descent
% E6_Hands_PIR_GN:         PIR, hands, rotations, SSD, Gauss-Newton
%
% E6_Hands_MLPIR_pause:    MLPIR, hands, affine, SSD, including pauses
% E6_Hands_MLPIR:          MLPIR, hands, affine, SSD
% E6_HNSP_MLPIR_reg:       MLPIR, HNSP, splines, regularizes
% E6_PETCT_MLPIR:          MLPIR, PETCT, affine, SSD

clc, clear, close all, help(mfilename);

runThis('E7_Hands_SSDvsRotation', 'SSD versus rotation (hands)');

runThis('E6_Hands_PIR_SD','PIR, hands, rotations, SSD, Steepest Descent');
runThis('E6_Hands_PIR_GN','PIR, hands, rotations, SSD, Gauss-Newton');

runThis('E6_Hands_MLPIR_pause','MLPIR, hands, affine, SSD, including pauses');
runThis('E6_Hands_MLPIR','MLPIR, hands, affine, SSD');
runThis('E6_HNSP_MLPIR_reg','MLPIR, HNSP, splines, regularizes');
runThis('E6_PETCT_MLPIR','MLPIR, PETCT, affine, SSD');

fprintf('\n<%s> done!\n',mfilename);
