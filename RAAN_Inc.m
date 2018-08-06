%% Function RAAN_Inc
% This fuction requires the master program to have been run.
%% Setup
close all; clear all;
VarStore
strNam = ['mat_files/TLE_',num2str(launchYear),'.mat']; % get strNam

load(strNam, 'tle_final')

tle_view=tle_final;
tle_view_temp=["norad_cat_id","Epoch time","Inclination (deg)","RAAN (deg)","Eccentricity (deg)","Arg of perigee(deg)","Mean anomaly (deg)","Mean motion (rev/day)","Period of rev (s/rev)","Semi-major axis (meter)","Semi-minor axis (meter)"];

tle_veiw = [tle_view_temp;tle_view]; % useful for looking at numbers
% this will create some nice plots of clustring by RAAN and Inclanation
tle_RAAN=sortrows(tle_final(:,:),4); 

figure(1)
%plot(tle_RAAN(:,4),tle_RAAN(:,3))
scatter(tle_RAAN(:,4),tle_RAAN(:,3))
grid on
diff=[];
for i=1:length(tle_RAAN(:,4))-1
    diff(i)=tle_RAAN(i+1,4)-tle_RAAN(i,4);
end

diff_x=1:length(diff);
figure(2)
plot(diff_x,diff)
grid on

figure(3)
plot(tle_RAAN(:,4),tle_RAAN(:,3))
%scatter(tle_RAAN(:,4),tle_RAAN(:,3))
grid on
barpt=[tle_RAAN(:,4),tle_RAAN(:,3)];
barpt_one=ones(length(barpt),1);
barpt_one=[barpt_one,barpt_one];
%{
figure(4)
%bar3(tle_RAAN(:,4),tle_RAAN(:,3))
%bar3(barpt,barpt_one)
bar3(barpt_one(:,1),barpt)
%bar3(Y,Z)

%}

figure(5)
scatter(tle_RAAN(:,3),tle_RAAN(:,4))
grid on
xlabel('Inclanation')
ylabel('RAAN')