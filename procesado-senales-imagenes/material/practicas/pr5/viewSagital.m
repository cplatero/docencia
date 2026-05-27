function viewSagital(im3D,dx)
im3D=single(im3D);
im3D=im3D/max(im3D(:));
T0 = maketform('affine',[-dx(2) 0; 0 -1; 0 0]);
R2 = makeresampler({'cubic','nearest'},'fill');
[nx,~,~]=size(im3D);
% k=12:2:nx-24;
k=1:2:nx;

nxx=length(k);
[ny,nz]=size(imtransform(squeeze(im3D(1,:,:))',T0,R2));
imOut = zeros(ny,nz,nxx);
for j=1:nxx
   imOut(:,:,j)= imtransform(squeeze(im3D(k(j),:,:))',T0,R2);
end
% clear D;
D(:,:,1,:)=imOut;
% figure;
montage(D);
end