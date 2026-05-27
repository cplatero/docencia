function varargout = PIRregularizer(varargin);
%function varargout = PIRregularizer(varargin);
%(c) Jan Modersitzki 2008/05/30, see FAIR.
%regularization for Parametric Image Registration, see PIRobjFctn.m
%uses persistent variable alpha, M, wRef to compute
% S(w) = alpha/2*(w-wRef)'*M*(w-wRef) or S = 0 if the variables are not defined
% PIRregularizer('alpha',1,'M',speye(n,n)[,'wRef',w0])
%   initializes the variables
% PIRregularizer('clear')
%  clears the persistent variables
% PIRregularizer('get')
%  returns {alpha,M,wRef}
% PIRregularizer('reset')
%  clear alpha, M, wRef and updates according to the varargin list
% PIRregularizer('set')
%  updates according to the varargin list
%
% =======================================================================================

error('1')
% handle options
persistent alpha M wRef

% if ischar(first input), administration mode
if ischar(varargin{1}),
  switch varargin{1},
    case {'clear','none'}, clear alpha M wRef;       return;
    case 'get',     varargout = {alpha,M,wRef};      return;
    case 'reset',   varargin(1) = [];   alpha = 0; M = []; wRef = 0;     
    case 'set',     varargin(1) = [];
    case 'disp',
      fprintf('[%s]',mfilename); 
      if isempty(alpha) || alpha == 0,
        fprintf('  %s\n','OPTN is empty')
      else
        str = @(X) sprintf('%d-by-%d',size(X,1),size(X,2));
        fprintf('\n');
        fprintf('%12s : %s\n','alpha',num2str(alpha));
        fprintf('%12s : %s\n','M is ',str(M));
        fprintf('%12s : %s\n','wRef is ',str(wRef));
      end;
      return;
  end;
  if ~exist('alpha','var'),  alpha  = 0;    end;
  if ~exist('M','var'),      M      = [];   end;
  if ~exist('wRef','var'),   wRef   = 0;    end;

  for k=1:2:length(varargin), % overwrites defaultparameter
    eval([varargin{k},'=varargin{',int2str(k+1),'};']);
  end;
  varargout = {alpha,M,wRef};
  return;
end;

% computation mode
w = varargin{1}; n = length(w);
if isempty(alpha) || (alpha == 0),
  % the regularization is set to S = 0
  varargout = {0,zeros(1,n),sparse(n,n)};
else
  % compute alpha/2*(w-wRef)'*M*(w-wRef)
  if isempty(wRef), wRef = 0; end;
  dS = alpha*(w-wRef)'*M;
  S  = 0.5*dS*(w-wRef);
  varargout = {S,dS,alpha*M};
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

