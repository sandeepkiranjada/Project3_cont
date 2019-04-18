%% Vehicle Platoon

close all; clc; clear;

%% Functions

kpi = 1;
kdi = 7;
d = 10;

N = 5; % Platoon size without Leader

A = diag(mod((1:N*2-1),2)==1,1)*1;

B = zeros(2*N,N);
% for n=2:2:2*N-1
%     B(n,n/2) = -1;
%     B(n,n/2+1) = 1;
% end
% 
% B(end,end) = -1;

for n=2:2:2*N
    B(n,n/2) = 1;
end
Q = eye(N*2);
R = 50*eye(N);
[K,S,E]=lqr(A,B,Q,R);

%% simulation

% X0  = zeros(1,N*2);
% X0(1,end-1:end) = [0 50];

X0 = [-10 40 -10 -40 -10 40 -10 -40 -10 40];

A_tilda = A-B*K;


% 
% 
% % Xdot = @(t,X) (A_tilda * X + U_tilda);
% 
[t,X] = ode45(@(t,X) Xdot2(t,X,A_tilda),[0 100],X0);

%% Plots
figure; plot(t,X(:,1),t,X(:,3),t,X(:,5),t,X(:,7));
% 
figure; plot(t,X(:,2),t,X(:,4),t,X(:,6),t,X(:,8));

% figure; plot(t,X(:,3)-X(:,1),t,X(:,5)-X(:,3),t,X(:,7)-X(:,5),t,X(:,9)-X(:,7));
% 
% figure; plot(t,X(:,4)-X(:,2),t,X(:,6)-X(:,4),t,X(:,8)-X(:,6),t,X(:,10)-X(:,8));


U = -K*X';

figure; plot(t,U(1,:),t,U(2,:),t,U(3,:),t,U(4,:))

