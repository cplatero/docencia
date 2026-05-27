%$ example for linear interpolation in 2D
%$ Comparative between FAIR & Matlab                            

function E3_linearInterpolation2D_CPD

%dataT = flipud([1,2,3,4;1,2,3,4;4,4,4,4])';
dataT = im2double(imread('cameraman.tif'));
m     = size(dataT); 
omega = [0,m(1),0,m(2)]; 
M     = {ceil(m/10),ceil(m/2)};   % two resolutions, coarse and fine

%% FAIR & Matlab
tic;
xc = reshape(getCenteredGrid(omega,M{1}),[],2);     % coarse resolution
Tc = linearInter2D(dataT,omega,xc(:));toc
tic;
Tc2 = imresize(dataT,M{1},'bilinear');toc


tic;
xf = reshape(getCenteredGrid(omega,M{2}),[M{2},2]); % fine   resolution
Tf = linearInter2D(dataT,omega,xf(:));toc
tic;
Tf2 = imresize(dataT,M{2},'bilinear');toc

%% Visualization
figure(1);imshow([reshape(Tc,M{1}),Tc2]);
figure(2);imshow([reshape(Tf,M{2}),Tf2]);

%clf; ph = plot3(xc(:,1),xc(:,2),Tc(:),'ro'); hold on;
%qh = surf(xf(:,:,1),xf(:,:,2),reshape(Tf,M{2}));


