% function [Tc,dT] = linearMatlab1D(T,omega,x,varargin);
% (c) Jan Modersitzki 2009/04/02, see FAIR.2 and FAIRcopyright.m.
% MATLAB's linear interpolator for the data T given on a cell-centered grid 
% on [0,omega], to be evaluated at x

function [Tc,dT] = linearMatlab1D(T,omega,x,varargin);

Tc = []; dT = [];                % initialize variables
if nargin == 0, Tc = mfilename('fullpath'); return; end;
doDerivative = (nargout>1);
for k=1:2:length(varargin),      % overwrite defaults
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;
xc = getCenteredGrid(omega,length(T));
Tc = interp1(xc,T,x,'linear');         Tc(isnan(Tc)) = 0;
if ~doDerivative, return;  end;
h = (omega(2:2:end)-omega(1:2:end))./(length(T)*10);
Tp = interp1(xc,T,x+h(1)/2,'linear');  Tp(isnan(Tp)) = 0;
Tm = interp1(xc,T,x-h(1)/2,'linear');  Tm(isnan(Tm)) = 0;
dT = spdiags((Tp-Tm)/h(1),0,length(Tc),length(Tc));

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
