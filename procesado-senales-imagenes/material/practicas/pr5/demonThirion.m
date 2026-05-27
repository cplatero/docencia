% bwHigFin = demonThirion(bwHigIni,imgBayes>=0,Dx,Dy);
function M = demonThirion(M,S,Dx,Dy)

%Force
M_ini = M;
Fx=zeros(size(S));Fy=Fx;Tx=Fx;Ty=Fy;
% maskDemon=false(size(S));

difSSD_th = 1;
i=0;
max_iter=30;
difSSD = inf;
SSD_new = sum((M(:)-S(:)).^2);
% strelNB = strel('square',3);

while((difSSD > difSSD_th) && (i<max_iter))
    k =4*exp(-3*i/max_iter);
    i = i+1
    
%     nb = imdilate(M,strelNB) & imerode(M,strelNB)==0;
%     maskDemon(:)=false;
%     maskDemon(nb)=xor(S(nb),M(nb));
    maskDemon=xor(S,M);

    Fx(:)=0; Fy(:)=0;
    Fx(maskDemon & M)= k*Dx(maskDemon & M);
    Fy(maskDemon & M)= k*Dy(maskDemon & M);
    
    Fx(maskDemon & M==0)= -k*Dx(maskDemon & M==0);
    Fy(maskDemon & M==0)= -k*Dy(maskDemon & M==0);
    
    % Add the new transformation field to the total transformation field.
    Tx(maskDemon)=Tx(maskDemon)+Fx(maskDemon);
    Ty(maskDemon)=Ty(maskDemon)+Fy(maskDemon);
    M=movepixels(M_ini,Ty,Tx);
    
    SSD_old = SSD_new;
    SSD_new = sum((M(:)-S(:)).^2)
    difSSD = SSD_old - SSD_new;
    if(difSSD<0)
        disp('SSD increasing');
    end
    imshow([M>.1,M_ini,S]);drawnow;
    pause(.1);
end
M = M>.1