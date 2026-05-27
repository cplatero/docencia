function demo_reg2D()
clear all; clf; close all;
% Read two greyscale images of Lena
  Imoving=imread('images/lenag1.png'); 
  Istatic=imread('images/lenag3.png');

  % Register the images
  [Ireg,Bx,By,Fx,Fy] = register_images(Imoving,Istatic,struct('Similarity','p'));

  % Show the registration result
  figure,
  subplot(2,2,1), imshow(Imoving); title('moving image');
  subplot(2,2,2), imshow(Istatic); title('static image');
  subplot(2,2,3), imshow(Ireg); title('registerd moving image');
  % Show also the static image transformed to the moving image
  Ireg2=movepixels(Istatic,Fx,Fy);
  subplot(2,2,4), imshow(Ireg2); title('registerd static image');

 % Show the transformation fields
  figure,
  subplot(2,2,1), imshow(Bx,[]); title('Backward Transf. in x direction');
  subplot(2,2,2), imshow(Fx,[]); title('Forward Transf. in x direction');
  subplot(2,2,3), imshow(By,[]); title('Backward Transf. in y direction');
  subplot(2,2,4), imshow(Fy,[]); title('Forward Transf. in y direction');

% Calculate strain tensors
  E = strain(Fx,Fy);
% Show the strain tensors
  figure,
  subplot(2,2,1), imshow(E(:,:,1,1),[]); title('Strain Tensors Exx');
  subplot(2,2,2), imshow(E(:,:,1,2),[]); title('Strain Tensors Exy');
  subplot(2,2,3), imshow(E(:,:,2,1),[]); title('Strain Tensors Eyx');
  subplot(2,2,4), imshow(E(:,:,2,2),[]); title('Strain Tensors Eyy');
  pause;

% Example Multi-Modalities
  % Read two brain images 
  Imoving=im2double(imread('images/brain_T1_wave.png')); 
  Istatic=im2double(imread('images/brain_T2.png'));

  % Register the images
  [Ireg,Bx,By] = register_images(Imoving,Istatic,struct('SigmaFluid',4));

  figure,
  subplot(1,3,1), imshow(Imoving); title('moving image');
  subplot(1,3,2), imshow(Istatic); title('static image');
  subplot(1,3,3), imshow(Ireg); title('registerd moving image');

  % Read normal T1 image and transformation field
  Inormal=im2double(imread('images/brain_T1.png'));
  load('images/wave_field.mat');

  % Show the difference with ideal image
  figure, imshow(Imoving-Inormal,[-0.5 0.5]); title('unregistered')
  figure, imshow(Ireg-Inormal,[-0.5 0.5]); title('registered');
  disp(['pixel abs difference : ' num2str(sum(abs(Imoving(:)-Inormal(:))))])
  disp(['pixel abs difference : ' num2str(sum(abs(Imoving(:)-Ireg(:))))])

  % Show Warp field
  figure,
  subplot(2,2,1), imshow(BxNormal,[-20 20]); title('Bx Normal');
  subplot(2,2,2), imshow(Bx,[-20 20]); title('Bx');
  subplot(2,2,3), imshow(ByNormal,[-20 20]); title('By Normal');
  subplot(2,2,4), imshow(By,[-20 20]); title('By');

end