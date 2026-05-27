%$ examples for spline interpolation in 2D
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

dataT = flipud([1,2,3,4;1,2,3,4;4,4,4,4])'; 
m     = size(dataT); 
omega = [0,m(1),0,m(2)]; 
M     = {m,10*m};   % two resolutions
xc    = reshape(getCenteredGrid(omega,M{1}),[],2);
xf    = reshape(getCenteredGrid(omega,M{2}),[M{2},2]);

B  = @(i) spdiags(ones(m(i),1)*[1,4,1],[-1:1],m(i),m(i));
T  = B(1)\dataT/B(2);
Tc = book_splineInter2D(T,omega,xc(:));
Tf = book_splineInter2D(T,omega,xf(:));

clf;
ph  = plot3(xc(:,1),xc(:,2),Tc(:),'ro');    hold on;
qh = surf(xf(:,:,1),xf(:,:,2),reshape(Tf,M{2}));
