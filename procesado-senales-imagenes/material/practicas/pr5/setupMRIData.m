% Initializing data to be used in FAIR.
% Original data: http://www.bic.mni.mcgill.ca/brainweb/
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
% -----------------------------------------------------------------------------

outfile = [mfilename('fullpath'),'.mat'];
example = 'MRI-head';

if exist(outfile,'file'),
  load(outfile);
  viewImage('reset',viewOptn{:});
  inter('reset',interOptn{:});
  return
end;

% set view options and interpolation options
viewOptn = {'viewImage','viewImage2D','colormap','bone(256)'};
viewImage('reset',viewOptn{:});

message = @(str) fprintf('%% %s  [ %s ]  % s\n',...
  char(ones(1,10)*'-'),str,char(ones(1,60-length(str))*'-'));
message(mfilename)

get2Ddata(outfile,'MRIhead-T.jpg','MRIhead-R.jpg',...
  'omegaT',[0,20,0,20],'omegaR',[0,20,0,20]);

