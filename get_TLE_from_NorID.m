%% Gets TLE from NORARD IDs
% based off this code: 
% https://github.com/jgte/matlab-sgp4/blob/master/get_tle.m
%% This code goes through a loop and gets all the TLEs, not just a small number




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

post={... % Create Post (rember to referance the github)
  'identity',username,...
  'password',password,...
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
        j=j+2;
        k=k+1;
end
tle_final=tle_stor;
%{ 

%% Function to save TLE string as txt
fid = fopen(fnName,'wt');
fprintf(fid, '%s', outStr);
fclose(fid); % prints to txt file

% gets rid of white space, from this link 
% https://www.mathworks.com/matlabcentral/answers/284560-text-file-modification-remove-blank-line
filecontent = fileread(fnName);
newcontent = regexprep(filecontent, {'\r', '\n\n+', '\n'}, {'', '\n', '\r\n'});
fid = fopen(fnName, 'w');
fwrite(fid, newcontent);
fclose(fid);
%}
