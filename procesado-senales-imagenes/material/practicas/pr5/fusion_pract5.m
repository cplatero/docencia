function [metrics,bwAuto_R1,bwAuto_R2]=fusion_pract5()
IBSR = true;

if(IBSR)
    load('ROIs_IBSROri');
    pathAtlases='../../../../../Hipocampo/fuentes/MA/Dis_Conv/';
    Spacing=[0.9375;1.5;0.9375];
else
    load('../../../../../Hipocampo/fuentes/AP/BuildingPA/ROIs_ref21Ori');
    pathAtlases='../../../../../Hipocampo/fuentes/MA/atlases_Dis_Conv/';
    Spacing=[0.39;2;0.39];
end
numAtlases=numel(listAffineRegion1);


nFusedAtlases = 5;
metrics=zeros(numAtlases,8,2);
bwAuto_R1(numAtlases)=struct('label',[]); 
bwAuto_R2(numAtlases)=struct('label',[]); 

%% Atlases
clc;
for i=1:numAtlases
    fprintf('Target: %d\n',i);
    bwManual_R1 = listAffineRegion1(i).label>0;
    bwManual_R2 = listAffineRegion2(i).label>0;
    

    %% ROI 1
    atlasesToTargetR1=...
            getRegisteredAtlases(1,pathAtlases,i,nFusedAtlases);
    prob_label=mayorityVoting(atlasesToTargetR1);
    bwAuto_R1(i).label=prob_label>.5;
    metrics(i,:,1) = metricsCPD(bwManual_R1,prob_label>.5,Spacing);
    fprintf('ROI 1, DICE: %.3f\n',metrics(i,1,1));
    
        
    %% ROI 2
    atlasesToTargetR2=...
            getRegisteredAtlases(2,pathAtlases,i,nFusedAtlases);
    prob_label=mayorityVoting(atlasesToTargetR2);
    bwAuto_R2(i).label=prob_label>.5;
    metrics(i,:,2) = metricsCPD(bwManual_R2,prob_label>.5,Spacing);
    fprintf('ROI 2, DICE: %.3f\n',metrics(i,1,2));
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%Auxiliar functions
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function atlasesToTarget=...
    getRegisteredAtlases(ROI_hippo,pathAtlases,index_Target,nAtlases)

%% Atlases
if(ROI_hippo==1)
    if(index_Target<10)
        fichName=strcat('NR_R1_Dis_0',num2str(index_Target),'.mat');
    else
        fichName=strcat('NR_R1_Dis_',num2str(index_Target),'.mat');
    end
else
    if(index_Target<10)    
        fichName=strcat('NR_R2_Dis_0',num2str(index_Target),'.mat');
    else
        fichName=strcat('NR_R2_Dis_',num2str(index_Target),'.mat');
    end
end

atlasesToTarget = readAtlasese(pathAtlases,fichName,nAtlases);
end

function atlasesToTarget = readAtlasese(pathAtlases,fichName,numSelectAt)
load(strcat(pathAtlases,fichName));
numAtlases=min(numSelectAt,numel(atlases_NR));
atlasesToTarget(1,numAtlases)=struct('imIn',[],'label',[]);
for i=1:numAtlases
    atlasesToTarget(i).imIn =atlases_NR(i).imIn;
    atlasesToTarget(i).label =atlases_NR(i).label>0;
end


end

function auto_seg=mayorityVoting(atlasesToTarget)

auto_seg=single(atlasesToTarget(1).label);
fixnumAtlases=numel(atlasesToTarget);
if(fixnumAtlases>1)
    for i=2:fixnumAtlases
        auto_seg=auto_seg+single(atlasesToTarget(i).label);
    end
end
auto_seg = auto_seg/fixnumAtlases;

end
