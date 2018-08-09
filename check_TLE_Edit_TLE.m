%% Function to check TLE
% This function checks the TLEs I have against the TLEs I wanted to have.
% It is part of my attempt to dealwith the repeating TLEs, I am dealing
% with this by varying the number of TLEs I grab

close all;
tle_stor_current=[];

for ik=1:length(tleA)-1 % save all tles to one array
    tle_stor_temp=tle_stor_Main{ik};
    tle_stor_current=[tle_stor_current;tle_stor_temp(2:tle_inc+1,:)];
end

[C,ia,ic]=unique(tle_stor_current(:,1),'rows'); % sort by row by norard cat id
tleUP_1 = tle_stor_current(ia,:);

tleUP=tleUP_1;
tle_final=tleUP_1;



strNam = ['mat_files/TLE_test_',num2str(launchYear),'.mat']; % save the TLE as a .mat
dateCreated=datetime;
save(strNam,'tle_final','dateCreated');


%{
vLen= 1:length(tle_final(:,1));
figure(1)
plot(vLen,tle_final(:,1))
grid on

diff = [];
for i=1:length(tle_final(:,1))-1
    diff(i)=tle_final(i+1,1)-tle_final(i,1);
    vLd(i)=i;
end

figure(2)
plot(vLd,diff)
grid on
%}
    