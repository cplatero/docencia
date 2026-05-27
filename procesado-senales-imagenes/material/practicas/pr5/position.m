function p = position(p);

s   = get(0,'screensize');
if ~exist('p','var'), p = 1; end;
pos = @(a,b) [s(3)-a+1-10,s(4)-b+1-100, a b];
if p == 1;
  p = pos(1200,800);
elseif length(p) == 1,
  p = pos(1200,p);
elseif length(p) == 2;
  p = pos(p(2),p(1));
end;
