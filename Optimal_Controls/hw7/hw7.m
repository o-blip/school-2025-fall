%% Problem 4.1-2 - Newton's System
clear all; clc; close all
% System
A = [0 1;
    0 0];
B = [0;1];
C = [1 0]; % only x1 is tracking r
% Weighting Matrices
Q = 10;
R = 1;

% part b: r = unit step, solve for v(t)
r=1; % unit step

P = 1e-10; % really want P to be as close to 0

x_0 = [0; 0]; % initial condition
% Boundary conditions
S_T = [P 0; 0 0]; 
v_T = [P*r;0];

T = 10; % simulation length

Sv_T = [S_T(1);S_T(2);S_T(3);v_T]; % ode45() solves for vectors only
[t,Sv1] = ode45(@(t,Sv) riccati(t,Sv,A,B,C,Q,R,r),[0 T],Sv_T);

% need to flip indeces since we integrated backwards in time
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

% Plotting v(t)
figure
plot(t_forw,v(1,:))
hold on
plot(t_forw,v(2,:))
grid on
title('Auxillary System \nu(t)')
legend('\nu_1','\nu_2')
xlabel('Time')
ylabel('\nu')

% simualting continuous plant 
[t,x]=ode45(@(t,x) plant(t,x,A,B,R,S,v,t_forw),[0 T],x_0);

% getting the control signal
N = length(t);
u = zeros(N,1);
for i = 1:N
    S_int = interp1(t_forw,S,t(i));
    v_int = interp1(t_forw,v',t(i));
    
    K = inv(R)*B'*squeeze(S_int);
    u(i) = -K*x(i,:)'+inv(R)*B'*v_int';
end


% plotting closed loop trajectory and control
figure
subplot(2,1,1)
plot(t,x(:,1))
hold on
plot(t,x(:,2))
title('State Trajectory')
legend('x_1','x_2')
grid on
subplot(2,1,2)
plot(t,u)
title('Control Signal')
xlabel('Time')
grid on

% part c
x_0 = [1;0];

timestep = 1; % unit step at t = timestep
t_ref = 0:0.1:T;
r2 = double(timestep <= t_ref); 

% Boundary conditions
S2_T = [P 0; 0 0]; 
v2_T = [P*r;0];



Sv2_T = [S2_T(1);S2_T(2);S2_T(3);v2_T]; % ode45() solves for vectors only
[t2,Sv2] = ode45(@(t,Sv) riccati2(t,Sv,A,B,C,Q,R,flip(r2),t_ref),[0 T],Sv2_T);

% need to flip indeces since we integrated backwards in time
N = length(t2);
S2 = zeros(N,2,2);
v2 = zeros(2,N);
K2 = zeros(N,2);
t_forw2 = zeros(N,1);
for i = 1:N
    tau = N-i+1;
    S2(i,:,:) = [Sv2(tau,1) Sv2(tau,2);
                Sv2(tau,2) Sv2(tau,3)];
    v2(:,i) = [Sv2(tau,4); Sv2(tau,5)];
    K2(i,:) = inv(R)*B'*squeeze(S2(i,:,:)); 
    t_forw2(i) = T-t2(tau);

end



% Plotting v(t)
figure
plot(t_forw2,v2(1,:))
hold on
plot(t_forw2,v2(2,:))
grid on
title('Auxillary System \nu(t)')
legend('\nu_1','\nu_2')
xlabel('Time')
ylabel('\nu')

% simualting continuous plant 
[t2,x2]=ode45(@(t,x) plant(t,x,A,B,R,S2,v2,t_forw2),[0 T],x_0);

% getting the control signal
N = length(t2);
u2 = zeros(N,1);
for i = 1:N
    S_int = interp1(t_forw2,S2,t2(i));
    v_int = interp1(t_forw2,v2',t2(i));
    
    K2 = inv(R)*B'*squeeze(S_int);
    u2(i) = -K2*x2(i,:)'+inv(R)*B'*v_int';
end


% plotting closed loop trajectory and control
figure
subplot(2,1,1)
plot(t2,x2(:,1))
hold on
plot(t2,x2(:,2))
title('State Trajectory')
legend('x_1','x_2')
grid on
subplot(2,1,2)
plot(t2,u2)
title('Control Signal')
xlabel('Time')
grid on


%% 4.2-2
% clc; close all;
A = [0 1;
    0 0];
B = [0;1];
C = [1 0];
T = 5;
x_0 = [0;0];
r_t = 10; % target

q = 10;
v = 0;

Q = [1 v; v q];
S_T = eye(2);
V_T = C';
P_T = 1e-10;

Sv_T = [S_T(1,1);S_T(1,2);S_T(2,2);V_T;P_T];

[t,Sv] = ode45(@(t,Sv) riccati3(t,Sv,A,B,Q,R),[0 T],Sv_T);

% need to flip indeces since we integrated backwards in time
N = length(t);
S = zeros(N,2,2);
v = zeros(2,N);
K = zeros(N,2);
t_forw = zeros(N,1);
for i = 1:N
    tau = N-i+1;
    S(i,:,:) = [Sv(tau,1) Sv(tau,2);
                Sv(tau,2) Sv(tau,3)];
    v(:,i) = [Sv(tau,4); Sv(tau,5)];
    K(i,:) = inv(R)*B'*squeeze(S(i,:,:)); 
    t_forw(i) = T-t(tau);
end
P = flip(Sv(:,6));

% Plotting v(t)
figure
plot(t_forw,v(1,:))
hold on
plot(t_forw,v(2,:))
grid on
title('Auxillary System \nu(t)')
legend('\nu_1','\nu_2')
xlabel('Time')
ylabel('\nu')

% simualting continuous plant 
[t,x]=ode45(@(t,x) plant2(t,x,A,B,R,S,v,P,r_t,t_forw),[0 T],x_0);

% getting the control signal
N = length(t);
u = zeros(N,1);
for i = 1:N
    S_int = interp1(t_forw,S,t(i));
    v_int = interp1(t_forw,v',t(i));
    
    K = inv(R)*B'*squeeze(S_int);
    u(i) = -K*x(i,:)'+inv(R)*B'*v_int';
end


% plotting closed loop trajectory and control
figure
subplot(2,1,1)
plot(t,x(:,1))
hold on
plot(t,x(:,2))
title('State Trajectory')
legend('x_1','x_2')
grid on
subplot(2,1,2)
plot(t,u)
title('Control Signal')
xlabel('Time')
grid on



%% suboptimal
S_inf = [sqrt(12) 1; 1 sqrt(12)];

K_inf = [1 sqrt(12)];
v_inf = [0;0];
r_ss = 10;
[t,v] = ode45(@(t,v) v_ss(t,v,A,B,C,Q,K_inf,r_ss),[0 T],x_0);
% [t,x_ss] = ode45(@(t,x) plant3(t,x,A,B,R,K_inf,v_inf),[0 T],x_0);

figure
plot(t,x_ss(:,1))
hold on
plot(t,x_ss(:,2))
% FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
% 
% for iFig = 1:length(FigList)-1
%   FigHandle = FigList(iFig);
%   FigName   = num2str(get(FigHandle, 'Number'));
%   set(0, 'CurrentFigure', FigHandle);
%   saveas(FigHandle, strcat(FigName, '.png'));
% end

function dv = v_ss(t,v,A,B,C,Q,K_inf,r_ss)
v
    dv = (A-B*K_inf)'*v+C'*Q*r_ss;
end