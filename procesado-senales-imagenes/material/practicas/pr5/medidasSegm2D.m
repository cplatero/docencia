function medidas = medidasSegm2D(segmManual,segmAuto)
[m1,s1] = volOverlap(segmManual,segmAuto);
[m2,s2] = volRelative(segmManual,segmAuto);
[m345,s345] = disAverage(segmManual,segmAuto);
medidas=[m1,m2,m345(1),m345(2),m345(3)];
%medidas=[m1,s1,m2,s2,m345(1),s345(1),m345(2),s345(2),m345(3),s345(3)];

%% Solapamiento de volumen
function [m1,s1] = volOverlap(ref,seg)
inter = ref & seg;
union = ref | seg;
m1=(1- (sum(inter(:))/sum(union(:))))*100;
s1= 100 - (25/6.4*m1);
%% Volumen relativo
function [m2,s2] = volRelative(ref,seg)
dif = abs(ref - seg);
m2=sum(dif(:))/sum(ref(:))*100;
s2= 100 - (25/4.7*m2);
%% Distancia a la superfice
function [m345,s345] = disAverage(ref,seg,info)
BordeManual = bwperim(ref);
BordeAuto = bwperim(seg);


mapaDist2D = bwdist(BordeManual);
distManual2Auto = mapaDist2D(BordeAuto);

mapaDist2D = bwdist(BordeAuto);
distAuto2Manual = mapaDist2D(BordeManual);


NA = size(distManual2Auto,1);
NB = size(distAuto2Manual,1);
m3 = (sum(distManual2Auto(:)) + sum(distAuto2Manual(:)))/(NA+NB);
m4 = sqrt((sum(distManual2Auto(:).^2) + sum(distAuto2Manual(:).^2))/(NA+NB));
m5 = max([distManual2Auto;distAuto2Manual]);
% dx = info.PixelSpacing(1)*2;
% dy = info.PixelSpacing(2)*2;
% %if(dx == dy)
%     m3 = m3*dx;
%     m4 = m4*dx;
%     m5 = m5*dx;
% %end
m345=[m3;m4;m5];
s3= 100 - (25/1*m3);
s4= 100 - (25/1.8*m4);
s5= 100 - (25/19*m5);
s345=[s3;s4;s5];
%s345=[0;0;0];
