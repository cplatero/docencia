function imAtlas3D_NR = readRawMHD(pathFile,nameFile)

nonR_At_ImRot = rawRead(pathFile,nameFile);
imAtlas3D_NR = zeros(size(nonR_At_ImRot,2),size(nonR_At_ImRot,1),size(nonR_At_ImRot,4));
for k=1:size(nonR_At_ImRot,4)
    imAtlas3D_NR(:,:,k) = nonR_At_ImRot(:,:,1,k)';
end

end