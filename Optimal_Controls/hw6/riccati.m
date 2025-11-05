function dS = riccati(t,S_old)
s1 = S_old(1);
s2 = S_old(2);
s3 = S_old(3);
r = 2;
ds1 = 1-(s2^2)/(2*r);
ds2 = s1-(1/(2*r))*s2*s3;
ds3 = 1+2*s2-(s3^2)/(2*r);
dS = [ds1;ds2;ds3];
end