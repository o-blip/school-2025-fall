clc; clearvars; 
close all
%%

p=3; % unit complexity
qz=8; % z direction array number
qx=6; % z direction array number
qy=6; % z direction array number
% geometrical paramters
r=60;
h=50;                    % mm
asp_rad=[0.4];      % 0.1:0.1:0.5  [0.1:0.1:0.9];
asp_h=[0.4];        % 0.1:0.4:0.9  [0.1:0.4:0.9]; 
[N1,C_b1,C_s1] = vUnit_gen(p,r,h,asp_rad,asp_h);

% RotM = Rodrigues([0 0 1]',pi/p/2);
% N1 = RotM * N1;

tenseg_plot(N1,C_b1,C_s1);

dis_unit = [2*r 2*r 2*h-asp_h*h]';  % unit off distance
% dis_unit = [2*r*cos(pi/p/2) 2*r*cos(pi/p/2) 2*h-asp_h*h]';  % unit off distance

[N2,C_b2,C_s2] = vUnit_array(p,qz,N1,C_b1,C_s1,[0;0;dis_unit(3)]);
tenseg_plot(N2,C_b2,C_s2);

[N,C_b,C_s] = vUnit_array3D(p,qz,qx,qy,N1,C_b1,C_s1,dis_unit);

C=[C_b;C_s];
[ne,nn]=size(C);
nb=size(C_b,1);
ns=size(C_s,1);

% tenseg_plot(N,C_b,C_s);
axis off;









