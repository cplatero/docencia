% function b = motherSpline(j,xi)
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
% convienient shortcut for the mother spline function 
% on the four non-trivial intervals (1,2,3,4) and its derivatives (5,6,7,8)

function b = motherSpline(j,xi)

switch j,
  case 1,  b = (2+xi).^3;
  case 2,  b = -(3*xi+6).*xi.^2+4;  %% -xi.^3 - 2*(xi+1).^3 +6*(xi+1);
  case 3,  b =  (3*xi-6).*xi.^2+4;  %% xi.^3 + 2*(xi-1).^3 -6*(xi-1);
  case 4,  b = (2-xi).^3;
  case 5,  b =  3*(2+xi).^2;
  case 6,  b = -(9*xi+12).*xi;      %% -3*xi.^2 - 6*(xi+1).^2+6;
  case 7,  b =  (9*xi-12).*xi;      %% 3*xi.^2 + 6*(xi-1).^2-6;
  case 8,  b = -3*(2-xi).^2;
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
