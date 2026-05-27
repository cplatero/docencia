function B = getTPSMatrix(omega,m)
% (C) 2008/10/14, Jan Modersitzki, see FAIR.


dim = length(omega)/2;
d1 = @(j) partial1 (omega,m,j);
d2 = @(j) partial11(omega,m,j);
switch dim,
  case 2,
    B = [
      kron(speye(m(2)),partial11(omega,m,1))
      sqrt(2)*kron(partial1(omega,m,2),partial1(omega,m,1))
      kron(partial11(omega,m,2),speye(m(1)))
      ];
  case 3,
    B = [
      kron(speye(m(3)*m(2)),partial11(omega,m,1))
      kron(speye(m(3)),kron(partial11(omega,m,2),speye(m(1))))
      kron(partial11(omega,m,3),speye(m(1)*m(2)))
      sqrt(2)*kron(speye(m(3)),kron(partial1(omega,m,2),partial1(omega,m,1)))
      sqrt(2)*kron(partial1(omega,m,3),kron(speye(m(2)),partial1(omega,m,1)))
      sqrt(2)*kron(partial1(omega,m,3),kron(partial1(omega,m,2),speye(m(1))))
      ];
  otherwise
    error('nyi');
end;

B = kron(speye(dim),B);

function D = partial1(omega,m,j);
h = (omega(2:2:end)-omega(1:2:end))./m;
%     | -1  1             |
%     | -1  0  1          |
% D = |    -1  0  1       | / (2*h)
%     |        .  .  .    |
%     |          -1  0  1 |
%     |             -1  1 |
D = spdiags(ones(m(j),1)*[-1,1],[-1,1],m(j),m(j))/(2*h(j));
D([1,end]) = D([2,end-1]);

function D = partial11(omega,m,j);
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
%D = spdiags(ones(m(j),1)*[1,-2,1],-1:1,m(j),m(j))/(h(j)*h(j));
%D([1,end],:) = 0;


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

 