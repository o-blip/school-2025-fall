clear all; clc;

% %% 2D example - D-bar
% % nodes
% n1 = [-1 0 0]';
% n2 = [0 -1 0]';
% n3 = [1 0 0]';
% n4 = [0 1 0]';
% N = [n1 n2 n3 n4];
% C_b_in = [1 2; 2 3; 4 5;4 1]; % bar connectivity index matrix
% C_s_in = [1 3;2 4]; % string connectivity index matrix
% 
% % converet index to connectivity matrix
% C_b = tenseg_ind2C(C_b_in,N);
% C_s = tenseg_ind2C(C_s_in,N);
% 
% % note, the bar matrix is N*transpose(C_b)
% 
% % plot
% tenseg_plot(N,C_b,C_s) % tenseg_plot(node matrix, bars, strings)

%% 3D example - 3D D-bar
% nodes
n1 = [-sqrt(3) -1 0]';
n2 = [0 2 0]';
n3 = [sqrt(3) -1 0]';
n4 = [0 0 -2]';
n5 = [0 0 2]';

N = [n1 n2 n3 n4 n5];

% bar and string index
C_b_in = [1 5; 5 3; 4 3; 4 1; 4 2; 5 2];
C_s_in = [1 2; 2 3; 3 1; 4 5];

% index to connectivity
C_b = tenseg_ind2C(C_b_in,N);
C_s = tenseg_ind2C(C_s_in,N);

% plot
tenseg_plot(N, C_b, C_s);

% unit connectivity
C = [C_b;C_s];
G = 9.81/6;
mass = 1;
b = n4;

load quake
Time = (1/200)*seconds(1:length(e))';
Time2 = 0:1/200:(length(e)-1)/200;

varNames = {'EastWest', 'NorthSouth', 'Vertical'};
quakeData = timetable(Time, e, n, v, 'VariableNames', varNames);
quakeData.Variables = 0.098*quakeData.Variables/1000;
dz_a_t = quakeData.EastWest;
dz_v_t = cumtrapz(Time2,dz_a_t);
dz_d_t = cumtrapz(Time2, dz_v_t);
[w_t,dnb_t,dnb_d_t,dnb_dd_t] = tenseg_earthquake(G,C,mass,b,dz_d_t,dz_v_t,dz_a_t,1);