function runfsl_bet()

pathImgFiles='/home/Compartida/Img/hipocampo/Train/';
pathResulImg='/home/Compartida/Img/hipocampo/Train/Brains/';
% comandfsl ='/usr/share/fsl/4.1/bin/bet';
% cd('/usr/share/fsl/4.1/bin/');
comandfsl ='bet';

listImgFiles=getFilesHDR(pathImgFiles); 


% system('export PATH=$PATH:/usr/share/fsl/4.1/bin');
% system('echo $PATH');
for i=1:numel(listImgFiles)
    ResultingFile = strcat(listImgFiles(i).name(1:end-4),'_brain.nii.gz');
    input = strcat(pathImgFiles,listImgFiles(i).name);
    output= strcat(pathResulImg,ResultingFile);
    options='-m';
    lineCommand = sprintf('%s %s %s %s',comandfsl,input,output,options);
    fprintf('%s\n',lineCommand);

    system(lineCommand);

end

convertNII_HDR(pathResulImg);
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
