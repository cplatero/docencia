function dice_train=test_affineRegistration(database)
addpath('D:\compartido\Fuentes\Toolboxes\NIFTI_20110921');


if(strcmp(database,'HFH'))
    spatialNormPath='D:\compartido\Img\hipocampo\Train\ref21\Labels\inv\';
    manualSegmPath = 'D:\compartido\Img\hipocampo\Train\Labels\';
    imgFichName = '*.hdr';
    listFichSeg = dir(strcat(spatialNormPath,imgFichName));
    listFichMan = dir(strcat(manualSegmPath,imgFichName));

else
    spatialNormPath='D:\compartido\Img\hipocampo\ADNI\train1_5T\ref06\Labels\inv\';
    manualSegmPath = 'D:\compartido\Img\hipocampo\ADNI\train1_5T\Labels\';
    imgFichName = 'S*.nii.gz';
    listFichSeg = dir(strcat(spatialNormPath,imgFichName));
    listFichMan = dir(strcat(manualSegmPath,imgFichName));
    
end


numAtlases = numel(listFichSeg);
dice_train = zeros(numAtlases,1);
dice=@(X,Y) 2* sum(X(:) & Y(:))/sum(X(:)+Y(:));

%% Atlases
for i=1:numAtlases

    fprintf('%s %s:',listFichSeg(i).name,listFichMan(i).name);
    hippo=load_nii(strcat(spatialNormPath,listFichSeg(i).name));
    label_seg=hippo.img>0;
    hippo=load_nii(strcat(manualSegmPath,listFichMan(i).name));
    label_man=hippo.img>0;
    dice_train(i)=dice(label_seg,label_man);
    fprintf(' %.3f\n',dice_train(i));
end

end