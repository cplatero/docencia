% unified framework for diary files
caller = dbstack;               % identify the name of the calling function
caller = caller(2).name;
diaryFile = fullfile(fairPath,'temp',[date,'-',caller,'.asc']);
if exist(diaryFile), delete(diaryFile); end;
diary(diaryFile);

fprintf('=============================================================================\n');
fprintf('FAIR: 2008/12/31 create log for %s\n',caller)
fprintf('      ==> write log to %s\n',diaryFile);
fprintf('=============================================================================\n');

