clear all; close all; clc

%% problem 1

a = 1; b=1; p=10; q=5; r=2;
T = 15;
x_0 = 3;
r_T = 4;

% part a
% t_range = 0:0.1:5;
sv_T = [p p*r_T];
[t_backwards, sv_backwards] = ode45(@(t,sv) riccati(t,sv,a,b,q,r,T),[0 T], sv_T);

% flip forward
N = length(t_backwards);
sv_forwards = zeros(N,2);
t_sv = zeros(N,1);
k = zeros(N,1);
for i = 1 : N
    sv_forwards(i,:) = sv_backwards(N-i+1,:);
    t_sv(i) = t_backwards(N-i+1);
    k(i) = sv_forwards(i,1)*b/r;
end
s = sv_forwards(:,1);
v = sv_forwards(:,2);


plot(t_sv, v)
figure 
plot(t_sv,s)
[t_x,x1] = ode45(@(t,x) plant(t,x,a,b,k,v,r,t_sv), [0 T], x_0);
[t_ref,r_ref] = create_r1(T,r_T);

figure
plot(t_x,x1)
hold on
plot(t_ref,r_ref)




function dsvp = riccati(t,sv,a,b,q,r,T)
    ref = 4;
    t_forw = T-t;
    if t_forw <=1 
        ref = 0;
    elseif t_forw<=5
        ref = t_forw-1;
    end
    s = sv(1);
    v = sv(2);
    ds = 2*a*s+q-(s^2)*(b^2)/r;
    k = s*b/r;
    dv = (a-b*k)*v+q*ref;
    dsvp = [ds;dv];
end

function dx = plant(t,x,a,b,k,v,r,t_sv)
v = interp1(t_sv,v,t);
k = interp1(t_sv,k,t);
u = -k*x+b*v/r;
dx = a*x+b*u;
end

function [t_ref, r_ref] = create_r1(T,r_T)
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