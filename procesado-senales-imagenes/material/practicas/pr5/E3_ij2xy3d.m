%$  Example for 3D data arrangement
%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

Tij=reshape(1:12,[3,2,2]), 
disp(flipdim(flipdim(permute(Tij,[3,2,1]),3),1))
disp(['T(:)''= [ 9  3 12  6  8  2 11  5  7  1 10  4]'])
