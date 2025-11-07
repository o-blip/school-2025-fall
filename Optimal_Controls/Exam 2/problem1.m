clear all; close all; clc

%% problem 1

a = 1; b=1; p=10; q=5; r=2;
T = 15;
x_0 = 3;
r_T = 4; % steady state reference

% plot options

%% part a
% reference signal
[t_ref,r_ref] = create_r1(T,r_T); 


% s(t) and v(t) 
sv_T = [p ;p*r_T]; % boundary conditions: s(T) = p, v(T) = p*r(T)

% setting tspan = [T 0] makes ode45 integrate backwards in time
% -> need to add back negatives in riccati
[t_sv, sv] = ode45(@(t,sv) ...
    riccati(t,sv,a,b,q,r,r_ref,t_ref),[T 0], sv_T);

% flip so s,v, and t runs from 0 -> T
s = flip(sv(:,1));
t_f = flip(t_sv);
v = flip(sv(:,2));
k = s.*b./r;

% simulate plant
[t,x] = ode45(@(t,x)...
    plant(t,x,a,b,k,v,r,t_f), [0 T],x_0);

u = get_u(t,x,v,k,b,r,t_f); % get control signal

%% plotting
formatSpec = {'LineWidth',2};
figure('Name','Problem1PartA')

subplot(2,1,1)
plot(t,x,formatSpec{:})
xlabel('Time (s)')
title('State Trajectory with x(0) = 3')
hold on
plot(t_ref,r_ref,formatSpec{:})
grid on
legend('x(t)','reference')

subplot(2,1,2)
plot(t,u,formatSpec{:})
xlabel('Time (s)')
title('Control Signal')
grid on

sgtitle('System with a=1 b=1 p=10 q=5 R=2')


%% part b- reference = sin(t) + cos(2t)
[t_ref, r_ref] = create_r2(T);
sv_T = [p ;p*r_T];

% integrating and flipping s,v
[t_sv, sv] = ode45(@(t,sv) ...
    riccati(t,sv,a,b,q,r,r_ref,t_ref),[T 0], sv_T);
s = flip(sv(:,1));
t_f = flip(t_sv);
v = flip(sv(:,2));
k = s.*b./r;

% simulate plant
[t,x] = ode45(@(t,x)...
    plant(t,x,a,b,k,v,r,t_f), [0 T],x_0);

u = get_u(t,x,v,k,b,r,t_f); % get control signal

% plotting
formatSpec = {'LineWidth',2};
figure('Name','Problem1PartB')

subplot(2,1,1)
plot(t,x,formatSpec{:})
xlabel('Time (s)')
title('State Trajectory with x(0) = 3')
hold on
plot(t_ref,r_ref,formatSpec{:})
grid on
legend('x(t)','reference')

subplot(2,1,2)
plot(t,u,formatSpec{:})
xlabel('Time (s)')
title('Control Signal')
grid on

sgtitle('System with a=1 b=1 p=10 q=5 R=2')


%% Helper functions
function dsvp = riccati(t,sv,a,b,q,r,ref,t_ref)
% integrate backwards to get s(t) and v(t)
ref_t = interp1(t_ref,ref,t);
s = sv(1);
v = sv(2);
ds = -(2*a*s+q-(s^2)*(b^2)/r);
dv = -((a-(b^2)*s/r)*v+q*ref_t);
dsvp = [ds;dv];
end

function dx = plant(t,x,a,b,k,v,r,t_sv)
% plant dynamics
v = interp1(t_sv,v,t);
k = interp1(t_sv,k,t);
u = -k*x+b*v/r;
dx = a*x+b*u;
end

function u = get_u(t,x,v,k,b,r,t_sv)
% calculates the control signal from the state
N = length(t);
u = zeros(N,1);
for i = 1:N
    k_t = interp1(t_sv,k,t(i));
    v_t = interp1(t_sv,v,t(i));
    u(i) = -k_t*x(i)+b*v_t/r;
end
end


function [t_ref, r_ref] = create_r1(T,r_T)
% creates the reference signal
t_ref = 0:0.1:T;
r_ref = r_T*ones(length(t_ref),1);
for i = 1:length(t_ref)
    if t_ref(i) <= 1
        r_ref(i) = 0;
    elseif t_ref(i) <= 5
        r_ref(i) = t_ref(i)-1;
    end
end
end

function [t_ref,r_ref] = create_r2(T)
t_ref = 0:0.1:T;
r_ref = sin(t_ref)+cos(2*t_ref);
end