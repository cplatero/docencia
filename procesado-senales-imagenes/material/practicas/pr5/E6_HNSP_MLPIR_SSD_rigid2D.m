%$ driver for Multi Level Parametric Image Registration
%$ example with HNSP, rigid transformations
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupHNSPData;                            % set up data
distance('reset','distance','SSD');       % specify distance measure
inter('reset','inter','splineInter2D');   % specify interpolator
trafo('reset','trafo','rigid2D');         % specify transformation
[wc,his] = MLPIR(MLdata,'minLevel',3,'plotMLiter',1);
