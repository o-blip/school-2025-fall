clear all
clc
close all


x1 = 0:0.5:10;
x2 = x1;
graph_limits = [0 10];
L = performanceIndex(x1,x2);
area = 5;
L_min = performanceIndex(area,area);
constraint = (area^2)./x1;

[L1,L2]= gradient(L);
figure
contour(x1,x2,L)
hold on
scatter(area,area,"Marker","*")
quiver(x1(1:3:end),x2(1:3:end)',L1(1:3:end,(1:3:end)),L2(1:3:end,(1:3:end)))
plot(x1,constraint,"Color","k") % plots constraint line
plot([0:0.1:10],(L_min-2*[0:0.1:10])*0.5) % plots contour line going through minimum
xline(0)
yline(0)
grid on
title("Optimized Area of Rectangle with Area = 5^2")
legend("Contour of L", "Constrained Minimum Point","Gradient of L","Area Constraint")
xlabel("Rectangle Width")
ylabel("Rectangle Height")
xlim(graph_limits)
ylim(graph_limits)




function L =  performanceIndex(x,y)
    y=y';
    L = 2*x + 2*y;
end
