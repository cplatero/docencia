function pShape = logOdds(bwLabel,Spacing,rho)
umb=10;
pShape = distanceTransform(bwLabel,Spacing,rho,umb);
pShape(pShape<-umb)=-umb;


%% LogOdds
% pShape=single(1/(1+exp(-pShape*rho)));
% pShape(pShape<.005)=0;
% pShape(pShape>.995)=1;
end

function D = distanceTransform(bwLabel,Spacing,rho,umb)
[nx,ny,nz]=size(bwLabel);
D=-ones(nx,ny,nz)*umb/rho;

bwPerimCoronal=unitDilateCoronal(bwLabel);
D(bwPerimCoronal)=-Spacing(2)/Spacing(1);
bwPerimCoronal=unitDilateCoronal(bwLabel|bwPerimCoronal);
D(bwPerimCoronal)=-2*Spacing(2)/Spacing(1);

for i=1:ny
    if(sum(sum(bwLabel(:,i,:)))>0)
        D(:,i,:)=-bwdist(squeeze(bwLabel(:,i,:)))+...
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