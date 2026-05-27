function [Img4D,Spacing] = rawRead(pathFile,mhdFile)

% Reading info from *.mhd file
[Dim,Spacing,Type,RawName] = mhdRead(strcat(pathFile,mhdFile));

% Opening Raw file
fid=fopen(strcat(pathFile,RawName), 'r');
if fid==-1
    error('File *.raw not found or permission denied.');
end
if strcmp(Type,'MET_CHAR')
    Img1D=fread(fid,'char=>bool');
% elseif strcmp(Type,'MET_UCHAR')
%     Img1D=fread(fid,'uchar=>bool');
elseif strcmp(Type,'MET_UCHAR')
    Img1D=fread(fid,'uchar=>uint8');        
elseif strcmp(Type,'MET_SHORT')
    Img1D=fread(fid,'short=>int16');
elseif strcmp(Type,'MET_DOUBLE')
    Img1D=fread(fid,'double');
elseif strcmp(Type,'MET_FLOAT')
    Img1D=fread(fid,'single');
else
    % Other types
    disp('Unsupported type');
end
fclose(fid);

% Reshaping to 3D image
Img4D=reshape(Img1D,Dim);
%clear Img1D;

%montage(Img3D);