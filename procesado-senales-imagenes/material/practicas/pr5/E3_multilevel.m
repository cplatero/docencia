%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupHNSPData; 
omega = MLdata{end}.omega; m = MLdata{end}.m;
distance('reset','distance','SSD');
inter('reset','inter','splineInter2D');
lMax = length(MLdata);
m  = @(l) MLdata{l}.m
xc = @(l) getCenteredGrid(omega,m(l));

Name  = @(c,l) sprintf('ML%c-%d',c,l)
Write = @(c,l,R,m) imwrite(uint8(flipud(reshape(R,m)')),...
  fullfile(fairPath,'temp',[Name(c,l),'.jpg']));

for level=3:length(MLdata);
  R = inter('coefficients',MLdata{level}.R,[],omega);
  Rc = inter(R,omega,xc(level));
  Rf = inter(R,omega,xc(lMax));
  figure(level); clf;
  subplot(1,2,1); viewImage(Rf,omega,m(lMax));
  subplot(1,2,2); viewImage(Rc,omega,m(level)); pause(1/6);
%   Write('f',level,Rf,m(lMax));
%   Write('c',level,Rc,m(level));
end;
