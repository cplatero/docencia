function contents
% (c) Jan Modersitzki 2009/04/06, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
%
% Various Examples (capital E?_*.m can also be found in the book, e?_*.m may not)
% FAIR kernel, contents.m: this file
%
% Armijo                  -> OPTIMIZATION    
% FAIRclear               -> ADMINISTRATIVE
% GaussNewtonArmijo       -> OPTIMIZATION
% LagPIRobjFctn           -> OPTIMIZATION
% MLIR                    -> MULTILEVEL
% MLPIR                   -> MULTILEVEL
% NPIRBFGSobjFctn         -> OPTIMIZATION
% NPIRobjFctn             -> OPTIMIZATION
% PIRBFGSobjFctn          -> OPTIMIZATION
% PIRobjFctn              -> OPTIMIZATION
% SteepestDescent         -> OPTIMIZATION
% TrustRegion             -> OPTIMIZATION
% center                  -> GRIDS
% checkDerivative         -> OPTIMIZATION
% getCenteredGrid         -> GRIDS
% getMultilevel           -> MULTILEVEL
% getNodalGrid            -> GRIDS
% getStaggeredGrid        -> GRIDS
% grid2grid               -> GRIDS
% lBFGS                   -> OPTIMIZATION
% nodal2center            -> GRIDS
% options                 -> ADMINISTRATIVE
% plotIterationHistory   -> OPTIMIZATION
% plotMLIterationHistory -> OPTIMIZATION
% reportStatus            -> ADMINISTRATIVE
% stg2array               -> GRIDS
% stg2center              -> GRIDS
% 
% ADMINISTRATIVE
%   options            handles options as used e.g. in inter, distances, ...
%   reportStatus       display the current configuration
%   FAIRclear          closes figures, clears shell and modules
% GRIDS (c=cell-centers, s=staggered, n=nodal)
%   center				transfers grids (c,s,n) to cell-centers (c)
%   getCenteredGrid		creates cell-centered grid
%   getNodalGrid        creates nodal grid
%   getStaggeredGrid    creates staggered grid
%   grid2grid           interpolates grid-in to grid-out 
%   nodal2center        transforms a nodal to cell-centered grid
%   stg2array           decomposed a staggered grid Y (n-by-1) into components
%   stg2center          supplies staggered to cell-centered grid operation
%
% MULTILEVEL:
%   MLIR				the MultiLevel Image Registration
%   MLPIR				the MultiLevel Parametric Image Registration
%   getMultilevel   	generates multilevel data struct for given data
%
% OPTIMIZATION
%   NPIRobjFctn         objective function for non-parametric image registration (Gauss-Newton style)
%   NPIRBFGSobjFctn     objective function for non-parametric image registration (BFGS style)
%   PIRobjFctn          objective function for     parametric image registration (Gauss-Newton style)
%   PIRBFGSobjFctn      objective function for     parametric image registration (BFGS style)
%   LagPIRobjFctn       objective function for     parametric image registration (Lagrangian style)
%   Armijo				Armijo Line Search
%   GaussNewtonArmijo   Gauss Newton Method with Armijo Line Search
%   lBFGS               limited memory BFGS with Armijo Line Search
%   SteepestDescent     Steepest Descent    with Armijo Line Search
%   TrustRegion         Trust Region methos
%   checkDerivative     checks the implementation of a derivative
%
% PLOTS:
% 	plotIterationHistory   plots iteration history (one level)
% 	plotMLIterationHistory plots iteration history (multi-level)
%
% see also BigTutorial2D and BigTutorial3D.





