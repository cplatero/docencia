% =======================================================================================
% function c = getTPScoefficients(LM,varargin);
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%
% Computes coefficients for Thin-Plate-Spline Interpolation
% | A + theta*I   B | * | c1 |  =  | t |,
% | B'            0 |   | c2 |     | 0 |
%
% A = [rho(t_j-r_k)], B = [1,r], t=LM(:,1:dim), r = M(:,dim+1:2*dim)
%
% Input:
%   LM			landmark positions
%   varargin    optional parameter, see below
%	
% Output:
%  c			coefficients
% =======================================================================================

function c = getTPScoefficients(LM,varargin);

theta = 0;
for k=1:2:length(varargin), % overwrites default parameter
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

% get number of landmarks, dimension, and radial basis function
n = size(LM,1);
d = size(LM,2)/2;
switch d,
  case 2,  rho   = @(r) r.^2.*log(r);
  case 3,  rho   = @(r) r;
end;
% fill 1-1 block
A = zeros(n);
for j=1:n, for k=1:j-1,
    A(j,k) = rho(norm(LM(j,d+1:end)-LM(k,d+1:end)));
end;       end;
A = A+A';
B = [ones(n,1),LM(:,d+1:end)];

% build KKT system and solve it
K = [A+theta*eye(n),B;B',zeros(d+1)];
c = K\[LM(:,1:d);zeros(d+1,d)];

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

