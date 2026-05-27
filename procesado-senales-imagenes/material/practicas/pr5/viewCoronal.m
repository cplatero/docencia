function viewCoronal(im3D)
im3D=single(im3D);
im3D=im3D/max(im3D(:));
T0 = maketform('affine',[0 -1; 1 0; 0 0]);
R2 = makeresampler({'cubic','nearest'},'fill');
[nx,ny,nz]=size(im3D);
imOut = zeros(nz,nx,ny);
for k=1:ny
   imOut(:,:,k)= imtransform(squeeze(im3D(:,k,:)),T0,R2);
end
D(:,:,1,:)=imOut;
% figure;
montage(D);
end