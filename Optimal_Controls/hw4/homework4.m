clear all; clc; close all;
%% 2.3-1
% Zero input dynamics
w_n = 1;
A = [0 1;-(w_n^2) 0];
B = [0;1];
C = eye(2);
D = zeros(2,1);
T = 0.05; % sampling rate (s)
N = 20; % 10 steps
time = 0:T:N ; % run for 10 seconds

U_zero = zeros(1,N);
U = kron(U_zero, ones(1,20));
x_0 = [1 0]';
sys = ss(A,B,C,D);
[x_zeroinput,t,X_zero]=lsim(sys,U,time(1:end-1),x_0);


% Optimal controls
A_s = [cos(w_n*T)       sin(w_n*T)/w_n; 
       -w_n*sin(w_n*T)  cos(w_n*T)];
B_s = [(1-cos(w_n*T))/(w_n^2); 
        sin(w_n*T)/w_n];
S_new = 10*eye(2);
Q = eye(2);
r = 1;
K = [];
u_k = [];
for i = 1:N
    delta = (B_s'*S_new*B_s+r);
    K_i = B'*S_new*A_s/delta;
    K = [K_i;K];
    S_new = (A_s)'*S_new*(A_s-B_s*K(i,:))+Q;
end
x_traj = [x_0];
u = [];
% propagating state using digital controls
for i = 1:N
    u(i) = -K(i,:)*x_traj(:,i);
    x_traj(:, i+1) = A_s*x_traj(:,i)+B_s*u(i);
end

% plotting
figure
subplot(2,1,2)
plot(1:N+1,x_traj(1,:),'o-', 'Linewidth',1.5)
hold on
plot(1:N+1,x_traj(2,:),'o-', 'Linewidth',1.5)
xlim([1 N])
grid on
ylabel("Controlled Response")
xlabel('Time (s)')
legend('x1','x2')

subplot(2,1,1)
plot(time(1:end-1),x_zeroinput(:,1),'Linewidth',1.5)
hold on
plot(time(1:end-1),x_zeroinput(:,2),'Linewidth',1.5)
ylabel("Zero Input Response")
grid on

legend('x1','x2')

title('Oscillator simulation using: SN = 10*I, Q = I, r = 1, x_0 = [1 0], N = 20')

%% 2.3-2
a = w_n;

A = [0 1;(a^2) 0];
B = [0;1];
U_zero = zeros(1,N);
U = kron(U_zero, ones(1,20));
x_0 = [1 0]';
sys = ss(A,B,C,D);
[x_zeroinput,t,X_zero]=lsim(sys,U,time(1:end-1),x_0);
S_new = 10*eye(2);

A_s = [cosh(a*T)     sinh(a*T)/a;
        a*sinh(a*T)  cosh(a*T)];
B_s = [(cosh(a*T)-1)/(a^2);
        sinh(a*T)/a];
for i = 1:N
    delta = (B_s'*S_new*B_s+r);
    K_i = B'*S_new*A_s/delta;
    K = [K_i;K];
    S_new = (A_s)'*S_new*(A_s-B_s*K(i,:))+Q;
end

x_traj = [x_0];
u = [];
% propagating state using digital controls
for i = 1:N
    u(i) = -K(i,:)*x_traj(:,i);
    x_traj(:, i+1) = A_s*x_traj(:,i)+B_s*u(i);
end
x_noinput = [x_0];
for i=1:N
    x_noinput(:,i+1) = A_s*x_noinput(:,i);
end


% plotting
figure
subplot(2,1,2)
plot(1:N+1,x_traj(1,:),'o-', 'Linewidth',1.5)
hold on
plot(1:N+1,x_traj(2,:),'o-', 'Linewidth',1.5)
xlim([1 N])
grid on
ylabel("Controlled Response")
xlabel('Time (s)')
legend('x1','x2')

subplot(2,1,1)
plot(0:N,x_noinput(1,:),'Linewidth',1.5)
hold on
plot(0:N,x_noinput(2,:),'Linewidth',1.5)
ylabel("Zero Input Response")
grid on
legend('x1','x2')
title('Unstable Systme using: SN = 10*I, Q = I, r = 1, x_0 = [1 0], N = 20')
