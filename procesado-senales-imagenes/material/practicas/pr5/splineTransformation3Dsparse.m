% function [y,dy] = splineTransformation3Dsparse(w,x,varargin)
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
% computes y = Qfull*w and the derivative wrt. w.
% x = reshape(x,[],3); 
% Qfull = kron(kron(I_2,Q3),kron(Q2,Q1)), where Q1(:,j) = spline(xj)
% stores only Q = {Q1,Q2,Q3} and uses matVecWw for multiplication
% if no argumanets are given, the parameters for the identity map are returned.

function [y,dy] = splineTransformation3Dsparse(w,x,varargin)

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
  dy = zeros(3*prod(p),1); 
  if nargin>0 && ischar(w), Q = []; end;
  return; 
end;

% test for need of updating Q
OK = ~any(isempty(Q));
if OK, 
  m1 = size(Q{1});  m2 = size(Q{2});  m3 = size(Q{3});
  OK = (3*m1(1)*m2(1)*m3(1) == size(x,1)) && (3*m1(2)*m2(2)*m3(2) == numel(w));
end;

if ~OK,
  % it is assumed that x is a cell centered grid, extract xi1, xi2, and xi3
  x  = reshape(x,[m,3]);
  Q{1} = getQ1d(omega(1:2),m(1),p(1),x(:,1,1,1));
  Q{2} = getQ1d(omega(3:4),m(2),p(2),x(1,:,1,2));
  Q{3} = getQ1d(omega(5:6),m(3),p(3),x(1,1,:,3));
  if nargout == 0, return; end;
end;
w  = reshape(w,[],3);
y  = x(:) + [matVecQw(w(:,1),Q);matVecQw(w(:,2),Q);matVecQw(w(:,3),Q)];
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


