function showHippoROICoronal()
warning('off');

%% Atlases
% load('ROIs_ref21N5');
load('ROIs_ref21Ori');
% load('ROIs_IBSROri');
listAtlases=listAffineRegion2;
clear listAffineRegion1 listAffineRegion2
dy_x = 2/0.39; %ref HFH_021 % dy_x = 2/0.781; %ref HFH_001
% dy_x=1.5/.9375;
dx=[1;dy_x;1];
numAtlases = numel(listAtlases);
%% Show
figure(1);
clc
for i=1:numAtlases
    subplot(1,2,1);
    img=single(listAtlases(i).imIn);
    mean_img=mean(img(:));
    std_img=std(img(:));
    max_img=max(img(:));
    viewCoronal(img);
    subplot(1,2,2);
    img(bwperim(listAtlases(i).label>0))=max_img;
    viewCoronal(img);
    title(sprintf('Atlas %d: %.1f %.1f %.1f',i,mean_img,std_img,max_img));
    pause;

end





end