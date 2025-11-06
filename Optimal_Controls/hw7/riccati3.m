function dSv = riccati3(t,Sv,A,B,Q,R)

S = [Sv(1) Sv(2); Sv(2) Sv(3)];
v = [Sv(4);Sv(5)];
P = Sv(6);
K = inv(R)*B'*S;

dS = (A'*S+S*A-S*B*R^-1*B'*S + Q);
dv = (A-B*K)'*v;
dP = -v'*B*inv(R)*B'*v;
dSv = [dS(1,1);dS(1,2);dS(2,2);dv;dP];
end