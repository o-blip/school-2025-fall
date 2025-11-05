function dSb = Riccati(t,Sb)
dSb=0;
a=2;
b=1;
q=20000;
r=4;
dSb=2*a*Sb+q-b^2*Sb^2/r;
end