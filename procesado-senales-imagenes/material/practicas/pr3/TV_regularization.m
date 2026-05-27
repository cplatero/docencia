% nameFich='W07_10_90.jpg'
% niter = 200;
% epsilon = 1e-2;
% lambda = .2;
% TV_regularization(nameFich,niter,lambda,epsilon)

function TV_regularization(nameFich,niter,lambda,epsilon)
%% Toolbox Peyre
getd = @(pt)path(pt,path);
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_signal/');
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_general/');
getd('D:/compartido/cplatero/misce/wavelets/fuentes/peyre/toolbox_signal/');
getd('D:/compartido/cplatero/misce/wavelets/fuentes/peyre/toolbox_general/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_signal/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_general/');


tau = 2 / ( 1 + lambda * 8 / epsilon);
y = im2double(imread(nameFich));
energy=zeros(niter,1);
fTV = y;
for i=1:niter
    Gr = grad(fTV);
    d = sqrt(sum3(Gr.^2,3));
    G0 = -div( Gr ./ repmat( sqrt( epsilon^2 + d.^2 ) , [1 1 2]) );
    G = fTV-y+lambda*G0;
    deps = sqrt( epsilon^2 + d.^2 );
    energy(i) = 1/2*norm( y-fTV,'fro' )^2 + lambda*sum(deps(:));
    fTV = fTV - tau*G;
end
clf;
figure(1);
plot(energy);
figure(2);
imshow([y,fTV]);