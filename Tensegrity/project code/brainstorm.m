clear all; clc; close all;

%% Import data from Apollo seismometers
waveform = readtable("waveform.csv");
time = waveform.time_seconds; % time vector in seconds
displacement = waveform.data; % displacement vector in nanometers

%% Velocity, acceleration from displacement data
velocity = derive(displacement,time);
accel = derive(velocity,time);


%% hexagonal unit - p=6
% code from professor
p=6; % unit complexity (# of polygon sides)
% qz by qx by qy units
qz=1; % z direction array number 
qx=6; % x direction array number
qy=6; % y direction array number
% geometrical paramters
r=60; % radius of polygon 
h=50; % height of inner top polygon
rad_ratio=[.4];      % radius scaling of inner polygon
height_ratio=[.4];        % height , when height_ratio = 1,
                           % polygons are on the surface of the structure
dis_unit = [2*r 2*r 2*h-height_ratio*h]';  % unit off distance (necessary separation between units_

[N1,C_b1,C_s1] = vUnit_gen(p,r,h,rad_ratio,height_ratio); % generating one unit
C1 = [C_b1; C_s1];
tenseg_plot(N1,C_b1,C_s1);


[N_bo,C_b,C_s] = vUnit_array3D(p,qz,qx,qy,N1,C_b1,C_s1,dis_unit); % generates 3D array of units

% pinned nodes
b = find(N1(3,:)==0);

[w_t,dnb_t,dnb_d_t,dnb_dd_t] = ...
tenseg_earthquake(9.8/6,C1,50,b,displacement,velocity,accel,1);
t = 1:length(dnb_t);
figure
plot(t,dnb_t)

%% D-bar
n1 = [0 0 0]';
n2 = [-sind(20) cosd(20) 0]';
n3 = [+sind(20) cosd(20) 0]';
n4 = [0 2*cosd(20) 0]';
n5 = [2 cosd(20) 0]';
n6 = [-2 cosd(20) 0]';
n7 = [4 0 0]';
n8 = [4-sind(20) cosd(20) 0]';
n9 = [4+sind(20) cosd(20) 0]';
n10 = [4 2*cosd(20) 0]';
n11 = [6 cosd(20) 0]';
N_bo = [n1 n2 n3 n4 n5 n6 n7 n8 n9 n10 n11];

% connectivity
% strings between d-bars
% C_b_in = [1 2; 1 3; 2 4; 3 4; 7 8; 7 9; 8 10; 9 10];
% C_s_in = [1 4; 2 3; 1 5; 5 4; 1 6; 6 4; 7 10; 8 9; 7 5;
%  5 10; 7 11; 10 11];

% bars instead of strings between d-bars
C_b_in = [1 2; 1 3; 2 4; 3 4; 7 8; 7 9; 8 10; 9 10; 1 5; 5 4;
 1 6; 6 4;7 5; 5 10; 7 11; 10 11];
C_s_in = [1 4; 2 3; 7 10; 8 9;];

C_b = tenseg_ind2C(C_b_in,N_bo);
C_s = tenseg_ind2C(C_s_in,N_bo);

tenseg_plot(N_bo, C_b, C_s)

