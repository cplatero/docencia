function Haar3DWavelets
%% Toolbox Peyre
getd = @(pt)path(pt,path);
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_signal/');
% getd('C:/cpd/wavelets/fuentes/peyre/toolbox_general/');
getd('D:/compartido/cplatero/misce/wavelets/fuentes/peyre/toolbox_signal/');
getd('D:/compartido/cplatero/misce/wavelets/fuentes/peyre/toolbox_general/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_signal/');
% getd('/home/cplatero/docencia/mip_psi/peyre/toolbox_general/');

%% 3D Volumetric Datasets
name = 'vessels';
options.nbdims = 3;
M = read_bin(name, options);
M = rescale(M);
% size of the image (here it is a cube).
n = size(M,1);