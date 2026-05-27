%$ Thin plate spline LM registration for hand example
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupHandData; xc = getCenteredGrid(omega,m);
c = getTPScoefficients(LM(:,1:4),'theta',0);
[yc,yLM] = evalTPS(LM,c,xc); 
LM(:,[5,6]) = reshape(yLM,[],2); 

P5_LM; % for nice plots
