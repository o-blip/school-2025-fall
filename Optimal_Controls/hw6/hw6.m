clear all; clc; close all

%% Defining Parameters
A = [0 1; 0 0];
B = [0;1];
Q = eye(2);
S_T = eye(2);
R = 2;
t_end =2; 

x_initial = [0;5];
x = x_initial;

%% Integrating backwards to get S(t) and K(t)
[t,Sb] = ode45(@riccati,[0 t_end],[1 0 1]);

N = length(t);
for i = 1:N
    S(i,:,:) = [Sb(N+1-i,1) Sb(N+1-i,2);
                Sb(N+1-i,2) Sb(N+1-i,3)];
    K(i,:,:) = [S(i,1,2) S(i,2,2)]/R;
    t_vec(i) = t_end - t(N+1-i);
end

%% Finding optimal control and state trajectory
for k=1:N-1
    K(k,:)=R^-1*B'*[S(k,1,1),S(k,1,2);S(k,2,1),S(k,2,2)];
    u(k)=-K(k,:)*x(:,k);
    x(:,k+1)=expm((A-B*K(k,:))*(t_vec(k+1)-t_vec(k)))*x(:,k);
end
%% Sub-optimal controls
K_inf = [sqrt(2/R) sqrt((2+4*sqrt(2*R))/R)];
x2 = x_initial;
for k=1:N-1
    u2(k)=-K_inf*x(:,k);
    x2(:,k+1)=expm((A-B*K_inf)*(t_vec(k+1)-t_vec(k)))*x(:,k);
end

%% plotting
figure(1)
subplot(3,1,1)

plot(t_vec(1:end-1),u,'LineWidth',2);
hold on
plot(t_vec(1:end-1),u2,'r--','LineWidth',2)
xlabel('Time(s)');
ylabel('Control input');
title('Optimal Control')
legend('Optimal','Sub-optimal')
grid on
subplot(3,1,2)
plot(t_vec,x(1,:),'LineWidth',2)
hold on
plot(t_vec,x2(1,:),'r--','LineWidth',2)
xlabel('Time(s)')
ylabel('State')
title('X_1')
legend('Optimal','Sub-optimal')
grid on
subplot(3,1,3)
plot(t_vec,x(2,:),'LineWidth',2)
hold on
plot(t_vec,x2(2,:),'r--','LineWidth',2)
xlabel('Time(s)')
ylabel('State')
title("X_2")
grid on
legend('Optimal','Sub-optimal')

%% 3.3-4
T = 5;
dt = 0.1;
t = 0:dt:T;
s1 = @(t) (T-t).^2+((T-t).^3)/3;
s3 = @(t) 2*(T-t).^2+2*((T-t).^3)/3;

s1_plot = s1(t);
s3_plot = s3(t);

figure
hold on
plot(t,s1_plot)
plot(t,s3_plot)


