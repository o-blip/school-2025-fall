clear all
clc
close all

% Parameters
a = 0.9048;
b = 0.0952;
r = 1;
q = 1;
sN = 100;
N = 10; % number of steps
S(1) = sN;
rN = 12; % target

% Free final state: adjust system to drive towards rN=12 not zero
x(1) = 5;
x_ref = rN; % xN = a*xN+b*u_ref
u_ref = (1-a)*x_ref/b;

% solving Riccati equation backwards in time
for k = 1:N
    S(k+1) = (a^2)*(r*S(k))/((b^2)*S(k)+r)+q;
    K(k) = a*b*S(k)/((b^2)*S(k)+r);
end

% applying the control to the system
for k=1:N
    u(k) = -K(end-k+1)*(x(k)-x_ref)+u_ref;
    x(k+1) = a*x(k)+b*u(k);
end



%% Fixed final state - becomes open loop control
xf(1) = 5;
for k = 0:N-1
    uf(k+1) = ((1 - a^2)/(b*(1 - a^(2*N))))*(rN - a^N * xf(1))*a^(N-1-k);
    xf(k+2) = a*xf(k+1)+b*uf(k+1);
end

%% Plotting the trajectory and control signal
% Free final state
figure
subplot(2,1,1)
stairs(0:N,[u u(end)],'LineWidth',1)
ylabel("u(k)")
title("Optimal Control Sequence (free final state)")
grid on
subplot(2,1,2)
plot(0:N,x,'LineWidth',1)
hold on
plot(N, x(end), 'ro', 'MarkerSize', 8, 'MarkerFaceColor','r');
xlabel("Step (k)")
ylabel("x(k)")
title("State Trajectory (free final state)")
grid on
legend('',sprintf('Final state = %.2f', x(end)),'Location','northwest')

% Fixed final state
figure
subplot(2,1,1)
stairs(0:N,[uf uf(end)],'LineWidth',1)
ylabel("u(k)")
title("Optimal Control Sequence (fixed final state)")
grid on
subplot(2,1,2)
plot(0:N,xf,'LineWidth',1)
hold on
plot(N, xf(end), 'ro', 'MarkerSize', 8, 'MarkerFaceColor','r');
xlabel("Step (k)")
ylabel("x(k)")
title("State Trajectory (fixed final state)")
grid on
legend('',sprintf('Final state = %.0f', xf(end)),'Location','northwest')
