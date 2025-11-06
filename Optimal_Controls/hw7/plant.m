function dx= plant(t,x,A,B,R,Sv,vv,t_forw)
S = interp1(t_forw',Sv,t);
v = interp1(t_forw,vv',t)';

K = inv(R)*B'*squeeze(S);
u_t = -K*x+inv(R)*B'*v;

dx = A*x+B*u_t;
end
