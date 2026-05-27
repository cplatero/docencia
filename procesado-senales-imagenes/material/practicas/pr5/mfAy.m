% =======================================================================================
% function [y,D] = mfAy(yc,para)
% (c) Jan Modersitzki 2008/07/29, see FAIR and FAIRcopyright.m.
%
% MatrixFree y =(M + alpha*h*B'*B)*y for elastic, diffusion, curvature
% where M is supposed to be diagonal and B is given via mfBu.m;
% the matrices M and B are represented by the struct para
%  returns also D = diag(alpha*h*B'*B) 

function [y,D] = mfAy(yc,para)

omega = para.omega; 
m     = para.m; 
dim   = length(omega)/2; 
h     = (omega(2:2:end)-omega(1:2:end))./m;
hd    = prod(h);
y     = para.M*yc + para.alpha*hd*mfBy(mfBy(yc,para,'By'),para,'BTy');

if nargout<2, return; end;


regularizer = para.regularizer;
mu     = para.mu;
lambda = para.lambda;

switch regularizer,
  case 'mfElastic',
    % assemple the diagonal of B'B, where B is the elasticity operator;
    % see mfBy
    one    = @(i,j) One(omega,m,i,j);
    
    if dim == 2,
      D   = [reshape( (2*mu+lambda)*one(1,1) + (  mu+lambda)*one(1,2),[],1)
        reshape( (  mu+lambda)*one(2,1) + (2*mu+lambda)*one(2,2),[],1)];
    else
      D   = [ ...
        reshape( (2*mu+lambda)*one(1,1)+(mu+lambda)*(one(1,2)+one(1,3)),[],1)
        reshape( (2*mu+lambda)*one(2,2)+(mu+lambda)*(one(2,1)+one(2,3)),[],1)
        reshape( (2*mu+lambda)*one(3,3)+(mu+lambda)*(one(3,1)+one(3,2)),[],1) ];
    end;
  case 'mfCurvature',
    D = (2/h(1)^2+2/h(2)^2)^2*ones(size(yc));
end;

D   = para.alpha*hd*spdiags(D,0,numel(D),numel(D));

function o = One(omega,m,i,j)
h = (omega(2:2:end)-omega(1:2:end))./m;
m = m + [1:length(m) == i];
o = ones(m)/h(j)^2;
switch j,
  case 1, o(2:end-1,:,:) = 2*o(2:end-1,:,:);
  case 2, o(:,2:end-1,:) = 2*o(:,2:end-1,:);
  case 3, o(:,:,2:end-1) = 2*o(:,:,2:end-1);
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

