function runfsl_flirt()

pathImgFiles='/home/Compartida/Img/hipocampo/Train/Brains/';
pathLabelFiles='/home/Compartida/Img/hipocampo/Train/Labels/';
% pathResulImg='/home/Compartida/Img/hipocampo/Train/ref01/';
pathResulImg='/home/Compartida/Img/hipocampo/Train/ref21/';
% pathResulLabels='/home/Compartida/Img/hipocampo/Train/ref01/Labels/';
pathResulLabels='/home/Compartida/Img/hipocampo/Train/ref21/Labels/';

comandfsl ='flirt';

% listImgFiles=getFilesNIIGZ(pathImgFiles);
listImgFiles=getFilesHDR(pathImgFiles);
listLabelFiles=getFilesHDR(pathLabelFiles);
% listMATFiles=getFilesMAT(pathResulLabels);

% numRef = 1;
numRef = 21;

% ref = strcat('-ref',32,pathImgFiles,'HFH_001_brain.hdr');
ref = strcat('-ref',32,pathImgFiles,'HFH_021_brain.hdr');

for i=1:numel(listImgFiles)
     if(i ~= numRef)
%    if(i == numRef)    
        ResultingFile = strcat(listImgFiles(i).name(1:end-4),'_021.brain.hdr');
        ResultingMatrix = strcat(listImgFiles(i).name(1:end-4),'_021.mat');
        input = strcat('-in',32,pathImgFiles,listImgFiles(i).name);
        output= strcat('-out',32,pathResulImg,ResultingFile);
        options=strcat('-omat',32,pathResulImg,ResultingMatrix,32,...
            '-datatype short');
        lineCommand = sprintf('%s %s %s %s %s',comandfsl,input,ref,output,options);
        fprintf('%s\n',lineCommand);
        system(lineCommand);
        %% label propagation
%         ResultingMatrix = listMATFiles(i-1).name;
        ResultingFile = strcat(listLabelFiles(i).name(1:end-4),'_021.label.hdr');
        input = strcat('-in',32,pathLabelFiles,listLabelFiles(i).name);
        output= strcat('-out',32,pathResulLabels,ResultingFile);
        options=strcat('-init',32,pathResulImg,ResultingMatrix,32,...
            '-datatype short -interp nearestneighbour -dof 12 -applyxfm');
%         options=strcat('-init',32,pathResulLabels,ResultingMatrix,32,...
%             '-datatype short -interp nearestneighbour -dof 12 -applyxfm');

        lineCommand = sprintf('%s %s %s %s %s',comandfsl,input,ref,output,options);
        fprintf('%s\n',lineCommand);
        system(lineCommand);
%         pause;
    end

end

end


function listImgFiles=getFilesHDR(pathImages)

%list of files *.hdr 
strDir = dir ( pathImages );
k=1;
for i=1:numel(strDir)
    if (~strDir(i).isdir)
        typeFile = strDir(i).name(1,end-3:end);
        if ( strcmp(typeFile,'.hdr') ||strcmp(typeFile,'.HDR'))
           listImgFiles(k).name=strDir(i).name;
           k = k +1; 
        end
    end
end
end

function listImgFiles=getFilesNIIGZ(pathImages)

%list of files *.hdr 
strDir = dir ( pathImages );
k=1;
for i=1:numel(strDir)
    if (~strDir(i).isdir)
        typeFile = strDir(i).name(1,end-6:end);
        if ( strcmp(typeFile,'.nii.gz') )
           listImgFiles(k).name=strDir(i).name;
           k = k +1; 
        end
    end
end
end


function listImgFiles=getFilesMAT(pathImages)

%list of files *.hdr 
strDir = dir ( pathImages );
k=1;
for i=1:numel(strDir)
    if (~strDir(i).isdir)
        typeFile = strDir(i).name(1,end-3:end);
        if ( strcmp(typeFile,'.mat') )
           listImgFiles(k).name=strDir(i).name;
           k = k +1; 
        end
    end
end
end