%# Test regularizers
%# (C) 2007/04/25, Jan Modersitzki, see FAIR.

FAIRdiary

alpha  = 1;
mu     = 1;
lambda = 0;

% tset syntax
regularizer('clear');
regularizer('disp');
regularizer('reset','regularizer','mfElastic',...
  'alpha',alpha,'mu',mu,'lambda',lambda);
regularizer('disp');
[a,b,c] = regularizer

omega = [0,1,0,1];
m = [32,32]/8;

% check elasticity
H.omega  = omega; 
H.m      = m; 
H.alpha  = regularizer('get','alpha');
H.mu     = regularizer('get','mu');
H.lambda = regularizer('get','lambda');
H.regularizer = regularizer;


B  = getElasticMatrixStg(omega,m,H.mu,H.lambda);
X  = getStaggeredGrid(omega,m);
Y  = randn(size(X));
By = B*Y;
testMF  = norm(By-mfBy(Y,H,'By'));
testMFT = norm(B'*By-mfBy(By,H,'BTy'));
hd = prod((omega(2:2:end)-omega(1:2:end))./m);
fprintf('|By-mfBy|=%s, |B''*By-mfBy''|=%s\n',num2str(testMF),num2str(testMFT));


% ---------------------------------------------------------------------
M   = spdiags(1+0*Y,0,length(Y),length(Y));
A   = M + hd*regularizer('get','alpha')*B'*B;
X   = getStaggeredGrid(omega,m);
rhs = A*X;
% rhs = A(:,5);
u0  = zeros(size(Y));

% prepare for multigrid
H.MGlevel      = log2(m(1))+1;
H.MGcycle      = 4;
H.MGomega      = 2/3;   %% !!! 0.5 should be better
H.MGsmoother   = 'mfJacobi';
H.MGpresmooth  = 10;
H.MGpostsmooth = 10;
H.M            = M;

Zmg = mfvcycle(H,u0,rhs,1e-12,H.MGlevel,5);
testMG = norm( A\rhs-Zmg);
fprintf('|A\\rhs-uMG|=%s\n',num2str(testMG));

%%
Omega = {[0,1,0,2],[0,1,0,2,0,3]};
M = {[4,5],[3,4,5]};
alpha = 1; mu = 1; lambda = 0;

for j=1:length(Omega),
  
  omega = Omega{j}; m = M{j}; 
  fprintf('dimension d=%d\n',length(omega))
  
  
  % the elastic version
  fprintf('the elastic version\n')
  X = getStaggeredGrid(omega,m);
  Y = randn(size(X));
  B = getElasticMatrixStg(Omega{j},M{j},1,0);
  regularizer('reset','regularizer','mfElastic','alpha',alpha,'mu',mu,'lambda',lambda);
  [S,dS,MF] = regularizer(X,Omega{j},M{j});
  
  By1 = B*Y;
  By2 = mfBy(Y,MF);
  
  testBy = norm(By1 - By2);
  fprintf('%-20s = %s\n','norm(By1 - By2)',num2str(testBy))
  
  Z = randn(size(By1));
  BTz1 = B'*Z;
  BTz2 = mfBy(Z,MF,'BTy');
  
  testBTz = norm(BTz1 - BTz2);
  fprintf('%-20s = %s\n','norm(BTz1 - BTz2)',num2str(testBTz))
  
  % the curvature version
  fprintf('the curvature version\n')
  X = getCenteredGrid(omega,m);
  Y = randn(size(X));
  B = getCurvatureMatrix(Omega{j},M{j});
  regularizer('reset','regularizer','mfCurvature','alpha',alpha);
  [S,dS,MF] = regularizer(X,Omega{j},M{j});
  
  By1 = B*Y;
  By2 = mfBy(Y,MF);
  
  testBy = norm(By1 - By2);
  fprintf('%-20s = %s\n','norm(By1 - By2)',num2str(testBy))
  
  Z = randn(size(By1));
  BTz1 = B'*Z;
  BTz2 = mfBy(Z,MF,'BTy');
  
  testBTz = norm(BTz1 - BTz2);
  fprintf('%-20s = %s\n','norm(BTz1 - BTz2)',num2str(testBTz))
  
  % the TPS version
  fprintf('the TPS version\n')
  X = getCenteredGrid(omega,m);
  Y = randn(size(X));
  B = getTPSMatrix(Omega{j},M{j});
  regularizer('reset','regularizer','mfTPS','alpha',alpha);
  [S,dS,MF] = regularizer(X,Omega{j},M{j});
  
  By1 = B*Y;
  By2 = mfBy(Y,MF);
  
  testBy = norm(By1 - By2);
  fprintf('%-20s = %s\n','norm(By1 - By2)',num2str(testBy))
  %%
  Z = randn(size(By1));
  BTz1 = B'*Z;
  BTz2 = mfBy(Z,MF,'BTy');
  
  testBTz = norm(BTz1 - BTz2);
  fprintf('%-20s = %s\n','norm(BTz1 - BTz2)',num2str(testBTz))
end;
diary off
close all; clc;



 












