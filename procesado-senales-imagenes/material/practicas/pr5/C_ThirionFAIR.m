function C_ThirionFAIR
%clear all;close all;
%Read image
[S,M]= generation_C(128,0);
M = M >0; S = S>0;
M_ini=M;


omega = [0 size(M,1) 0 size(M,2)];
m = size(S);
inter('reset','inter','splineInter2D');
[T,R]=inter('coefficients',double(M),double(S),omega,'out',0);
xc=getCenteredGrid(omega,m);
Rc=inter(R,omega,xc);



%Demon in P
[Sx,Sy]=gradient(reshape(Rc,m));

% tic;
% Sx =imfilter(Sx,fspecial('gaussian',[9 9],1));
% Sy =imfilter(Sy,fspecial('gaussian',[9 9],1));
% toc
tic;
dt =2;
Sx =aosiso(Sx,ones(size(Sx)),dt);
Sy =aosiso(Sy,ones(size(Sy)),dt);
toc

modGrad = (Sx.^2 +Sy.^2).^.5;
Dx=Sx./modGrad;
Dy=Sy./modGrad;
% When divided by zero
Dx(isnan(Dx))=0; Dy(isnan(Dy))=0;

%Dx(bwperim(S==0))=0;Dy(bwperim(S==0))=0;
quiver(Dx,Dy);pause;

%Force
Fx=zeros(size(S));Fy=Fx;
difSSD_th = 1;
i=0;
max_iter=20;
yc = xc;
Tc=inter(T,omega,yc);
M = reshape(Tc,m)>0.5;
Sc= reshape(Rc,m)>0.5;
difSSD = inf;
SSD_new = sum((Rc-Tc).^2);

while((difSSD > difSSD_th) && (i<max_iter))
    k =8*exp(-3*i/max_iter);
    i = i+1
    maskDemon=xor(Sc,M);
    Fx(:)=0; Fy(:)=0;
    Fx(maskDemon & M)= k*Dx(maskDemon & M);
    Fy(maskDemon & M)= k*Dy(maskDemon & M);
    
    Fx(maskDemon & M==0)= -k*Dx(maskDemon & M==0);
    Fy(maskDemon & M==0)= -k*Dy(maskDemon & M==0);
    %imshow([M,bwperim(S)]);hold on; quiver(Fx,Fy); hold off;
    
    % Add the new transformation field to the total transformation field.
    yc = yc+[Fy(:);Fx(:)];
    Tc=inter(T,omega,yc);
    
    M=reshape(Tc,m)>0.5;
    SSD_old = SSD_new;
    SSD_new = sum((Rc-Tc).^2)
    difSSD = SSD_old - SSD_new;
    if(difSSD<0)
        disp('SSD increasing');
    end
    %imshow(logical(M)==0);hold on;quiver(Tx,Ty);hold off;
    %pause;
    imshow([M,M_ini,S]);drawnow;
    %pause(.1);
end
    

    