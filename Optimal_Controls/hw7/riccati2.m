function dSv = riccati2(t,Sv,A,B,C,Q,R,r,t_ref)
r = interp1(t_ref,r,t);
S = [Sv(1) Sv(2); Sv(2) Sv(3)];
v = [Sv(4);Sv(5)];
K = inv(R)*B'*S;

dS = (A'*S+S*A-S*B*R^-1*B'*S + C'*Q*C);
dv = (A-B*K)'*v+[10*r;0];
dSv = [dS(1,1);dS(1,2);dS(2,2);dv];
end