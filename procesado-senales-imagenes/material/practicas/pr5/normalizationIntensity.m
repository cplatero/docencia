function normalizationIntensity()
% load('ROIs_ref21BFC');
load('ROIs_ref21Ori');
% load('ROIs_ref01Ori');

refHippo1 = 23;
refHippo2 = 23;
ref1=double(listAffineRegion1(refHippo1).imIn);
ref2=double(listAffineRegion2(refHippo2).imIn);
numAtlases = numel(listAffineRegion1);clc;
for i=1:numAtlases
    if(i ~= refHippo1)
        fprintf('Normalization intensity: region 1: %d with reference %d\n',...
            i,refHippo1);
        listAffineRegion1(i).imIn = int16(histogramMatching(...
            double(listAffineRegion1(i).imIn),ref1));
    end
    if(i ~= refHippo2)
        fprintf('Normalization intensity: region 2: %d with reference %d\n',...
            i,refHippo2);
        listAffineRegion2(i).imIn = int16(histogramMatching(...
            double(listAffineRegion2(i).imIn),ref2));
    end
    
end
%% Show
% dy_x = 2/0.39; %ref HFH_021 
% % dy_x = 2/0.781; %ref HFH_001
% dx=[1;dy_x;1];clc;
% for i=1:numAtlases
%     figure(1);
%     fprintf('Image %d\n',i);
%     im3D = double(listAffineRegion1(i).imIn);
%     im3D = im3D./double(max(listAffineRegion1(i).imIn(:)));
%     viewSagital(im3D,dx);
% %     im3D(imdilate(bwperim(listAffineRegion1(i).label>0),...
% %         strel('disk',0)))=1;
% %     figure(2);
% %     viewSagital(im3D,dx);
%     figure(2);
%     im3D = double(listAffineRegion2(i).imIn);
%     im3D = im3D./double(max(listAffineRegion2(i).imIn(:)));
%     viewSagital(im3D,dx);
% %     im3D(imdilate(bwperim(listAffineRegion2(i).label>0),...
% %         strel('disk',0)))=1;
% %     figure(4);
% %     viewSagital(im3D,dx);    
%     pause; 
% end

save ROIs_ref21N23 listAffineRegion1 listAffineRegion2 ROI1 ROI2

end