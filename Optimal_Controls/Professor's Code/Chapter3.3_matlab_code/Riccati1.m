function dSb = Riccati1(t,Sb)
dSb=zeros(3,1);
b=1;
B=[0,b]';
wn=1;
zeta=0;
A=[0,1;-wn^2,-2*zeta*wn];
q1=100;
q2=10;
Q=[q1,0;0,q2];
R=1;
S=[Sb(1),Sb(2);Sb(2),Sb(3)];
dS=A'*S+S*A-S*B*R^-1*B'*S+Q;
dSb(1)=dS(1,1);
dSb(2)=dS(1,2);
dSb(3)=dS(2,2);
end