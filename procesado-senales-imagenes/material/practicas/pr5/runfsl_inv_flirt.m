function runfsl_inv_flirt()


%% Inverse MAT file
% pathResulLabel='./inv/';
% % pathResulLabel='./BP2/';
% pathResulLabel='/home/Compartida/Img/hipocampo/Train/ref21/Labels/inv/';
% pathResulLabel='/home/Compartida/Img/hipocampo/Train/ref21/BP/inv2/';
pathResulLabel='/home/Compartida/Img/hipocampo/Test/ref21/MA_PA/inv/';

% % pathSpatialNorm='./ref01/';
pathSpatialNorm='/home/Compartida/Img/hipocampo/Test/ref21/';

 
comandfsl_inv ='convert_xfm';

listMATFiles=getFilesMAT(pathSpatialNorm);
for i=1:numel(listMATFiles)
    outputFile = strcat(pathResulLabel,'inv_',listMATFiles(i).name);
    inputFile = strcat(pathSpatialNorm,listMATFiles(i).name);
    comandLine = strcat(comandfsl_inv,32,'-omat',32,outputFile,32,...
        '-inverse',32,inputFile);
    fprintf('%s\n',comandLine);
%     pause;
    system(comandLine);
end
pause;
%% Inverse HDR

% pathNormLabel='./BP2/';
% pathNormLabel='/home/Compartida/Img/hipocampo/Train/ref21/Labels/';
% pathNormLabel='/home/Compartida/Img/hipocampo/Train/ref21/BP/';
pathNormLabel='/home/Compartida/Img/hipocampo/Test/ref21/MA_PA/';
% pathNormLabel='/home/Compartida/Img/hipocampo/Train/ref01/';
% pathRefFiles='/home/Compartida/Img/hipocampo/Train/Brains/';
pathRefFiles='/home/Compartida/Img/hipocampo/Test/';

% pathResulLabel='./inv/';
% pathResulLabel='./BP2/';
% pathResulLabel='/home/Compartida/Img/hipocampo/Train/ref21/Labels/inv/';


comandfsl ='flirt';
listLabelFiles=getFilesHDR(pathNormLabel);
listRefFiles=getFilesHDR(pathRefFiles);
listMATFiles=getFilesMAT(pathResulLabel);

% atlas_ref = 21;
for i=1:numel(listLabelFiles)
    ResultingLabelFile = strcat(pathResulLabel,listLabelFiles(i).name);
    ResultingMatrix = strcat(pathResulLabel,listMATFiles(i).name);
%     if(i<atlas_ref)
        ref=strcat('-ref',32,pathRefFiles,listRefFiles(i).name);
%     else
%         ref=strcat('-ref',32,pathRefFiles,listRefFiles(i+1).name);
%     end
    input = strcat('-in',32,pathNormLabel,listLabelFiles(i).name);
    output= strcat('-out',32,ResultingLabelFile);
    options=strcat('-init',32,ResultingMatrix,32,...
        '-datatype short -interp nearestneighbour -dof 12 -applyxfm');
    lineCommand = sprintf('%s %s %s %s %s',comandfsl,input,ref,output,options);
    fprintf('%s\n',lineCommand);
%     pause;
    system(lineCommand);  
end
pause;
convertNII_HDR(pathResulLabel);

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
