% Initializing HNSP data to be used in FAIR.
% Data courtesy Oliver Schmitt, Institute of Anatomy, University of Rostock, Germany
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
% -----------------------------------------------------------------------------

outfile = [mfilename('fullpath'),'.mat'];
example = 'Avion';

if exist(outfile,'file'),
  load(outfile);
  viewImage('reset',viewOptn{:});
  inter('reset',interOptn{:});
  return
end;

% set view options and interpolation options
viewOptn = {'viewImage','viewImage2D','colormap','gray(256)'};
viewImage('reset',viewOptn{:});

message = @(str) fprintf('%% %s  [ %s ]  % s\n',...
  char(ones(1,10)*'-'),str,char(ones(1,60-length(str))*'-'));
message(mfilename)

% get2Ddata(outfile,'HNSP-T.jpg','HNSP-R.jpg',...
%   'omega',[0,2,0,1],'m',[512,256]);