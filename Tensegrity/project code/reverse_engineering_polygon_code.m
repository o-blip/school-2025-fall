%% Recreation of polygon unit from professor
clear all; close all; clc;
p = 6; % polygon side number
% polygon parameters
r = 10; 
h = 10;
h_ratio = 0.4;
r_ratio = 0.4;

% generate nodes for unit
N_unit = generate_N(p,r,h,r_ratio,h_ratio);
n_N = length(N_unit(1,:)); % number of nodes

% Bar connectivity index
[C_b_in, bar_group_unit] = bar_connectivity(p);

% String connectivity index
[C_s_in,string_group_unit] = string_connectivity(p);

%% Statics analysis on unit
C_s_unit = tenseg_ind2C(C_s_in,N_unit);
C_b_unit = tenseg_ind2C(C_b_in,N_unit);
C_unit = [C_b_unit;C_s_unit];
[ne_unit,nn_unit] = size(C_unit);
tenseg_plot(N_unit,C_b_unit,C_s_unit);
index_pinned_unit = find(N_unit(3,:) == 0); % finding pinned nodes (fixed to ground)
[Ia,Ib,a,b] = tenseg_boundary(index_pinned_unit,index_pinned_unit,index_pinned_unit,nn_unit);



%% Creating a base of repeated units
dis_unit = [2*r 2*r 2*h-h_ratio*h]';  % unit off distance
qz = 2; qx = 2; qy = 2; % create a grid of units

[N,C_b,C_s] = vUnit_array3D(p,qz,qx,qy,N_unit,C_b_unit,C_s_unit,dis_unit);
tenseg_plot(N,C_b,C_s);

%% Finding pinned and free nodes
index_pinned = find(N(3,:) == 0);
C=[C_b;C_s]; % combined connectivity matrix
[n_elem, n_nodes] =size(C); % number of elements and number of nodes
[Ia,Ib,a,b] = tenseg_boundary(index_pinned,index_pinned,index_pinned,n_nodes);

%% Grouping all like strings and bars for whole structure
% actually i think i need to group these before deleting repeated nodes

% bar_group = bar_group_unit;
% string_group = string_group_unit;
% n_units = qy*qz*qx; % 'Volume' of structure in terms of units
% for i = 1:n_units-1
%     for j = 1:size(bar_group_unit,2)
%         bar_group{j} = [bar_group{j}, bar_group{j}+4*p*i];
%     end
% end