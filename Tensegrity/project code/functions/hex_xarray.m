function [N,C_b,C_s] = hex_xarray(N_in,C_b_in,C_s_in,qx,R)
%% Array along x direction, shifts occur at angles for proper tessellation
offset_angle = pi/6; % hexagon inner angle is 60deg (pi/3 rad)
inner_r = sqrt(3)*R/2;
offset_dist = 2*inner_r;

N = N_in;
C_b = C_b_in;
C_s = C_s_in;

N_old = N_in;

for i = 1:qx-1
    offset_angle = -offset_angle; % alternating angles
    offset_vec = offset_dist*[cos(offset_angle) sin(offset_angle) 0];

    N_old = N_old+offset_vec(:);

    N = [N N_old];
    C_b = blkdiag(C_b,C_b_in);
    C_s = blkdiag(C_s,C_s_in);
end