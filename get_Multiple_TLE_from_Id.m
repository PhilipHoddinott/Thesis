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
fprintf('j = %d, tle %d to tle %d\n',j_GMTFI,tleA(j_GMTFI), tleA(j_GMTFI+1));
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

