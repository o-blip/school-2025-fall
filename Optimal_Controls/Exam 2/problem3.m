%% Problem 3
clear all; clc; close all;

T = 0.5; % sampling time
t_f = 10; % final time 
N = t_f/T;
t = T:T:t_f;

x_0 = [3;1];
A = [1 T; 0 1];
B = [(T^2)/2; T];

S_N = [10 0; 0 10];
Q = [1 0;0 2];
R = 10;
C =[1 0];

% reference
c_0 = 1;
c_1 = -1;
c_2 = 0.02;
r = zeros(N,1);
for k =1:N
    r(k) = c_0+c_1*T*k+c_2*(T^2)*(k^2)/2;
end
r_N = r(end);


% optimal affine control
S = zeros(N,2,2);
S(N,:,:) = S_N; % 2x2 matrix
K = zeros(N,2); % 1x2 row vector
Ku = zeros(N,2); % 1x2 row vector

V = zeros(2,N); % 2x1 column vector
V(:,N) = C';
P = zeros(N,1);
u = zeros(N-1,1);
x = zeros(2,N);
x(:,1) = x_0;
%%
for k = N-1:-1:1
    S_future = squeeze(S(k+1,:,:));
    K(k,:) =inv(B'*S_future*B+R)*B'*S_future*A;
    S(k,:,:) = A'*S_future*(A-B*K(k,:))+Q;
    V(:,k) = (A-B*K(k,:))'*V(:,k+1);
    P(k) = P(k+1)-V(:,k+1)'*B*inv(B'*S_future*B+R)*B'*V(:,k+1);
    Ku(k,:) = inv(B'*S_future*B+R)*B';
   
    
    u(k) = -(K(k,:)-Ku(k,:)*V(:,k+1)*inv(P(k))*V(:,k)')*x(:,k)-Ku(k,:)*V(:,k+1)*inv(P(k))*r_N;
    x(:,k+1) = A*x(:,k)+B*u(k);
end
%% 
figure
plot(t, r)
hold on
plot(t,x(1,:))
plot(t,x(2,:))
plot(t(1:end-1),u)