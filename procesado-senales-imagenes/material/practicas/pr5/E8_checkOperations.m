% Tutorial for regularization
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.
%
% illustrates the tools for L2-norm based regularization
%
%  S(y) = alpha/2 * norm(B*(y-yRef)^2,
%
% here: solving the matrix free version usinf multigrid
% where
%  alpha regularization parameter, weights regularization versus 
%        distance in the joint objective function, alpha = 1 here
%  yRef  is a reference configuration, e.g. yRef = x or a 
%        pre-registration result
%  B     a discrete partial differential operator either in explicit
%        matrix form or as a structure containing the necessary
%        parameters to compute B*y, see also mfBy.m
%

alpha  = 1; % regularization parameter, irrelevant in this tutorial
mu     = 1; % Lame constants, control elasticity properties like
lambda = 0; % Youngs modulus and Poisson ratio


% 3D example
omega  = [0,4,0,2,0,1]; % physical domin
m      = [32,16,8];     % number of discretization points
yRef   = getStaggeredGrid(omega,m); % reference for regularization
yc     = rand(size(yRef));          % random transformation

% build elasticity operator on a staggered grid
B = getElasticMatrixStg(omega,m,mu,lambda);
FAIRfigure(1); clf;
spy(B); title('B elastic on staggered grid')


regularizer('reset','regularizer','mfElastic',...
  'alpha',alpha,'mu',mu,'lambda',lambda);
regularizer('disp');

hd  = prod((omega(2:2:end)-omega(1:2:end))./m);
mbA = hd*alpha*B'*B;

[S,dS,d2S] = regularizer(yc-yRef,omega,m);

fprintf('difference: |explicit computation - S(yc)| = %s\n',...
  num2str(abs(0.5*alpha*(yc-yRef)'*mbA*(yc-yRef)-S)));

% check elasticity
H.omega  = omega;
H.m      = m;
H.alpha  = regularizer('get','alpha');
H.mu     = regularizer('get','mu');
H.lambda = regularizer('get','lambda');
H.regularizer = regularizer;


B  = getElasticMatrixStg(omega,m,H.mu,H.lambda);
xc = getStaggeredGrid(omega,m);
yc = randn(size(xc));
By = B*yc;
testMF  = norm(By-mfBy(yc,H,'By'));
testMFT = norm(B'*By-mfBy(By,H,'BTy'));
hd = prod((omega(2:2:end)-omega(1:2:end))./m);
fprintf('|By-mfBy|=%s, |B''*By-mfBy''|=%s\n',num2str(testMF),num2str(testMFT));

% ---------------------------------------------------------------------
% using multigrid to solve A uc = fc, where A = I + alpha*hd*B'*B

xc  = getStaggeredGrid(omega,m);
M   = speye(length(xc),length(xc)); % idenity matrix
A   = M + hd*alpha*B'*B;
fc  = A*xc;
u0  = zeros(size(xc));

% prepare for multigrid
H.MGlevel      = log2(m(1))+1;
H.MGcycle      = 4;
H.MGomega      = 2/3;   %% !!! 0.5 should be better
H.MGsmoother   = 'mfJacobi';
H.MGpresmooth  = 10;
H.MGpostsmooth = 10;
H.M            = M;

uMG = mfvcycle(H,u0,fc,1e-12,H.MGlevel,5);
testMG = norm( A\fc - uMG);
fprintf('|A\\fc-uMG|=%s\n',num2str(testMG));

