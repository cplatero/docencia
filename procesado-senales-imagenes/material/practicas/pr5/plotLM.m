% =======================================================================================
% function [ph,th] = plotLM(LM,varargin);
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%
% a convenient way of plotting landmarks
%                   
% Input:
%   LM			landmark positions
%   varargin    optional parameter, see below
%
% Output:
%  ph           handle to plot
%  th           handle to text
% =======================================================================================

function [ph,th] = plotLM(LM,varargin);

% set-up default parameter
dim       = size(LM,2);
numbering = 'off';
dx        = 0.1;
fontsize  = 20;
color     = 'y';
for k=1:2:length(varargin), % overwrites default parameter
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

ph = []; th = []; % create empty handles

% handle options 'numbering', 'fontsize' and 'dx'
J = strcmp(varargin,'numbering') ...
  | strcmp(varargin,'dx') | strcmp(varargin,'fontsize');
if any(J),
  I = find(J);
  K = setdiff(1:length(varargin),[I,I+1]);
  varargin = {varargin{K}};
end;

% use plot in 2D or 3D
varargin = {varargin{:},'color',color};
switch dim,
  case 2, ph = plot(LM(:,1),LM(:,2),'x',varargin{:});
  case 3, ph = plot3(LM(:,1),LM(:,2),LM(:,3),'x',varargin{:});
end;

if strcmp(numbering,'off'), return;  end;

% add labels to the landmarks
dx = [dx,zeros(1,dim-1)];
pos = @(j) LM(j,:) + dx;
for j=1:size(LM,1),
  th(j) = text('position',pos(j),'string',sprintf('%d',j));
end;
set(th,'fontsize',fontsize,'color',color);

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


    
