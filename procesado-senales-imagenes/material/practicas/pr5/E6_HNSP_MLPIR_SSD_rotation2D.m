%$ driver for Multi Level Parametric Image Registration
%$ example with HNSP, rotation around the origin
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

setupHNSPData;                            % set up data
distance('reset','distance','SSD');       % specify distance measure
inter('reset','inter','splineInter2D');   % specify interpolator and
center = (omega(2:2:end)-omega(1:2:end))'/2;
trafo('reset','trafo','rotation2D','c',center); 
[wc,his] = MLPIR(MLdata,'minLevel',3,'plotMLiter',1);
