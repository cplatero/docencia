function demoGeoCut(I,t_MRF,typeN,lambda_min, lambda_max, lambda_incr)

%% Energy & manual & sub-graph
g=getRiemanIsotropic2D(I);
mask_P = imdilate(bwareaopen(g<.25,50),strel('disk',10));
manual = imfilter(im2double(imfill(bwareaopen(g<.5,500),'holes')),...
    fspecial('gaussian',[9 9],1))>.75;

mask_Pin = manual & mask_P ==0;
mask_Pout = manual==0 & mask_P ==0;
aux=I;
aux(bwperim(manual))=1;
figure(1);
clf
imshow([aux,mask_P,mask_Pin,mask_Pout])
title('Manual, sub-graph, obj, bck');
% pause;

figure(2);
clf;
aux=I;
aux(bwperim(mask_P))=1;
subplot(1,2,1);
imshow(aux);
title('Sub-graph');
subplot(1,2,2);
imshow(g);
title('Reimann Metric');

%% Geo-Cut
typeMRF={'dist_pq','I_pq','modGrad','Ipq_dir','geoCutIso','geoCutAni'};
strMRF= struct('typeMRF',typeMRF{t_MRF},'dist_pq',[],'Img',[],...
    'modGrad',[],'mask_nlink',[],...
    'ux',[],'uy',[],'g',g);

mask_nlink = find(mask_P);
[height,width]=size(I);
if(typeN == 4)
    E_dist_select = edges4connectedEDistSelect(height,width,mask_nlink);
    K = 5;
else
    E_dist_select = edges8connectedEDistSelect(height,width,mask_nlink);
    K = 9;
    strMRF.dist_pq =1;
end
strMRF.mask_nlink = mask_nlink;

%% Table Boykov 01
Rp_bkg=zeros(height,width);
Rp_bkg(mask_Pout)=K;

Rp_obj=zeros(height,width);
Rp_obj(mask_Pin)=K;

%Sub-graph
mean_obj = mean(I(mask_Pin));
mean_bck = mean(I(mask_Pout));

Rp_bkg(mask_P) = K*(I(mask_P)-mean_obj).^2;
Rp_obj(mask_P) = K*(I(mask_P)-mean_bck).^2;



%% Oracle
lambda_list = linspace(lambda_min, lambda_max, lambda_incr);
m_error = zeros(length(lambda_list),1);

figure(3);
clf;
for j=1:length(lambda_list)
    lambda = lambda_list(j);
%     lambda_flow = 5;
%     [Rp_bkg,Rp_obj]= grayflow2(I,mask_P,Rp_bkg,Rp_obj,-lambda_flow);

    lambda_MRF_4N = lambda;
    [flow,labels] =graph2DBoykov(Rp_obj,Rp_bkg,lambda_MRF_4N,...
            E_dist_select,strMRF);
    m_error(j) = measure_error(manual,labels);
    fprintf('Medida de solapamiento de imagen con lambda %.2f: %.3f y flujo %.1f\n',...
        lambda,m_error(j),flow);
    subplot(1,length(lambda_list)+1,j);
    aux=I;
    aux(bwperim(labels))=1;
    imshow(aux);
    title(sprintf('lambda %.2f: %.3f ',lambda,m_error(j)));
end
subplot(1,length(lambda_list)+1,j+1);
aux=I;
aux(bwperim(manual))=1;
imshow(aux);
title('Ground Truth');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%Auxiliar
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function g=getRiemanIsotropic2D(I)
[Iy,Ix]=gradient(I);

modGrad = ((Ix.^2) + (Iy.^2)).^.5;
sigma_robust= mean(modGrad(:));
g = exp(-modGrad/2/sigma_robust).^.5;

function m_error = measure_error(BW_i,BW_j)
m_error = sum(BW_i(:) & BW_j(:))/sum(BW_i(:) | BW_j(:));

function [Rp_bkg,Rp_obj]= grayflow(I,maskImg,Rp_bkg,Rp_obj,lambda)
[Vy,Vx]=gradient(I);
Vy = Vy*lambda;
Vx = Vx*lambda;
[width,~] = size(I);


