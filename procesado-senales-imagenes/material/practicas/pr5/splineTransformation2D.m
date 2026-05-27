% function [y,dy] = splineTransformation2D(w,x,varargin)
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
% computes y = Q*w and the derivative wrt. w.
% x = reshape(x,[],3); 
% Q = kron(I_2,kron(Q2,Q1)), where Q1(:,1) = spline(X1), Q2(:,1) = spline(X2),
% dy = Q:
% if no argumanets are given, the parameters for the identity map are returned.

 function [y,dy] = splineTransformation2D(w,x,varargin)
%(c) Jan Modersitzki 2007/04/25, see FAIR.

p = []; m = []; omega = [];
for k=1:2:length(varargin), % overwrites defaults
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

persistent Q 
y  = []; dy = [];
% if no input is given or ischar(w), y=[function name] and 
% dy=[parameterization of the identity map] are returned
if nargin == 0 || ischar(w),
  y  = mfilename('fullfile'); 
  dy = zeros(2*prod(p),1); 
  if nargin>0 && ischar(w), Q = []; end;
  return; 
end;
if isempty(w) || (size(Q,1) ~= numel(x)) || (size(Q,2) ~= numel(w)),
  % it is assumed that x is a cell centered grid, extract xi1 and xi2
  x  = reshape(x,[m,2]);
  Q1 = getQ1d(omega(1:2),m(1),p(1),x(:,1,1));
  Q2 = getQ1d(omega(3:4),m(2),p(2),x(1,:,2));
  Q  = kron(speye(2),kron(sparse(Q2),sparse(Q1)));
  if nargout == 0, return; end;
end;
y = x(:) + Q*w;
dy = Q;

function Q = getQ1d(omega,m,p,xi)
Q  = zeros(m,p); xi = reshape(xi,[],1);
for j=1:p,
  cj=zeros(p,1); cj(j) = 1;
  Q(:,j) = splineInter1D(cj,omega,xi);
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

