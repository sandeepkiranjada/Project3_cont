%% Vehicle Platoon

close all; clc; clear;

%% Functions

kpi = 1;
kdi = 1;
d = 10;

N = 10; % Platoon size with Leader

N_folw = N-1;

A = diag(mod((1:N_folw*2),2)==1,1)*1;

B = zeros(2*N-1,N);
C = zeros(N_folw*5-3,2*N-1);
for n=2:2:2*N_folw
    B(n,n/2) = 1;
end
B(2*N-1,N) = 1;

Ci = [-1  0  1  0  0  0; ...
       0 -1  0  1  0  0; ...
       0  0 -1  0  1  0; ...
       0  0  0 -1  0  1; ...
       0  0  0  1  0  0];

for n=1:N_folw-2
    C(((n-1)*5+4):((n-1)*5+8),((n)*2 + 1):((n)*2 + 6)) = Ci;
end
Ki = [kpi kdi -kpi -kdi 0];

Ri = @(vn) [d d 0 0 vn]';

Yi = @(Ci,Xi) Ci*Xi;
