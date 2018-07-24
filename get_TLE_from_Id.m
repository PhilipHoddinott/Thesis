%% Gets TLE from NORARD IDs
% based off this code: 
% https://github.com/jgte/matlab-sgp4/blob/master/get_tle.m

load('UserPass.mat') % load in username and password

strTLE='/';
for i = 1:numberTLE-1
    strTLE=[strTLE, num2str(relDeb(i)),','];
end
strTLE=[strTLE, num2str(relDeb(numberTLE)),'/'];
strTLE=[strTLE,'orderby/ORDINAL%20asc/limit/',num2str(numberTLE),'/format/tle/metadata/false'];  


URL='https://www.space-track.org/ajaxauth/login';

post={... % Create Post (rember to referance the github)
  'identity',username,...
  'password',password,...
  'query',[...
    'https://www.space-track.org/basicspacedata/query/class/tle_latest/NORAD_CAT_ID',...
    strTLE
  ]...
};

out3TLE=urlread(URL,'Post',post,'Timeout',50); % gets the output
outStr=convertCharsToStrings(out3TLE); % coverts output to string
