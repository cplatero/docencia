%% Exercies 1 Implement a full wavelet transform that extract iteratively
% wavelet coefficients, by repeating these steps. Take care of choosing the correct number of steps.
Jmax = log2(n)-1;
Jmin = 4;
MW = M;
clf;
for j=Jmax:-1:Jmin
    A = MW(1:2^(j+1),1:2^(j+1));
    %
    Coarse = ( A(1:2:size(A,1),:) + A(2:2:size(A,1),:) )/sqrt(2);
    Detail = ( A(1:2:size(A,1),:) - A(2:2:size(A,1),:) )/sqrt(2);
    A = cat3(1, Coarse, Detail );
    %
    Coarse = ( A(:,1:2:size(A,1)) + A(:,2:2:size(A,1)) )/sqrt(2);
    Detail = ( A(:,1:2:size(A,1)) - A(:,2:2:size(A,1)) )/sqrt(2);
    A = cat3(2, Coarse, Detail );
    %
    MW(1:2^(j+1),1:2^(j+1)) = A;
    j1 = Jmax-j;
    if j1<4
        imageplot(A(1:2^j,2^j+1:2^(j+1)), ['Horizontal, j=' num2str(j)], 3,4, j1 + 1);
        imageplot(A(2^j+1:2^(j+1),1:2^j), ['Vertical, j=' num2str(j)], 3,4, j1 + 5);
        imageplot(A(2^j+1:2^(j+1),2^j+1:2^(j+1)), ['Diagonal, j=' num2str(j)], 3,4, j1 + 9);
    end
end
pause;
%% Exercise 2 Write the inverse wavelet transform that computes M1 from the
% coefficients MW. Compare M1 with M.
M1 = MW;
clf;
for j=Jmin:Jmax
    A = M1(1:2^(j+1),1:2^(j+1));
    Coarse = A(1:2^j,:);
    Detail = A(2^j+1:2^(j+1),:);
    A(1:2:size(A,1),:) = ( Coarse + Detail )/sqrt(2);
    A(2:2:size(A,2),:) = ( Coarse - Detail )/sqrt(2);
    Coarse = A(:,1:2^j);
    Detail = A(:,2^j+1:2^(j+1));
    A(:,1:2:size(A,1)) = ( Coarse + Detail )/sqrt(2);
    A(:,2:2:size(A,2)) = ( Coarse - Detail )/sqrt(2);
    M1(1:2^(j+1),1:2^(j+1)) = A;
    %
    j1 = Jmax-j;
    if j1>0 & j1<5
        subplot(2,2,j1);
        imageplot(A, ['Partial reconstruction, j=' num2str(j)]);
    end
end
%% Exercice 3 Find the thresholds T so that the number m of remaining
% coefficients in MWT are .05*n^2 and .2*n^2. 
% Use this threshold to compute MWT and then display the corresponding approximation M1 of M.
mlist = round([.05 .2]*n^2); % number of kept coefficients
MW = perform_haar_transf(M,4,1);
v = sort(abs(MW(:))); 
if v(1)<v(n^2)
    v = reverse(v);
end
clf;
for i=1:length(mlist)
    m = mlist(i);
    % threshold
    T = v(m);
    MWT = MW .* (abs(MW)>=T);
    % inverse
    M1 = perform_haar_transf(MWT,4,-1);
    % display the result
    imageplot(clamp(M1), strcat(['m/n^2=' num2str(m/n^2,2) ', SNR=' num2str(snr(M,M1),3) 'dB']), 1,2,i );
end
pause;
