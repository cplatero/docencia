function [listAffineRegion1,listAffineRegion2,ROI1,ROI2]=buildingHipoFLIRT()

addpath('D:\compartido\cplatero\Hipocampo\fuentes\NIFTI_20110921');
% addpath('C:\cpd\Hipocampo\fuentes\NIFTI\NIFTI_20110921');

% spatialNormPath = 'D:\compartido\Img\hipocampo\Train\ref21\N3\';
% spatialNormPath='C:\cpd\Hipocampo\images\Train\ref21\';
spatialNormPath = 'D:\compartido\Img\hipocampo\Train\ref21\';

% imgFichName = '*.brain.hdr';
imgFichName = '*.hdr';

listFichImg = dir(strcat(spatialNormPath,imgFichName));

spatialNormPath2 = 'D:\compartido\Img\hipocampo\Train\ref21\Labels\';
% spatialNormPath2='C:\cpd\Hipocampo\images\Train\ref21\Labels\';
% spatialNormPath2 = 'D:\compartido\Img\hipocampo\Train\ref01\Labels\';

segFichName = '*.label.hdr';
listFichSeg = dir(strcat(spatialNormPath2,segFichName));

% refNumber = 21;
% hippo_ref = load_nii(strcat(spatialNormPath,listFichImg(refNumber).name));
% load('AP_ref21');
% load('AP_ref01');
%% Overlap
numAtlases = numel(listFichSeg);
for i=1:numAtlases
    manualFile=strcat(spatialNormPath2,listFichSeg(i).name);

    labels=load_nii(manualFile);
    if(i~=1)
        spam = spam | labels.img>0;
    else
        spam = labels.img>0;
    end
end


%% Detecting regions of interest
maskSPAM = imdilate(spam>0,strel('disk',5));
featRegions = regionprops(bwlabeln(maskSPAM),'BoundingBox');


%% AP for each region
numAtlases = numel(listFichImg);

%% Region 1
bound_Region = featRegions(1).BoundingBox;
offset=3;
ROI1=[ceil(bound_Region(2))-offset,ceil(bound_Region(2)+bound_Region(5))+offset,...
     ceil(bound_Region(1))-offset,ceil(bound_Region(1)+bound_Region(4))+offset,...
     ceil(bound_Region(3))-offset,ceil(bound_Region(3)+bound_Region(6))+offset];

listAffineRegion1(1,numAtlases) = struct('label',[],'imIn',[]);
clc;
% refGray1=19;
% hippo_gray = load_nii(strcat(spatialNormPath,listFichImg(refGray1).name));
% ref_double = double(hippo_gray.img(ROI1(1):ROI1(2),ROI1(3):ROI1(4),...
%         ROI1(5):ROI1(6)));
for i=1:numAtlases
    fprintf('%s %s\n',listFichImg(i).name,listFichSeg(i).name);
    hippo=load_nii(strcat(spatialNormPath,listFichImg(i).name));
    listAffineRegion1(i).imIn=hippo.img(ROI1(1):ROI1(2),ROI1(3):ROI1(4),...
        ROI1(5):ROI1(6));
%     if(i ~= refGray1)
%         hippo_gray = load_nii(strcat(spatialNormPath,listFichImg(i).name));
%         listAffineRegion1(i).imIn = int16(histogramMatching(...
%             double(hippo_gray.img(ROI1(1):ROI1(2),ROI1(3):ROI1(4),...
%         ROI1(5):ROI1(6))),ref_double));
%     else
%         listAffineRegion1(i).imIn = int16(ref_double);
%     end
    
    hippo=load_nii(strcat(spatialNormPath2,listFichSeg(i).name));
    listAffineRegion1(i).label=hippo.img(ROI1(1):ROI1(2),ROI1(3):ROI1(4),...
        ROI1(5):ROI1(6));

end


