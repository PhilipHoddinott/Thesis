%% Function RAAN_Inc
% This fuction requires the master program to have been run.
%% Setup
close all; clear all;

launchYear=1960;
VarStore
strNam = ['mat_files/TLE_',num2str(launchYear),'.mat']; % get strNam

load(strNam, 'tle_final')

c1=clock;
fprintf('Start time %d/%d/%d, %d:%d:%.3f\n',c1(3),c1(2),c1(1),c1(4),c1(5),c1(6));

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


figure(6)
%Y=[1:360;1:150];
for i=1:360
    %bC=0;
    for j=1:150
        bC=0;
        for w=1:length(tle_RAAN(:,1))
            if (i<tle_RAAN(w,4)) && ( tle_RAAN(w,4)<(i+1) )
                if ( j<tle_RAAN(w,3) ) && ( tle_RAAN(w,3)<(j+1) )
                    bC=bC+1;
                end
            end
        end
        
        Y(i,j)=bC;%i*j;
    end
end
h=bar3(Y);
for i = 1:numel(h)
  index = logical(kron(Y(:, i) == 0, ones(6, 1)));
  zData = get(h(i), 'ZData');
  zData(index, :) = nan;
  set(h(i), 'ZData', zData);
end
% https://stackoverflow.com/questions/2050367/how-to-hide-zero-values-in-bar3-plot-in-matlab
grid on
zlabel('Number of debris in 1 deb by 1 deg square')
xlabel('Inc (deg)')
ylabel('RAAN')

Ytrim = Y;%(:,60:110);


figure(7)
%bar3(Ytrim)

h=bar3(Ytrim);
for i = 1:numel(h)
  index = logical(kron(Y(:, i) == 0, ones(6, 1)));
  zData = get(h(i), 'ZData');
  zData(index, :) = nan;
  set(h(i), 'ZData', zData);
end

xlim([60, 110]);
grid on
zlabel('Number of debris')
xlabel('Inc (deg)')
ylabel('RAAN')


figure(8)
%bar3(Ytrim)

h=bar3(Ytrim);
for i = 1:numel(h)
  index = logical(kron(Y(:, i) == 0, ones(6, 1)));
  zData = get(h(i), 'ZData');
  zData(index, :) = nan;
  set(h(i), 'ZData', zData);
end

xlim([60, 110]);
ylim([150, 340]);
grid on
zlabel('Number of debris')
xlabel('Inc (deg)')
ylabel('RAAN')


c2=clock;
fprintf('End time %d/%d/%d, %d:%d:%.3f\n',c2(3),c2(2),c2(1),c2(4),c2(5),c2(6));
rt=(c2(6)+c2(5)*60+c2(4)*60*60)-(c1(6)+c1(5)*60+c1(4)*60*60);
rts=mod(rt,60); rtm=floor(rt);
fprintf('Run time = %d min, %.3f seconds\n',rtm,rts);

        %Z=1:360;
%bar3(Y,Z)
%bar3(barpt,barpt_one(:,1))
