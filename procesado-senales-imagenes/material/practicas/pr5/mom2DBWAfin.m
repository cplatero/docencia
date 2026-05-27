% function Tc_BW= mom2DBWAfin(R_BW,T_BW,gradRot,fig)
% R_BW: Modelo referencia
% T_BW: Modelo a transformar
% gradRot : grados a desplazar el modelo de referencia
% Ejemplo de registro
% function testMom2DBWAfin
% R_BW =im2bw(imread('Avion/avion1.jpg'));R_BW([1,end],:)=false;
% T_BW =im2bw(imread('Avion/avion2.jpg'));T_BW([1,end],:)=false;
% figure;imshow([R_BW,T_BW]);
% % R_BW = imrotate(R_BW,gradRot);
% Tc_BW = mom2DBWAfin(R_BW,T_BW,1);
% MSE = sum((R_BW(:)-Tc_BW(:)).^2)/size(R_BW,1)/size(R_BW,2);


function Tc_BW= mom2DBWAfin(R_BW,T_BW,fig)

affineVector = getAffineVector(R_BW);
[Tc_BW,T_BW] = aligningBinaryMomentImage(T_BW,R_BW,affineVector);

%Visualization
if(fig)
    figure;
    imshow([R_BW,Tc_BW])
end









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% Auxilary functions
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function affineVectorBW = getAffineVector(BWMod)
%% Canonical image
[x1,x2]=find(BWMod);

%first and second central moments
cdg_Mod = mean([x1,x2]);
affineVectorBW(1)=cdg_Mod(1);
affineVectorBW(2)=cdg_Mod(2);
areaObj = size(x1,1);
d10 = (x1-cdg_Mod(1));
d01 = (x2-cdg_Mod(2));
m20 = sum(d10.*d10)/(areaObj-1);
m02 = sum(d01.*d01)/(areaObj-1);
m11 = sum(d10.*d01)/(areaObj-1);
detAux =((m20-m02)^2 +(4*m11*m11))^.5;
varMod(1)= (m20+m02+detAux)/2;
varMod(2)= (m20+m02-detAux)/2;

affineVectorBW(3)=varMod(1);
affineVectorBW(4)=varMod(2);

theta = atan((m02-m20+detAux)/2/m11);

affineVectorBW(5)=theta;



function [BWAlignModel,BWModMof] = aligningBinaryMomentImage(BWModel,BWRef,affineVector)
%% aligning Binary Images
cdg_Ref=[affineVector(1);affineVector(2)];
[x1,x2]=find(BWModel);

%The same size BWModel and BWRef
[nxRef,nyRef]=size(BWRef);
[nxMod,nyMod]=size(BWModel);
if([nxRef,nyRef] ~= [nxMod,nyMod])
    xIni = floor((nxRef - nxMod)/2);
    yIni = floor((nyRef - nyMod)/2);
    BWModMof=false([nxRef,nyRef]);
    BWModMof(xIni:xIni+nxMod-1,yIni:yIni+nyMod-1)=BWModel;
else
    BWModMof=BWModel;
end
    
%% first and second normalized central moments
areaObj = size(x1,1);
cdg_Mod = mean([x1,x2]);
d10 = (x1-cdg_Mod(1));
d01 = (x2-cdg_Mod(2));
m20 = sum(d10.*d10)/(areaObj-1);
m02 = sum(d01.*d01)/(areaObj-1);
m11 = sum(d10.*d01)/(areaObj-1);
detAux =((m20-m02)^2 +(4*m11*m11))^.5;
varMod(1)= (m20+m02+detAux)/2;
varMod(2)= (m20+m02-detAux)/2;


theta = atan((m02-m20+detAux)/2/m11);
theta = -theta;%canonical form
eig_D=[cos(theta) -sin(theta);sin(theta) cos(theta)];


%% Resize matrix
% % weight as PC
% W=[(affineVector(3)/varMod(1))^.5,0;0,(affineVector(4)/varMod(2))^.5];

% scale
c_ref=(affineVector(3)*affineVector(4))^(1/4);
c_nor=(varMod(1)*varMod(2))^(1/4);
W=[c_ref/c_nor,0;0,c_ref/c_nor];

%% Rotation matrix
% alfa =(180-affineVector(5))*pi/180;
alfa =affineVector(5);
rotForm = [cos(alfa),-sin(alfa);sin(alfa),cos(alfa)];

%% Affine matrix
% affineMatrix = eig_D;
affineMatrix = rotForm*W*eig_D;

y1=((x1-cdg_Mod(1))*affineMatrix(1,1))+((x2-cdg_Mod(2))*affineMatrix(1,2));
y2=((x1-cdg_Mod(1))*affineMatrix(2,1))+((x2-cdg_Mod(2))*affineMatrix(2,2));
[nx,ny]=size(BWRef);
BWAlignModel=false([nx,ny]);
BWAlignModel(sub2ind([nx,ny],round(y1+cdg_Ref(1)),round(y2+cdg_Ref(2))))=1;

%% Interpolation
BWAlignModel = imfilter(im2double(BWAlignModel),fspecial('gaussian'))>0.1;
BWAlignModel = imfill(BWAlignModel,'holes');
se=strel('square',3);
BWAlignModel = imerode(BWAlignModel,se);
