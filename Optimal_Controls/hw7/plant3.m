function dx= plant3(t,x,A,B,R,K_inf,v_inf)


u_t = -K_inf*x+inv(R)*B'*v_inf;

dx = A*x+B*u_t;
end