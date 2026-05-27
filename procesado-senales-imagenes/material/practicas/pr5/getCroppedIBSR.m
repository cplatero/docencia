function [listAffineROI1,listAffineROI2]=getCroppedIBSR()
addpath('D:\compartido\cplatero\Hipocampo\fuentes\NIFTI_20110921');
pathAtlases='D:\compartido\Img\hipocampo\IBSR_V2.0\IBSR_nifti_stripped\';
close all;
show_list = false;
numAtlases = 18;
%% Overlap
for i=1:numAtlases
    if(i<10)
        manualFile=strcat(pathAtlases,sprintf('IBSR_0%d\\',i),...
            sprintf('IBSR_0%d_seg_ana.nii',i));
    else
        manualFile=strcat(pathAtlases,sprintf('IBSR_%d\\',i),...
            sprintf('IBSR_%d_seg_ana.nii',i));     
    end

    labels=load_nii(manualFile);
    label_ROI1=labels.img==17;
    label_ROI2=labels.img==53;
    if(i>1)
        overlapMask_ROI1 = overlapMask_ROI1 | label_ROI1;
        overlapMask_ROI2 = overlapMask_ROI2 | label_ROI2;
    else
        overlapMask_ROI1 =  label_ROI1;
        overlapMask_ROI2 =  label_ROI2;
    end
end

% labels.img=overlapMask_ROI1;
% view_nii(labels);
% labels.img=overlapMask_ROI2;
% view_nii(labels);

%% ROI1
maskSPAM = imdilate(overlapMask_ROI1,strel('disk',1));
featRegions = regionprops(bwlabeln(maskSPAM),'BoundingBox');
bound_Region = featRegions(1).BoundingBox;
offset=3;
ROI1=[ceil(bound_Region(2))-offset,ceil(bound_Region(2)+bound_Region(5))+offset,...
     ceil(bound_Region(1))-offset,ceil(bound_Region(1)+bound_Region(4))+offset,...
     ceil(bound_Region(3))-offset,ceil(bound_Region(3)+bound_Region(6))+offset];

maskSPAM = imdilate(overlapMask_ROI2,strel('disk',1));
featRegions = regionprops(bwlabeln(maskSPAM),'BoundingBox');
bound_Region = featRegions(1).BoundingBox;
ROI2=[ceil(bound_Region(2))-offset,ceil(bound_Region(2)+bound_Region(5))+offset,...
     ceil(bound_Region(1))-offset,ceil(bound_Region(1)+bound_Region(4))+offset,...
     ceil(bound_Region(3))-offset,ceil(bound_Region(3)+bound_Region(6))+offset];

listAffineROI1(1,numAtlases) = struct('label',[],'imIn',[]);
listAffineROI2(1,numAtlases) = struct('label',[],'imIn',[]);
for i=1:numAtlases
    if(i<10)
        patientFile=strcat(pathAtlases,sprintf('IBSR_0%d\\',i),...
            sprintf('IBSR_0%d_ana_strip.nii',i));
        manualFile=strcat(pathAtlases,sprintf('IBSR_0%d\\',i),...
            sprintf('IBSR_0%d_seg_ana.nii',i));
    else
        patientFile=strcat(pathAtlases,sprintf('IBSR_%d\\',i),...
            sprintf('IBSR_%d_ana_strip.nii',i));
        manualFile=strcat(pathAtlases,sprintf('IBSR_%d\\',i),...
            sprintf('IBSR_%d_seg_ana.nii',i));
        
    end

    hippo=load_nii(patientFile);
    labels=load_nii(manualFile);
    label_ROI1=labels.img==17;
    label_ROI2=labels.img==53;
    listAffineROI1(i).imIn = hippo.img(ROI1(1):ROI1(2),ROI1(3):ROI1(4),...
        ROI1(5):ROI1(6));
    listAffineROI2(i).imIn = hippo.img(ROI2(1):ROI2(2),ROI2(3):ROI2(4),...
        ROI2(5):ROI2(6));
    listAffineROI1(i).label = label_ROI1(ROI1(1):ROI1(2),ROI1(3):ROI1(4),...
        ROI1(5):ROI1(6));
    listAffineROI2(i).label = label_ROI2(ROI2(1):ROI2(2),ROI2(3):ROI2(4),...
        ROI2(5):ROI2(6));
    
end

if(show_list)
    dx=[.9375;1.5;.9375];
    for i=1:numAtlases
        figure(1);
        %viewCoronal(listAffineROI1(i).imIn);
        viewSagital(listAffineROI1(i).imIn,dx);
        figure(2);
        %viewCoronal(listAffineROI1(i).label);
        viewSagital(listAffineROI1(i).label,dx);
        
        figure(3);
        %viewCoronal(listAffineROI2(i).imIn);
        viewSagital(listAffineROI2(i).imIn,dx);
        figure(4);
        %viewCoronal(listAffineROI2(i).label);
        viewSagital(listAffineROI2(i).label,dx);
        
        fprintf('Patient %d\n',i);
        pause;
    end
end