function B = getCurvatureMatrix(omega,m)
% (C) 2007/08/20, Jan Modersitzki, see FAIR.
% function B = getCurvatureMatrix(omega,m);
% Generates the curvature matrix B for the domain defined by omega
% and a cell centered grid discretization defined by m:
%     | \Delta 0 0 |
% B = | 0 \Delta 0 |.
%     | 0 0 \Delta |

dim = length(omega)/2;
Dxx = @(j) delta(omega,m,j);
switch dim,
  case 2,
    D = kron(Dxx(2),speye(m(1))) + kron(speye(m(2)),Dxx(1));
  case 3
    D = kron(Dxx(3),kron(speye(m(2)),speye(m(1)))) ...
      + kron(speye(m(3)),kron(Dxx(2),speye(m(1)))) ...
      + kron(speye(m(3)),kron(speye(m(2)),Dxx(1)));
  otherwise
    error('nyi');
end;

B = kron(speye(dim),D);

function D = delta(omega,m,j);
h = (omega(2:2:end)-omega(1:2:end))./m;
%     | -2  1       |
% D = |  1 -2  .    | / h^2
%     |     .  .  1 |
%     |        1 -2 |
D = spdiags(ones(m(j),1)*[1,-2,1],-1:1,m(j),m(j))/(h(j)*h(j));
% !! does not match descriptzion, but is OK, soso
%    D(1,1) = D(1,1)/2; D(end,end) = D(end,end)/2;
%    D([1,end]) = D([2,end-1]);

%with no BC
% D = spdiags(ones(m(j),1)*[1,-2,1],-1:1,m(j),m(j))/(h(j)*h(j));
% D([1,end],:) = 0;

%Neumann BC
D([1,end]) = -D([2,end-1]);


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

