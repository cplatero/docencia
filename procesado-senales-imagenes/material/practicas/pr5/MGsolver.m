% =======================================================================================
% function Y = MGsolver(rhs,H);
% (c) Jan Modersitzki 2008/07/29, see FAIR and FAIRcopyright.m.
%
% prepares for multigrid solver for H*Y=rhs by initializing smoothing operator and such
% =======================================================================================

function Y = MGsolver(rhs,H);

H.MGlevel      = log2(H.m(1))+1;
H.MGcycle      = 1;
H.MGomega      = 0.5;   
H.MGsmoother   = 'mfJacobi';
H.MGpresmooth  = 3;
H.MGpostsmooth = 1;

u0 = zeros(size(rhs));
Y  = mfvcycle(H,u0,rhs,1e-12,H.MGlevel,(max(H.m)>32));
