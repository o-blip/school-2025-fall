function C_b=transfer_C_b_new(N,C_b,precision)
%% This function is going to transfer connectivity matrices in coordinates form(Alpha*N) into adjacent form(-1 and 1)
% Inputs:
%       N: N*3 matrix              
%       C_b: Alpha*3 matrix with coordinates info of nodes connected by bar
%       precision: Positive integer that indicates the precision(e.g. 10^-6)
% Output:
%       C_b:Alpha*2 matrix with index info of nodes connected by bar or
%              string
%%
C_b_in = C_b(:,1:3);
C_b_out = C_b(:,4:6);
C_b = [];
for i=1:length(C_b_in(:,1))
    a = find(((N(:,1)-C_b_in(i,1)).^2 + (N(:,2)-C_b_in(i,2)).^2 +(N(:,3)-C_b_in(i,3)).^2).^0.5<10^-precision ==1);
    b = find(((N(:,1)-C_b_out(i,1)).^2 + (N(:,2)-C_b_out(i,2)).^2 +(N(:,3)-C_b_out(i,3)).^2).^0.5<10^-precision ==1);
    C_b = [C_b;[a b]];
end
end