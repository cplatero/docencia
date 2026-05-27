% enables a generic derivative test of the distance functions which
% return a Gauss Newton type output

function [m,dm] = parseDistance(type,TD,Rc,omega,m,X)
[Tc,dT] = inter(TD,omega,X);
[Dc,rc,dD,dr,d2psi] = distance(Tc,Rc,omega,m);
dr = dr*dT;
dD = dD*dT;

switch type,
  case 1, m = rc(:); dm = dr;
  case 2, m = Dc;    dm = dD;
  case 3, m = dD';   dm = dr'*(d2psi*dr);
end;
