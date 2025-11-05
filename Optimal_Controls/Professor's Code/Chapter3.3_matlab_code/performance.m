function dx=performance(t,x)
dx=zeros(3,1);
a=2;
b=1;
q=2;
r=4;
dx(1)=0;
dx(2)=0;
dx(3)=(x(1)^2*q+x(2)^2*r)/2;
end