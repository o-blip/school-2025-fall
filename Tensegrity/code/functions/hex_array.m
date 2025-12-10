function [N,C_b,C_s] = hex_array(N_in,C_b_in,C_s_in,qy,R)
%% Linear arrays a hexagonal unit such that 
% adjacent units share a side

inner_r = sqrt(3)*R/2; % inradius of a hexagon
y_offset = 2*inner_r; % shift center by twice inner radius
N = N_in;
C_b = C_b_in;
C_s = C_s_in;
for i = 1:qy-1
    % shift nodes by the offset
    N_temp = N_in;
    N_temp(2,:) = N_temp(2,:)+y_offset*i;
    N = [N,N_temp];
    % connectivity matrices of entire structure
    C_b = blkdiag(C_b,C_b_in);
    C_s = blkdiag(C_s,C_s_in);
end

end