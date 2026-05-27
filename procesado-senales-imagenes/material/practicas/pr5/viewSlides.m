% =======================================================================================
% function vh = viewSlides(T,omega,m,varargin)
% (c) Jan Modersitzki 2008/07/29, see FAIR and FAIRcopyright.m.
%
% visualizes a 3D image as slides
%
% Input:
%   T           discretized image
%   omega		describing the domain
%	m 			number of discretization points
%   varargin    optional parameters like {'axis','off'}
%
% Output:
%  ih			image handle
%  B			the mosaic image
%  frames       number of frames for ij-directions
% =======================================================================================

function vh = viewSlides(T,omega,m,varargin)

% set default parameter
s1 = round(m(1)/2);
s2 = round(m(2)/2);
s3 = round(m(3)/2);
threshold = min(T(:))+0.1*(max(T(:))-min(T(:)));

for k=1:2:length(varargin), % overwrites default parameter
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

T  = reshape(T,m);
X  = reshape(getCenteredGrid(omega,m),[m,3]);

% show ortho-slices to first dimension
vh = []; h = [];
for i=1:length(s1),
  x1 = squeeze(X(s1(i),:,:,1));
  x2 = squeeze(X(s1(i),:,:,2));
  x3 = squeeze(X(s1(i),:,:,3));
  Ti = squeeze(T(s1(i),:,:));
  
  sh(i) = surf(x1,x2,x3);
  hi = findobj('type','surface');
  h(end+1) = hi(1);
  set(h(end),'CData',Ti,'FaceColor','texturemap','edgecolor','none');
end;
vh = [vh;h]; h = [];

% show ortho-slices to second dimension
for i=1:length(s2),
  x1 = squeeze(X(:,s2(i),:,1));
  x2 = squeeze(X(:,s2(i),:,2));
  x3 = squeeze(X(:,s2(i),:,3));
  Ti = squeeze(T(:,s2(i),:));
  
  sh(i) = surf(x1,x2,x3);
  hi = findobj('type','surface');
  h(end+1) = hi(1);
  set(h(end),'CData',Ti,'FaceColor','texturemap','edgecolor','none');
end;
vh = [vh;h]; h = [];

% show ortho-slices to third dimension
for i=1:length(s3),
  x1 = squeeze(X(:,:,s3(i),1));
  x2 = squeeze(X(:,:,s3(i),2));
  x3 = squeeze(X(:,:,s3(i),3));
  Ti = squeeze(T(:,:,s3(i)));
  
  sh(i) = surf(x1,x2,x3);
  hi = findobj('type','surface');
  h(end+1) = hi(1);
  set(h(end),'CData',Ti,'FaceColor','texturemap','edgecolor','none');
end;
vh = [vh;h];


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
