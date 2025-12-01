%% Recreation of polygon unit from professor
clear all; close all; clc;

%% Material properties: just pick a material as placeholder (some aluminum alloy)



%% Unit Geometry
p = 6; % polygon side number
% polygon parameters
r = 10; 
h = 10;
h_ratio = 0.4;
r_ratio = 0.4;

%% Generate nodes and connectivity for unit
N_unit = generate_N(p,r,h,r_ratio,h_ratio);
n_N = length(N_unit(1,:)); % number of nodes
unit_height = h*(2-h_ratio);
% Bar connectivity index
C_b_in = bar_connectivity(p);
C_b_unit = tenseg_ind2C(C_b_in,N_unit);

% String connectivity index
C_s_in = string_connectivity(p);
C_s_unit = tenseg_ind2C(C_s_in,N_unit);

C_unit = [C_b_unit;C_s_unit];

%% Creating a base of repeated units
dis_unit = [2*r 2*r 2*h-h_ratio*h]';  % unit off distance
qz = 1; qx = 2; qy = 2; % create a grid of units

[N,C_b,C_s] = vUnit_array3D(p,qz,qx,qy,N_unit,C_b_unit,C_s_unit,dis_unit);
tenseg_plot(N,C_b,C_s);
n_N = size(N,2);

%% Finding pinned and free nodes: pinned nodes on ground
index_pinned = find((N(3,:) - 0.1) < 0);
C=[C_b;C_s]; % combined connectivity matrix
[n_elem, n_nodes] =size(C); % number of elements and number of nodes
[Ia,Ib,a,b] = tenseg_boundary(index_pinned,index_pinned,index_pinned,n_nodes);

%% Grouping top and bottom strings
string_grps = group_strings(N,C_s,h,h_ratio);
% plotting each string group in different colors
colors = [
    0.0000    0.4471    0.7412;   % Electric Blue
    0.8510    0.3255    0.0980;   % Vivid Orange
    0.9294    0.6941    0.1255;   % Strong Yellow
    0.4941    0.1843    0.5569;   % Saturated Purple
    0.0000    0.5020    0.0000;   % Deep Green
    0.8000    0.0000    0.0000;   % Crimson Red
];

% plot only a unit
string_grps_unit = group_strings(N_unit,C_s_unit,h,h_ratio);
fig = figure;
lbl = ["Group 1", "Group 2", "Group 3", "Group 4", "Group 5", "Group 6"];
for i =1:6
    tenseg_plot2(N_unit,C_b_unit,string_grps_unit{i},fig,colors(i,:))
    
end
legend("", lbl(1), "", "", lbl(2),"", "", lbl(3),"", "", lbl(4),"", "", ...
    lbl(5),"", "", lbl(6),"")

%% Equilibrium analysis
weight_habitat = 1000; % 1 ton weight
g_moon = 1.62; % moon gravity
top_nodes = find(N(3,:)==unit_height);
w_weight = weight_habitat/size(top_nodes,2); % force due to habitat on each top node

w_external = zeros(3*n_N,1); 
w_external(3*top_nodes) = -w_weight;


%% Prestressing strings

