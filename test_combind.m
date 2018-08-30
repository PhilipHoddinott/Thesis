% test combind Tle, txt reader 
close all; clear all;
c=clock;
fprintf(' H = %d, Min = %d, Sec = %.1f\n',c(4),c(5),c(6));

load('UserPass.mat') % load in username and password
VarStore

strTLE='/38584,38587,38595,38596,38598,38603,38604,38605,38607,38613,38614,38615,38617,38618,38620,38621,38623,38626,38627,38628,38630,38632,38633,38634,38635,38637,38638,38639,38641,38642,38644,38657,38658,38659,38660,38661,38662,38663,38664,38674,38677,38678,38679,38879,38907,38948,38957,38959,38960,38961,38966,38971,38989,39029,39119,39204,39205,39213,39214,39224,39225,39231,39327,39329,39331,39342,39600,39601,39626,39627,39628,39629,39798,39799,39802,39803,39804,39933,39934,39987,39990,39991,39992,39993,39994,39995,39996,39997,40052,40121,40152,40154,40155,40156,40164,40165,40167,40168,40173,40176,40177,40183,40200,40245,40263,40264,40265,40266,40288,40289,40290,40291,40328,40530,40531,40532,40533,40594,40649,40816,40817,40818,40822,40823,40824,40826,40827,40828,40830,40833,40834,40835,40836,40846,40857,40864,40870,40871,40872,40987,40989,40990,40991,41023,41024,41040,41041,41042,41119,41318,41319,41320,41322,41323,41324,41439,41444,41445,41447,41541,41542,41543,41544,41545,41546,41547,41548,41561,41562,41642,41643,41644,41645,41646,41647,41648,41649,41650,41651,41676,41678,41679,41680,41682,41683,41684,41685,41686,41688,41689,41690,41691,41692,41693,41694,41695,41696,41697,41698,41700/orderby/ORDINAL%20asc/limit/200/format/tle/metadata/false';
URL='https://www.space-track.org/ajaxauth/login';

post={... % Create Post (rember to referance the github)
  'identity',username,...
  'password',password,...
  'query',[...
    'https://www.space-track.org/basicspacedata/query/class/tle_latest/NORAD_CAT_ID',...
    strTLE
  ]...
};
out4TLE=urlread(URL,'Post',post,'Timeout',timeOutVal); % gets the output
outStr=convertCharsToStrings(out4TLE); % coverts output to string

c=clock;
fprintf(' H = %d, Min = %d, Sec = %.1f\n',c(4),c(5),c(6));

philip =2;
j=1;
k=1;
C = splitlines(outStr);
while j<length(C)-1
    A1=convertStringsToChars(C(j,1));
    A2=convertStringsToChars(C(j+1,1));
%j = j + 1;
        satnum = str2num(A1(3:7));
        %if isempty(catalog) || ismember(satnum, catalog)   
            %assert(chksum(A1), 'Checksum failure on line 1')
            %assert(chksum(A2), 'Checksum failure on line 2')

            Incl = str2num(A2(9:16));
            Omega = str2num(A2(18:25));
            ecc = str2num(['.' A2(27:33)]);
            w = str2num(A2(35:42));      
            M = str2num(A2(44:51));      
            n = str2num(A2(53:63));      
            T = 86400/n;      
            a = ((T/(2*pi))^2*398.6e12)^(1/3);      
            b = a*sqrt(1-ecc^2);     
            % uncomment for display
            %{ 
            fprintf('%s\n', repmat('-',1,50));
            fprintf('Satellite: %s\n', A0);
            fprintf('Catalog Number: %d\n', satnum);
            fprintf('Epoch time: %s\n', A1(19:32)) % YYDDD.DDDDDDDD
            fprintf('Inclination: %f deg\n', Incl)
            fprintf('RA of ascending node: %f deg\n', Omega)
            fprintf('Eccentricity: %f\n', ecc);
            fprintf('Arg of perigee: %f deg\n', w);
            fprintf('Mean anomaly: %f deg\n', M);
            fprintf('Mean motion: %f rev/day\n', n);
            fprintf('Period of rev: %.0f s/rev\n', T);
            fprintf('Semi-major axis: %.0f meters\n', a);
            fprintf('Semi-minor axis: %.0f meters\n', b);
            %}
            %j=j-1
            tle_stor(k,1)=satnum;
            tle_stor(k,2)=str2num(A1(19:32));
            tle_stor(k,3)=Incl;
            tle_stor(k,4)=Omega;
            tle_stor(k,5)=ecc;
            tle_stor(k,6)=w;
            tle_stor(k,7)=M;
            tle_stor(k,8)=n;
            tle_stor(k,9)=T;
            tle_stor(k,10)=a;
            tle_stor(k,11)=b;
            %j=j+1
        %end

        %A1 = fgetl(fd);
        %A2 = fgetl(fd);
        j=j+2
        k=k+1;
end
    tle_stor_current=tle_stor;
[C,ia,ic]=unique(tle_stor(:,1),'rows'); % sort by row by norard cat id
tle_view_1 = tle_stor_current(ia,:);

tle_view_temp=["norad_cat_id","Epoch time","Inclination (deg)","RAAN (deg)","Eccentricity (deg)","Arg of perigee(deg)","Mean anomaly (deg)","Mean motion (rev/day)","Period of rev (s/rev)","Semi-major axis (meter)","Semi-minor axis (meter)"];

tle_veiw_1 = [tle_view_temp;tle_view_1]; % useful for looking at numbers

strNam = ['mat_files/TLE_test_',num2str(launchYear),'.mat']; % save the TLE as a .mat
dateCreated=datetime;
save(strNam,'tle_veiw_1','dateCreated');