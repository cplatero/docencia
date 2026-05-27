function metrics = metricsCPD(ref,seg,dX)
dice= getDice(ref,seg);
m1= volOverlap(ref,seg);
m2 = volRelative(ref,seg);
[m3,m4,m5] = disAverage(ref,seg,dX);
metrics=[dice,m1,m2,m3,m4,m5,sum(ref(:)),sum(seg(:))];
end

function dice= getDice(ref,seg)
dice = 2*sum(ref(:) & seg(:))/(sum(ref(:))+sum(seg(:)));
end
%% Overlap volume
function m1 = volOverlap(ref,seg)
inter = ref & seg;
union = ref | seg;
m1=(1- (sum(inter(:))/sum(union(:))))*100;
end
%% Volumen relativo
function m2 = volRelative(ref,seg)
dif = seg-ref;
m2=sum(dif(:))/sum(ref(:));
end
%% Distancia a la superfice
function [m3,m4,m5] = disAverage(ref,seg,dX)

scale = dX(2)/dX(1);
D_ref = distanceTransform(ref,dX,3*scale);
D1=D_ref(bwperim(seg))/scale;

D_seg = distanceTransform(seg,dX,3*scale);
D2=D_seg(bwperim(ref))/scale;


NA = length(D1);
NB = length(D2);
m3 = mean([D1;D2]);
m4 = sqrt((sum(D1.^2) + sum(D2.^2))/(NA+NB));
m5 = max([D1;D2]);

end


function D = distanceTransform(bwLabel,Spacing,umb)
[nx,ny,nz]=size(bwLabel);
D=ones(nx,ny,nz)*umb;

bwPerimCoronal=unitDilateCoronal(bwLabel);
D(bwPerimCoronal)=Spacing(2)/Spacing(1);
bwPerimCoronal_1 = bwPerimCoronal;
bwPerimCoronal=unitDilateCoronal(bwLabel|bwPerimCoronal_1);
D(bwPerimCoronal)=2*Spacing(2)/Spacing(1);
bwPerimCoronal_2 = bwPerimCoronal;
bwPerimCoronal=unitDilateCoronal(bwLabel|bwPerimCoronal_1|bwPerimCoronal_2);
D(bwPerimCoronal)=3*Spacing(2)/Spacing(1);

for i=1:ny
    if(sum(sum(bwLabel(:,i,:)))>0)
        D(:,i,:)=bwdist(squeeze(bwLabel(:,i,:)))+...
            bwdist(squeeze(bwLabel(:,i,:)==0));
    end
end
end


function bwPerimCoronal = unitDilateCoronal(bwLabel)
NHOOD=true(1,3,1);
strElement=strel('arbitrary',NHOOD);
bwDilCoronal= imdilate(bwLabel,strElement);
bwPerimCoronal = bwDilCoronal & (bwLabel==0);
end
