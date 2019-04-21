%% Vehicle Platoon

close all; clc; clear;

%% Functions

kpi = 1;
kdi = 5;
d = 10;

N = 3; % Platoon size with Leader

R = or(mod((3:N*5-2),5)==1,mod((3:N*5-2),5)==3)' .* d; % Reference Signal
R(end) = 0;

W = @(t) t*0; % Acceleration of the leader.
G = zeros(2*N,1);
G(end) = 1;

A = diag(mod((1:N*2-1),2)==1,1)*1;
B = zeros(2*N,N);
C = zeros(N*5-4,2*N);
for n=2:2:2*N
    B(n,n/2) = 1;
end

Ci = [-1  0  1  0  0  0; ...
       0 -1  0  1  0  0; ...
       0  0 -1  0  1  0; ...
       0  0  0 -1  0  1; ...
       0  0  0  1  0  0];
   
C1 = [ -1  0  1  0; ...
        0 -1  0  1; ...
        0  1  0  0];

CN = [ -1  0  1  0; ...
        0 -1  0  1; ...
        0  0  0  1];

C(1:3,1:4) = C1;
C(end-2:end,end-3:end) = CN;

K = zeros(N,length(R));
Ki = [kpi kdi -kpi -kdi 0];
K1 = [-kpi -kdi 0];
KN = [kpi kdi 0];

K(1,1:3) = K1;
K(end,end-2:end) = KN;

for n=0:N-3
    C(((n)*5+4):((n)*5+8),((n)*2 + 1):((n)*2 + 6)) = Ci;
    
    K(n+2,n*5+4:n*5+8) = Ki;
end

B(end,end) = 0;

A_tilda = A-B*K*C;
% U_tilda = B*K*R+G*W(1);

U_tilda = B*K*R;




%% simulation

% X0  = [0 0 0 0 0 0 0 0 0 50]';
X0  = zeros(N*2,1);
X0(end) = 22.352; % 50 mph in m/s


% Xdot = @(t,X) (A_tilda * X + U_tilda);

[t,X] = ode45(@(t,X) Xdot(t,X,A_tilda,U_tilda),[0 30],X0);

%% Plots
U = -K*C*X'+K*R;

maxA = 13.4112; % 30 mph/s in m/s^2
minA = -13.4112; % -30 mph/s m/s^2

U(maxA<U)=maxA;
U(-maxA>U)=maxA;

for n=1:N
figure(1); plot(t,X(:,n*2-1)); hold on;
end
title('Positions');
xlabel('Time (s)');
ylabel('Positions (m)');
% legend

for n=1:N
figure(2); plot(t,X(:,n*2).*2.23694); hold on
end

title('Velocities');
xlabel('Time (s)');
ylabel('Velocities (mph)');
% legend

for n=1:N-1
figure(3); plot(t,X(:,(n+1)*2-1)-X(:,(n)*2-1)); hold on;
end
title('Seperation');
xlabel('Time (s)');
ylabel('dP (m)');
% legend

for n=1:N-1
figure(4); plot(t,X(:,(n+1)*2).*2.23694-X(:,n*2).*2.23694); hold on
end

title('Error in Velocities');
xlabel('Time (s)');
ylabel('dV (mph)');
% legend

for n=1:N
figure(5); plot(t,U(n,:)./9.806); hold on
end

title('Accelerations');
xlabel('Time (s)');
ylabel('Accelerations (g)');
% legend

% figure; plot(t,U(1,:),t,U(2,:),t,U(3,:),t,U(4,:),t,U(5,:))

