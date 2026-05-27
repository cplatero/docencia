function [Dim,Spacing,Type,RawName]=mhdRead(fichMHD)

% Apertura del archivo
fid=fopen(fichMHD,'r');
if fid==-1
    error('File *.mhd not found or permission denied.');
end

while 1
    line = fgetl(fid);
    if line==-1
        fclose(fid);
        return;
    end
    
    % ElementSpacing
    if strncmp('ElementSpacing',line,14)==1
        Spacing=str2num(line(18:end)); %#ok<ST2NM>
    end
    
    % DimSize
    if strncmp('DimSize',line,7)==1
        Dim=str2num(line(11:end)); %#ok<ST2NM>
        Dim=[Dim(1),Dim(2),1,Dim(3)];
    end

    % ElementType
    if strncmp('ElementType',line,11)==1
        Type=line(15:end);
    end

    % ElementDataFile
    if strncmp('ElementDataFile',line,15)==1
        RawName=line(19:end);
    end
end


