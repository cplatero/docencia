% Initializing 3D brain data to be used in FAIR.
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%
% data originates from Ron Kikinis, 
% -----------------------------------------------------------------------------

outfile = fullfile(fairPath,'temp',[mfilename,'.mat']);
example = '3Dbrain';

if exist(outfile,'file'),
  load(outfile);
  viewImage('reset',viewOptn{:});
  inter('reset',intOptn{:});
  trafo('reset',traOptn{:});
  distance('reset',disOptn{:});
  regularizer('reset',regOptn{:});
  reportStatus
  return
end;

% set view options and interpolation options
viewOptn = {'viewImage','viewImage2D','colormap','bone(256)'};
viewImage('reset',viewOptn{:});

message = @(str) fprintf('%% %s  [ %s ]  % s\n',...
  char(ones(1,10)*'-'),str,char(ones(1,60-length(str))*'-'));
message(mfilename)


% load multilevel representation of data
load brain3D

% set-up image viewer,
[viewer,viewOptn] = viewImage('reset','viewImage','imgmontage',...
  'colormap','gray(256)','direction','-zyx');

% set-up interpolation scheme
[int,intOptn] = inter('reset','inter','linearInter3D');

% set-up  transformation used in the parametric part
[tra,traOptn] = trafo('reset','trafo','affine3D');

% set-up distance measure
[dis,disOptn] = distance('reset','distance','SSD');

% initialize the regularizer for the non-parametric part
[reg,regOptn] = regularizer('reset','regularizer','mfCurvature','alpha',100);
[reg,regOptn] = regularizer('reset','regularizer','mfElastic','alpha',1000,'mu',1,'lambda',0);

omegaI = @(i) omega(min(i,size(omega,1)),:);
xc = @(k) getCenteredGrid(omegaI(k),m);

viewData  = @(I,k) viewImage(inter(I,omegaI(k),xc(k)),omegaI(k),m);

FAIRfigure(1,'figname',mfilename); clf;
subplot(1,2,1); viewData(dataT,1); title('template');
subplot(1,2,2); viewData(dataR,2); title('reference');

MLdata = getMultilevel({dataT,dataR},omega,m,'fig',2);

% save to outfile
% save(outfile,'outfile','dataT','dataR','omega','m',...
%   'MLdata','viewOptn','intOptn','traOptn','disOptn','regOptn');
