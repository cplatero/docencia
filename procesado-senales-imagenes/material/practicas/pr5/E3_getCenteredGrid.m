%$ Examples for grid generation
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              
       
omega = [0,6,0,4,0,8], m = [3,2,2]
xc = getCenteredGrid(omega(1:2),m(1));   xc = reshape(xc,1,[])
xc = getCenteredGrid(omega(1:4),m(1:2)); xc = reshape(xc,[m(1:2),2])
xc = getCenteredGrid(omega(1:6),m(1:3)); xc = reshape(xc,[m(1:3),3])
