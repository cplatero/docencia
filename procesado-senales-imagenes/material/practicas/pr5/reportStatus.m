% function reportStatus(str)
% (c) Jan Modersitzki 2008/08/12, see FAIR and FAIRcopyright.m.
% reports current setting

function reportStatus(str)

if ~exist('str','var'), str = 'current FAIR setting'; end;

fprintf('%% %s[   %s   ]%s\n',...
  char(ones(1,4)*'='),str,char(ones(1,66-length(str))*'='));

viewImage('disp');
inter('disp');
distance('disp');
trafo('disp');
regularizer('disp');
fprintf('%% %s\n',char(ones(1,80)*'='));
