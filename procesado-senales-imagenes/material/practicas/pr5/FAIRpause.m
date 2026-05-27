% wrapper for pauses during tests
function FAIRpause(varargin)
if ~isempty(findstr(pwd,'tests')), pause(1/100); return; end;
fprintf('...pause...');
pause(varargin{:});
fprintf('\n');
