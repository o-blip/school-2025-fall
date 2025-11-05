clear all
q1=100;
q2=10;
Q=[q1,0;0,q2];
R=1;
S1T=100;
S2T=100;
ST=[S1T,0;0,S2T];
wn=1;
zeta=0;
b=1;
B=[0,b]';
A=[0,1;-wn^2,-2*zeta*wn];
T=10;
x0=[10,10]';
[t,Sb]=ode45(@Riccati1,[0 T],[S1T,0,S2T]); %Integrate the Riccati equation forward to get Sb
N=length(t);
t1=zeros(N,1);
for k=1:N
    S(k,:,:)=[Sb(N-k+1,1),Sb(N-k+1,2);Sb(N-k+1,2),Sb(N-k+1,3)]; %Calculate the S(t)=Sb(T-t)
    Sb1(k,:)=Sb(N-k+1,:);
    t1(k)=T-t(N-k+1);
end

x(:,1)=x0;
for k=1:N-1
    K(k,:)=R^-1*B'*[S(k,1,1),S(k,1,2);S(k,2,1),S(k,2,2)];
    u(k)=-K(k,:)*x(:,k);
    x(:,k+1)=expm((A-B*K(k,:))*(t1(k+1)-t1(k)))*x(:,k);
end
u(k+1)=-R^-1*B'*[S(k+1,1,1),S(k+1,1,2);S(k+1,2,1),S(k+1,2,2)]*x(:,k+1);

K_infinity=R^-1*B'*[S(1,1,1),S(1,1,2);S(1,2,1),S(1,2,2)];
x1(:,1)=x0;
for k=1:N-1
    u1(k)=-K_infinity*x1(:,k);
    x1(:,k+1)=expm((A-B*K_infinity)*(t1(k+1)-t1(k)))*x1(:,k);
end
u1(k+1)=-K_infinity*x1(:,k+1);

figure(1)
plot(t1,u,'r-');
hold on
plot(t1,u1,'-');
xlabel('Time(s)');
ylabel('Control input');
legend('optimal control','sub-optimal control');

figure(2)
plot(t1,x(1,:),'r-.');
hold on
plot(t1,x(2,:),'r-');
plot(t1,x1(1,:),'k-.');
plot(t1,x1(2,:),'k-.');
xlabel('Time(s)');
ylabel('State trajectory');
legend('x_1 with optimal control','x_2 with optimal control','x_1 with sub-optimal control','x_2 with sub-optimal control');

figure(3)
plot(t1,Sb1)
H=[A,-B*B'/R;
    -Q,-A'];
lamda=eig(H);
lamda1=zeros(2,1);
j=1;
for i=1:4
    if (real(lamda(i))<0)
        lamda1(j)=lamda(i);
        j=j+1;
    end
end
Deta_A=A*A-(lamda1(1)+lamda1(2))*A+lamda1(1)*lamda1(2)*eye(2);
en=[0,1];
Un=[B,A*B];
K_inf=en*inv(Un)*Deta_A;
        
