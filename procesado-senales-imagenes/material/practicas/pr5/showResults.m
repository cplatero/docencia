% =======================================================================================
% function showResults(MLdata,yc,varargin);
% (c) Jan Modersitzki 2008/08/14, see FAIR and FAIRcopyright.m.
%
% visualizes registration results
%
% Input:
%   MLdata          multi-level representation of data
%   yc    		transformation
%   varargin    optional parameters like {'isovalue',100}
% =======================================================================================

function showResults(MLdata,yc,varargin);

fig     = [];
figname = sprintf('inter=[%s],trafo=[%s],distance=[%s],regularizer=[%s,alpha=%s]',...
  inter,trafo,distance,regularizer,num2str(regularizer('get','alpha')));

level  = length(MLdata);
mode   = 'duplex';
folder = '.';
prefix = mfilename;

for k=1:2:length(varargin), % overwrites defaults
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

omega = MLdata{level}.omega;
m     = MLdata{level}.m;
[T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega,'out',0);
yc    = center(yc,m); % make yc cell-centered
xc    = getCenteredGrid(omega,m);
R0    = inter(R,omega,xc);
T0    = inter(T,omega,xc);
T1    = inter(T,omega,yc);
d0    = distance(T0,R0,omega,m);
d1    = distance(T1,R0,omega,m);
red   = num2str(100*d1/d0);
D0    = 255 - abs(T0-R0);
D1    = 255 - abs(T1-R0);
pause(1/100);
FAIRfigure(fig,'figname',figname,'position',800);

fprintf('reduction %s(yc)/%s(xc)=%s%%\n',distance,distance,red);

if strcmp(mode,'single');
  Name  = @(str) fullfile(folder,sprintf('%s-%s',prefix,str));
%    Name('test');   return
  Write = @(I) imwrite(uint8(round(flipud(reshape(I,m)'))),...
    [Name(inputname(1)),'.jpg']);

  viewImage(R0,omega,m); title('R0'); Write(R0); pause(1);
  viewImage(T0,omega,m); title('T0'); Write(T0); pause(1);
  viewImage(D0,omega,m); title('D0'); Write(D0); pause(1);

  clf;   
  viewImage(T0,omega,m); hold on;
  yn = grid2grid(yc,m,'centered','nodal');
  plotGrid(yn,omega,m,'color','w','linewidth',2,...
    'spacing',[max([1,m(1)/32]),max([1,m(2)/32])]);
  axis off;
  FAIRprint(Name('grid'),'obj','gca','folder',[],'pause','off');
  clf;
  viewImage(T1,omega,m); title('T1'); Write(T1); pause(1);
  viewImage(D1,omega,m); title('D1'); Write(D1); pause(1);
  return

else
  subplot(2,3,1); viewImage(R0,omega,m); title('R')
  subplot(2,3,2); viewImage(T0,omega,m); title('T(xc)')
  subplot(2,3,3); viewImage(T1,omega,m); title('T(yc)')
  subplot(2,3,5); viewImage(D0,omega,m);
  title(sprintf('%s(T(xc),R)=%s%%',distance,num2str(100)))
  subplot(2,3,6); viewImage(D1,omega,m);
  title(sprintf('%s(T(yc),R)=%s%%',distance,red))
  subplot(2,3,4); viewImage(T0,omega,m); hold on; title('T(xc) and yc')
  plotGrid(yc,omega,m,'spacing',ceil(m/32));
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
