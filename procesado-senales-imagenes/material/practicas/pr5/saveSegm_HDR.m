function saveSegm_HDR()
%load('aljabar_R1_8_R2_6');
load('mv_HFH');
bwIniPA_R1=bwAuto_R1;
bwIniPA_R2=bwAuto_R2;

numAtlases = numel(bwIniPA_R1);
fprintf('WARNING cpd: The header of the files have to be changed by the header of image file\n');
%% Reference
addpath('D:\compartido\cplatero\Hipocampo\fuentes\NIFTI_20110921');
typeData = 1;
imageNorPath = {'D:\compartido\Img\hipocampo\Train\ref21\'};
imgFichName = 'HFH*.hdr';
listFichImg = dir(strcat(imageNorPath{typeData},imgFichName));
hippo_img = load_nii(strcat(imageNorPath{typeData},...
                            listFichImg(1).name));
CS_PA = zeros(size(hippo_img.img),'int16');
R1=zeros(size(bwIniPA_R1(1).label),'int16');
R2=zeros(size(bwIniPA_R2(1).label),'int16');

%% save HDR
autoSegmPath = {'D:\compartido\Img\hipocampo\Train\ref21\MV\'};
for i=1:numAtlases
    R1(:)=0;R2(:)=0;
    R1(bwIniPA_R1(i).label)=2;
    R2(bwIniPA_R2(i).label)=1;
    CS_PA(ROI1(1):ROI1(2),ROI1(3):ROI1(4),ROI1(5):ROI1(6))=R1;
    CS_PA(ROI2(1):ROI2(2),ROI2(3):ROI2(4),ROI2(5):ROI2(6))=R2;
    hippo_img = load_nii(strcat(imageNorPath{typeData},...
                            listFichImg(i).name));
    hippo_img.img = CS_PA;
    fichAutoSeg = listFichImg(i).name;
    fprintf('%s\n',fichAutoSeg);
    save_nii(hippo_img,strcat(autoSegmPath{typeData},fichAutoSeg));
end
end