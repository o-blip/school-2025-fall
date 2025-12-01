% function S_b = riccati(t,S)
% S_b = [2*S(2)+1; S(3)+S(2)-S(1);-2*(S(2)-S(3))-1];
% end

function S_b = riccati(t,S)
Q = eye(2);
A = [0 1; 0 0];
S_matrix = [S(1) S(2); S(2) S(3)];
dS = -((A')*S_matrix+S_matrix*A+Q);
S_b = [dS(1,1); dS(1,2); dS(2,2)];
end