function rawWrite(mhdFile,img,spacing)

% Write the info to *.mhd file
type = class(img);
[pathFile,rawName] = mhdWrite(mhdFile,length(size(squeeze(img))),...
    spacing,size(squeeze(img)),type);

% Write data to raw file
fid=fopen(strcat(pathFile,rawName),'w');
if fid==-1
    error('Permission denied.');
end
if(islogical(img))
    fwrite(fid,img(:));
elseif(isa(img,'uint8'))
    fwrite(fid,img(:),'uint8');
elseif(isa(img,'int16'))
    fwrite(fid,img(:),'int16');
elseif(isa(img,'double'))
    fwrite(fid,img(:),'double');
elseif(isa(img,'single'))
    fwrite(fid,img(:),'single');
end
fclose(fid);