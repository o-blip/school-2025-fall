clear all; clc; close all;
load quake
Time = (1/200)*seconds(1:length(e))';
plot(e)

varNames = {'EastWest', 'NorthSouth', 'Vertical'};
quakeData = timetable(Time, e, n, v, 'VariableNames', varNames);
head(quakeData)
quakeData.Variables = 0.098*quakeData.Variables/30;
subplot(1,3,1)
plot(quakeData.Time,quakeData.EastWest)
title('East-West Acceleration')
ylabel("acceleration in mm/s^2")

subplot(1,3,2)
plot(quakeData.Time,quakeData.NorthSouth)
title('North-South Acceleration')


subplot(1,3,3)
plot(quakeData.Time,quakeData.Vertical)
title('Vertical')
