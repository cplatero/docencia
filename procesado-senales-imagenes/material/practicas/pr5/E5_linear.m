%$ Linear LM registration for hand example
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupHandData; xc = reshape(getCenteredGrid(omega,m),[],2);
Q  = [LM(:,3:4),ones(size(LM,1),1)];
wc = (Q'*Q)\(Q'*LM(:,1:2));
yc  = [(wc(1,1)*xc(:,1) + wc(2,1)*xc(:,2) + wc(3,1)),...
       (wc(1,2)*xc(:,1) + wc(2,2)*xc(:,2) + wc(3,2)) ];
LM(:,[5,6]) = ...    
     [(wc(1,1)*LM(:,3) + wc(2,1)*LM(:,4) + wc(3,1)),...
      (wc(1,2)*LM(:,3) + wc(2,2)*LM(:,4) + wc(3,2)) ];

P5_LM; % for nice plots

