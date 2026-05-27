% Test interpolation schemes
% (c) Jan Modersitzki 2009/04/06, see FAIR.2 and FAIRcopyright.m.
% ----------------------------------------------------------------------------------------

FAIRdiary
mode = 'edit+run+move'


for chapter = 9,
  files = getFiles(fullfile(fairPath,'E9'),sprintf('e%d*',chapter));
  
  for kExample = 1:length(files)
    FAIRprint('set','draft','on');
    file = files{kExample}
    fprintf('\n\n%s:\n',file);
    
    

    if ~isempty(findstr(mode,'run')),
      save dummy
      eval(file); pause(2); close all
      load dummy
    end;
    
    if ~isempty(findstr(mode,'move')),
      shortfile = sprintf('E%s.m',file(2:end));
      src = fullfile(fairPath,'E9',[file,'.m']);
      dst = fullfile(fairPath,'examples',shortfile);
      eval(sprintf('!mv %s %s',src,dst));
    end;

    if ~isempty(findstr(mode,'edit')),
      edit(shortfile)
    end;

%     return

  end;
end;
return




diary off
% =========================================================================
% clean up
fprintf('%s%s\n',mfilename,' testing done! .... ');
pause(2); close all; clc
% =========================================================================
