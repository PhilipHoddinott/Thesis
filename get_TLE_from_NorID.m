%% get_TLE_from_NorID.m
% By Philip Hoddinott
% This code gets the TLEs from NORARD IDs and then extracts the keplerian elements from the TLEs. This code is orginally based off of this code: https://github.com/jgte/matlab-sgp4/blob/master/get_tle.m

%% Create string for post request
strTLE='/';
for i = tleA(j_GMTFI):tleA(j_GMTFI+1)-2
    strTLE=[strTLE, num2str(relDeb(i)),','];
end
if tleA(j_GMTFI+1)==decayEnd
    strTLE=[strTLE, num2str(relDeb(tleA(j_GMTFI+1)-1)),num2str(relDeb(tleA(j_GMTFI))),'/'];
    fnName = [tle_folder,'/tle_',num2str(j_GMTFI),'_',num2str(tleA(j_GMTFI)),'_',num2str(tleA(j_GMTFI+1)),'.txt'];
else
    strTLE=[strTLE, num2str(relDeb(tleA(j_GMTFI+1)-1)),'/'];
    fnName = [tle_folder,'/tle_',num2str(j_GMTFI),'_',num2str(tleA(j_GMTFI)),'_',num2str(tleA(j_GMTFI+1)-1),'.txt'];
end
fprintf('j = %d, tle %d to tle %d',j_GMTFI,tleA(j_GMTFI), tleA(j_GMTFI+1));
c=clock;
fprintf(' H = %d, Min = %d, Sec = %.1f\n',c(4),c(5),c(6));
%fprintf(strTLE);fprintf('\n'); %uncomment if you need to see %NORAD_CAT_ID
strTLE=[strTLE,'orderby/ORDINAL%20asc/limit/',num2str(tle_inc),'/format/tle/metadata/false'];  


URL='https://www.space-track.org/ajaxauth/login';

post={'identity',username,'password',password,...
  'query',[...
    'https://www.space-track.org/basicspacedata/query/class/tle_latest/NORAD_CAT_ID',...
    strTLE
  ]...
};

out3TLE=urlread(URL,'Post',post,'Timeout',timeOutVal); % gets the output
outStr=convertCharsToStrings(out3TLE); % coverts output to string


j=1;
k=1;
C = splitlines(outStr);
while j<length(C)-1
    LineOne=convertStringsToChars(C(j,1)); % get first line
    LineTwo=convertStringsToChars(C(j+1,1)); % get second line
    satnum = str2num(LineOne(3:7)); % get sat num
    Incl = str2num(LineTwo(9:16)); % get inc
    Omega = str2num(LineTwo(18:25)); % get 
    ecc = str2num(['.' LineTwo(27:33)]);
    w = str2num(LineTwo(35:42));      
    M = str2num(LineTwo(44:51));      
    n = str2num(LineTwo(53:63));      
    T = 86400/n;      
    a = ((T/(2*pi))^2*398.6e12)^(1/3);      
    b = a*sqrt(1-ecc^2);     
    % store in array
    tle_stor(k,1)=satnum;
    tle_stor(k,2)=str2num(LineOne(19:32));
    tle_stor(k,3)=Incl;
    tle_stor(k,4)=Omega;
    tle_stor(k,5)=ecc;
    tle_stor(k,6)=w;
    tle_stor(k,7)=M;
    tle_stor(k,8)=n;
    tle_stor(k,9)=T;
    tle_stor(k,10)=a;
    tle_stor(k,11)=b;

    j=j+2;
    k=k+1;
end
tle_final=tle_stor;
