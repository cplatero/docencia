% =======================================================================================
% function Y = nodal2center(Y,m)
% (c) Jan Modersitzki 2008/07/29, see FAIR and FAIRcopyright.m.
%
% transfers a nodal grid to a cell-centered grid or vice-versa, depending on numel(Y)
%
% Input:
%   Y    		input points,  c or n
%	m 			number of discretization points
%
% Output:
%  Y			output points, n or c
% =======================================================================================

function Y = nodal2center(Y,m)

dim = length(m);
Y   = reshape(Y,[],dim);

% Here starts the matrix free code
if numel(Y) == dim*prod(m),
  % -----------------------
  % cell-centered ->  nodal
  % -----------------------
  Z = zeros(prod(m+1),dim);             % allocate memory
  for i=1:dim,    						% run over all components of Y
    yi = reshape(Y(:,i),m);
    for j=1:dim,  						% run over all dimensions in yi
      J = [j,setdiff(1:dim,j)]; 		% make j-th dimension first
      yi = permute(yi,J);
      zi = zeros(size(yi)+(1:dim==1)); 	% allocate memory
      % average in center and extrapolate boundary linearly
      zi(1:end-1,:,:) = yi; zi(2:end,:,:) = zi(2:end,:,:) + yi;
      zi(2:end-1,:,:) = 0.5*zi(2:end-1,:,:);
      zi(1,:,:)   = (3*yi(1,:,:)   - yi(2,:,:))/2;
      zi(end,:,:) = (3*yi(end,:,:) - yi(end-1,:,:))/2;
      yi = ipermute(zi,J);				% undo permutation
    end
    Z(:,i) = yi(:);                     % store i-th component
  end;
else
  % -----------------------
  % nodal -> cell-centered
  % -----------------------
  Z = zeros(prod(m),dim);				% allocate memory
  for i=1:dim,                          % run over all components of Y
    yi = reshape(Y(:,i),m+1);           % reorganize Y
    for j=1:dim,						% run over all dimensions in yi
      J = [j,setdiff(1:dim,j)];			% make j-th dimension first
      yi = permute(yi,J);
      % average nodal to center
      yi = 0.5*(yi(1:end-1,:,:)+yi(2:end,:,:));
      yi = ipermute(yi,J);				% undo permutation
    end;
    Z(:,i) = reshape(yi,[],1);			% store i-th component
  end;
end;
Y = reshape(Z,[],1);					% reshape

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
