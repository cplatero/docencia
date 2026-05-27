% wrapper for tests while calling a tutorial
function run = runThis(file,str,varargin)

tests = 0;
if tests,
  run = 0;
  fprintf('%% %-24s %s\n',[file,':'],str);
%   edit(file)
  return
end;

tests = 1;
for k=1:2:length(varargin), % overwrites default parameter 
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

folder = pwd; 
if ~isempty(findstr(folder,'tests')),
  run = tests; 
else
  run = input(sprintf('%-60s | <0,1> : ',[str,' ?']));
end;
if ~run,            return; end;
if isempty(file),   return; end;
eval(file);
