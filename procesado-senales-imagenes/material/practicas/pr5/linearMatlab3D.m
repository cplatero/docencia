% function [Tc,dT] = linearMatlab3D(T,omega,x,varargin);
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
% linear interpolator for the data T given on a cell-centered grid on
%  [0,omega(1)]x[0,omega(2)]x[0,omega(3)], to be evaluated at x

function [Tc,dT] = linearMatlab3D(T,omega,x,varargin);

Tc = []; dT = [];
if nargin == 0, Tc = mfilename('fullpath'); return; end;
doDerivative = (nargout>1);
for k=1:1:length(varargin)/2,
  eval([varargin{2*k-1},'=varargin{',int2str(2*k),'};']);
end;
m  = size(T); 
h  = (omega(2:2:end)-omega(1:2:end))./m; 
d  = length(omega)/2; 
n  = length(x)/d;                          
xi = @(i) (omega(2*i-1)+h(i)/2:h(i):omega(2*i)-h(i)/2)';
[X1,X2,X3] = meshgrid(xi(1),xi(2),xi(3));
Tfctn = @(x1,x2,x3) interp3(X1,X2,X3,permute(T,[2,1,3]),x1,x2,x3,'linear');
Tc = Tfctn(x(1:n),x(n+1:2*n),x(2*n+1:end));         Tc(isnan(Tc)) = 0;
if ~doDerivative, return;  end;
Tp = Tfctn(x(1:n)+h(1)/2,x(n+1:2*n),x(2*n+1:end));  Tp(isnan(Tp)) = 0;
Tm = Tfctn(x(1:n)-h(1)/2,x(n+1:2*n),x(2*n+1:end));  Tm(isnan(Tm)) = 0;
dT(:,1) = (Tp-Tm)/h(1);
Tp = Tfctn(x(1:n),x(n+1:2*n)+h(2)/2,x(2*n+1:end));  Tp(isnan(Tp)) = 0;
Tm = Tfctn(x(1:n),x(n+1:2*n)-h(2)/2,x(2*n+1:end));  Tm(isnan(Tm)) = 0;
dT(:,2) = (Tp-Tm)/h(2);
Tp = Tfctn(x(1:n),x(n+1:2*n),x(2*n+1:end)+h(3)/2);  Tp(isnan(Tp)) = 0;
Tm = Tfctn(x(1:n),x(n+1:2*n),x(2*n+1:end)-h(3)/2);  Tm(isnan(Tm)) = 0;
dT(:,3) = (Tp-Tm)/h(3);
dT = spdiags(dT,[0,n,2*n],n,3*n);

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
