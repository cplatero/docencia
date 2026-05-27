% ========================================================================
% function By = mfBy(yc,para,flag);
%(C) 2008/07/31, Jan Modersitzki, see FAIR and FAIRcopyright.m.
%
% MatrixFree B*u for elastic, diffusion, curvature
% computes B*zy or B'*yc (depends on flag, works for dim=2,3)
% where B is implicitly given by the parameters para.
%=========================================================================

function By = mfBy(yc,para,flag);

% default is B*yc
if ~exist('flag','var'), flag = 'By';  end;

% extract parameters
omega = para.omega; 
m     = para.m; 
dim   = length(omega)/2; 
h     = (omega(2:2:end)-omega(1:2:end))./m;

if ~isfield(para,'mu'),     para.mu     = 0; end;
if ~isfield(para,'lambda'), para.lambda = 0; end;

a  = sqrt(para.mu); 
b  = sqrt(para.mu+para.lambda);
nc = prod(m);
ns = prod(ones(length(m),1)*m+eye(length(m)),2);

flag = [para.regularizer,'-',flag,'-',int2str(dim)];


switch flag

  % By for elastic-grad
  % yc -> [u1,u2,u3]
  %
  %     dim == 3,                     dim == 2,
  %     | d11         |
  %     | d21         |
  %     | d31         |   | u1 |          | d11     |
  %     |     d12     |   |    |          | d21     |   | u1 |
  %  y= |     d22     | * | u2 |      y = |     d12 | * |    |
  %     |     d32     |   |    |          |     d22 |   | u2 |
  %     |         d13 |   | u3 |          | d11 d22 |
  %     |         d23 |
  %     |         d33 |
  %     | d11 d22 d33 |

  
  
  case 'mfElastic-By-2'
    y1  = reshape(yc(1:ns(1)),m(1)+1,m(2));
    y2  = reshape(yc(ns(1)+(1:ns(2))),m(1),m(2)+1);
        
    p1 = nc;                            %    1:p1   d11 y1
    p2 = p1+(m(1)+1)*(m(2)-1);          % p1+1:p2   d21 y1
    p3 = p2+(m(1)-1)*(m(2)+1);          % p2+1:p3   d12 y2
    p4 = p3+nc;                         % p3+1:p4   d22 y2
    p5 = p4+nc;                         % p4+1:p5   div y
    By = zeros(p5,1);

    d1 = @(Y) reshape(Y(2:end,:)-Y(1:end-1,:),[],1)/h(1);
    d2 = @(Y) reshape(Y(:,2:end)-Y(:,1:end-1),[],1)/h(2);
    
    By(1:p4)    = [d1(y1);d2(y1);d1(y2);d2(y2)];
    % div y = d11 y1 + d22 y2
    By(p4+1:p5) = By(1:p1) + By(p3+1:p4);
    By(1:p4)    = a*By(1:p4);
    By(p4+1:p5) = b*By(p4+1:p5);
    
  case 'mfElastic-BTy-2'
    
    % the input yc is the result of B*y, therefore it can be splitted into 5
    % parts: d11u1, d21u1,d12u2,d22u2,Divy
  
    p1 = nc;                            %    1:p1   d11 y1
    p2 = p1+(m(1)+1)*(m(2)-1);          % p1+1:p2   d21 y1
    p3 = p2+(m(1)-1)*(m(2)+1);          % p2+1:p3   d12 y2
    p4 = p3+nc;                         % p3+1:p4   d22 y2
    p5 = p4+nc;                         % p4+1:p5   div y

    By  = zeros(sum(ns),1);
    
    d1T = @(Y) reshape([-Y(1,:);Y(1:end-1,:)-Y(2:end,:);Y(end,:)],[],1)/h(1);
    d2T = @(Y) reshape([-Y(:,1),Y(:,1:end-1)-Y(:,2:end),Y(:,end)],[],1)/h(2);
    
    By(1:ns(1))     = a*d1T(reshape(yc(   1:p1),m)) ...
      +               a*d2T(reshape(yc(p1+1:p2),m(1)+1,m(2)-1)) ...
      +               b*d1T(reshape(yc(p4+1:p5),m));

    By(1+ns(1):end) = a*d1T(reshape(yc(p2+1:p3),m(1)-1,m(2)+1)) ...
      +               a*d2T(reshape(yc(p3+1:p4),m)) ...
      +               b*d2T(reshape(yc(p4+1:p5),m));    
    
  case 'mfElastic-By-3'
    y1  = reshape(yc(1:ns(1)),m(1)+1,m(2),m(3));
    y2  = reshape(yc(ns(1)+(1:ns(2))),m(1),m(2)+1,m(3));
    y3  = reshape(yc(ns(1)+ns(2)+(1:ns(3))),m(1),m(2),m(3)+1);
    
    p1  = nc;                            %    1:p1   d11 y1
    p2  = p1+(m(1)+1)*(m(2)-1)*m(3);     % p1+1:p2   d21 y1
    p3  = p2+(m(1)+1)*m(2)*(m(3)-1);     % p2+1:p3   d31 y1
    p4  = p3+(m(1)-1)*(m(2)+1)*m(3);     % p3+1:p4   d12 y2
    p5  = p4+nc;                         % p4+1:p5   d22 y2
    p6  = p5+m(1)*(m(2)+1)*(m(3)-1);     % p5+1:p6   d32 y2
    p7  = p6+(m(1)-1)*m(2)*(m(3)+1);     % p6+1:p7   d13 y3
    p8  = p7+m(1)*(m(2)-1)*(m(3)+1);     % p7+1:p8   d23 y3
    p9  = p8+nc;                         % p8+1:p9   d33 y3
    p10 = p9+nc;                         % p9+1:p10  div y
    By = zeros(p10,1);

    d1 = @(Y) reshape(Y(2:end,:,:)-Y(1:end-1,:,:),[],1)/h(1);
    d2 = @(Y) reshape(Y(:,2:end,:)-Y(:,1:end-1,:),[],1)/h(2);
    d3 = @(Y) reshape(Y(:,:,2:end)-Y(:,:,1:end-1),[],1)/h(3);
    
    By(1:p9)    = [...
      d1(y1);d2(y1);d3(y1);...
      d1(y2);d2(y2);d3(y2);...
      d1(y3);d2(y3);d3(y3) ];
    % div y = d11 y1 + d22 y2 + d33 y3
    By(p9+1:p10) = By(1:p1) + By(p4+1:p5)+ By(p8+1:p9);
    By(   1:p9 ) = a* By(1:p9);
    By(p9+1:p10) = b* By(p9+1:p10);
            
  case 'mfElastic-BTy-3'
    
    % the input yc is the result of B*y, therefore it can be splitted into 10
    % parts: d11y1, d21y1,d31y1,d12y2,d22y2,d32y2,d13y3,d23y3,u33y3,Divy

    p1  = nc;                            %    1:p1   d11 y1
    p2  = p1+(m(1)+1)*(m(2)-1)*m(3);     % p1+1:p2   d21 y1
    p3  = p2+(m(1)+1)*m(2)*(m(3)-1);     % p2+1:p3   d31 y1
    p4  = p3+(m(1)-1)*(m(2)+1)*m(3);     % p3+1:p4   d12 y2
    p5  = p4+nc;                         % p4+1:p5   d22 y2
    p6  = p5+m(1)*(m(2)+1)*(m(3)-1);     % p5+1:p6   d32 y2
    p7  = p6+(m(1)-1)*m(2)*(m(3)+1);     % p6+1:p7   d13 y3
    p8  = p7+m(1)*(m(2)-1)*(m(3)+1);     % p7+1:p8   d23 y3
    p9  = p8+nc;                         % p8+1:p9   d33 y3
    p10 = p9+nc;                         % p9+1:p10  div y
    By  = zeros(sum(ns),1);
    
    d1T = @(Y) reshape(d1t(Y),[],1)/h(1);
    d2T = @(Y) reshape(d2t(Y),[],1)/h(2);
    d3T = @(Y) reshape(d3t(Y),[],1)/h(3);

     
    By(1:ns(1))   = a*d1T(reshape(yc(   1:p1),m)) ...
      +             a*d2T(reshape(yc(p1+1:p2),m(1)+1,m(2)-1,m(3))) ... 
      +             a*d3T(reshape(yc(p2+1:p3),m(1)+1,m(2),m(3)-1)) ...
      +             b*d1T(reshape(yc(p9+1:p10),m));

    By(ns(1)+(1:ns(2))) = ...
          a*d1T(reshape(yc(p3+1:p4),m(1)-1,m(2)+1,m(3))) ...
      +   a*d2T(reshape(yc(p4+1:p5),m)) ...
      +   a*d3T(reshape(yc(p5+1:p6),m(1),m(2)+1,m(3)-1)) ...
      +   b*d2T(reshape(yc(p9+1:p10),m));    

    By(ns(1)+ns(2)+1:end) = ...
          a*d1T(reshape(yc(p6+1:p7),m(1)-1,m(2),m(3)+1)) ...
      +   a*d2T(reshape(yc(p7+1:p8),m(1),m(2)-1,m(3)+1)) ...
      +   a*d3T(reshape(yc(p8+1:p9),m)) ...
      +   b*d3T(reshape(yc(p9+1:p10),m));    
   
  case {'mfCurvature-By-2','mfCurvature-BTy-2'},
    %
    % By = | \Delta y^1 0          | = | d_1^2 y^1 + d_2^2 y^1 |
    %      | 0          \Delta y^2 | = | d_1^2 y^2 + d_2^2 y^2 |   
    yc = reshape(yc,[m,2]);
    d2 = @(i) D2(i,omega,m);
    yc(:,:,1) = d2(1)*yc(:,:,1) + yc(:,:,1)*d2(2);
    yc(:,:,2) = d2(1)*yc(:,:,2) + yc(:,:,2)*d2(2);
    By = yc(:);
  
  case {'mfCurvature-By-3','mfCurvature-BTy-3'},
    %
    %      | \Delta y^1 0          0          | = | d_1^2 y^1 + d_2^2 y^1 + d_3^2 y^1 |
    % By = | 0          \Delta y^2 0          | = | d_1^2 y^2 + d_2^2 y^2 + d_3^2 y^2 |   
    %      | 0          0          \Delta y^3 | = | d_1^2 y^3 + d_2^2 y^3 + d_3^2 y^3 |   

    % efficient implementation of Bcurvature*Y	
    n  = prod(m);            % number of voxels
    yc = reshape(yc,[m,3]);  % note that now yc(:,:,:,ell) is the ell-th
                             % component of Y=(Y^1,Y^2,Y^3)
                             % of size m(1)-by-m(2)-by-m(3)
    By = zeros(numel(yc),1); % allocate memory for the output
    d2 = @(i) D2(i,omega,m); % this is a shortcut to the discrete second derivative

    % the following line is a shortcut for 
    %  - permuting the 3d-array using the permutation J
    %  - reshape it to a 2D-array of size q-by-prod(m)/q, where q=m(J(1))
    %  - multiply by A (which is q-by-q)
    %  - undo the reshape, i.e. make the result to m(J(1))-by-m(J(2))-by-m(J(3))
    %  - undo the permutation
    operate = @(A,z,J) ipermute(reshape(A*reshape(permute(z,J),m(J(1)),[]),m(J)),J);

    % run over all compunents y^ell of Y=(Y^1,Y^2,Y^3)
    for ell=1:3,
      % compute
      % (I_3\otimes I_2\otimes d2(1) + I_3\otimes d2(2)\otimes I_1 ...
      % + d2(3)\otimes I_2\otimes I_1) y^ell
      for k=1:3,
        z = operate(d2(k),yc(:,:,:,ell),[k,setdiff(1:3,k)]);
        By((ell-1)*n+(1:n)) = By((ell-1)*n+(1:n)) + reshape(z,[],1);
      end;
    end;
    
  case 'mfTPS-By-2',
    % up to sdcaling (sqrt(2) for the mixed derivatives) 
    %      | d_1^2 y^1            |
    %      | d1d2  Y^1            |
    % By = | d_2^2 Y^1            |
    %      |            d_1^2 y^2 |
    %      |            d1d2  Y^2 |
    %      |            d_2^2 Y^2 |
    
    yc = reshape(yc,[m,2]);
    n = prod(m);
    By = zeros(6*n,1);
    d1 = @(i) D1(i,omega,m);
    d2 = @(i) spdiags(ones(m(i),1)*[1,-2,1],-1:1,m(i),m(i))/h(i)^2;
    J  = @(i) (i-1)*n + (1:n);

    By(J(1)) =         reshape(d2(1)*yc(:,:,1),[],1);
    By(J(2)) = sqrt(2)*reshape(d1(1)*yc(:,:,1)*d1(2)',[],1);
    By(J(3)) =         reshape(yc(:,:,1)*d2(2),[],1);
    By(J(4)) =         reshape(d2(1)*yc(:,:,2),[],1);
    By(J(5)) = sqrt(2)*reshape(d1(1)*yc(:,:,2)*d1(2)',[],1);
    By(J(6)) =         reshape(yc(:,:,2)*d2(2),[],1);

  case 'mfTPS-BTy-2',
    % up to sdcaling (sqrt(2) for the mixed derivatives) 
    %  
    % BTz = [
    %    d_1^2 z^1 + d1d2  z^2 + d_2^2 z^3 
    %    d_1^2 z^4 + d1d2  z^5 + d_2^2 z^6 
    %  ]
    
    yc = reshape(yc,[m,6]);
    n  = prod(m);
    d1 = @(i) D1(i,omega,m);
    d2 = @(i) spdiags(ones(m(i),1)*[1,-2,1],-1:1,m(i),m(i))/h(i)^2;

    By = [...
              reshape(d2(1)*yc(:,:,1),[],1)       + ...
      sqrt(2)*reshape(d1(1)'*yc(:,:,2)*d1(2),[],1) + ...
              reshape(yc(:,:,3)*d2(2),[],1)       
              reshape(d2(1)*yc(:,:,4),[],1)       + ...
      sqrt(2)*reshape(d1(1)'*yc(:,:,5)*d1(2),[],1) + ...
              reshape(yc(:,:,6)*d2(2),[],1)];

  case 'mfTPS-By-3',
    % up to sdcaling (sqrt(2) for the mixed derivatives) 
    %  
    %      | d_1^2 y^1                         |
    %      | d_2^2 y^1                         |
    %      | d_3^2 Y^1                         |
    %      | d1d2  Y^1                         |
    %      | d1d3  y^1                         |
    %      | d2d3  y^1                         |
    %      |             d_1^2 y^2             |
    %      |             d_2^2 y^2             |
    % By = |             d_3^2 Y^2             |
    %      |             d1d2  Y^2             |
    %      |             d1d3  y^2             |
    %      |             d2d3  y^2             |
    %      |                         d_1^2 y^3 |
    %      |                         d_2^2 y^3 |
    %      |                         d_3^2 Y^3 |
    %      |                         d1d2  Y^3 |
    %      |                         d1d3  y^3 |
    %      |                         d2d3  y^3 |
    
    yc = reshape(yc,[m,3]);
    n = prod(m);
    By = zeros(18*n,1); 
    
    d1 = @(i) D1(i,omega,m);
    d2 = @(i) spdiags(ones(m(i),1)*[1,-2,1],-1:1,m(i),m(i))/h(i)^2;
    J  = @(i) (i-1)*n + (1:n);
 
    % permute the volume, such that direction L(1) is leading
    % reshape to [m(L(1)),prod(m)/m(L(1))]
    % multiply by A
    % undo reshape and permute
    operate = @(A,z,L) ipermute(reshape(A*reshape(permute(z,L),m(L(1)),[]),m(L)),L);
    
    k = 0;
    for ell = 1:3,
      z = yc(:,:,:,ell);

      k = k+1; % d_1^2 * z
      By(J(k)) = operate(d2(1),z,[1,2,3]);
      k = k+1; % d_2^2 * z
      By(J(k)) = operate(d2(2),z,[2,1,3]);
      k = k+1; % d_3^2 * z
      By(J(k)) = operate(d2(3),z,[3,1,2]);
      

      % mixed derivativs
      % d1 y^ell
      z = operate(d1(1),z,[1,2,3]);
      
      k = k+1; % d2d1 y^ell
      By(J(k)) = sqrt(2)*operate(d1(2),z,[2,1,3]);
      k = k+1; % d3d1 y^ell
      By(J(k)) = sqrt(2)*operate(d1(3),z,[3,1,2]);

      % d1 y^ell
      z = operate(d1(2),yc(:,:,:,ell),[2,1,3]);
      k = k+1; % d3d2 y^ell
      By(J(k)) = sqrt(2)*operate(d1(3),z,[3,1,2]);
    end;      

  case 'mfTPS-BTy-3',
    % up to sdcaling (sqrt(2) for the mixed derivatives)
    %  
    % BTz = [ 
    %  d_1^2 z^1    + d_2^2 z^2    + d_3^2 z^3    + d1d2 z^4    + d1d3 z^5    + d2d3z^6
    %  d_1^2 z^7    + d_2^2 z^8    + d_3^2 z^9    + d1d2 z^{10} + d1d3 z^{11} + d2d3z^{12}
    %  d_1^2 z^{13} + d_2^2 z^{14} + d_3^2 z^{15} + d1d2 z^{16} + d1d3 z^{17} + d2d3z^{18}
    %  ]

    
    yc = reshape(yc,[m,18]);
    n = prod(m);
    d1 = @(i) D1(i,omega,m);
    d2 = @(i) spdiags(ones(m(i),1)*[1,-2,1],-1:1,m(i),m(i))/h(i)^2;
    vec = @(A) reshape(A,[],1);
    operate = @(A,z,L) ipermute(reshape(A*reshape(permute(z,L),m(L(1)),[]),m(L)),L);
 
    
 %operate(d1(2),,[2,1,3]) + ...
    By = [...
      vec(operate(d2(1),yc(:,:,:, 1),[1,2,3])) + ...
      vec(operate(d2(2),yc(:,:,:, 2),[2,1,3])) + ...
      vec(operate(d2(3),yc(:,:,:, 3),[3,1,2])) + ...
      sqrt(2)*vec(operate(d1(2)',operate(d1(1)',yc(:,:,:, 4),[1,2,3]),[2,1,3])) + ...
      sqrt(2)*vec(operate(d1(3)',operate(d1(1)',yc(:,:,:, 5),[1,2,3]),[3,1,2])) + ...
      sqrt(2)*vec(operate(d1(3)',operate(d1(2)',yc(:,:,:, 6),[2,1,3]),[3,1,2]))
      
      vec(operate(d2(1),yc(:,:,:, 7),[1,2,3])) + ...
      vec(operate(d2(2),yc(:,:,:, 8),[2,1,3])) + ...
      vec(operate(d2(3),yc(:,:,:, 9),[3,1,2])) + ...
      sqrt(2)*vec(operate(d1(2)',operate(d1(1)',yc(:,:,:,10),[1,2,3]),[2,1,3])) + ...
      sqrt(2)*vec(operate(d1(3)',operate(d1(1)',yc(:,:,:,11),[1,2,3]),[3,1,2])) + ...
      sqrt(2)*vec(operate(d1(3)',operate(d1(2)',yc(:,:,:,12),[2,1,3]),[3,1,2])) 
      
      vec(operate(d2(1),yc(:,:,:, 13),[1,2,3])) + ...
      vec(operate(d2(2),yc(:,:,:, 14),[2,1,3])) + ...
      vec(operate(d2(3),yc(:,:,:, 15),[3,1,2])) + ...
      sqrt(2)*vec(operate(d1(2)',operate(d1(1)',yc(:,:,:,16),[1,2,3]),[2,1,3])) + ...
      sqrt(2)*vec(operate(d1(3)',operate(d1(1)',yc(:,:,:,17),[1,2,3]),[3,1,2])) + ...
      sqrt(2)*vec(operate(d1(3)',operate(d1(2)',yc(:,:,:,18),[2,1,3]),[3,1,2])) 
      ];
    
  otherwise, error(flag)
