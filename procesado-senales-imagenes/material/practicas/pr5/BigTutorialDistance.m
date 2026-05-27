% Tutorial for FAIR: DISTANCES
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
%
% E7_Hands_SSDvsRotation:  SSD versus rotation (hands)
% E7_PETCT_SSDvsRotation:  SSD versus rotation (PET/CT)
% E7_PETCT_MIvsRotation:   MI versus rotation  (PET/CT)
% E7_US_MIvsRotation:      MI versus rotation  (US/-US) 
%
% E7_basic:                distances versus rotation 
% E7_extended:             distances vs rotation (ext)
% E7_SSDforces:            show SSD forces
%
% E6_PETCT_MLPIR:           MLPIR, PETCT, affine, SSD
%
% E9_PETCT_MLIR_NGF_mbElas: MLIR, PETCT, NGF, elastic, matrix based
% E9_HNSP_MLIR_TR:          MLIR, HNSP, elastic, matrix free, TrustRegion

clc, clear, close all, help(mfilename);

runThis('E7_Hands_SSDvsRotation', 'SSD versus rotation (hands)');
runThis('E7_PETCT_SSDvsRotation', 'SSD versus rotation (PET/CT)');  
runThis('E7_PETCT_MIvsRotation',  'MI versus rotation  (PET/CT)');   
runThis('E7_US_MIvsRotation',     'MI versus rotation  (US/-US) ');  
runThis('E7_basic',    'distances versus rotation ');    
runThis('E7_extended', 'distances vs rotation (ext)'); 
runThis('E7_SSDforces','show SSD forces'); 

% MultiLevel Parametric Image Registration
runThis('E6_PETCT_MLPIR','MLPIR, PETCT, affine, SSD');

% MultiLevel Non-Parametric Image Registration
runThis('E9_PETCT_MLIR_NGF_mbElas','MLIR, PETCT, NGF, elastic, matrix based');
runThis('E9_HNSP_MLIR_TR','MLIR, HNSP, elastic, matrix free, TrustRegion');

fprintf('\n<%s> done!\n',mfilename); 
