function [R] = Rodrigues(v,theta)
%author Wang Xueshi
%input: v: rotation axis; theta:angle theta rad
%output: rotation R
v = v/norm(v);
K = [0 -v(3) v(2);v(3) 0 -v(1);-v(2) v(1) 0];
R = eye(3) + sin(theta)*K + (1-cos(theta))*(K*K);
end

