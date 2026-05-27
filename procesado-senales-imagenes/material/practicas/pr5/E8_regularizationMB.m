%$ (c) Jan Modersitzki 2009/03/25, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              
%$ Example for usage of regularization
%$ (c) Jan Modersitzki 2009/04/02, see FAIR.2 and FAIRcopyright.m.
%$ illustrates the usage of L2-norm based regularization
%$
%$  S(y) = alpha/2 * norm(B*(y-yRef))^2,
%$
%$ where
%$  alpha regularization parameter, weights regularization versus 
%$        distance in the joint objective function, alpha = 1 here
%$  yRef  is a reference configuration, e.g. yRef = x or a 
%$        pre-registration result
%$  B     a discrete partial differential operator either in explicit
%$        matrix form or as a structure containing the necessary
%$        parameters to compute B*y, see also mfBy.m
%$

% initialize the regularization and create a starting  point
regularizer('reset','regularizer','mbElastic','alpha',1,'mu',1,'lambda',0);
y0 = @(omega,m) randn(size(getStaggeredGrid(omega,m)));

% 2D example, initialize physical domain and number of discretization points
omega = [0,1,0,1]; m = [16,12];   % 

% test derivative of 2D implementation
fctn = @(yc) regularizer(yc,omega,m);  checkDerivative(fctn,y0(omega,m));

% 3D example, initialize physical domain and number of discretization points
omega = [0,1,0,1,0,1]; m  = [16,12,8];

% test derivative of 3D implementation
fctn = @(yc) regularizer(yc,omega,m); checkDerivative(fctn,y0(omega,m));