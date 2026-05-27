% =======================================================================================
% function X = getNodalGrid(omega,m);
% (c) Jan Modersitzki 2008/07/29, see FAIR and FAIRcopyright.m.
%
% creates a nodal discretization of [0,omega(1)] x ... x[0,omega(end)] of m points
%
%          X1                     X2
% x-----x-----x-----x    x-----x-----x-----x
% |     |     |     |    |     |     |     |
% |     |     |     |    |     |     |     |
% |     |     |     |    |     |     |     |
% x-----x-----x-----x    x-----x-----x-----x
% |     |     |     |    |     |     |     |
% |     |     |     |    |     |     |     |
% |     |     |     |    |     |     |     |
% x-----x-----x-----x    x-----x-----x-----x
%
% Input:
%   omega		describing the domain
%	m 			number of discretization points
%
% Output:
%  X			collection of grid points, X is length(omega)*prod(m+1)-by-1
% =======================================================================================

function X = getNodalGrid(omega,m);

X  = []; x1 = []; x2 = []; x3 = [];
h   = (omega(2:2:end)-omega(1:2:end))./m; % voxel size for integration
nu = @(i) (omega(2*i-1)       :h(i):omega(2*i)       )'; % nodal
switch length(omega)/2,
  case 1, x1 = nu(1);
  case 2, [x1,x2] = ndgrid(nu(1),nu(2));
  case 3, [x1,x2,x3] = ndgrid(nu(1),nu(2),nu(3));
end;
X = [x1(:);x2(:);x3(:)];

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
