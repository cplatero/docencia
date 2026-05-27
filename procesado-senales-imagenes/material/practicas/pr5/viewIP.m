% =======================================================================================
% function [ih,I] = viewIP(I,omega,m,varargin);
% (c) Jan Modersitzki 2008/07/29, see FAIR and FAIRcopyright.m.
%
% visualizes the intensity projections of a 3D image
%
% Input:
%   I           discretized image
%   omega		describing the domain
%	m 			number of discretization points
%   varargin    optional parameters like {'axis','off'}
%
% Output:
%  ih			image handle
%  I			[I1,I2;I3',0]
% =======================================================================================

function [ih,I] = viewIP(I,omega,m,varargin);

% reshape and form the avarage images
I  = reshape(I,m);
I1 = squeeze(sum(I,3))/m(3);
I2 = squeeze(sum(I,2))/m(2);
I3 = squeeze(sum(I,1))/m(1);

I = [I1,I2;I3',zeros(m(3),m(3))]; cla;
ih  = imagesc(I); axis image; hold on
ph1 = plot(0.5+m(2)*[1,1],[0,m(1)+m(3)],'b-','linewidth',2);
ph2 = plot([0,m(2)+m(3)],0.5+m(1)*[1,1],'b-','linewidth',2);
ih = [ih;ph1;ph2];

% the following lines add some nice stuff to the code.
% if varargin = {'title','FAIR','xlabel','x'}
% the code evaluates "title('FAIR');xlabel('x');"
for k=1:2:length(varargin), 
  if ~isempty(varargin{k}), feval(varargin{k},varargin{k+1}); end;
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
