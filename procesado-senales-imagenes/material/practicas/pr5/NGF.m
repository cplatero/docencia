function [Dc,rho,dD,drho,d2psi] = NGF(Tc,Rc,omega,m,varargin);
% This is a link to NGFdot, THE implementation of Normalized Gradient Fields
[Dc,rho,dD,drho,d2psi] = NGFdot(Tc,Rc,omega,m,varargin{:});