%% Show
% clc;
% for i=1:numAtlases
%     fprintf('Atlas %d\n',i);
%     close all;
%     %Original region
%     aux=zeros(size(spam),'int16');
% %     aux(ROI1(1):ROI1(2),ROI1(3):ROI1(4),ROI1(5):ROI1(6))=...
% %         listAffineRegion1(i).label;
% %     bwRegion =aux>0;
% %     hippo_ref.img=aux;view_nii(hippo_ref);
%     aux(ROI1(1):ROI1(2),ROI1(3):ROI1(4),ROI1(5):ROI1(6))=...
%         listAffineRegion1(i).imIn;
% %     hippo_ref.img=aux;view_nii(hippo_ref);    
% %     aux(bwperim(bwRegion))=int16(max(aux(:)));
%     hippo_ref.img=aux;view_nii(hippo_ref);
%     
%     aux(ROI1(1):ROI1(2),ROI1(3):ROI1(4),ROI1(5):ROI1(6))=...
%         listAffineRegion1(i).imAux;
%     hippo_ref.img=aux;view_nii(hippo_ref);
%     pause;
% end
%% Region 2
bound_Region = featRegions(2).BoundingBox;
offset=3;
ROI2=[ceil(bound_Region(2))-offset,ceil(bound_Region(2)+bound_Region(5))+offset,...
     ceil(bound_Region(1))-offset,ceil(bound_Region(1)+bound_Region(4))+offset,...
     ceil(bound_Region(3))-offset,ceil(bound_Region(3)+bound_Region(6))+offset];

listAffineRegion2(1,numAtlases) = struct('label',[],'imIn',[]);
% refGray2=24;
% hippo_gray = load_nii(strcat(spatialNormPath,listFichImg(refGray2).name));
% ref_double = double(hippo_gray.img(ROI2(1):ROI2(2),ROI2(3):ROI2(4),...
%         ROI2(5):ROI2(6)));
for i=1:numAtlases
    fprintf('%s %s\n',listFichImg(i).name,listFichSeg(i).name)
    hippo=load_nii(strcat(spatialNormPath,listFichImg(i).name));
    listAffineRegion2(i).imIn=hippo.img(ROI2(1):ROI2(2),ROI2(3):ROI2(4),...
        ROI2(5):ROI2(6));
    
%     if(i ~= refGray2)
%         hippo_gray = load_nii(strcat(spatialNormPath,listFichImg(i).name));
%         listAffineRegion2(i).imIn = int16(histogramMatching(...
%             double(hippo_gray.img(ROI2(1):ROI2(2),ROI2(3):ROI2(4),...
%         ROI2(5):ROI2(6))),ref_double));
%     else
%         listAffineRegion2(i).imIn = int16(ref_double);
%     end
    
    hippo=load_nii(strcat(spatialNormPath2,listFichSeg(i).name));
    listAffineRegion2(i).label=hippo.img(ROI2(1):ROI2(2),ROI2(3):ROI2(4),...
        ROI2(5):ROI2(6));
    
end


%% Show
% clc;
% for i=1:numAtlases
%     fprintf('Atlas %d\n',i);
%     close all;
%     %Original region
%     aux=zeros(size(spam),'int16');
% %     aux(ROI2(1):ROI2(2),ROI2(3):ROI2(4),ROI2(5):ROI2(6))=...
% %         listAffineRegion2(i).label;
% %     bwRegion =aux>0;
% %     hippo_ref.img=aux;view_nii(hippo_ref);
%     aux(ROI2(1):ROI2(2),ROI2(3):ROI2(4),ROI2(5):ROI2(6))=...
%         listAffineRegion2(i).imIn;
% %     hippo_ref.img=aux;view_nii(hippo_ref);    
% %     aux(bwperim(bwRegion))=int16(max(aux(:)));
%     hippo_ref.img=aux;view_nii(hippo_ref);    
%    
%     pause;
% end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Auxiliar functions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


