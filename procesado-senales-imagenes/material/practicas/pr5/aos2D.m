function y = aosiso(x, g_mx, g_px, g_my, g_py, t)
% AOSISO   Aditive Operator Splitting Isotropic Interation
%
%    y = AOSISO(x, d, t) calculates the new image "y" as the result of an
%    isotropic (scalar) diffusion iteration on image "x" with diffusivity 
%    "d" and steptime "t" using the AOS scheme.
%
%  - If "d" is constant the diffusion will be linear, if "d" is
%    a matrix the same size as "x" the diffusion will nonlinear.
%  - The stepsize "t" can be arbitrarially large, in contrast to the explicit
%    scheme, where t < 0.25. Using larger "t" will only affect the quality
%    of the diffused image. (Good choices are 5 < t < 20)
%  - "x" must be a 2D image.

% initialization
%y = zeros(size(x));
%p = zeros(size(d));

% Start  ======================================================================
% Operating on Rows
p = g_mx + g_px;
p(1,:)= g_px(1,:);p(end,:)=g_mx(end,:);
a = 1 + t.*p; 
b = -t.*g_px(1:end-1,:);
c = -t.*g_mx(2:end,:);

y = thomas(a,b,c,x);

% Operating on Columns
p = g_my + g_py;
p(:,1)= g_py(:,1);p(:,end)=g_my(:,end);

a = 1 + t.*p';
b = -t.*g_py(:,1:end-1)';
c = -t.*g_my(:,2:end)';

y = y + thomas(a,b,b,x')';

% End  ========================================================================
y = y/2;

