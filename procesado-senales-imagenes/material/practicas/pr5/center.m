% =======================================================================================
% function function yc = center(yc,m);
% (c) Jan Modersitzki 2009/04/02, see FAIR.2 and FAIRcopyright.m.
%
% transfers yc (centered, staggered, nodal) to a centered grid
%
% Input:
%   yc			current grid points
%	  m 			number of discretization points
%
% Output:
%  yc			on cell-centered grid
% =======================================================================================

function yc = center(yc,m);

dim = length(m);

if dim*prod(m) == numel(yc),
  % yc is already cell-centered
  yc = reshape(yc,[],1);
elseif dim*prod(m+1) == numel(yc),
  % yc is nodal 
  yc = nodal2center(yc,m);
elseif sum(prod(ones(dim,1)*m+eye(dim),2)) == numel(yc)
  % yc is staggered
  yc = stg2center(yc,m);
else
  error('don''t know how to deal this grid')
end;

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
