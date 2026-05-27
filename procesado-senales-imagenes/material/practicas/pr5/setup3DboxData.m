% Initializing 3D brain data to be used in FAIR.
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%
% data originates from Ron Kikinis,
% -----------------------------------------------------------------------------

outfile = [mfilename('fullpath'),'.mat'];
example = '3Dbox';

if exist('rebuild','var'), makeNew = rebuild; else makeNew = 0; end;

if ~makeNew && exist(outfile,'file'),
  load(outfile);
  viewImage('reset',viewOptn{:});
  inter('reset',intOptn{:});
  trafo('reset',traOptn{:});
  distance('reset',disOptn{:});
  regularizer('reset',regOptn{:});
  reportStatus
  return
end;

message = @(str) fprintf('%% %s  [ %s ]  % s\n',...
  char(ones(1,10)*'-'),str,char(ones(1,60-length(str))*'-'));
message(mfilename)

viewOptn = {'viewImage','imgmontage','colormap','bone(256)'};
viewImage('reset',viewOptn{:});

omega = [0,1,0,1,0,1];
m = [64,64,64]/8;
xc = getCenteredGrid(omega,m);
xc = reshape(xc,[],3);
dataT = (abs(xc(:,1)-0.5) < 0.25) & (abs(xc(:,2)-0.5) < 0.2)& (abs(xc(:,3)-0.5) < 0.22);
xc  = xc(:);
dataT = 200*reshape(dataT,m);
wc = reshape([eye(3),[-0.1;0;0]]',[],1);
yc = affine3D(wc,xc);
dataR = reshape(linearInter3D(dataT,omega,yc),m);

FAIRfigure(1,'position',[1200,700,1200,800]); clf;
viewImage(dataT,omega,m);
FAIRfigure(2,'position',[1200,200,1200,800]); clf;
viewImage(dataR,omega,m);

% set-up interpolation scheme
[int,intOptn] = inter('reset','inter','linearInter3D');

% set-up  transformation used in the parametric part
[tra,traOptn] = trafo('reset','trafo','affine3D');

MLdata = getMultilevel({dataT,dataR},omega,m,'fig',2);

% set-up distance measure
[dis,disOptn] = distance('reset','distance','SSD');

% initialize the regularizer for the non-parametric part
[reg,regOptn] = regularizer('reset','regularizer','mfElastic',...
  'alpha',1,'mu',1,'lambda',0);

% save to outfile
save(outfile,'dataT','dataR','omega','m',...
  'MLdata','viewOptn','intOptn','traOptn','disOptn','regOptn');
