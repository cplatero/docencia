function startup

fprintf('\n%% %s\n',char('='*ones(78,1)));
fprintf('FAIR: Flexible Algorithms for Image Registration\n');
fprintf('(c) Jan Modersitzki  -- 2009/01/30\n');

fprintf('Set path on [%s], pwd is [%s]\n',computer,pwd);
f = fopen('fairPath.m','w');
str = sprintf('function value=fairPath; value=''%s'';',pwd);
fprintf('  -  %s\n',str);
fprintf(f,'%s\n',str);
fclose(f);

folder = dir(fairPath);
fprintf('  - addpath %s\n',pwd);
addpath(pwd);
for i=1:length(folder)
  if folder(i).isdir && ~(folder(i).name(1) == '.') && ~(folder(i).name(1) == '#'),
    f = fullfile(fairPath,folder(i).name);
    fprintf('  - addpath %s\n',f);
    addpath(f);
  end;
end;
%opengl hardware
fprintf('%% %s\n',char('='*ones(78,1)));

fprintf('[new to FAIR? type: help tutorials and/or run BigTutorial2D]\n');

% fprintf('add book\n')
% addpath(fullfile(fairPath,'..','add-ons','book'));

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

