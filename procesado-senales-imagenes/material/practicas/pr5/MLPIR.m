% =======================================================================================
% function [wOpt,his] = MLPIR(MLdata,varargin)
% (c) Jan Modersitzki 2008/07/29, see FAIR and FAIRcopyright.m.
%
% Multi-Level Parametric Image Registration
%
% minimizes J^h(w) = D^h(T(Y(w)),R) + S^h(w) for h=coarse:fine
% uses PIR [=@GaussNewtonArmijo]  for optimization
%               
% Input:
%   MLdata  		struct of coarse to fine representations of the data, 
%               see getMultilevel.m
%	varagin     optinonal parameters, see below
% Output:
%  wOpt         optimal parameter for the parametric part
%  MLhis        iteration history
%
% for level=minLevel:maxLevel,
%   get data(level)
%   if level>minLevel, w0 = wOpt; end;
%   get wOpt running PIR  using w0 as starting guess
% end%For
%
% =======================================================================================

function [wOpt,his] = MLPIR(MLdata,varargin)

% set default output and input variables
his        = [];                 % iteration history
w0         = trafo('w0');        % starting guess
wStop      = w0;                 % global stopping
beta       = 0;                  % regularization: H -> H + beta*I
wRef       = w0;                 % regularization: (w-wRef)'*M*(w-wRef)
M          = [];                 %
PIR        = @GaussNewtonArmijo; % optimizer for PIR
Plots      = @FAIRplots;         % plots for optimizer
maxIter    = 10;                 % maximum number of iterations
plotIter   = 0;                  % plot iteration history each level
plotMLiter = 0;                  % plot summarized iteration history
pause      = 0;                  % do pause i nbetween

[MLdata,minLevel,maxLevel] = getMultilevel(MLdata);

for k=1:2:length(varargin),   % overwrites default parameter
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

message = @(str) fprintf('%% %s  [ %s ]  % s\n',...
  char(ones(1,10)*'='),str,char(ones(1,60-length(str))*'='));
dimstr  = @(m) sprintf('[%s]',sprintf(' %d',m));
message([mfilename,' (JM 2008/05/28)']);

reportStatus(sprintf('%s, minLevel=%d:maxLevel=%d',...
  'MultiLevel Parametric Image Registration',minLevel,maxLevel));

omega = MLdata{end}.omega;

% -- for loop over all levels ---------------------------------------------
for level=minLevel:maxLevel;

  message(sprintf('%s: level %d from %d to %d, %s',...
    mfilename,level,minLevel,maxLevel,dimstr(MLdata{level}.m)));

  
  % get data for current level, compute interpolation coefficients
  m     = MLdata{level}.m; 
  [T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega);
  
  % update transformation
  trafo('set','omega',omega,'m',m);

  % initialize plots
  FAIRplots('set','mode','PIR-multi level','fig',level,'plots',1);
  FAIRplots('init',struct('Tc',T,'Rc',R,'omega',omega,'m',m)); 

  
  

  % ----- call PIR ------------------------------------
  xc   = getCenteredGrid(omega,m); 
  Rc   = inter(R,omega,xc);
  fctn = @(wc) PIRobjFctn(T,Rc,omega,m,beta,M,wRef,xc,wc);
  if level == minLevel, 
    fctn([]);   % report status
  else
    w0 = wOpt;  % update starting guess
  end; 
  optn = {'maxIter',maxIter,'tolG',1e0','yStop',wStop,...
    'solver',[],'Plots',@FAIRplots};
  [wOpt,hisPIR] = PIR(fctn,w0,optn{:});
  % ----- end PIR --------------------------------------

  if plotIter,                                                
    plotIterationHistory(hisPIR,'J',[1,2,5],'fig',20+level);  
  end;                                                        
  
  % update iteration history
  if level == minLevel,
    his.str = hisPIR.str;
    his.his = [];
  end;
  doPause(pause)
  his.his = [his.his;hisPIR.his];
  
end;%for level
% -- for loop over all levels ---------------------------------------------

if plotMLiter,
  plotMLIterationHistory(his,'fig',30);
end;
message([mfilename,' : done !']);

% =======================================================================================

function doPause(p)
if ~isempty(findstr(pwd,'tests')), pause(1/100); return; end;
if strcmp(p,'on'), pause; elseif p>0, pause(p); end;

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
