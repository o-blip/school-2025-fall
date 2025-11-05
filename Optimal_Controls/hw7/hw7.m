%% Problem 3.4-1 - Newton's System
clear all; clc
A = [0 1;
    0 0];
B = [0;1];
C = [1 0];
Q = 10;
R = 1;
r=1;

P = 1e-10;

x_0 = [0; 0];
S_T = [P 0; 0 0];
v_T = [P*r;0];

T = 10;

Sv_T = [S_T(1);S_T(2);S_T(3);v_T];
[t,Sv1] = ode45(@(t,Sv) riccati(t,Sv,A,B,C,Q,R,r),[0 T],Sv_T);

N = length(t);
S = zeros(N,2,2);
v = zeros(2,N);
K = zeros(N,2);
t_forw = zeros(N,1);
for i = 1:N
    tau = N-i+1;
    S(i,:,:) = [Sv1(tau,1) Sv1(tau,2);
                Sv1(tau,2) Sv1(tau,3)];
    v(:,i) = [Sv1(tau,4); Sv1(tau,5)];
    K(i,:) = inv(R)*B'*squeeze(S(i,:,:));
    t_forw(i) = T-t(tau);

end

x = zeros(2, N+1);
u = zeros(N+1,1);
x(:,1) = x_0;
for i = 1:N
    u(i) = -K(i,:)*x(:,i)+inv(R)*B'*v(:,i);
    x(:,i+1) = A*x(:,i)+B*u(i);
end



    
plot(t_forw,x(1,1:end-1))


