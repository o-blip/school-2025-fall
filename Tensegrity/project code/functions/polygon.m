function N = polygon(p,r)
% p: complexity (# of sides)  r: radius
% returns the nodal matrix of a polygon of sides p and radius r at z=0
N = zeros(3,p);
theta = 2*pi/p;
for i = 1:p
    n_i = [r*cos(2*pi*(i-1)/p), r*sin(2*pi*(i-1)/p),0];
    N(:,i) = n_i;
end

