%% Vehicle Platoon

close all; clc; clear;

%% Functions

kp = 1;
kd = 1;
d = 10;

N = 10; % Platoon size with Leader

N_folw = N-1;

A = diag(mod((1:N_folw*2),2)==1,1)*1;

B = zeros(2*N-1,N);
for n=2:2:2*N_folw
    B(n,n/2) = 1;
end
B(2*N-1,N) = 1;


Ki = [-kp kp -kd kd 0];

Ri = @(vn) [d d 0 0 vn]';

Yi = @(xi,vi,xim1,xip1,vim1,vip1) [xip1-xi xi-xim1 vip1-vi vi-vim1 vi]';
