%% Problem 2
clear all; clc; close all;

A = [0 1;2 0];
B = [0;1];

S_T = 10*eye(2);
Q = [2 0; 0 1];
R = 2;
T = 20;
X_0 = [3;1];

C = [1 0];
V_T = C';
P_T = 1e-5; % not 0 to prevent singularities

% reference
t_ref = 0:0.1:T;
% r_ref = t_ref; % linear reference
r_ref = sin(t_ref); % sinusoidal reference
r_T = r_ref(end);

SV_T = [S_T(1,1);S_T(1,2);S_T(2,2);V_T;P_T];
[t_SV, SV] = ode45(@(t,SV) riccati(t,SV,A,B,R,Q),[T 0],SV_T);

% flip
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

% plotting
figure('Name','Problem2PartA')
plot(t,X(:,1))
hold on
plot(t,U)
plot(t_ref,r_ref)

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