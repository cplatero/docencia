% Tutorial for FAIR: 1D interpolation: DERIVATIVES
% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%
% set-up data
% display and visualize data
% compute interpolants Tfctn(x) = spline(TD,omega,x) and 
% check derivative
%
% the tutorial explores the derivative of the interpolant Tfctn
clear, close all, help(mfilename);


% set-up data
fprintf('%s\n','generate some data');

%                     x
%                                              T
%             x               x 
% |---x---|---+---|---+---|---+---|---x---|    x
% 0                                       omega

omega = [0,14];         % x data is located in intervall [omega(1),omega(2)]
dataX = 1:2:omega(2);   % data location x(j) and values T(j)
dataT = [0;0;1;4;1;0;0];% the data
fprintf('[dataX;dataT]=\n'); disp(reshape([dataX(:);dataT(:)],[],2)')

% prepare continuous medel
coefT = getSplineCoefficients(dataT,'dim',1,'out',0);
T     = @(x) splineInter1D(coefT,omega,x);

% output:display
fprintf('%s\n','visualize the data')

% output:plot
figure(1); clf; 
ph = plot(dataX,0*dataT,'k.',dataX,dataT,'b.','markersize',20); hold on; 
title('1D interpolation with derivatives','fontsize',20); 
axis([omega(1)-1,omega(2)+1,min(dataT)-1,max(dataT)+1]);
xFine = getCenteredGrid(omega,101);
ph(3) = plot(xFine,T(xFine),'b-','linewidth',3);
lstr = {'location','data','T'}; legend(ph,lstr,1);
FAIRpause;

% play with derivatives: get some interestin points
yc = getCenteredGrid(omega,9);
[Tc,dT] = T(yc);

% grep diagonal of dT
dT = full(diag(dT)); dx = 0.35*diff(omega)./length(yc);

for j=1:length(yc),
  qh=plot(yc(j),Tc(j),'m.',yc(j)+dx*[-1,1],Tc(j)+dT(j)*dx*[-1,1],'m-',...
    'markersize',20,'linewidth',2);
end;
lstr{end+1}= 'derivative';
legend([ph;qh(end)],lstr,1)
FAIRpause;

% the ultimative derivative check: for MATLAB and FAIR
x = omega(1)+diff(omega)*randn(15,1);
Mfctn = @(x) linearMatlab1D(coefT,omega,x);
checkDerivative(Mfctn,x);
ylabel('MATLAB linear interpolation','fontsize',30);
set(gca,'fontsize',30);

checkDerivative(T,x);
ylabel('FAIR spline interpolation','fontsize',30);
set(gca,'fontsize',30);
