% =======================================================================================
% function varargout = stg2array(Y,m);
% (c) Jan Modersitzki 2008/07/29, see FAIR and FAIRcopyright.m.
%
% decompose a staggered y into its components y1, y2, y3
%
% Input:
%   Y    		staggered points
%	m 			number of discretization points
%
% Output:
%  {Y1,Y2[,Y3]}	components of Y
% =======================================================================================

function varargout = stg2array(Y,m);

dim = length(m);
ns = cumsum([0;prod(ones(dim,1)*m+eye(dim),2)]);
varargout = {[],[],[]};

e = @(i) (1:dim == i); % i-th unit vector
for i=1:dim,
  varargout{i} = reshape(Y(ns(i)+1:ns(i+1)),m+e(i));
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

