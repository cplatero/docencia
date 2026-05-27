% function[x,r] = mfJacobi(x,b,para,steps);
%(C) 2008/07/31, Jan Modersitzki, see FAIR and FAIRcopyright.m.
% Jacobi smoother for multigrid, see mfvcycle

function[x,r] = mfJacobi(x,b,para,steps);

% n = length(b);
[r,D] = mfAy(x,para);
r     = b - r; 
D     = para.M + D;

for i=1:steps,
  ss = D\r;
  x = x + para.MGomega*ss;   %x = rmnspace(x,para.Z);
  r = b - mfAy(x,para);      %r = b - rmnspace(mfAu(x,para),para.Z); 
%     his(i) = norm(r)/norm(b);  
%    figure(2); plot(r); pause
end;

%  figure(1); clf; plot(his); 
%  mfilename, keyboard


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