end;

function y = d1t(Y) 
m = size(Y);
y = zeros(m+[1,0,0]);
y(1,:,:) = -Y(1,:,:);
y(2:end-1,:,:) = Y(1:end-1,:,:)-Y(2:end,:,:);
y(end,:,:) = Y(end,:,:);
function y = d2t(Y) 
m = size(Y);
y = zeros(m+[0,1,0]);
y(:,1,:) = -Y(:,1,:);
y(:,2:end-1,:) = Y(:,1:end-1,:)-Y(:,2:end,:);
y(:,end,:) = Y(:,end,:);
function y = d3t(Y) 
m = size(Y); if length(m) == 2, m = [m,1]; end;
y = zeros(m+[0,0,1]);
y(:,:,1) = -Y(:,:,1);
y(:,:,2:end-1) = Y(:,:,1:end-1)-Y(:,:,2:end);
y(:,:,end) = Y(:,:,end);

function D = D1(i,omega,m)
h = (omega(2:2:end)-omega(1:2:end))./m;
D = spdiags(ones(m(i),1)*[-1,0,1],-1:1,m(i),m(i))/(2*h(i));
D([1,end]) = D([2,end-1]);

function D = D2(i,omega,m)
h = (omega(2:2:end)-omega(1:2:end))./m;
D = spdiags(ones(m(i),1)*[1,-2,1],-1:1,m(i),m(i))/h(i)^2;
D([1,end]) = -D([2,end-1]);

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

