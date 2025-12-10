clear all; clc;
E = 70e9; % Youngs modulus = 70 GPa
sigma_y = 250e6; % Yield stress = 250 MPa
rho = 2800; % density = 2.8 g/cm^3
L = 3;
g = -9.81;
m_load = 500; % 500 kg load
P = m_load*g;

omega = linspace(0,20*pi/180,50); % range of omegas in radians
psi = linspace(0,20*pi/180,50);
[x,y] = meshgrid(omega,psi);

A_t = P./(sigma_y.*(x+y));
A_c = 2*L.*sqrt(-P./(E*pi*(x+y)))./cos(y);
L_t = L./cos(x);
L_c = L./cos(y);
m_total = rho*(A_t.*L_t+A_c.*L_c);
mesh(x,y,m_total)



% height constraint
H_max = 1; % max distance between booms, in meters
H = L*(tan(x)+tan(y)); % boom separation using the angle mesh
valid = H<=H_max;
m_total(~valid) = NaN; % sets all angles corresponding to invalid angles to NaN
figure
surf(x,y,m_total)
% surf(x,y,m_total)

% finding angles for minimum mass
[cols,y_ind] = min(m_total);
[min_m,x_ind] = min(cols);
y_coor = y_ind(x_ind);
min_omega = omega(x_ind)*180/pi;
min_psi = psi(y_coor)*180/pi;

%% Design 2
