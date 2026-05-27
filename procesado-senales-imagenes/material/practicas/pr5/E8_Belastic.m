% Tutorial for FAIR
% (c) Jan Modersitzki 2009/04/07, see FAIR.2 and FAIRcopyright.m.

clc, clear, close all
fprintf('=============================================================================\n');
fprintf('FAIR: (JM: 2008/04/16) Tutorial on Discretized Elastic B\n')
fprintf('FAIR: <%s>\n',mfilename('fullpath'))
fprintf('=============================================================================\n');

% set parameter for the matrix based version
omega  = [0,1,0,2,0,3];
m      = [4,5,6];
mu     = 1; 
lambda = 1;
B = getElasticMatrixStg(omega,m,mu,lambda);

figure(1); clf; spy(B); set(gca,'fontsize',30)
xlabel(['nz = ' int2str(nnz(B))],'fontsize',30);

% set parameter for the matrix free version
MF.omega  = omega;
MF.m      = m;
MF.mu     = mu;
MF.lambda = lambda;
MF.regularizer = 'mfElastic';

yc = randn(size(B,2),1);
zc = randn(size(B,1),1);
compare = @(s,l,r) fprintf('%-25s = %s\n',s,num2str(norm(l-r)));
compare('||B*yc-mfBy(y)||',B*yc,mfBy(yc,MF,'By'));
compare('||B''*z-mfBy(z,''BTy'')||',B'*zc,mfBy(zc,MF,'BTy'));

fprintf('<%s> done!\n',mfilename); FAIRpause;


