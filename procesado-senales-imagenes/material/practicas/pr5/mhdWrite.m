function [pathFile,rawName] = mhdWrite(fichMHD,nDims,spacing,dimSize,elementType)

% Creacion del archivo
fid=fopen(fichMHD,'w');
if fid==-1
    error('Permission denied.');
end

% ObjectType = Image
fprintf(fid,'ObjectType = Image\n');

% NDims = nDims
fprintf(fid,'NDims = %d\n',nDims);

% BinaryData = True
fprintf(fid,'BinaryData = True\n');

% BinaryDataByteOrderMSB = False
fprintf(fid,'BinaryDataByteOrderMSB = False\n');

% CompressedData = False
% fprintf(fid,'CompressedData = False\n');

if(nDims==2)
    fprintf(fid,'TransformMatrix = %g 0  0 %g\n',spacing(1),...
        spacing(2));
    % Offset = 0 0
    fprintf(fid,'Offset = 0 0 0\n');
    % CenterOfRotation = 0 0 0
    fprintf(fid,'CenterOfRotation = 0 0\n');
    % ElementSpacing = spacing(1 spacing(2)
    fprintf(fid,'ElementSpacing = %g %g\n',spacing(1),...
        spacing(2));
    % DimSize = dimSize(1) dimSize(2)
    fprintf(fid,'DimSize = %d %d\n',dimSize(1),dimSize(2));
    % AnatomicalOrientation = RAI
    % fprintf(fid,'AnatomicalOrientation = RAI\n');
else
    % TransformMatrix = spacing(1) 0 0 0 spacing(2) 0 0 0 spacing(3)
    fprintf(fid,'TransformMatrix = %g 0 0 0 %g 0 0 0 %g\n',spacing(1),...
        spacing(2),spacing(3));
    % Offset = 0 0 0
    fprintf(fid,'Offset = 0 0 0\n');
    % CenterOfRotation = 0 0 0
    fprintf(fid,'CenterOfRotation = 0 0 0\n');
    % ElementSpacing = spacing(1 spacing(2) spacing(3)
    fprintf(fid,'ElementSpacing = %g %g %g\n',spacing(1),...
        spacing(2),spacing(3));
    % DimSize = dimSize(1) dimSize(2) dimSize(3)
    fprintf(fid,'DimSize = %d %d %d\n',dimSize(1),dimSize(2),dimSize(3));
    % AnatomicalOrientation = RAI
    % fprintf(fid,'AnatomicalOrientation = RAI\n');
end

% ElementType = elementType
if(strcmp(elementType,'int16'))
    fprintf(fid,'ElementType = MET_SHORT\n');
elseif(strcmp(elementType,'logical'))
    fprintf(fid,'ElementType = MET_CHAR\n');
elseif(strcmp(elementType,'uint8'))
    fprintf(fid,'ElementType = MET_UCHAR\n');
elseif(strcmp(elementType,'double'))
    fprintf(fid,'ElementType = MET_DOUBLE\n');
elseif(strcmp(elementType,'single'))
    fprintf(fid,'ElementType = MET_FLOAT\n');
else
    disp('Unsupported data type');
end  

% ElementDataFile = fichMHD
aux = findstr(fichMHD,'/');
rawName = strcat(fichMHD(aux(end)+1:end-3),'raw');
pathFile = fichMHD(1:aux(end));
fprintf(fid,'ElementDataFile = %s\n',rawName);

fclose(fid);
