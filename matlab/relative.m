%% Vehicle Platoon

close all; clc; clear;

%% Functions

kp = 1;
kd = 7;
d = 10;

N = 5; % Platoon size with Leader

for n = 1:N-1
    B(n*2,n:n+1) = [-1 1];
    
end

for n=0:N-1
    K(n+1,n*2+1:n*2+4) = [-kp -kd kp kd];
end

K  = K(:,3:end-2);
A = diag(mod((1:N*2-3),2)==1,1)*1;

%% LQR
% Q = eye(N*2);
% R = 50*eye(N);
% [K,S,E]=lqr(A,B,Q,R);

%% simulation

% X0  = zeros(1,N*2);
% X0(1,end-1:end) = [0 50];

X0 = [-10 5 -10 5 -10 5 -10 5];

tf = 50;
dt = 0.01;

clear X t
t=0:dt:tf;

maxA = 13.4112; % 30 mph/s in m/s^2
minA = -13.4112; % -30 mph/s m/s^2

X(1,:) = X0';

for n=2:length(t)
%     E(n-1,:) = (R - C*X(n-1,:)')';
    
    U(n-1,:) = (K*X(n-1,:)');
%     U(n-1,:) = (K_a*E(n-1,:)');

    U(maxA<U)=maxA;
    U(minA>U)=minA;   

    Xd = A*X(n-1,:)' + B*U(n-1,:)';
    X(n,:) = X(n-1,:) + dt*Xd';
end

%% Plots
for n=1:N-1
figure(1); plot(t,X(:,(n)*2-1)); hold on;
n
end
title('Seperation');
xlabel('Time (s)');
ylabel('dP (m)');
legend('show')
grid on



for n=1:N-1
figure(2); plot(t,X(:,n*2).*2.23694); hold on
n
end
title('Error in Velocities');
xlabel('Time (s)');
ylabel('dV (mph)');
legend('show')
grid on


for n=1:N-1
figure(3); plot(t(1:end-1),U(:,n)./9.806); hold on
end
title('Accelerations');
xlabel('Time (s)');
ylabel('Accelerations (g)');
legend('show')
grid on


