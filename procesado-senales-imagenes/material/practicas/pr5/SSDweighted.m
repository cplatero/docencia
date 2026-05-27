% =======================================================================================
% function [Dc,rc,dD,dr,d2psi] = SSD(T,R,omega,m,varargin);
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
% Sum of Squared Differences based distance measure 
% using a general Gauss-Newton type framework
% computes D(T,R) = hd*psi(r(T)), r = T-R, psi = 0.5*r'*r 
% and derivatives, dr = dT, d2psi= hd*I, hd = prod(omega./m)
%
% Input: 
%  T, R			template and reference
%  omega, m 	represents domain and discretization
%  varargin		optional parameters, e.g. doDerivative=0
%
% Output:
%  Dc           SSD(T,R)
%  rc           T-R
%  dD           dpsi*dr
%  dr           dT
%  d2psi        hd = prod(omega./m)
% =======================================================================================

function [Dc,rc,dD,dr,d2psi] = SSDweighted(T,R,omega,m,varargin);

Dc  = []; dD = []; rc  = []; dr = []; d2psi = [];
W = speye(length(T),length(T));

doDerivative = (nargout > 3);

for k=1:2:length(varargin), % overwrite default parameter
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

hd = prod(omega./m);        	% voxel size for integration
rc = T-R;                  		% the residual
Dc = 0.5*hd * rc'*W*rc;       	% the SSD
if ~doDerivative, return; end;
dr = 1; 						% or speye(length(rc),length(rc)); 
dD = hd * rc'*W*dr; 
d2psi = hd*W;                 

%$=======================================================================================
%$  FAIR: Flexible Algorithms for Image Registration
%$  Copyright (c): Jan Modersitzki
%$  1280 Main Street West, Hamilton, ON, Canada, L8S 4K1
%$  Email: modersitzki@mcmaster.ca
%$  URL:   http://www.cas.mcmaster.ca/~modersit/index.shtml
%$=======================================================================================
%$  No part of this code may be reproduced, stored in a retrieval system,
%$  translated, transcribed, transmitted, or distributed in any form
%$  or by any means, means, manual, electric, electronic, electro-magnetic,
%$  mechanical, chemical, optical, photocopying, recording, or otherwise,
%$  without the prior explicit written permission of the authors or their 
%$  designated proxies. In no event shall the above copyright notice be 
%$  removed or altered in any way.
%$ 
%$  This code is provided "as is", without any warranty of any kind, either
%$  expressed or implied, including but not limited to, any implied warranty
%$  of merchantibility or fitness for any purpose. In no event will any party
%$  who distributed the code be liable for damages or for any claim(s) by 
%$  any other party, including but not limited to, any lost profits, lost
%$  monies, lost data or data rendered inaccurate, losses sustained by
%$  third parties, or any other special, incidental or consequential damages
%$  arrising out of the use or inability to use the program, even if the 
%$  possibility of such damages has been advised against. The entire risk
%$  as to the quality, the performace, and the fitness of the program for any 
%$  particular purpose lies with the party using the code.
%$=======================================================================================
%$  Any use of this code constitutes acceptance of the terms of the above
%$                              statements
%$=======================================================================================

