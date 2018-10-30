clear all; close all; 
strLoc='C:\Users\Philip\Documents\GitHub\Thesis\mat_files\';


strNam=[strLoc,'TLE_2000.mat'];
load(strNam,'dateCreated','tle_final')
lenN=length(tle_final(:,1));
format long g
%[RPI,R] = geotiffread('gMaps.tiff');
figure(1)
hold on
%mapshow(RPI,R);
axis image off
%geoshow('gMap.tiff','FaceColor',[0.5 1 0.5]);
geoshow('landareas.shp','FaceColor',[0.5 1 0.5]);
title('Satellite Ground Track')
for ik=1:10%lenN
    %ik=1;
    tle=tle_final(ik,:);
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
    groundtrack_V2(Kepler,timeArr);
end
%xlim([-75 -72])
%ylim([41 44])
%TL; 42.738950, -73.692060
%TR 42.738441, -73.65988
%BR 42.722137, -73.659189
%xlim([-73.692060, -73.659189])
%ylim([42.722137, 42.738441])

%42.7321274,-73.6721397,13.94z