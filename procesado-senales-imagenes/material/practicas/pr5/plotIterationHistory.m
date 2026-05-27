% =======================================================================================
% function [fig,ph,th] = plotIterationHistory(his,varargin);
% (c) Jan Modersitzki 2008/07/29, see FAIR and FAIRcopyright.m.
%
% plots iteration history
%
% Example: plotIterationHistory(his,'J',[1,2,5],'fig',2);
% Input:
%   his		    struct wigth headlines and list
%  varargin		optional parameters, see below
% Output:
%  fig         figure handle
%  ph          plot handle
%  th          text handle
% =======================================================================================

function [fig,ph,th] = plotIterationHistory(his,varargin);

fig     = [];
col     = 'krgbcmykrgbcmy';
figname = mfilename;
J       = [];
for k=1:2:length(varargin),
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

if isempty(J), J = 1:length(his.str);  end;
str = his.str(J); his = his.his(:,J);
dum = abs(max(his,[],1));
dum = dum + (dum==0);
if ~isempty(fig),
  fig = figure(fig); clf; 
else  
  fig = figure;      clf; 
end;

set(fig,'numbertitle','off','name',sprintf('[FAIR:%d] %s',fig,figname));
for j=2:size(his,2),
  ph(j-1) = plot(his(2:end,1),his(2:end,j)/dum(j),'color',col(j-1)); hold on;
end;
set(ph,'linewidth',2);
th(1) = title(str{1});
th(2) = xlabel('iter');
th(3) = legend(ph,str{2:end});

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

