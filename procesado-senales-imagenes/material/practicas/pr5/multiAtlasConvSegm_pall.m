function multiAtlasConvSegm_pall()
warning('off');
ROI = 1;
numFusedAtlases = 15;
%% Atlases
% load('ROIs_ref21Ori');
load('ROIs_IBSROri');

if(ROI==1)
    listAtlases = listAffineRegion1;
else
    listAtlases = listAffineRegion2;
end
clear listAffineRegion1 listAffineRegion2
numAtlases = numel(listAtlases);
% Spacing=[0.39;2;0.39];
Spacing=[0.9375;1.5;0.9375];
dV=Spacing(1)*Spacing(2)*Spacing(3);
%% Save atlases in MHD
% for j=1:numAtlases
%     saveMHD(single(listAtlases(j).imIn),listAtlases(j).label>0,...
%         j,Spacing);
% end
%% Multi-atlas segmentation
for fix=1:numAtlases
    clc;
    [index,score]=bestPreviouslyMatchingMI(listAtlases(fix).imIn,...
        listAtlases,listAtlases(fix).label>0);
    atlases_NR(1,numFusedAtlases)=struct('imIn',[],'label',[]);
    metrics_NR=zeros(numFusedAtlases,4);
    
    man_seg=listAtlases(fix).label>0;
    parfor moving=1:numFusedAtlases
        [labelAtlas3D_NR,imAtlas3D_NR] = ...
           nonRigidAtlasToTargetElastixImage(fix,index(moving+1),false);

        atlases_NR(moving).imIn=single(imAtlas3D_NR);
        atlases_NR(moving).label=single(labelAtlas3D_NR);
        
        auto_seg = labelAtlas3D_NR > 0;
                
        scoreDICE1 = measureDICE(man_seg,auto_seg);
        scoreDICE2 = measureDICE(listAtlases(index(moving+1)).label>0,auto_seg);
        scoreDICE3 = measureDICE(man_seg,listAtlases(index(moving+1)).label>0);
%         fprintf('\n%.3f %.3f %.3f\n',scoreDICE1,scoreDICE2,scoreDICE3);
%         fprintf('%.0f %.0f\n',sum(man_seg(:))*dV,sum(auto_seg(:))*dV);
        metrics_NR(moving,:)=[scoreDICE1,scoreDICE2,scoreDICE3,...
            sum(auto_seg(:))*dV];
    end
    %% Save registered atlases
    if (fix < 10)
        if(ROI==1)
            nameFich_NR=strcat('./Dis_Conv/NR_R1_Dis_0',num2str(fix),'.mat');
        else
            nameFich_NR=strcat('./Dis_Conv/NR_R2_Dis_0',num2str(fix),'.mat');
        end
    else
        if(ROI==1)
            nameFich_NR=strcat('./Dis_Conv/NR_R1_Dis_',num2str(fix),'.mat');
        else
            nameFich_NR=strcat('./Dis_Conv/NR_R2_Dis_',num2str(fix),'.mat');
        end
        
    end
    save(nameFich_NR,'atlases_NR','metrics_NR');
            
end


end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%Auxiliar functions
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function maskRegistering = dilateCS(bwIni_SC,Spacing,scale)
dV=round(Spacing(1)*scale./Spacing);
NHOOD=true(dV(1),dV(2),dV(3));
strElement=strel('arbitrary',NHOOD);
maskRegistering= imdilate(bwIni_SC,strElement);
end


function scoreDICE = measureDICE(bwIni3D,bwAffine)
scoreDICE=  2*sum(bwIni3D(:) & bwAffine(:))/sum(bwIni3D(:) + bwAffine(:));
end


function saveMHD(imTarget3D,labelTarget3D,index_target,Spacing)

if(isempty(labelTarget3D))
    fileImTarget=strcat('./targets/imTarget_',num2str(index_target),'.mhd');
else
    fileImTarget=strcat('./atlases/imAtlas_',num2str(index_target),'.mhd');
end
    

imTarget3DRot = zeros(size(imTarget3D,2),size(imTarget3D,1),size(imTarget3D,3),'single');
for k=1:size(imTarget3D,3)
    imTarget3DRot(:,:,k) = imTarget3D(:,:,k)';
end
SpacingRot=[Spacing(2);Spacing(1);Spacing(3)];
rawWrite(fileImTarget,imTarget3DRot,SpacingRot);

if(isempty(labelTarget3D)==0)

    filelabelAtlas=strcat('./atlases/logOddslabelAtlas_',num2str(index_target),'.mhd');
    % logOdds
    rho=1;
    labelTarget3D=logOdds(labelTarget3D,Spacing,rho);
    % viewCoronal(labelTarget3D);
    % viewCoronal(labelTarget3D-min(labelTarget3D(:))/(max(labelTarget3D(:))-min(labelTarget3D(:))));
    % fprintf('%f %f\n',min(labelTarget3D(:)),max(labelTarget3D(:)));
    % pause;
    labelTarget3DRot = zeros(size(imTarget3D,2),size(imTarget3D,1),size(imTarget3D,3),'single');
    % 
    % Common 
    for k=1:size(imTarget3D,3)
        labelTarget3DRot(:,:,k) = labelTarget3D(:,:,k)';
    end
    rawWrite(filelabelAtlas,labelTarget3DRot,SpacingRot);
end



end



function [labelAtlas3D_NR,imAtlas3D_NR] = ...
    nonRigidAtlasToTargetElastixImage(index_target,index_atlas,testSet)

if(testSet)
    fileTarget=strcat('./targets/imTarget_',num2str(index_target),'.mhd');
else
    fileTarget=strcat('./atlases/imAtlas_',num2str(index_target),'.mhd');
end
fileImAtlas=strcat('./atlases/imAtlas_',num2str(index_atlas),'.mhd');
fileParameters='parameters/nonRigidParametersConv.txt';
comandElastix=strcat('elastix -f',32,fileTarget,32,'-m',32,fileImAtlas,...
    32,'-out output -p',32,fileParameters);

system(comandElastix);

% Result
nonR_At_ImRot = rawRead('./output/','result.0.mhd');
imAtlas3D_NR = zeros(size(nonR_At_ImRot,2),size(nonR_At_ImRot,1),size(nonR_At_ImRot,4));
for k=1:size(nonR_At_ImRot,4)
    imAtlas3D_NR(:,:,k) = nonR_At_ImRot(:,:,1,k)';
end
clear nonR_At_ImRot;


filelabelAtlas=strcat('./atlases/logOddslabelAtlas_',num2str(index_atlas),'.mhd');
comandElastix=strcat('transformix -in',32,filelabelAtlas,32,...
    '-out output -tp output/TransformParameters.0.txt');
system(comandElastix);

labelTarget3DRot = rawRead('./output/','result.mhd');
labelAtlas3D_NR = zeros(size(labelTarget3DRot,2),size(labelTarget3DRot,1),size(labelTarget3DRot,4));
for k=1:size(labelTarget3DRot,4)
    labelAtlas3D_NR(:,:,k) = labelTarget3DRot(:,:,1,k)';
end

end
