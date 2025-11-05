clear all
a=2;
b=1;
q=20000;
r=4;
ST=1000; %Final state weighting matrix
T=0.5;%Final time

[tor,Sb]=ode45(@Riccati,[0 T],ST); %Integrate the Riccati equation forward to get Sb
N=length(tor);
for k=1:N
    S(k)=Sb(N-k+1); %Calculate the S(t)=Sb(T-t)
    t(k)=T-tor(N-k+1);
end
figure(1)
plot(t,S)
hold on
xlabel('Time (s)')
ylabel('S')
x0=10;
x(1)=x0;
for k=1:N-1
    K(k)=b*S(k)/r;
    u(k)=-K(k)*x(k);
    [t1,X]=ode45(@dynamics,[t(k) t(k+1)],[x(k) K(k)]);
    x(k+1)=X(length(t1),1);
end
J_opt=1/2*x0^2*S(1); %Calculate the performance index
figure(2)
plot(t,x,'r');
hold on

figure(3)
plot(t(1:N-1),u,'r')
hold on

system=ss(a-b^2*S(1)/r,b,1,1); %Simulate the system with sub-optimal control
t1=0:0.001:T;
N=length(t1);
u1=zeros(N,1);
x0=10;
[y,t1,X]=lsim(system,u1,t1,x0);
u1=-b*S(1)*X/r;

figure(2)
plot(t1,X)
xlabel('Time (s)')
ylabel('State trajectory')
legend('Optimal trajector','Suboptima trajectory')

figure(3)
plot(t1,u1)
xlabel('Time (s)')
ylabel('Control input')
legend('Optimal control','Suboptima control')

dJ=(1/2*X.*X*q+1/2*r*u1.*u1);
Ts=tf([1],[1,0]);
J=lsim(Ts,dJ,t1,0);
J_sub=max(J)+1/2*X(N)^2*ST;

figure(4)
plot(J_opt,'r*');
hold on
%plot(J_optimal,'rv');
plot(J_sub,'kv');
%axis([0 1 0 1000])
ylabel('J');
legend('With optimal control','With suboptima control')

