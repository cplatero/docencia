function h = showDifference(T,R,omega,m,varargin);

colT = [0,0.5,0];
colR = [1,1,1];
colD = [0.5,0,0];

ih = []; h  = omega./m; xi = @(i) h(i)/2:h(i):omega(i);
IC = @(I,col) uint8(permute(reshape(I,[m,3]),[2,1,3]));

I1 = IC(R*colR);
I2 = IC(T*colT);
I3 = IC(255*(abs(T-R)>0)*colD);

ih(1) = image(xi(1),xi(2),I1);   
axis xy image; hold on;
set(ih(1),'alphadata',1);

ih(2) = image(xi(1),xi(2),I2); 
AT = reshape((T>0).*(R==0),m)';
set(ih(2),'alphadata',AT);

ih(3) = image(xi(1),xi(2),I3); 
AD = reshape((R>0).*abs(T-R)/255,m)';
set(ih(3),'alphadata',AD);

% the following lines add some nice stuff to the code.
% if varargin = {'title','FAIR','xlabel','x'}
% the code evaluates "title('FAIR');xlabel('x');"
for k=1:2:length(varargin), 
  if ~isempty(varargin{k}), feval(varargin{k},varargin{k+1}); end;
end;
