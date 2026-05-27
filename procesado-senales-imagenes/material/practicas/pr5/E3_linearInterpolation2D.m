%$ example for linear interpolation in 2D
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

dataT = flipud([1,2,3,4;1,2,3,4;4,4,4,4])'; 
m     = size(dataT); 
omega = [0,m(1),0,m(2)]; 
M     = {m,10*m};   % two resolutions, coarse and fine
xc = reshape(getCenteredGrid(omega,M{1}),[],2);     % coarse resolution
xf = reshape(getCenteredGrid(omega,M{2}),[M{2},2]); % fine   resolution
Tc = linearInter2D(dataT,omega,xc(:));
Tf = linearInter2D(dataT,omega,xf(:));
clf; ph = plot3(xc(:,1),xc(:,2),Tc(:),'ro'); hold on;
qh = surf(xf(:,:,1),xf(:,:,2),reshape(Tf,M{2}));
