function dy=dynamics(t,y)
dy=zeros(2,1);
x=y(1);
K=y(2);
a=2;
b=1;
q=2;
r=4;
u=-K*x;
dy(1)=a*x+b*u;
dy(2)=0;
end