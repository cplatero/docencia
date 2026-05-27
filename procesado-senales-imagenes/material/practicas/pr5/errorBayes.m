function tablaBayes = errorBayes(mediasCT,stdCT,PComp,numGris)

incr_gris =1/numGris;
u=0:incr_gris:1;
x=u;

media_out1 = mediasCT(1);
media_in =   mediasCT(2);
media_out2 = mediasCT(3);

std_out1 = stdCT(1);
std_in =   stdCT(2);
std_out2 = stdCT(3);

p_out1 = 1/(sqrt(2*pi)*std_out1)*(exp(-(x-media_out1).^2/(2*std_out1*std_out1)));
p_in = 1/(sqrt(2*pi)*std_in)*(exp(-(x-media_in).^2/(2*std_in*std_in)));
p_out2 = 1/(sqrt(2*pi)*std_out2)*(exp(-(x-media_out2).^2/(2*std_out2*std_out2)));

p_out1 = p_out1./sum(p_out1)*PComp(1);
p_in = p_in./sum(p_in)*PComp(2);
p_out2 = p_out2./sum(p_out2)*PComp(3);


p_out =(p_out1 + p_out2);

% figure(2);
% plot(x,p_out,'b',x,p_in,'r');
% drawnow;
% pause;
% vectProb= log(p_out./p_in)';
% 
% vectProb = (u-media_in).^2 - min((u-media_out1).^2,(u-media_out2).^2);
% 
% tablaBayes = [u',vectProb'];

vectProb= log(p_in./p_out);
tablaBayes = [u',vectProb'];




