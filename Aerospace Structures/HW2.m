clear all; clc; close all;
% system parameters
h = 1; % height
L = 10*h; % length = 10xheight
h2 = h^2; % precalculating h^2
h3 = h^3;

% creating the mesh of the beam
[X,Y] = beam_mesh(L,h,50);

%% Case A
q = 1; % q is negative at the top cause its compressive




% Stresses from stress function
factor_A = -q/(20*h3);
sigma_xA = @(x,y) factor_A*(120*(x.^2).*y +12*h2.*y-80*(y.^3));
sigma_yA = @(x,y) factor_A*(10*h3-30*h2.*y+40*(y.^3));
tau_A = @(x,y) -factor_A*(-30*h2*x+120*x.*(y.^2));

stress_A = {sigma_xA(X,Y),sigma_yA(X,Y),tau_A(X,Y)};

plot_stresses(X,Y,stress_A)

%% Case B
q = 1; % positive for tension
factor_B = q/(h3);
sigma_xB = @(x,y) factor_B*(-6*(x.^2).*y-3*h2*y/5+4*(y.^3));
sigma_yB = @(x,y) factor_B*(h3/2+3*h2*y/2-2*(y.^3));
tau_B = @(x,y) -factor_B*(3*h2*x/2-6*x.*(y.^2));

stress_B = {sigma_xB(X,Y),sigma_yB(X,Y),tau_B(X,Y)};
plot_stresses(X,Y,stress_B)


%% Stress functions
% Stress function for case A
const_A = -q/h3;
field_A = @(x,y) const_A*(h3*(x.^2)/4-3*h2*(x.^2).*y/4 ...
    +(x.^2).*(y.^3)+h2*(y.^3)/10-(y.^5)/5);
field_B = @(x,y) -const_A*(h3*(x.^2)/4+3*h2*(x.^2).*y/4 ...
    -(x.^2).*(y.^3)-h2*(y.^3)/10+(y.^5)/5);
fieldA = field_A(X,Y);
fieldB = field_B(X,Y);
fields = {fieldA,fieldB,0};

figure
tiledlayout(1,2)
% nexttile
% imagesc(X(1,:), Y(:,1), fieldA)
% nexttile
% imagesc(X(1,:), Y(:,1), fieldB)
% colormap turbo
% colorbar
% subplot(1,2,1)
nexttile
surf(X,Y,fieldA)
xlabel('x')
ylabel('y')
zlabel('\phi')
% subplot(1,2,2)
nexttile
surf(X,Y,fieldB)
xlabel('x')
ylabel('y')
zlabel('\phi')
title('Stress ')
% plot_stresses(X,Y,fields)
%% Functions

function [X,Y] = beam_mesh(L,h,n)
% default spacing for mesh
if nargin < 3
    n = 20;
end
x_lim = linspace(0,L,n);
y_lim = linspace(-h/2,h/2,n);
[X,Y] = meshgrid(x_lim,y_lim);
end

function plot_stresses(X,Y,stress)
s_x = stress{1};
s_y = stress{2};
tau = stress{3};
figure
subplot(1,3,1)
imagesc(X(1,:), Y(:,1), s_x)      % or surf(X, Y, Z), contourf(X, Y, Z), etc.
colormap turbo
colorbar
title('\sigma_x')
subplot(1,3,2)
imagesc(X(1,:), Y(:,1), s_y)      % or surf(X, Y, Z), contourf(X, Y, Z), etc.
colormap turbo
colorbar
title('\sigma_y')
subplot(1,3,3)
imagesc(X(1,:), Y(:,1), tau)      % or surf(X, Y, Z), contourf(X, Y, Z), etc.
colormap turbo
colorbar
title('\tau_x_y')
end
