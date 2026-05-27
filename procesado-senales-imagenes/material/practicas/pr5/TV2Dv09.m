function I = TV2Dv09(I,dt,iter,par)

%% Parámetros
p = par(1);
ee= par(2).^(2);


%% Algoritmo
for i=1:iter,  %% do iterations
   % estimate derivatives (Newmann BC)
   I_mx = I-I([1 1:end-1],:);
   I_px = I([2:end end],:)-I;
   I_my = I-I(:,[1 1:end-1]);
   I_py = I(:,[2:end end])-I;

   g_px = 1./(I_px.^(2)+ee).^(p/2);
   g_mx = 1./(I_mx.^(2)+ee).^(p/2);
   g_py = 1./(I_py.^(2)+ee).^(p/2);
   g_my = 1./(I_my.^(2)+ee).^(p/2);
   

   I = aos2D( I, g_mx, g_px, g_my, g_py,dt);

end

