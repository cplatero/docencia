% =======================================================================================
% function [fh,ph,th] = checkDerivative(f0tn,x0);
% (c) Jan Modersitzki 2009/04/02, see FAIR.2 and FAIRcopyright.m.
%
% checks the implementation of a derivative by comparing the function 
% with the Taylor-poly
%
%   \| f(x0 + h ) - TP_p(x0,h) \|   !=   O( h^{p+1} ) 
%
% Input:
%   f0tn		function handle
%	x0			expanding point
%
% Output:
%  fh			figure handle to graohical output
%  ph			plot handle
%  th			text handle
% =======================================================================================

function [fh,ph,th] = checkDerivative(fctn,x0);

fprintf('%s: derivative test\n',mfilename);
fprintf('T0 = |f0 - ft|, T1 = |f0+h*f0'' - ft|\n');
[f0,df] = feval(fctn,x0);
h = logspace(-1,-10,10);
v = randn(size(x0));
dvf = df*v; 
for j=1:length(h),
  ft = feval(fctn,x0+h(j)*v);		% function value
  T0(j) = norm(f0-ft);				% TaylorPoly 0
  T1(j) = norm(f0+h(j)*dvf - ft);   % TaylorPoly 1
  fprintf('h=%12.4e     T0=%12.4e    T1=%12.4e\n',h(j),T0(j),T1(j));
end;
fh = figure;
ph = loglog(h,[T0;T1]); set(ph(2),'linestyle','--')
th  = title(sprintf('%s: |f-f(h)|,|f+h*dvf -f(h)| vs. h',mfilename));

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
