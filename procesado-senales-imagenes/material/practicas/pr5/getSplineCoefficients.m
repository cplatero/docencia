% function c = getSplineCoefficients(dataT,varargin);
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
% computes regularized spline coefficients for interpolation, see Section 3.6.

function coefT = getSplineCoefficients(dataT,varargin)

% parameter and defaults
theta       = 0;
regularizer = 'none';
m           = size(dataT);
dim         = length(size(dataT));
out         = 1;
for k=1:2:length(varargin), % overwrite default parameter
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

if out, % report
  fprintf('compute %dD spline coefficients, m=[',dim);
  fprintf(' %d',m);
  fprintf('], regularizer=[%s], theta=[%s]\n',regularizer,num2str(theta));
end;

if isempty(dataT), coefT = []; return; end;
if ~strcmp(regularizer,'truncated'),
  switch dim,
    case 1,
      [M,P] = regularizedB(length(dataT),regularizer,theta);
      coefT = M\(P'*reshape(dataT,[],1));
    case 2,
      [M,P] = regularizedB(m(1),regularizer,theta);
      coefT = M\(P*dataT);
      coefT = permute(coefT,[2,1]);
      [M,P] = regularizedB(m(2),regularizer,theta);
      coefT = permute(M\(P*coefT),[2,1]);
    case 3,
      [M,P] = regularizedB(m(1),regularizer,theta);
      coefT = reshape(M\(P*reshape(dataT,m(1),m(2)*m(3))),m);
      [M,P] = regularizedB(m(2),regularizer,theta);
      coefT = reshape(permute(coefT,[2,1,3]),m(2),m(1)*m(3));
      coefT = permute(reshape(M\(P*coefT),m(2),m(1),m(3)),[2,1,3]);
      [M,P] = regularizedB(m(3),regularizer,theta);
      coefT = reshape(permute(coefT,[3,1,2]),m(3),m(1)*m(2));
      coefT = permute(reshape(M\(P*coefT),m(3),m(1),m(2)),[2,3,1]);
  end;
else
  switch dim,
    case 1,
      M = regularizedB(length(dataT),regularizer,theta);
      coefT = M*dataT;
    case 2,
      M = regularizedB(m(1),regularizer,theta);
      coefT = M*dataT;
      coefT = permute(coefT,[2,1]);
      M = regularizedB(m(2),regularizer,theta);
      coefT = permute(M*coefT,[2,1]);
    case 3,
      M = regularizedB(m(1),regularizer,theta);
      coefT = reshape(M*reshape(dataT,m(1),m(2)*m(3)),m);
      M = regularizedB(m(2),regularizer,theta);
      coefT = reshape(permute(coefT,[2,1,3]),m(2),m(1)*m(3));
      coefT = permute(reshape(M*coefT,m(2),m(1),m(3)),[2,1,3]);
      M = regularizedB(m(3),regularizer,theta);
      coefT = reshape(permute(coefT,[3,1,2]),m(3),m(1)*m(2));
      coefT = permute(reshape(M*coefT,m(3),m(1),m(2)),[2,3,1]);
  end;
end;
function [M,P] = regularizedB(m,regularizer,theta)
M = []; P = spdiags(ones(m,1)*[1,4,1],[-1:1],m,m);
switch regularizer,
  case 'none',      M = P;                        P = 1;
  case 'identity',  M = P'*P+theta*speye(m,m);
  case 'gradient',  D = spdiags(ones(m,1)*[-1,1],[0,1],m-1,m);
    M = P'*P+theta*D'*D;
  case 'moments',   M = P'*P+theta*toeplitz([96,-54,0,6,zeros(1,m-4)]);

  case 'truncated',
    k = max([1,min([ceil((1-theta)*m),m])]);
    d = 1./(4+2*cos((1:m)'*pi/(m+1)));
    V = sqrt(2/(m+1))*sin((1:m)'*(1:m)*pi/(m+1));
    M = V*diag([d(1:k);zeros(m-k,1)])*V';
  otherwise, error(regularizer);
end;
return;

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
