function derivative = derive(data,time)
derivative = zeros(length(time),1);
for i = 1:length(time)-1
    derivative(i) = (data(i+1)-data(i))/(time(i+1)-time(i));
end
end