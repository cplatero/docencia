% Tutorial for FAIR: 1D interpolation: BASICS
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
% \url{http://www.cas.mcmaster.ca/~fair/index.shtml}
%
% setup data
% display and visualize data
% compute interpolants (MATLAB, linear, spline) and visualize
%
% This is a very basic example for the interpolation of 1D data (x(j),T(j)), j=1:m
% The data is displayed and visualized, the interpolant is computed and visualized
% interpolation models are MATAB, FAIR linear, and FAIR spline
clear, close all, help(mfilename);

% setup data
fprintf('%s\n','generate some data');

%                     x
%                                              T
%             x               x 
% |---x---|---+---|---+---|---+---|---x---|    x
% 0                                       omega

omega = [0,14],;          % x data is located in intervall [omega(1),omega(2)]
dataX = 1:2:omega(2);     % data location x(j) and values T(j)
dataT = [0;0;1;4;1;0;0];  % the data

fprintf('[x;T]=\n')
disp(reshape([dataX(:);dataT(:)],[],2)')

% output:display
fprintf('%s\n','visualize the data')

% output:plot
figure(1); clf; 
ph = plot(dataX,0*dataT,'k.',dataX,dataT,'b.','markersize',20); hold on;
title('1D interpolation','fontsize',20); 
axis([omega(1)-1,omega(2)+1,min(dataT)-1,max(dataT)+1]);
lstr = {'location','data'}; legend(ph,lstr,1);
FAIRpause;

% discretization for the visualization of the interpolant
m  = 101; % discretization for the model
xc = getCenteredGrid(omega,m);

% interpolation using MATLAB, FAIR linear, and FAIR spline 

fprintf('%s\n','MATLAB interpolation')
Tc = interp1(dataX,dataT,xc,'linear'); Tc(isnan(Tc)) = 0;
lstr{3} = 'MATLAB'; ph(3) = plot(xc,Tc,'b-','linewidth',3); 
legend(ph,lstr,1)
FAIRpause;

fprintf('%s\n','FAIR linear interpolation')
Tc = linearInter1D(dataT,omega,xc);
lstr{4} = 'linear'; ph(4) = plot(xc,Tc,'r-','linewidth',3);
legend(ph,lstr,1)
FAIRpause;

fprintf('%s\n','FAIR spline interpolation')
Tcoeff = getSplineCoefficients(dataT,'dim',1,'out',0);
Tc = splineInter1D(Tcoeff,omega,xc);
lstr{5} = 'spline'; ph(5) = plot(xc,Tc,'g-','linewidth',3);
legend(ph,lstr,1)
