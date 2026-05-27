function testAvionAffin
clear all;close all;
%% Mediante momentos de segundo orden
tic;
R_BW =im2bw(imread('Avion/avion1.jpg'));R_BW([1,end],:)=false;
T_BW =im2bw(imread('Avion/avion2.jpg'));T_BW([1,end],:)=false;
% R_BW = imrotate(R_BW,gradRot);
Tc_BW = mom2DBWAfin(R_BW,T_BW,0);
figure;imshow([R_BW,T_BW,Tc_BW]);
MSE = sum((R_BW(:)-Tc_BW(:)).^2)/size(R_BW,1)/size(R_BW,2)
toc
pause;

%% Mediante registro
tic;
% initialize the interpolation scheme and coefficients
inter('set','inter','splineInter2D'); 

R_BW =im2bw(imread('Avion/avion1.jpg'));R_BW([1,end],:)=false;
T_BW =im2bw(imread('Avion/avion2.jpg'));T_BW([1,end],:)=false;
% R_BW = imrotate(R_BW,20);


level = 4;
omega = [0 size(R_BW,1) 0 size(R_BW,2)]; m = size(R_BW); 
% [T,R] = inter('coefficients',double(T_BW*255),double(R_BW*255),omega);
[T,R] = inter('coefficients',convertSmoothModel(T_BW),...
                convertSmoothModel(R_BW),omega);

%% PIR
xc = getCenteredGrid(omega,m); 
Rc = inter(R,omega,xc);

% initialize distance measure
distance('set','distance','SSD');       

% initialize the transformation and a starting guess
trafo('reset','trafo','affine2D');
w0 = trafo('w0'); 

% build objective function
% note: T  is template image
%       Rc is sampled reference
%       optional Tichonov-regularization is disabled by setting m = [], wRef = []
%       beta = 0 disables regularization of Hessian approximation
beta = 0; M = []; wRef = [];
fctn = @(wc) PIRobjFctn(T,Rc,omega,m,beta,M,wRef,xc,wc); 
%fctn([]);   % report status

% -- solve the optimization problem -------------------------------------------
[wc,his] = GaussNewtonArmijo(fctn,w0,'solver',[],'maxIter',100);

yc = trafo(wc,xc);
Tc = inter(T,omega,yc);
Tc_BW = reshape(Tc>128,m);
toc;
figure;imshow([R_BW,T_BW,Tc_BW]);
MSE = sum((R_BW(:)-Tc_BW(:)).^2)/m(1)/m(2)