E3_MS_splineInterpolation1D.m
E3_MS_splineInterpolation2D.m
E3_bsplines.m
E3_checkDerivative.m
E3_getCenteredGrid.m
E3_ij2xy3d.m
E3_interpolation2D.m
E3_linearInterpolation1D.m
E3_linearInterpolation2D.m
E3_matlabInterpolation1D.m
E3_multilevel.m
E3_splineInterpolation1D.m
E3_splineInterpolation2D.m
E3_truncatedSplineInterpolation1D.m
E4_Affine2D.m
E4_Affine2Dplain.m
E4_Bizarr.m
E4_Rigid2D.m
E4_Rigid2Dplain.m
E4_SplineTransformation2D.m
E4_Translation2D.m
E4_Translation2Dplain.m
E5_TPS.m
E5_linear.m
E5_quadratic.m
E6_HNSP_MLPIR_SSD_affine2D.m
E6_HNSP_MLPIR_SSD_rigid2D.m
E6_HNSP_MLPIR_SSD_rotation2D.m
E6_HNSP_PIR.m
E6_HNSP_PIR_GN.m
E6_HNSP_PIR_NelderMead.m
E6_HNSP_PIR_SSD_affine2D_level5.m
E6_HNSP_PIR_SSD_rigid2D_level4.m
E6_HNSP_PIR_SSD_rigid2D_level7.m
E6_HNSP_PIR_SSD_rotation2D_level4.m
E6_HNSP_PIR_SSD_rotation2D_level7.m
E6_HNSP_PIR_scale.m
E6_HNSP_PIR_spline2D_level5.m
E6_HNSP_RPIR.m
E6_HNSP_SSD_rotation2D_level4.m
E6_HNSP_SSD_rotation2D_level8.m
E6_HNSP_SSD_translation2D_level4.m
E6_HNSP_SSD_translation2D_level4_spline.m
E6_HNSP_SSD_translation2D_level8.m
E6_HNSP_SSD_translation2D_level8_spline.m
E6_quadrature_Gaussian2D.m
E6_quadrature_SSD2D.m
E6_quadrature_Spline1D.m
E6_quadrature_Spline2D.m
E7.m
E7_HNSP_SSD_forces.m
E7_Hands_distance_rotation.m
E7_Hands_distance_rotation_ext.m
E7_PETCT_MLPIR.m
E7_PETCT_MLPIR_ext.m
E7_histogram1D.m
E7_histogram1D_ext.m
E8_regularizationMB.m
E8_regularizationMF.m
E9_3Dbrain_GN.m
E9_3Dbrain_TR.m
E9_3Dbrain_lBFGS.m
E9_HNSP_MLIR_SSD_elas.m
E9_HNSP_MLIR_SSD_elas_MF.m
E9_HNSP_NPIR.m
E9_HNSP_NPIR_pre.m
E9_Hands_BFGS.m
E9_Hands_MLIR.m
E9_Hands_MLIR_SSD_curv.m
E9_Hands_MLIR_SSD_elas.m
E9_Hands_MLIR_SSD_mfElas.m
E9_Hands_MSIR.m
E9_Hands_NPIR.m
E9_Hands_NPIR_pre.m
E9_Hands_affine.m
E9_MRIhead_MLIR_MI_elas.m
E9_MRIhead_MLIR_NGF_elas.m
E9_MRIhead_MLIR_SSD_elas.m
E9_MRIhead_MLIRlBFGS_MI_elas.m
E9_MRIhead_MLIRlBFGS_NGF_elas.m
E9_PETCT_MLIR_NGF_curv.m
E9_PETCT_MLIR_NGF_elas.m
E9_PETCT_MLIRlBFGS_MI_curv.m
E9_PETCT_MLIRlBFGS_MI_elas.m
E9_PETCT_MLIRlBFGS_NGF_curv.m
E9_PETCT_MLIRlBFGS_NGF_elas.m
FAIRdiary.m
P5_LM.m
book_affine2D.m
book_kron3D.m
book_linearInter1D.m
book_rigid2D.m
book_splineInter1D.m
book_splineInter2D.m
contents.m
get2Ddata.m
setup3DboxData.m
setup3DbrainData.m
setup3DkneeData.m
setupHandData.m
setupMRIData.m
setupMyData.m
setupPETCTdata.m
setupUSData.m
spline1D.m
splineInterpolation2D.m
