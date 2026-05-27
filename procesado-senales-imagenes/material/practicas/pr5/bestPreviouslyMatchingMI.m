function [index,score]=bestPreviouslyMatchingMI(imTarget3D_nor,strAtlases,...
    bwGT_nor)
%% Measures
numAtlases = numel(strAtlases);
scoreMI = zeros(numAtlases,1);
if(isempty(bwGT_nor)==0)
    scoreDICE=scoreMI;
end
for i=1:numAtlases
   scoreMI(i)=measureMI(imTarget3D_nor,strAtlases(i).imIn);
   if(isempty(bwGT_nor)==0)
       scoreDICE(i)=measureDICE(bwGT_nor,strAtlases(i).label>0);
   end
end

%% Fusion decision
[score,index]= sort(scoreMI,'descend');
if(isempty(bwGT_nor)==0)
    score=[score,scoreDICE(index)];
end
end


function scoreMI = measureMI(imTarget3D,imAffine)
numBins = 32;
scoreMI=  mi(imTarget3D(:),imAffine(:),numBins);

end

function scoreDICE = measureDICE(bwIni3D,bwAffine)
scoreDICE=  2*sum(bwIni3D(:) & bwAffine(:))/sum(bwIni3D(:) + bwAffine(:));
end
