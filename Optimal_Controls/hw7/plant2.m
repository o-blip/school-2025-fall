function dx= plant2(t,x,A,B,R,Sv,vv,Pv,r_T,t_forw)
S = interp1(t_forw',Sv,t);
v = interp1(t_forw,vv',t)';
P = interp1(t_forw,Pv,t)';
K = inv(R)*B'*squeeze(S);
u_t = -(K-inv(R)*B'*v*inv(P)*v')*x-inv(R)*B'*v*inv(P)*r_T;

dx = A*x+B*u_t;
end
