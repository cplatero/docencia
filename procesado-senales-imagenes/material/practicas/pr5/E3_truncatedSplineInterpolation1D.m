%$ examples for truncated spline interpolation in 1D
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

dataT  = [0,2,2,2,1]'; omega = [0,5]; m = length(dataT);  % initialize some data
xc = linspace(omega(1)-1,omega(2)+1,101);                 % fine discretization 
Tc = @(T) book_splineInter1D(T,omega,xc);                  % spline interpolant 
B  = spdiags(ones(m,1)*[1,4,1],[-1:1],m,m);               % spline basis
% D  = spdiags(ones(m,1)*[-1,1],[0,1],m-1,m);             % derivative operation
% M  = toeplitz([96,-54,0,6,zeros(1,m-4)]);               % second derivative 

clf; ph = plot(getCenteredGrid(omega,m),dataT,'.k',xc,Tc(B\dataT),'k-'); hold on;
d = 1./(4+2*cos((1:m)'*pi/(m+1)));
V = sqrt(2/(m+1))*sin((1:m)'*(1:m)*pi/(m+1));
style = {'-','--','-.','.','-'}; col   = 'krgbmc';
for q=2:4,
  c= V'*diag([d(1:q);zeros(m-q,1)])*(V*dataT);
  ph(q+1) = plot(xc,Tc(c),style{q},'color',col(q),'linewidth',1.5); 
end;
