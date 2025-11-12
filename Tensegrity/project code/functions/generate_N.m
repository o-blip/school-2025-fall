function N = generate_N(p,r,h,r_ratio,h_ratio)
%% generates the nodal matrix of a polygonal unit
% inputs are:
% p - complexity (# of sides of polygon)
% r - radius of polygon
% h - height of inner polygon
% r_ratio - ratio of inner to outer radius
% h_ratio - ratio of distance between inner polygons to h
% Outputs the Nodal Coordinates

offset_angle = pi/p;
Rz = [  cos(offset_angle)   -sin(offset_angle)  0;
        sin(offset_angle)   cos(offset_angle)   0;
        0                   0                   1]; % rotation about z-axis

N_bo = polygon(p,r); % bottom outer polygon
N_bi = Rz*N_bo*r_ratio+[0;0;h*(1-h_ratio)]*ones(1,p); % bottom inner
N_ti = N_bo*r_ratio+[0;0;h]*ones(1,p); % top inner
N_to = Rz*N_bo+[0;0;h*(2-h_ratio)]*ones(1,p); % top outer
N = [N_bo N_bi N_ti N_to];
end