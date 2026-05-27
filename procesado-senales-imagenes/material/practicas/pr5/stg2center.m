% =======================================================================================
% function P = stg2center(y,m)
% (c) Jan Modersitzki 2008/07/29, see FAIR and FAIRcopyright.m.
%
% transfers a staggered grid to a cell-centered grid
% if nargin == 1, builds P explicitely, else return results of P(y), matrix free; endif
% depending on numel(Y), the matrix free version also handles P'(Y)
%
% Input:
%   y    		input points,  s or c 
%	m 			number of discretization points
%
% Output:
%   P			the projection matrix P, if nargin == 2
%               P*y,                     if y is staggered
%               P'*y,                    if y is cell-centered
% =======================================================================================

function P = stg2center(y,m)

if nargin == 1, m = y;  end;

dim = length(m);
% ms are the sizes of the staggered components, e.g. dor dim == 3:
% 
%      | m(1)+1 m(2)   m(3)   |
% ms = | m(1)   m(2)+1 m(3)   |
%      | m(1)   m(2)   m(3)+1 |
ms  = ones(dim,1)*m + eye(dim);
ns  = prod(ms,2);
n0  = 0;

if nargin == 1,

  % ----------------------------------
  % build the matrix P and return it
  % ----------------------------------

  % for the dimension ms(i) of the i-th staggered grid, the i-th component 
  % of of m=[m(1),m(2),m(3)] has to be increased by one; the i-th staggered
  % grid contains ns(i)points

  % an averaging operator a:\R^{m+1}->\R^m is defined
  %     | 1 1     |
  % a = |   . .   |/2
  %     |     1 1 |
  a = @(j) spdiags(ones(m(j),1)*[1,1],0:1,m(j),m(j)+1)/2;

  % shortcuts for the identity matrix of size m(i) and n-by-ns(i) zeros
  E = @(i) speye(m(i),m(i));
  Z = @(i) sparse(prod(m),ns(i));

  switch dim,
    case 2,
      P = [kron(E(2),a(1)),Z(2)
        Z(1),kron(a(2),E(1))];
    case 3,
      P = [kron(E(3),kron(E(2),a(1))),Z(2),Z(3)
        Z(1),kron(E(3),kron(a(2),E(1))),Z(3)
        Z(1),Z(2),kron(a(3),kron(E(2),E(1))) ];
  end;
  return;
end;

% ----------------------------------
% Here starts the matrix free code
% ----------------------------------

if numel(y) == dim*prod(m),

  % cell-centered to staggered

  z = zeros(sum(ns),1);
  y = reshape(y,[],length(m));
  for i=1:length(m),
    yi = reshape(y(:,i),m);
    zi = zeros(ms(i,:));
    switch i,
      case 1, zi(1:end-1,:,:) = yi; zi(2:end,:,:) = zi(2:end,:,:) + yi;
      case 2, zi(:,1:end-1,:) = yi; zi(:,2:end,:) = zi(:,2:end,:) + yi;
      case 3, zi(:,:,1:end-1) = yi; zi(:,:,2:end) = zi(:,:,2:end) + yi;
    end;
    zi = 0.5*zi;
    z(n0+(1:ns(i))) = reshape(zi,[],1); n0 = n0 + ns(i);
  end;
else

  % staggered to cell-centered

  z = zeros(prod(m),length(m));
  for i=1:length(m),
    yi = reshape(y(n0+(1:ns(i))),ms(i,:));
    n0 = n0 + ns(i);
    switch i,
      case 1, yi = (yi(1:end-1,:,:) + yi(2:end,:,:))/2;
      case 2, yi = (yi(:,1:end-1,:) + yi(:,2:end,:))/2;
      case 3, yi = (yi(:,:,1:end-1) + yi(:,:,2:end))/2;
    end;
    z(:,i) = reshape(yi,[],1);
  end;
  z = reshape(z,[],1);
end;
P = z;

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

