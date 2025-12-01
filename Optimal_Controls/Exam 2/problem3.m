%% Problem 3: Discrete Function of Final-State-Fixed LQ Regulator
% Follows Table 4.5-1 in Optimal Control by Lewis, Vrabie, Syrmos
clear all; clc; close all;

T = 0.5; % sampling time
t_f = 10; % final time 
N = t_f/T+1; % MATLAB arrays start at 1
t = 0:T:t_f;

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
r_ref = zeros(N,1);
for k =1:N
    r_ref(k) = c_0+c_1*T*k+c_2*(T^2)*(k^2)/2;
end
r_N = r_ref(end);


% optimal affine control
S = zeros(N,2,2);
S(N,:,:) = S_N; % 2x2 matrix
K = zeros(N,2); % 1x2 row vector
Ku = zeros(N,2); % 1x2 row vector

V = zeros(2,N); % 2x1 column vector
V(:,N) = C';
P = zeros(N,1);
U = zeros(N-1,1);
X = zeros(2,N);
X(:,1) = x_0;
%%
for k = N-1:-1:1
    S_future = squeeze(S(k+1,:,:));
    K(k,:) =inv(B'*S_future*B+R)*B'*S_future*A;
    S(k,:,:) = A'*S_future*(A-B*K(k,:))+Q;
    V(:,k) = (A-B*K(k,:))'*V(:,k+1);
    P(k) = P(k+1)-V(:,k+1)'*B*inv(B'*S_future*B+R)*B'*V(:,k+1);
    Ku(k,:) = inv(B'*S_future*B+R)*B';
   
    
    U(k) = -(K(k,:)-Ku(k,:)*V(:,k+1)*inv(P(k))*V(:,k)')*X(:,k)-Ku(k,:)*V(:,k+1)*inv(P(k))*r_N;
    X(:,k+1) = A*X(:,k)+B*U(k);
end
%% 
% figure
% plot(t, r)
% hold on
% plot(t,X(1,:))
% % plot(t,X(2,:))
% % plot(t(1:end-1),U)
% 

formatSpec = {'LineWidth',2};


figure('Name','Problem3PartA')
subplot(2,1,1)
plot(t,X(1,:),formatSpec{:})
hold on
plot(t,X(2,:),formatSpec{:})
plot(t,r_ref,formatSpec{:})
grid on
xlabel("Time (seconds)")
ylabel("X(t)")
title('State Trajectory with X_0 = [3; 1]')
legend("X_1","X_2", "reference signal",Location="southwest")

subplot(2,1,2)
plot(t(1:end-1),U,formatSpec{:})
ylabel("U(t)")
xlabel("Time (seconds)")
title('Control Signal')
grid on
sgtitle("Probelm 3: Sampled Newton's System")