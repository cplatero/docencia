% Initializing Knee data to be used in FAIR.
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%
% data originates from Thomas Netsch, Philips Medical Solutions, Hamburg
% -----------------------------------------------------------------------------

outfile = fullfile(fairPath,'temp',[mfilename,'.mat']);
example = '3Dknee';

if exist('rebuild','var'), makeNew = rebuild; else makeNew = 0; end;

if ~makeNew && exist(outfile,'file'),
  load(outfile);
  viewImage('reset',viewOptn{:});
  viewImage('set','viewImage','imgmontage','direction','-zyx','colormap','bone(256)')

  inter('reset',intOptn{:});
  trafo('reset',traOptn{:});
  distance('reset',disOptn{:});
  regularizer('reset',regOptn{:});
  regularizer('set','alpha',500)
  reportStatus
  return
end;

prefix = sprintf('CH9-%s-',example);


viewK = @(T) volView(T,omega,m,'isovalue',15,'view',[-20,-5],'colormap','bone(256)');

FAIRfigure(1,'position','default'); clf; 
viewK(dataT); hold on;
axis off; colormap(gray(128)); %% plotBox(omega,7)
set(1,'color','w')
FAIRprint('T0','folder','temp','prefix',prefix,'obj','gcf','rect',[295,84,654,654])

FAIRfigure(2,'position','default'); clf; 
viewK(dataR); hold on;
axis off; colormap(gray(128)); %% plotBox(omega,7)
set(2,'color','w')
FAIRprint('R0','folder','temp','prefix',prefix,'obj','gcf','rect',[295,84,654,654])


% set-up view options
viewOptn = {'viewImage','volView','isovalue',15,'view',[-20,-5],'colormap','bone(256)'};
viewImage('reset',viewOptn{:});


% set-up interpolation scheme
[int,intOptn] = inter('reset','inter','linearInter3D');

% set-up  transformation used in the parametric part
[tra,traOptn] = trafo('reset','trafo','affine3D');

% set-up distance measure
[dis,disOptn] = distance('reset','distance','SSD');

% initialize the regularizer for the non-parametric part
[reg,regOptn] = regularizer('reset','regularizer','mfElastic','alpha',100,'mu',1,'lambda',0);


load(fullfile(fairPath,'..','add-ons','examples','createPhilipsKnees.mat'));

FAIRfigure(1,'figname',mfilename); clf;
subplot(1,2,1); viewImage(dataT,omega,m); title('template');
subplot(1,2,2); viewImage(dataR,omega,m); title('reference');

MLdata = getMultilevel({dataT,dataR},omega,m,'fig',2);

% save to outfile
save(outfile,'outfile','dataT','dataR','omega','m',...
  'MLdata','viewOptn','intOptn','traOptn','disOptn','regOptn');
load(outfile);