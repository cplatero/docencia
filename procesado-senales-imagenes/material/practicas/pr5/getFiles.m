% =======================================================================================
% function files = getFiles(folder,pattern)
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
% 
% returns all mfiles with patter [pattern] in folder [folder]
% =======================================================================================
function files = getFiles(folder,pattern)

files = {};
if ~(exist(folder) == 7),
  fprintf('\n\n%s: folder [%s] does not exists!\n\n',mfilename,folder);
  return
end;

pattern = fullfile(folder,[pattern,'.m']);
files = dir(pattern);
fprintf('%s: found %d files of pattern %s\n',mfilename,length(files),pattern);
files = {files(:).name};
for k=1:length(files), files{k} = files{k}(1:end-2); end;