%% Problem 2: Continuous Function of Final-State-Fixed LQ Regulator
% Follows Table 4.2-1 in Optimal Control by Lewis, Vrabie, Syrmos
clear all; clc; close all;

% System
A = [0 1;2 0];
B = [0;1];

% Weights
S_T = 10*eye(2);
Q = [2 0; 0 1];
R = 2;
T = 20;

% Boundary conditions
X_0 = [3;1];
C = [1 0];
V_T = C';
P_T = 1e-5; % not 0 to prevent singularities

% reference
t_ref = 0:0.1:T;

% r_ref = t_ref; % part a: linear reference
r_ref = sin(t_ref); % part b: sinusoidal reference
r_T = r_ref(end);

% Solving SVP backwards
SV_T = [S_T(1,1);S_T(1,2);S_T(2,2);V_T;P_T];
[t_SV, SV] = ode45(@(t,SV) riccati(t,SV,A,B,R,Q),[T 0],SV_T);

% flip SVP to forwards in time
t_f = flip(t_SV);
SV_f = flip(SV,1);
S_vector = SV_f(:,1:3);
V = SV_f(:,4:5);
P = SV_f(:,6);
N =  length(t_f);
K = zeros(N,2);
for i = 1:N
    S_i = [S_vector(i,1) S_vector(i,2);
            S_vector(i,2) S_vector(i,3)];
    K(i,:) = inv(R)*B'*S_i;
end

% simulating plant
[t,X] = ode45(@(t,X) plant(t,X,A,B,R,K,V,P,t_f,r_T), [0 T], X_0);

% getting control signal
N = length(t);
U = zeros(N,1);
for i = 1:N
    V_t = interp1(t_f,V,t(i))'; % transpose to get column vector
    P_t = interp1(t_f,P,t(i));
    K_t = interp1(t_f,K,t(i));
    U(i) = -(K_t-inv(R)*B'*V_t*inv(P_t)*V_t')*X(i,:)'-inv(R)*B'*V_t*inv(P_t)*r_T;
end

%% plotting
formatSpec = {'LineWidth',2};


figure('Name','Problem2PartB')
subplot(2,1,1)
plot(t,X(:,1),formatSpec{:})
hold on
plot(t,X(:,2),formatSpec{:})
plot(t_ref,r_ref,formatSpec{:})
grid on
xlabel("Time (seconds)")
ylabel("X(t)")
title('State Trajectory with X(0) = [3; 1]')
legend("X_1","X_2", "reference signal",Location="northwest")

subplot(2,1,2)
plot(t,U,formatSpec{:})
ylabel("U(t)")
xlabel("Time (seconds)")
title('Control Signal')
grid on
sgtitle("Probelm 2B: Function of final state x_1 = 20")

%% System Functions

function dX = plant(t,X,A,B,R,K,V,P,t_f,r_T)
    V_t = interp1(t_f,V,t)'; % transpose to get column vector
    P_t = interp1(t_f,P,t);
    K_t = interp1(t_f,K,t);
    u = -(K_t-inv(R)*B'*V_t*inv(P_t)*V_t')*X-inv(R)*B'*V_t*inv(P_t)*r_T;
    dX = A*X+B*u;
end

function dSVP = riccati(t,SVP,A,B,R,Q)
S = [SVP(1) SVP(2); SVP(2) SVP(3)];
V = [SVP(4); SVP(5)];
dS = -(A'*S+S*A'-S*B*inv(R)*B'*S+Q);
dV = -(A-B*inv(R)*B'*S)'*V;
dP = V'*B*inv(R)*B'*V;
dSVP = [dS(1,1);dS(1,2);dS(2,2);dV;dP];
end