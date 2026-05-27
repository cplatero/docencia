function testGreig(beta)

%% load SPAM (statistical probability anatominal map)
imIn = im2double(rgb2gray(imread('atlas_A.jpg')));
spam = imfilter(imIn,fspecial('gaussian',9,1));
spam = imnoise(spam,'gaussian',0,0.1);
% imOr = imnoise(imIn,'gaussian',0,0.1);
imOr = imnoise(imIn,'salt & pepper',0.5);
% imshow([imIn,spam,imOr]);
%% Prior
pf= spam;
pB= 1-spam;
p_i_f = exp(-(imOr-1).^2).*pf;
p_i_b = exp(-(imOr-0).^2).*pB;

Z= p_i_f+p_i_b;
p_i_f= p_i_f./Z;
p_i_b= 1-p_i_f;

lamda_i = log(p_i_f./p_i_b);
% imshow([imIn,spam,imOr,lamda_i>0]);
%% Graph
[height,width] = size(imOr);

% prior
% lamda_f=zeros([height,width]);
% lamda_f(lamda_i>0)=lamda_i(lamda_i>0);
% lamda_b=zeros([height,width]);
% lamda_b(lamda_i<0)=-lamda_i(lamda_i<0);
% capacity_i=[lamda_f(:);lamda_b(:)];
capacity_i=[-log(p_i_f(:));-log(p_i_b(:))];
N = height*width;
T = sparse([1:N;1:N]',[ones(N,1);ones(N,1)*2],capacity_i);

% MRF
E = edges4connected(height,width);
V = ones(size(E,1),1)*beta;
A = sparse(E(:,1),E(:,2),V,N,N,4*N);

%% min-cut
[flow,labels] = maxflow(A,T);
labels = reshape(labels,[height width]);
imshow([imIn,spam,imOr,lamda_i>0,labels==1]);
title('MAP-MRF: a)Ideal, b)SPAM, c)Original, d)log (p_{in}/p_{out}) >0, e) min-cut');


