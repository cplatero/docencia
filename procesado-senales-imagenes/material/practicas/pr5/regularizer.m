function varargout = regularizer(varargin);
%function varargout = regularizer(varargin);
%(c) Jan Modersitzki 2008/05/30, see FAIR.
%multipurpose L2-norm regularizer for NPIR,
%   
%  S(Y) = 0.5*alpha*hd*|B*Y|^2
%
% Notes: 
%  [Sc,dS,d2S] = regularizer(Y,omega,m)
%  alpha and yRef can be set using regularizer('set','alpha',1);
%  A = alpha*hd*B'*B is made persistent for eficiency
%  hd = prod(omega./m)
%  an option grid is introduce to indicate the appropriate discretization: 
%  staggered for elastic and diffusive, cell-centered for curvature
%  enables matrix based and matrix free evaluation
%
% call
%  [Sc,dS,d2S] = regularizer(Y,omega,m);
%  computes S(Y), derivative dS and Hessian
%
% for resetting, intitializing, setting, updating, clearing, displaying
% see options.m
%=======================================================================================


persistent OPTN A 

% --------------------------------------------------------------------------------------
% handle options
[method,OPTN,task,stop] = options(OPTN,varargin{:});

% check the grid according to the regularizer to be used
if strcmp(task,'set') || strcmp(task,'reset'),
  A = [];
  switch method,
    case {'mbElastic','mfElastic'},
      [dummy,OPTN] = options(OPTN,'set','grid','staggered');
    case {'mbCurvature','mfCurvature'},
      [dummy,OPTN] = options(OPTN,'set','grid','cell-centered');
    case {'mbTPS','mfTPS'},
      [dummy,OPTN] = options(OPTN,'set','grid','cell-centered');
    case {'mbElasticNodal'},
      [dummy,OPTN] = options(OPTN,'set','grid','nodal');
    otherwise,
      [dummy,OPTN] = options(OPTN,'set','grid',[]);
      error('nyi')
  end;  
  [dummy,OPTN] = options(OPTN,'set','matrixFree',strcmp(method(1,2),'mf'));
end;
% return, if no further work has to be handled
if stop,
  varargout{1} = method;
  if nargout > 1, varargout{2} = OPTN;  varargout{3} = A;  end;
  return;
end
% --------------------------------------------------------------------------------------


% --------------------------------------------------------------------------------------
% do the work

% extract regularization parameter
alpha  = options(OPTN,'get','alpha');
mu     = options(OPTN,'get','mu');     if isempty(mu),     mu     = 1; end;
lambda = options(OPTN,'get','lambda'); if isempty(lambda), lambda = 0; end;
%yRef   = options(OPTN,'get','yRef');   if isempty(yRef),   yRef   = 0; end;
 


% extract variables
yc     = varargin{1};
omega  = varargin{2};
m      = varargin{3};
hd     = prod((omega(2:2:end)-omega(1:2:end))./m);
doDerivative = (nargout>1);
varargin = varargin(4:end);
for k=1:2:length(varargin), % overwrites defaults
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

matrixBased = 1;
switch method,
  case 'none', 
    varargout = {0,sparse(1,length(yc)),sparse(size(yc,1),size(yc,1))};
    return;
  case 'mbElastic',
    getB = @(omega,m) getElasticMatrixStg(omega,m,mu,lambda);
  case 'mbElasticNodal',
    getB = @(omega,m) getElasticMatrixNodal(omega,m,mu,lambda);
  case 'mbCurvature',
    getB = @(omega,m)getCurvatureMatrix(omega,m);
  case 'mbTPS',
   getB = @(omega,m) getTPSMatrix(omega,m);
  otherwise
    matrixBased = 0;
end;


if matrixBased,
  if size(A,2) ~= numel(yc),
    A = getB(omega,m);
    A = alpha*hd*A'*A;
  end;
  dS  = yc'*A;
  Sc  = 0.5*dS*yc;
  varargout = {Sc,dS,A};
else    
    % set parameter for the matrix free version
    A = [];
    A.regularizer = method;
    A.omega  = omega;
    A.m      = m;
    A.alpha  = alpha;
    A.mu     = mu;
    A.lambda = lambda;

    By = mfBy(yc,A,'By');
    Sc = alpha*hd/2 * norm(By)^2;
    dS = [];
    if doDerivative, dS = alpha*hd*mfBy(By,A,'BTy')'; end;
    varargout = {Sc,dS,A}; 
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

