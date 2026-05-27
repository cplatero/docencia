% function [y,dy] = affine2D(w,x,varargin)
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
% computes y = Q*w = [w(1),w(2);w(4),w(5)] * x + w([3,6]) and the derivative wrt. w.
% x = reshape(x,[],2); 
% Q = [x(:,1),x(:,2),1, 0      0        0 
%      0      0      0, x(:,1),x(:,2,1),1]
% dy = Q:
% if no argumanets are given, the parameters for the identity map are returned.

function [y,dy] = affine2D(w,x,varargin)

% the persitent variable stores the matrix 
% Q(x) = kron( I_2 , [x(:,1),x(:,2),1] );

persistent Q

% intitialize  y and dy
y  = []; dy = [];

% if no input is given or ischar(w), y=[function name] and 
% dy=[parameterization of the identity map] are returned
if nargin == 0 | ischar(w), 
  y = mfilename('fullfile'); 
  dy = [1;0;0;0;1;0]; 
  if nargin>0 && ischar(w), Q = []; end;
  return; 
end;

% if isempty(w) or size mismatch of Q and x, recompute Q
if isempty(w) || (size(Q,1) ~= numel(x)),
  n = length(x)/2; x = reshape(x,n,2);
  Q = sparse(kron(speye(2),[x,ones(n,1)]));
  if nargout == 0 || isempty(w), return; end;
end;
y  = Q*w;
dy = Q;

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
