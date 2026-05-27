% Initializing 2D data to be used in FAIR.
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
%
% This file creates outfile.mat where the following data is to be stored: 
% dataT      interpolation data for template
% dataR      interpolation data for reference
% omegaT     = [left,right,bottom,top] template domain
% omegaR     = [left,right,bottom,top] reference domain
% m          size for finest representation, 
% MLdata     multilevel representation of data, see getMultilevel for details
% viewOptn   options for image viewer
% interOptn  options for image interpolation
% -----------------------------------------------------------------------------

function setup2Ddata(outfile,fileT,fileR,varargin)

if exist(outfile,'file'),
  fprintf('[%s] %s exists\n',mfilename,outfile);
  return
end;

omega  = [];
m      = [];

for k=1:2:length(varargin), % overwrite defaults  
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;


txt = {
  'creates '
  ' - dataT:    data for templateimage, d-array of size p'
  ' - dataR:    data for reference image, d-array of size q'
  ' - omega:    coding domain = [omega(1),omega(2)]x...x[omega(2*d-1),omega(2*d)]'
  '             note: omega(1,:) for T' 
  '                   omega(end,:) for all others'
  ' - m:        size of the finest interpolation grid'
  ' - MLdata:   MLdata representation of the data'
  };
fprintf('%s\n',txt{:});

% do whatever needed to be done to get your data here
image = @(str) double(flipud(imread(str))'); % reads and converts

% load the original data, set domain, initial discretization, and grid
dataT = image(fileT); 
dataR = image(fileR);

if isempty(omega), omega = [0,size(dataT,1),0,size(dataT,2)];  end;
if isempty(m),     m     = size(dataR);                        end;
caller = dbstack; caller = caller(2).name;

inter('reset','inter','linearInter2D');
interOptn = {'inter','linearInter2D'};
[viewer,viewOptn] = viewImage;


omegaI = @(i) omega(min(i,size(omega,1)),:);
xc = @(k) getCenteredGrid(omegaI(k),m);

viewData  = @(I,k) viewImage(inter(I,omegaI(k),xc(k)),omegaI(k),m);

FAIRfigure(1,'figname',caller); clf;
subplot(1,2,1); viewData(dataT,1); title('template');
subplot(1,2,2); viewData(dataR,2); title('reference');

MLdata = getMultilevel({dataT,dataR},omega,m,'fig',2);

% save to outfile
save(outfile,'dataT','dataR','omega','m',...
  'MLdata','viewOptn','interOptn');

