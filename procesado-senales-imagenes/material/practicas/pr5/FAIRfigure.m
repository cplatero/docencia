function varargout = FAIRfigure(fig,varargin)

figname  = '';
color    = [1,1,0.9];
position = [];
for k=1:2:length(varargin), % overwrite defaults  
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;


if nargin == 0,
  fig == [];
end;

if isempty(fig), fig = figure;  end;

fig     = figure(fig); 
figname = sprintf('[FAIR:%d] %s',fig,figname);
set(fig,'numbertitle','off','name',figname,'color',color);
% setPosition(fig,position)
if nargout == 1, varargout = {fig};  end;



function setPosition(fig,p);
f = 0;
if isempty(p), return;  end;
if strcmp(p,'default'), p=[800,1200]; f = fig; end;

s   = get(0,'screensize');
%pos = @(a,b) [s(3)+1-a-75-f*25,s(4)+1-b-100-f*25, a b];
pos = @(a,b) [f*25,s(4)+1-b-100-f*25, a b];
if p == 1;
  p = pos(1200,800);
elseif length(p) == 1,
  p = pos(1200,p);
elseif length(p) == 2;
  p = pos(p(2),p(1));
end;
set(fig,'position',p);