function showIBSR()
addpath('D:\compartido\cplatero\Hipocampo\fuentes\NIFTI_20110921');
pathAtlases='D:\compartido\Img\hipocampo\IBSR_V2.0\IBSR_nifti_stripped\';
close all;

for i=1:18
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
    %view_nii(hippo);

    labels=load_nii(manualFile);
    label_ROI1=labels.img==17;
    label_ROI2=labels.img==53;
    mask = label_ROI1 | label_ROI2;
    hippo.img(bwperim(mask))=max(hippo.img(:));
    view_nii(hippo);
    pause;
end

end