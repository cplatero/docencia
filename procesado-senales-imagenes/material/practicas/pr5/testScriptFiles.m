function testScriptFiles(folder)

if ~exist('folder','var'), folder = 'data';  end;

clc
mfiles = dir(fullfile(folder,'*.m'));
J = find(folder == filesep);
if ~isempty(J),
  folder = folder(J+1:end)
end;
diaryFile = [folder,'.log'];

fprintf('%s of %s, %d mfiles, log -> %s\n',...
  mfilename,folder,length(mfiles),diaryFile)
pause(2);


if exist(diaryFile,'file'), delete(diaryFile); end;
log = fopen(diaryFile,'w');

for j=1:length(mfiles)
  file = mfiles(j).name;
  p = fopen(file,'r'); contents = fread(p,'char')'; fclose(p);
  if findstr(contents,'function'),
    fprintf('file %d/%d - %s - is propably a function and thus not called\n',...
      j,length(mfiles),file);
    fprintf(log,'file %d/%d - %s - is propably a function and thus not called\n',...
      j,length(mfiles),file);
  else
    fprintf('try %d/%d - %s\n',...
      j,length(mfiles),file);
    
    try
      [p,file] = fileparts(file);
      eval(file);
      fprintf(log,'%-50s OK\n',file)
    catch 
      fprintf(log,'-- %45s not OK\n',file);      
    end;
    
  end;
end;

fclose(log);
return;
