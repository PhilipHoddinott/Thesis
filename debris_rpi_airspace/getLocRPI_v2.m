clear all; close all; 
strLoc='C:\Users\Philip\Documents\GitHub\Thesis\mat_files\';

meetTime = {'2018-10-30-15-00-00'};
dateCurr = datetime(meetTime,'InputFormat','yyyy-MM-dd-HH-mm-ss');
%th=hour(t)

%function [state] = state_from_mcoe(a,ecc,inc,omasc,omper,anom,tag)
%tag='mea';
%STATE_FROM_MCOE Summary of this function goes here
%   Detailed explanation goes here
%--------------------------------------------------------------------------
% inputs:
%     a     semi-major axis [m]
%     ecc   eccentricity
%     inc   inclination [deg]
%     omasc right-ascension of the ascending node [deg]
%     omper argument of perigee [deg]
%     anom  time since perigee [s] or true/mean/eccentric anomaly [deg]
%     tag   string-tag: 'time', 'true' (default), 'mean' or 'eccentric'
% 
% output:
%     Y     state vector (position[m], velocity[m/s])
%


strNam=[strLoc,'TLE_1960.mat'];
load(strNam,'dateCreated','tle_final')
lenN=length(tle_final(:,1))
%lenN=100;
format long g
%{
%[RPI,R] = geotiffread('gMaps.tiff');

figure(1)
hold on
mapshow(RPI,R);
axis image off
%geoshow('gMap.tiff','FaceColor',[0.5 1 0.5]);
title('Satellite Ground Track')
%}
tle_final_viewTime=tle_final;
for ik=1:length(tle_final)
    year1=(tle_final(ik,2)-mod(tle_final(ik,2),1000))/1000;
    doy=mod(tle_final(ik,2),1000);
    [yy mm dd HH MM] = datevec(datenum(year1,1,doy));
    tle_final_viewTime(ik,12)=yy;
    tle_final_viewTime(ik,13)=mm;
    tle_final_viewTime(ik,14)=dd;
    tle_final_viewTime(ik,15)=HH;
    %tle_final_viewTime(ik,16)=mm*31+dd*24+HH;
    
end


tle_final_sorted= sortrows(tle_final_viewTime,2);
for ik=1:length(tle_final_sorted)
    if tle_final_sorted(ik,12) ==18
        yearL=ik;
        break;
    end
end
%keyboard
tle_final_sorted=tle_final_sorted(yearL:end,:); % sort by year
for ik=1:length(tle_final_sorted)
    if tle_final_sorted(ik,13) ==10
        monthL=ik;
        break;
    end
end
%keyboard
tle_final_sorted=tle_final_sorted(monthL:end,:); % sort by month


for ik=1:length(tle_final_sorted)
    if tle_final_sorted(ik,14) ==30
        dayL=ik;
        break;
    end
end
%keyboard
tle_final_sorted=tle_final_sorted(dayL:end-4,:); % sort by month
lenN=length(tle_final_sorted(:,1));
%tle_final_sorted = flip(tle_final_sorted);


lenN=length(tle_final_sorted(:,1));
for ik=1:lenN
    tle=tle_final_sorted(ik,:);
    a=tle(10);
    e=tle(5);
    i=tle(3);
    Omega=tle(4);
    omega=tle(6);
    M0=tle(7);
    tle_SV(ik,1)=tle_final_sorted(ik,1);
    state = state_from_mcoe(a,e,i,Omega,omega,M0,'mea');
    R0=state(1:3)./1000;
    V0=state(4:6)./1000;
    
    
    %    yy=timeArr(1);
    %mm=timeArr(2);
    %dd=timeArr(3);
    %HH=timeArr(4);
    %MM=timeArr(5);
    
    year1=(tle_final_sorted(ik,2)-mod(tle_final_sorted(ik,2),1000))/1000;
    doy=mod(tle_final_sorted(ik,2),1000);
    [yy mm dd HH MM] = datevec(datenum(year1,1,doy));
    dcyy=year(dateCurr)-2000;
    dcmm=month(dateCurr);
    dcdd=day(dateCurr);
    dcHH=hour(dateCurr)+5;
    dcMM=minute(dateCurr);
    dcss=second(dateCurr);
    to = juliandate(yy,mm,dd,HH,MM,0);

    tf = juliandate(dcyy,dcmm,dcdd,dcHH,dcMM,dcss);
    timeDiff=24*60*60*(tf-to);
    [R,V] = rv_from_r0v0(R0, V0, timeDiff);
    state=[R;V];
    Kepler=[a,e,i,Omega,omega,M0];
    timeArr=[yy, mm, dd, HH, MM];
    [Lat, Lon, Alt] =get_LatLon_givenTimeState(Kepler,timeArr,dateCurr,tle_final_sorted(ik,1),state);
    satLatLon(ik,1)=tle_final_sorted(ik,1);
    satLatLon(ik,2)=Lon*180/pi;
    satLatLon(ik,3)=Lat*180/pi;
    satLatLon(ik,4)=Alt;
    
    if -73.692060<satLatLon(ik,2) &&satLatLon(ik,2)< -73.659189
        if 42.722137<satLatLon(ik,3) &&satLatLon(ik,3)<  42.738441
            for ip=1:4
                fprintf('near RPI:\n');
            end
        end
    end
    if mod(ik,100)==0
        fprintf('ik = %d  of %d\n',ik, lenN);
    end
    
end
    %{

a=Kepler(1);
    e=Kepler(2);
    i=Kepler(3);
    Omega=Kepler(4);
    omega=Kepler(5);
    M0=Kepler(6);
    Y = kep2cart(a,e,i,Omega,omega,M0,'mea');
%}
%{


%}
%{
satLatLon=zeros(lenN,4);
for ik=1:lenN
    
    tle=tle_final_sorted(ik,:);
    a=tle(10);
    e=tle(5);
    i=tle(3);
    Omega=tle(4);
    omega=tle(6);
    M0=tle(7);
    Kepler=[a,e,i,Omega,omega,M0];
    

    year=(tle_final(ik,2)-mod(tle_final(ik,2),1000))/1000;
    doy=mod(tle_final(ik,2),1000);
    [yy mm dd HH MM] = datevec(datenum(year,1,doy));
    timeArr=[yy, mm, dd, HH, MM];
    [Lat, Lon, Alt] =get_LatLon_givenTime(Kepler,timeArr,dateCurr,tle_final_sorted(ik,1));
    satLatLon(ik,1)=tle_final_sorted(ik,1);
    satLatLon(ik,2)=Lon*180/pi;
    satLatLon(ik,3)=Lat*180/pi;
    satLatLon(ik,4)=Alt;
    if mod(ik,100)==0
        fprintf('ik = %d  of %d\n',ik, lenN);
    end
    %groundtrack_V2(Kepler,timeArr);
end

%}
figure(1)
scatter(satLatLon(:,2),satLatLon(:,3))

for ik=1:lenN
    if -73.692060<satLatLon(ik,2) &&satLatLon(ik,2)< -73.659189
        if 42.722137<satLatLon(ik,3) &&satLatLon(ik,3)<  42.738441
            for ip=1:4
                satRPI(ik,ip)=satLatLon(ik,ip);
            end
        end
    end
end
fprintf('done\n');            
%xlim([-75 -72])
%ylim([41 44])
%TL; 42.738950, -73.692060
%TR 42.738441, -73.65988
%BR 42.722137, -73.659189
%xlim([-73.692060, -73.659189])
%ylim([42.722137, 42.738441])

%42.7321274,-73.6721397,13.94z
%}