%% Vehicle Platoon

close all; clc; clear;

%% Functions

kp = 1;
kd = 1;
d = 10;

ui_end_1 = @(xi,vi,xip1,vip1) ( kp * ( -xi + xip1 - d ) + kd * ( -vi + vip1 ) );

ui_mid_1 = @(xi,vi,xim1,xip1,vim1,vip1) ( kp * ( -2*xi + xim1 + xip1 ) + kd * ( -2*vi + vim1 + vip1 ) );


ui_first_1 = @(xi,vi,xim1,xip1,vim1,vip1) ( kp * ( -2*xi + xim1 + xip1 ) + kd * ( -2*vi + vim1 + vip1 ) );