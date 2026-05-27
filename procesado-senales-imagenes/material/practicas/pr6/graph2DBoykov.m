function [flow,labels] =graph2DBoykov(Rp_obj,Rp_bkg,lambda,E,strMRF)
%% prior s-t
[height,width]=size(Rp_obj);
N =height*width;

capacity_i=[Rp_bkg(:);Rp_obj(:)];
T = sparse([1:N;1:N]',[ones(N,1);ones(N,1)*2],capacity_i);


%% MRF
typeMRF = strMRF.typeMRF;
if(strcmp(typeMRF,'dist_pq'))
    V = lambda * getV_dist_pq(E,strMRF.dist_pq);
elseif(strcmp(typeMRF,'I_pq'))
    V= lambda * getV_I_pq(E,strMRF.dist_pq,strMRF.Img);
elseif(strcmp(typeMRF,'modGrad'))
    V= lambda * getV_modGrad(E,strMRF.dist_pq,strMRF.modGrad,...
        strMRF.mask_nlink);
elseif(strcmp(typeMRF,'Ipq_dir'))
    V= lambda * getV_Ipq_dir(E,strMRF.dist_pq,strMRF.Img);
elseif(strcmp(typeMRF,'geoCutIso'))
    V= lambda * geoCutIso(E,strMRF.dist_pq,strMRF.g);
elseif(strcmp(typeMRF,'geoCutAni'))
    V= lambda * getCutAni(E,strMRF.dist_pq,strMRF.detD_p,...
        strMRF.g,strMRF.ux,strMRF.uy,strMRF.uz);
end
A = sparse(E(:,1),E(:,2),V,N,N,size(E,1));
%% min-cut
[flow,labels] = maxflow(A,T);
labels = reshape(labels,[height width])>0;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%Auxiliar
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function V = getV_dist_pq(E,dist_pq)
V = ones(size(E,1),1);

if(isempty(dist_pq)==0)
    mask_8N_PQ =  E(:,3) == 1;
    V(mask_8N_PQ)= 1/sqrt(2);     
end


end

function V = getV_I_pq(E,dist_pq,Img)

if(length(dist_pq)==1)
    mask_6N_PQ = E(:,3) == 1;
    mask_4N_PQ = E(:,3) == 0;
    var_robust = getVarImg(Img,E,mask_4N_PQ,mask_6N_PQ);
    V = ones(size(E,1),1);
    V(mask_4N_PQ)=  exp(-(Img(E(mask_4N_PQ,1))-Img(E(mask_4N_PQ,2))).^2./...
           (2*var_robust(1)));   
    V(mask_6N_PQ)= exp(-(Img(E(mask_6N_PQ,1))-Img(E(mask_6N_PQ,2))).^2./...
           (2*var_robust(2)))/dist_pq; 
end

end

function V = getV_modGrad(E,dist_pq,modGrad,mask_nlink)

sigma_robust= 2*mean(modGrad(mask_nlink));
Bp = 1 - exp(-modGrad/sigma_robust);
V =1 - max(Bp(E(:,1)),Bp(E(:,2)));

if(length(dist_pq)==1)
    mask_6N_PQ = E(:,3) == 1;
    V(mask_6N_PQ)=V(mask_6N_PQ)/dist_pq;
elseif(length(dist_pq)==5)   
    mask_dist_2 =  E(:,3) == 1;
    V(mask_dist_2) = V(mask_dist_2)/dist_pq(2);
    mask_dist_3 =  E(:,3) == 2;
    V(mask_dist_3) = V(mask_dist_3)/dist_pq(3);
    mask_dist_4 =  E(:,3) == 3;
    V(mask_dist_4) = V(mask_dist_4)/dist_pq(4);
    mask_dist_5 =  E(:,3) == 4;
    V(mask_dist_5) = V(mask_dist_5)/dist_pq(5);       
end

end

function V = getV_Ipq_dir(E,dist_pq,Img)

if(length(dist_pq)==1)
    mask_6N_PQ = E(:,3) == 1;
    mask_4N_PQ = E(:,3) == 0;
    var_robust = getVarImg(Img,E,mask_4N_PQ,mask_6N_PQ);
    V = ones(size(E,1),1);
    mask_4N = find(Img(E(mask_4N_PQ,1))>=Img(E(mask_4N_PQ,2)));
    V(mask_4N)=  exp(-(Img(E(mask_4N,1))-Img(E(mask_4N,2))).^2./...
           (2*var_robust(1)));
    V(mask_6N_PQ)= 1/dist_pq;    
    mask_6N = find(Img(E(mask_6N_PQ,1))>=Img(E(mask_6N_PQ,2)));
    V(mask_6N)= exp(-(Img(E(mask_6N,1))-Img(E(mask_6N,2))).^2./...
           (2*var_robust(2)))/dist_pq; 
end

end

function V = geoCutIso(E,dist_pq,g)


V =g(E(:,1));

if(isempty(dist_pq)==0)
    mask_8N_PQ = E(:,3) == 1;
    V(mask_8N_PQ)=V(mask_8N_PQ)/sqrt(2);     
end

end

function V = getCutAni(E,dist_pq,detD_p,g,ux,uy,uz)

one_g = 1-g;
V =ones(size(E,1),1);

if(length(dist_pq)==1)
    %x-axe
    mask_6N_PQ = E(:,3) == 1;
    mask_x = E(mask_6N_PQ,1);
    V(mask_6N_PQ)=detD_p(mask_x)./(g(mask_x)+...
        (one_g(mask_x).*ux(mask_x).*ux(mask_x))).^2;
    %y-axe
    mask_6N_PQ = E(:,3) == 2;
    mask_y = E(mask_6N_PQ,1);
    V(mask_6N_PQ)=detD_p(mask_y)./(g(mask_y)+...
        (one_g(mask_y).*uy(mask_y).*uy(mask_y))).^2;
    %z-axe
    mask_6N_PQ = E(:,3) == 3;
    mask_z = E(mask_6N_PQ,1);
    V(mask_6N_PQ)=detD_p(mask_z)./(g(mask_z)+...
        (one_g(mask_z).*uz(mask_z).*uz(mask_z)))./dist_pq;

end
end

function var_robust = getVarImg(Img,E,mask_4N_PQ,mask_6N_PQ)
var_robust=zeros(2,1);
var_robust(1) = mean((Img(E(mask_4N_PQ,1))-Img(E(mask_4N_PQ,2))).^2);
var_robust(2) = mean((Img(E(mask_6N_PQ,1))-Img(E(mask_6N_PQ,2))).^2);
% var_robust(1) = (1.4826*mad((Img(E(mask_4N_PQ,1))-Img(E(mask_4N_PQ,2))),1))^2;
% var_robust(2) = (1.4826*mad((Img(E(mask_6N_PQ,1))-Img(E(mask_6N_PQ,2))),1))^2;
% PercentOfPixelsNotEdges=0.75;
% counts=hist(modGrad(:), 64);
% sigma_robust = find(cumsum(counts) > PercentOfPixelsNotEdges*N,1,'first')/64 ;

end

