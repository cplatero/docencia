% =======================================================================================
% function [yc,wc,MLhis] = MLIR(MLdata,varargin)
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%
% Multi-Level Image Registration
%
% minimizes J^h(y) = D^h(T(y),R) + S^h(y) for h=coarse:fine
% uses PIR [=@GaussNewtonArmijo] and NPIR [=@GaussNewtonArmijo]
%               
% Input:
%   MLdata  	coarse to fine representations of the data, see getMultilevel.m
%   varagin     optinonal parameters, see below
% Output:
%   yc          numerical optimizer
%   wc          optimal parameters for PIR
%   MLhis       iteration history
%
% for level=minLevel:maxLevel,
%   get data(level)
%   if level==minLevel, get wOpt running PIR; end;
%   use pre-registered Yref=trafo(wOpt,X) for regularization
%   if level==minLevel
%     y0 = Ystop; % use this as starting guess
%   else
%     get y0 by prologating Yopt from coarse to finer level
%   end;
%   get Yopt running NPIR using y0 as starting guess
% end%For
%
% =======================================================================================

function [yc,wc,MLhis] = MLIR(MLdata,varargin)
% set-up default parameter
parametric  = 1;        % flag for parametric pre-registration
beta        = 0;        % regularization for Hessian in PIR
w0          = [];       % starting guess for PIR
wStop       = [];       % global stopping for PIR
wRef        = [];       % regularization: (w-wRef)'*M*(w-wRef)
M           = [];       %
maxIterPIR  = 50;       % maximum number of iterations for PIR    
maxIterNPIR = 10;       % maximum number of iterations for NPIR    
pause       = 0;        % flag for pauses
plots       = 1;        % flag for plots
plotIter    = 0;        % flag for output of iteration history each level
plotMLiter  = 1;        % flag for output of summarized iteration history
PIR         = @GaussNewtonArmijo; % optimizer to be used for PIR
PIRobj      = @PIRobjFctn;        % objective function for PIR
NPIR        = @GaussNewtonArmijo; % optimizer to be used for NPIR
NPIRobj     = @NPIRobjFctn;       % objective function for NPIR
yc = []; wc = []; MLhis = [];
% get minLevel and maxLevel from MLdata
[MLdata,minLevel,maxLevel] = getMultilevel(MLdata);

for k=1:2:length(varargin), % overwrites default parameter
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

% prepare nice output
message = @(str) fprintf('%% %s[   %s   ]%s\n',...
  char(ones(1,10)*'-'),str,char(ones(1,60-length(str))*'-'));
dimstr  = @(m) sprintf('[%s]',sprintf(' %d',m));

% initialization
omega   = MLdata{end}.omega;  % spatial domain
xc      = [];                 % current grid
grid    = regularizer('get','grid');
switch grid,
  case 'cell-centered', getGrid = @(m) getCenteredGrid(omega,m);
  case 'staggered',     getGrid = @(m) getStaggeredGrid(omega,m);
  otherwise, error('nyi');
end;

MLhis   = [];                 % multi-level iteration history
fprintf('\n\n');

fprintf('%s: MultiLevel Image Registration\n',mfilename)
fprintf('-- distance=%s, regularizer=%s, alpha=%s, trafo=%s\n',...
  distance,regularizer,num2str(regularizer('get','alpha')),trafo);

tic;
%--------------------------------------------------------------------------
for level=minLevel:maxLevel,

  message(sprintf('%s: level %d from %d to %d, %s',...
    mfilename,level,minLevel,maxLevel,dimstr(MLdata{level}.m)));

  % store old grid, update m, grid, and data coefficients
  xOld  = xc; 
  m     = MLdata{level}.m; 
  [T,R] = inter('coefficients',MLdata{level}.T,MLdata{level}.R,omega);
  xc    = getGrid(m);
  Rc    = inter(R,omega,center(xc,m));
    
  if level == minLevel && parametric, % parametrc pre-registration
    % initialize plots
    FAIRplots('reset','mode','PIR','fig',minLevel-1,'plots',plots);
    FAIRplots('init',struct('Tc',T,'Rc',R,'omega',omega,'m',m)); 

    % ----- call Parametric Image Registration ----------------------------
    fctn  = @(wc) PIRobj(T,Rc,omega,m,beta,M,wRef,center(xc,m),wc); 
    fctn([]); % report status of objective function
    if isempty(w0),    w0    = trafo('w0'); end;
    if isempty(wStop), wStop = w0;          end;
    optn = {'maxIter',maxIterPIR,'Plots',@FAIRplots,varargin{:},...
      'yStop',wStop,'solver','MATLAB'};
    [wc,his] = PIR(fctn,w0,optn{:});
    fprintf('wc = \n'); disp(wc');  doPause(pause);    
    % ----- end PIR --------------------------------------
    if plotIter,                              
      his.str{1} = 'iteration history for PIR'; 
      plotIterationHistory(his,'J',1:4,'fh',100+minLevel-1);
    end;                                      
  elseif level == minLevel, % no pre-registration
    wc = [];                                
  end;                                        
  
  % compute yRef = xc or yc = trafo(wc,xc) on the appropriate grid 
  if isempty(wc), % use yRef(x) = x
    yRef = xc;  
  else            % compute yn=y(wc,xNodal) and interpolate on current grid    
    yn   = trafo(wc,getNodalGrid(omega,m));   
    yRef = grid2grid(yn,m,'nodal',grid);  
  end;
    
  % compute starting guess y0
  if level == minLevel,
    y0 = yRef;  % the best known so far
  else
    % prolongate yc (coarse) y0 (current) 
    y0 = xc + mfPu(yc - xOld,omega,m/2);
  end;
  

  % ----- call NPIR -------------------------------------
  % S(y) = 0.5*alpha*hd*norm(B*(Y-Yref))^2
  % initialize plots for NPIR
  FAIRplots('reset','mode','NPIR','fig',level);
  FAIRplots('init',struct('Tc',T,'Rc',R,'omega',omega,'m',m)); 
  fctn = @(yc) NPIRobj(T,Rc,omega,m,yRef,yc); 
%   save dummy; return; 
  
  if level == minLevel, fctn([]);  end; % report status of objective function 
  optn ={'maxIter',maxIterNPIR,'yStop',xc,'Plots',@FAIRplots,varargin{:},'tolJ',1e-4};
  [yc,his] = NPIR(fctn,y0,optn{:});
  % ----- end NPIR --------------------------------------

  if plotIter,
    his.str{1} = sprintf('iteration history for NPIR, level=%d',level);
    plotIterationHistory(his,'J',1:4,'fh',100+level);
  end;

  % update iteration history
  if level == minLevel,
    MLhis.str = his.str;
    MLhis.his = his.his;
  else
    MLhis.his = [MLhis.his;his.his];
  end;
  doPause(pause);

%--------------------------------------------------------------------------
end;%For level
%--------------------------------------------------------------------------
MLhis.time = toc;
if plotMLiter,
  plotMLIterationHistory(MLhis,'fh',[]);
end;
MLhis.reduction = fctn(yc)/fctn(xc);
J = find(MLhis.his(:,1)==-1); 
MLhis.iter(minLevel:maxLevel) = MLhis.his([J(2:end)-1;size(his.his,1)],1)';

message([mfilename,' : done !']);



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
