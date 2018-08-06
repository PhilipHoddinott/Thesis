clear all; close all; 

VarStore

strNam = ['mat_files/TLE_',num2str(launchYear),'.mat']; % get strNam
if exist(strNam, 'file') == 2
    load(strNam, 'tle_final'); % load in file
    
end


tle_view_temp=["norad_cat_id","Epoch time","Inclination (deg)","RAAN (deg)","Eccentricity (deg)","Arg of perigee(deg)","Mean anomaly (deg)","Mean motion (rev/day)","Period of rev (s/rev)","Semi-major axis (meter)","Semi-minor axis (meter)"];

tle_veiw = [tle_view_temp;tle_final]; % useful for looking at numbers

tle_latest=sortrows(tle_final(:,:),2); % sort by last epoch
c=clock;
%cyear=clock(1); cmonth=clock(2); cday =clock(3); chour=clock(4); cmin=clock(5); csec=clock(6);
cyear=c(1); cmonth=c(2); cday =c(3); chour=c(4); cmin=c(5); csec=c(6);
tleY=tle_latest(:,2);
tleY=[tleY,floor(tle_latest(:,2)/1000),mod(tle_latest(:,2),1000)];

if mod(cyear,4)==0
    % is leap year
    days=366;
    f=29;
else
    days =365;
    f=28;
end

D = datetime(2018,1,1);
C = calmonths(0:c(2));
c1=caldays(1:212);
%M = D + C
m1=D+c1


[y,m,d]=ymd(datetime)

dayInMonth=eomday(c(1), 1:c(2)-1)
days=0;
for i=1:length(dayInMonth)
    days=days+dayInMonth(i);
end
days=days+c(3);
days =days +5/24; % get to UTC
days = days + c(4)/24 + c(5)/(24*60)+c(6)/(24*60*60);

for i=1:length(tleY(:,1))
    %yTd(i,1)=
    tleY(i,4)=365.25*tleY(i,2);
    tleY(i,5)=(365.25*(c(1)-2000)+days)-(tleY(i,4)+tleY(i,3));
    tleY(i,6)=tleY(i,5)*24;
end



