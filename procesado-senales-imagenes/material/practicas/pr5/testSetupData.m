% ==============================================================================
function testSetupData

FAIRdiary

clear = @() []; % fools matlab's clear command and most likely also me

message = @(str) fprintf('%% %s[   %s   ]%s\n',...
  char(ones(1,10)*'-'),str,char(ones(1,60-length(str))*'-'));

message(mfilename)
fprintf('\n\n\n')
list = {'dataT','omega','MLdata','m','viewOptn'};
% setup*
files  = getFiles(fullfile(fairPath,'examples'),'setup*');
for j = 1:length(files); 
  message(['test ',files{j}]);
  mat = which([files{j},'.mat']);
  if ~isempty(mat), delete(mat); end;
  eval(files{j});
  if ~ismember(files{j},list),
    error('missing variable');
  end;
end;
pause(2)
diary off

close all;
return;

function OK = ismember(matfile,var)
what = whos('-file',matfile);
OK = 1;
for k=1:length(var),
  if isempty(find(strcmp({what(:).name},var{k})==1));
    OK = 0; error(var{k}); 
  end;
end;