% Vx>0
maskP = find(Vx>=0 & maskImg);
Rp_bkg(maskP)=Rp_bkg(maskP)+Vx(maskP)/2;
Rp_obj(maskP+1)=Rp_obj(maskP+1)+Vx(maskP)/2;
Rp_obj(maskP)=Rp_obj(maskP)+Vx(maskP)/2;
Rp_bkg(maskP-1)=Rp_bkg(maskP-1)+Vx(maskP)/2;

% Vx <0
maskP = find(Vx<0 & maskImg);
Rp_obj(maskP)=Rp_obj(maskP) - Vx(maskP)/2;
Rp_bkg(maskP+1)=Rp_bkg(maskP+1)-Vx(maskP)/2;
Rp_bkg(maskP)=Rp_bkg(maskP) - Vx(maskP)/2;
Rp_obj(maskP-1)=Rp_obj(maskP-1)-Vx(maskP)/2;

% Vy >0
maskP = find(Vy>=0 & maskImg);
Rp_bkg(maskP)=Rp_bkg(maskP) + Vy(maskP)/2;
Rp_obj(maskP+width)=Rp_obj(maskP+width)+Vy(maskP)/2;
Rp_obj(maskP)=Rp_obj(maskP) + Vy(maskP);
Rp_bkg(maskP-width)=Rp_bkg(maskP-width)+Vy(maskP)/2;

% Vy <0
maskP = find(Vy<0 & maskImg);
Rp_obj(maskP)=Rp_obj(maskP) - Vy(maskP)/2;
Rp_bkg(maskP+width)=Rp_bkg(maskP+width)-Vy(maskP)/2;
Rp_bkg(maskP)=Rp_bkg(maskP) - Vy(maskP)/2;
Rp_obj(maskP-width)=Rp_obj(maskP-width)-Vy(maskP)/2;

function [Rp_bkg,Rp_obj]= grayflow2(I,maskImg,Rp_bkg,Rp_obj,lambda)
[Vy,Vx]=gradient(I);
Vy = Vy*lambda;
Vx = Vx*lambda;
[height,width] = size(I);
N = height*width;

% Vx>0
maskP = find(Vx>=0 & maskImg);
% Rp_bkg(maskP)=Rp_bkg(maskP)+Vx(maskP)/2;
maskPaux =maskP(mod(maskP,height)~=0);
Rp_obj(maskPaux+1)=Rp_obj(maskPaux+1)+Vx(maskPaux)/2;
% Rp_obj(maskP)=Rp_obj(maskP)+Vx(maskP)/2;
maskPaux =maskP(mod(maskP,height)~=1);
Rp_bkg(maskPaux-1)=Rp_bkg(maskPaux-1)+Vx(maskPaux)/2;

% Vx <0
maskP = find(Vx<0 & maskImg);
% Rp_obj(maskP)=Rp_obj(maskP) - Vx(maskP)/2;
maskPaux =maskP(mod(maskP,height)~=0);
Rp_bkg(maskPaux+1)=Rp_bkg(maskPaux+1)-Vx(maskPaux)/2;
% Rp_bkg(maskP)=Rp_bkg(maskP) - Vx(maskP)/2;
maskPaux =maskP(mod(maskP,height)~=1);
Rp_obj(maskPaux-1)=Rp_obj(maskPaux-1)-Vx(maskPaux)/2;

% Vy >0
maskP = find(Vy>=0 & maskImg);
% Rp_bkg(maskP)=Rp_bkg(maskP) + Vy(maskP)/2;
maskPaux =maskP((maskP+height)<=N);
Rp_obj(maskPaux+height)=Rp_obj(maskPaux+height)+Vy(maskPaux)/2;
% Rp_obj(maskP)=Rp_obj(maskP) + Vy(maskP);
maskPaux =maskP((maskP-height)>0);
Rp_bkg(maskPaux-height)=Rp_bkg(maskPaux-height)+Vy(maskPaux)/2;

% Vy <0
maskP = find(Vy<0 & maskImg);
% Rp_obj(maskP)=Rp_obj(maskP) - Vy(maskP)/2;
maskPaux =maskP((maskP+height)<=N);
Rp_bkg(maskPaux+height)=Rp_bkg(maskPaux+height)-Vy(maskPaux)/2;
% Rp_bkg(maskP)=Rp_bkg(maskP) - Vy(maskP)/2;
maskPaux =maskP((maskP-height)>0);
Rp_obj(maskPaux-height)=Rp_obj(maskPaux-height)-Vy(maskPaux)/2;