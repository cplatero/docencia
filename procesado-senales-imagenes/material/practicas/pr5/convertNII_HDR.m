function convertNII_HDR(pathImgFiles)

%pathImgFiles='/home/Compartida/Img/hipocampo/Test/ref21/';
% pathImgFiles='/home/Compartida/Img/hipocampo/Train/Brains/';
% pathImgFiles='./BP2/';
% pathImgFiles='./inv/';
% pathImgFiles='/home/Compartida/Img/hipocampo/Train/ref21/Labels/';

comandfsl ='fslchfiletype ANALYZE';

listImgFiles=getFilesNIIGZ(pathImgFiles);
for i=1:numel(listImgFiles)
    input = strcat(32,pathImgFiles,listImgFiles(i).name);
    lineCommand = sprintf('%s %s',comandfsl,input);
    fprintf('%s\n',lineCommand);
    system(lineCommand);
%     pause;
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
